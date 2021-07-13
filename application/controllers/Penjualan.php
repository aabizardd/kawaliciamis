<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Penjualan extends CI_Controller
{
    public function __construct()
    {
        parent::__construct();
        is_login();
        $this->load->model('Tbl_penjualan_obat_alkes_bhp_model');
        $this->load->model('Tbl_obat_alkes_bhp_model');
        $this->load->library('form_validation');
        $this->load->database();

    }

    public function index()
    {
        $q = urldecode($this->input->get('q', true));
        $start = intval($this->input->get('start'));

        if ($q != '') {
            $config['base_url'] = base_url() . 'penjualan/index.html?q=' . urlencode($q);
            $config['first_url'] = base_url() . 'penjualan/index.html?q=' . urlencode($q);
        } else {
            $config['base_url'] = base_url() . 'index.php/penjualan';
            $config['first_url'] = base_url() . 'index.php/penjualan';
        }

        $config['per_page'] = 10;
        $config['page_query_string'] = true;
        $config['total_rows'] = $this->Tbl_penjualan_obat_alkes_bhp_model->total_rows($q);
        $penjualan = $this->Tbl_penjualan_obat_alkes_bhp_model->get_limit_data($config['per_page'], $start, $q);
        $config['full_tag_open'] = '<ul class="pagination pagination-sm no-margin pull-right">';
        $config['full_tag_close'] = '</ul>';
        $this->load->library('pagination');
        $this->pagination->initialize($config);

        $data = array(
            'penjualan_data' => $penjualan,
            'q' => $q,
            'pagination' => $this->pagination->create_links(),
            'total_rows' => $config['total_rows'],
            'start' => $start,
        );
        $this->template->load('template', 'penjualan/tbl_penjualan_obat_alkes_bhp_list', $data);
    }

    public function read($id)
    {
        $row = $this->Tbl_penjualan_obat_alkes_bhp_model->get_by_id($id);
        if ($row) {
            $data = array(
                'no_faktur' => $row->no_faktur,
                'tanggal' => $row->tanggal,
                'tanggal' => $row->nama_pasien,
                'tanggal' => $row->aturan_pemakaian,
                'kode_supplier' => $row->kode_supplier,
            );
            $data['sql'] = "SELECT tb2.kode_barang,tb2.nama_barang,tb1.harga,tb1.qty,tb1.id_penjualan
                FROM tbl_penjualan_detail as tb1, tbl_obat_alkes_bhp as tb2
                WHERE tb1.kode_barang=tb2.kode_barang and tb1.no_faktur='$id'";
            $this->template->load('template', 'penjualan/tbl_penjualan_obat_alkes_bhp_read', $data);
        } else {
            $this->session->set_flashdata('message', 'Record Not Found');
            redirect(site_url('penjualan'));
        }
    }

    public function create()
    {
        $data = array(
            'button' => 'Simpan Transaksi',
            'action' => site_url('penjualan/create_action'),
            'no_faktur' => set_value('no_faktur'),
            'tanggal' => set_value('tanggal'),
            'nama_pasien' => set_value('nama_pasien'),
            'aturan_pemakaian' => set_value('aturan_pemakaian'),
            'kode_supplier' => set_value('kode_supplier'),
            'obat' => $this->Tbl_obat_alkes_bhp_model->get_all(),
            'pasiens' => $this->db->get('tbl_pasien')->result(),
            'obats' => $this->Tbl_obat_alkes_bhp_model->get_all_obat()->result(),
        );

        // var_dump($data['pasiens']);die();

        $this->template->load('template', 'penjualan/tbl_penjualan_obat_alkes_bhp_form', $data);
    }

    public function getKodeSupplier($namaSupplier)
    {
        $this->db->where('nama_supplier', $namaSupplier);
        $data = $this->db->get('tbl_supplier')->row_array();
        return $data['kode_supplier'];
    }

    public function getKodeObat($namaSupplier)
    {
        $this->db->where('nama_barang', $namaSupplier);
        $data = $this->db->get('tbl_obat_alkes_bhp')->row_array();
        return $data['kode_barang'];
    }

    public function create_action()
    {

        $data = array(
            'no_faktur' => $this->input->post('no_faktur', true),
            'tanggal' => $this->input->post('tanggal', true),
            'nama_pasien' => $this->input->post('nama_pasien', true),
        );

        $this->Tbl_penjualan_obat_alkes_bhp_model->insert($data);

        $kode_barang = $_POST['kode_barang'];
        $aturan_pemakaian = $_POST['aturan_pemakaian'];

        $qty = $_POST['qty'];

        if (!empty($kode_barang)) {
            for ($a = 0; $a < count($kode_barang); $a++) {
                if (!empty($kode_barang[$a])) {
                    $kode_barangs = $this->getKodeObat($kode_barang[$a]);
                    $aturan_pemakaians = $aturan_pemakaian[$a];
                    $qtys = $qty[$a];

                    $barang[$kode_barangs] = $this->db->get_where('tbl_obat_alkes_bhp', array('kode_barang' => $this->getKodeObat($kode_barang[$a])))->row_array();

                    if ($barang[$kode_barangs]['Stok'] >= $qty[$a]) {

                        $this->db->insert('tbl_penjualan_detail', [
                            'kode_barang' => $this->getKodeObat($kode_barang[$a]),
                            'aturan_pemakaian' => $aturan_pemakaian[$a],
                            'qty' => $qty[$a],
                            'no_faktur' => $this->input->post('no_faktur', true),
                        ]);

                        //update stok
                        $dataBarang = array(

                            'Stok' => $barang[$kode_barangs]['Stok'] - $qty[$a],
                        );

                        $this->Tbl_obat_alkes_bhp_model->update($this->getKodeObat($kode_barang[$a]), $dataBarang);

                    } else {
                        $this->session->set_flashdata('message', 'Stok Obat Kurang');
                        redirect(site_url('penjualan'));

                    }

                }
            }
        }

        $this->session->set_flashdata('message', 'Create Record Success 2');
        redirect(site_url('penjualan'));

    }

    public function update($id)
    {
        $row = $this->Tbl_penjualan_obat_alkes_bhp_model->get_by_id($id);

        $this->db->select('*');
        $this->db->from('tbl_penjualan_detail');
        $this->db->join('tbl_obat_alkes_bhp', 'tbl_obat_alkes_bhp.kode_barang = tbl_penjualan_detail.kode_barang');
        $this->db->where('no_faktur', $id);

        $detail = $this->db->get()->result();

        if ($row) {
            $data = array(
                'button' => 'Update',
                'action' => site_url('penjualan/update_action'),
                'no_faktur' => set_value('no_faktur', $row->no_faktur),
                'tanggal' => set_value('tanggal', $row->tanggal),
                'nama_pasien' => set_value('nama_pasien', $row->nama_pasien),
                'aturan_pemakaian' => set_value('aturan_pemakaian', $row->aturan_pemakaian),
                'detail' => $detail,
                'obat' => $this->Tbl_obat_alkes_bhp_model->get_all(),

            );

            $this->template->load('template', 'penjualan/edit', $data);
        } else {
            $this->session->set_flashdata('message', 'Record Not Found');
            redirect(site_url('penjualan'));
        }
    }

    public function update_action()
    {

        $data = array(
            'tanggal' => $this->input->post('tanggal', true),
            'nama_pasien' => $this->input->post('nama_pasien', true),
            // 'aturan_pemakaian' => $this->input->post('aturan_pemakaian',TRUE),
            // 'kode_supplier' => $this->input->post('kode_supplier',TRUE),
        );

        $this->Tbl_penjualan_obat_alkes_bhp_model->update($this->input->post('no_faktur', true), $data);

        $this->db->where('no_faktur', $this->input->post('no_faktur', true));
        $this->db->delete('tbl_penjualan_detail');

        // if($delete){

        $kode_barang = $_POST['kode_barang'];
        $aturan_pemakaian = $_POST['aturan_pemakaian'];

        $qty = $_POST['qty'];

        if (!empty($kode_barang)) {
            for ($a = 0; $a < count($kode_barang); $a++) {
                if (!empty($kode_barang[$a])) {
                    $kode_barangs = $kode_barang[$a];
                    $aturan_pemakaians = $aturan_pemakaian[$a];
                    $qtys = $qty[$a];

                    $this->db->insert('tbl_penjualan_detail', [
                        'kode_barang' => $this->getKodeObat(($kode_barang[$a])),
                        'aturan_pemakaian' => $aturan_pemakaian[$a],
                        'qty' => $qty[$a],
                        'no_faktur' => $this->input->post('no_faktur', true),
                    ]);
                }
            }
        }

        // }

        // }

        $this->session->set_flashdata('message', 'Update Record Success');
        redirect(site_url('penjualan'));

    }

    public function delete($id)
    {

        $row = $this->Tbl_penjualan_obat_alkes_bhp_model->get_by_id($id);

        if ($row) {

            $this->db->select('*');
            $this->db->from('tbl_penjualan_detail');
            $this->db->join('tbl_obat_alkes_bhp', 'tbl_obat_alkes_bhp.kode_barang = tbl_penjualan_detail.kode_barang');

            $this->db->where('no_faktur', $id);

            $detail = $this->db->get()->result();

            if ($detail !== null) {

                foreach ($detail as $key => $value) {

                    $this->Tbl_obat_alkes_bhp_model->update($value->kode_barang, [
                        'Stok' => $value->Stok + $value->qty,
                    ]);

                }

            }

            $this->db->where('no_faktur', $id);
            $this->db->delete('tbl_penjualan_detail');

            $this->Tbl_penjualan_obat_alkes_bhp_model->delete($id);

        }
    }

    public function _rules()
    {
        $this->form_validation->set_rules('tanggal', 'tanggal', 'trim|required');
        //$this->form_validation->set_rules('kode_supplier', 'kode supplier', 'trim|required');
        $this->form_validation->set_rules('nama_pasien', 'nama_pasien', 'trim|required');
        $this->form_validation->set_rules('aturan_pemakaian', 'aturan_pemakain', 'trim|required');

        $this->form_validation->set_rules('no_faktur', 'no_faktur', 'trim');
        $this->form_validation->set_error_delimiters('<span class="text-danger">', '</span>');
    }

    public function add_ajax()
    {
        $NamaBarang = $this->input->get('barang');
        $qty = $this->input->get('qty');
        $faktur = $this->input->get('faktur');
        $nama_pasien = $this->input->get('nama_pasien');
        $aturan_pemakaian = $this->input->get('aturan_pemakaian');
        // mencari kode barang berdasarkan nama barang
        $barang = $this->db->get_where('tbl_obat_alkes_bhp',
            array('nama_barang' => $NamaBarang))->row_array();

        $data = array(
            'kode_barang' => $barang['kode_barang'],
            'qty' => $qty,
            'no_faktur' => $faktur,
            'nama_pasien' => $nama_pasien,
            'aturan_pemakaian' => $aturan_pemakaian,
        );
        $this->db->insert('tbl_penjualan_detail', $data);
    }

    public function list_penjualan()
    {
        $faktur = $_GET['faktur'];
        echo "<table class='table table-bordered'>
                <tr><th>NO</th><th>NAMA OBAT</th><th>QTY</th><th>HARGA</th></tr>";
        $sql = "SELECT tb2.kode_barang,tb2.nama_barang,tb2.harga,tb1.qty,tb1.id_penjualan
                FROM tbl_penjualan_detail as tb1, tbl_obat_alkes_bhp as tb2
                WHERE tb1.kode_barang=tb2.kode_barang and tb1.no_faktur='$faktur'";

        $list = $this->db->query($sql)->result();
        $no = 1;
        foreach ($list as $row) {
            echo "<tr>
                <td width='10'>$no</td>
                <td>$row->nama_barang</td>
                <td width='20'>$row->qty</td>
                <td width='100'>$row->harga</td>
                <td width='100' onClick='hapus($row->id_penjualan)'><button class='btn btn-danger btn-sm'>Hapus</button></td>
                </tr>";
            $no++;
        }
        echo " </table>";
    }

    public function hapus_ajax()
    {
        $id_penjualan = $_GET['id_penjualan'];
        $this->db->where('id_penjualan', $id_penjualan);
        $this->db->delete('tbl_penjualan_detail');
    }

    public function cetak()
    {

        $data['bulan'] = [
            'semua' => 'semua',
            '01' => 'Januari',
            '02' => 'Februari',
            '03' => 'Maret',
            '04' => 'April',
            '05' => 'Mei',
            '06' => 'Juni',
            '07' => 'Juli',
            '08' => 'Agustus',
            '09' => 'September',
            '10' => 'Oktober',
            '11' => 'November',
            '12' => 'Desember',
        ];
        $yearnow = date('Y');

        $tahun['semua'] = 'semua';

        for ($t = 2020; $t <= $yearnow; $t++) {
            $tahun[$t] = $t;
        }

        $data['tahun'] = $tahun;

        $data['employees'] = $this->db->get('tbl_pegawai')->result();

        $this->template->load('template', 'penjualan/filter', $data);

    }

    public function cetak_action()
    {

        $bulan = $this->input->get('bulan');
        $tahun = $this->input->get('tahun');
        $pj = $this->input->get('pj');

        if ($bulan == 'semua' and $tahun != 'semua') {

            $param = $tahun . '%';

        } else if ($tahun == 'semua' and $bulan != 'semua') {

            $param = '%' . '-' . $bulan . '%';

        } else if ($tahun == 'semua' and $bulan == 'semua') {
            $param = '%';
        } else {
            $param = $tahun . '-' . $bulan . '%';

        }

        $sql = "SELECT * , sum(qty) as qty_total, sum(tbl_obat_alkes_bhp.harga) as harga_total FROM tbl_penjualan_obat_alkes_bhp
            JOIN tbl_penjualan_detail ON tbl_penjualan_obat_alkes_bhp.no_faktur = tbl_penjualan_detail.no_faktur
            JOIN tbl_obat_alkes_bhp ON tbl_penjualan_detail.kode_barang = tbl_obat_alkes_bhp.kode_barang
            WHERE tbl_penjualan_obat_alkes_bhp.tanggal LIKE '$param' GROUP BY nama_barang";

        $data['list'] = $this->db->query($sql)->result();

        $data['obat_keluar'] = $this->db->query("SELECT sum(tbl_penjualan_detail.qty) as total FROM tbl_penjualan_obat_alkes_bhp
        JOIN tbl_penjualan_detail ON tbl_penjualan_obat_alkes_bhp.no_faktur = tbl_penjualan_detail.no_faktur
        JOIN tbl_obat_alkes_bhp ON tbl_penjualan_detail.kode_barang = tbl_obat_alkes_bhp.kode_barang
        WHERE tbl_penjualan_obat_alkes_bhp.tanggal LIKE '$param'")->row();

        $data['total_pengeluaran'] = $this->db->query("SELECT sum(tbl_obat_alkes_bhp.harga) as total FROM tbl_penjualan_obat_alkes_bhp
        JOIN tbl_penjualan_detail ON tbl_penjualan_obat_alkes_bhp.no_faktur = tbl_penjualan_detail.no_faktur
        JOIN tbl_obat_alkes_bhp ON tbl_penjualan_detail.kode_barang = tbl_obat_alkes_bhp.kode_barang
        WHERE tbl_penjualan_obat_alkes_bhp.tanggal LIKE '$param'")->row();

        $data['obat_keluar_terbanyak'] = $this->db->query("SELECT nama_barang,sum(tbl_penjualan_detail.qty) as total FROM tbl_penjualan_obat_alkes_bhp
        JOIN tbl_penjualan_detail ON tbl_penjualan_obat_alkes_bhp.no_faktur = tbl_penjualan_detail.no_faktur
        JOIN tbl_obat_alkes_bhp ON tbl_penjualan_detail.kode_barang = tbl_obat_alkes_bhp.kode_barang
        WHERE tbl_penjualan_obat_alkes_bhp.tanggal LIKE '$param'
        GROUP BY nama_barang ORDER BY total DESC
        LIMIT 1
        ")->row();

        $data['obat_sedikit_keluar'] = $this->db->query("SELECT nama_barang,sum(tbl_penjualan_detail.qty) as total FROM tbl_penjualan_obat_alkes_bhp
        JOIN tbl_penjualan_detail ON tbl_penjualan_obat_alkes_bhp.no_faktur = tbl_penjualan_detail.no_faktur
        JOIN tbl_obat_alkes_bhp ON tbl_penjualan_detail.kode_barang = tbl_obat_alkes_bhp.kode_barang
        WHERE tbl_penjualan_obat_alkes_bhp.tanggal LIKE '$param'
        GROUP BY nama_barang ORDER BY total ASC
        LIMIT 1
        ")->row();

        $bulan_arr = [

            'semua' => 'semua',
            '01' => 'Januari',
            '02' => 'Februari',
            '03' => 'Maret',
            '04' => 'April',
            '05' => 'Mei',
            '06' => 'Juni',
            '07' => 'Juli',
            '08' => 'Agustus',
            '09' => 'September',
            '10' => 'Oktober',
            '11' => 'November',
            '12' => 'Desember',
        ];

        $data['bulan'] = $bulan_arr[$bulan];
        $data['tahun'] = $tahun;
        $data['pj'] = $pj;

        $this->load->view('penjualan/cetak', $data);

    }

}

/* End of file Pengadaan.php */
/* Location: ./application/controllers/Pengadaan.php */
/* Please DO NOT modify this information : */
/* Generated by Harviacode Codeigniter CRUD Generator 2017-12-10 02:07:42 */
/* http://harviacode.com */