<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Pengadaan extends CI_Controller
{
    public function __construct()
    {
        parent::__construct();
        is_login();
        $this->load->model('Tbl_pengadaan_obat_alkes_bhp_model');
        $this->load->model('Tbl_obat_alkes_bhp_model');

        $this->load->model('Tbl_supplier_model');
        $this->load->library('form_validation');
    }

    public function index()
    {
        $q = urldecode($this->input->get('q', true));
        $start = intval($this->input->get('start'));

        if ($q != '') {
            $config['base_url'] = base_url() . 'pengadaan/index.php?q=' . urlencode($q);
            $config['first_url'] = base_url() . 'pengadaan/index.php?q=' . urlencode($q);
        } else {
            $config['base_url'] = base_url() . 'index.php/pengadaan';
            $config['first_url'] = base_url() . 'index.php/pengadaan';
        }

        $config['per_page'] = 10;
        $config['page_query_string'] = true;
        $config['total_rows'] = $this->Tbl_pengadaan_obat_alkes_bhp_model->total_rows($q);
        $pengadaan = $this->Tbl_pengadaan_obat_alkes_bhp_model->get_limit_data($config['per_page'], $start, $q);
        $config['full_tag_open'] = '<ul class="pagination pagination-sm no-margin pull-right">';
        $config['full_tag_close'] = '</ul>';
        $this->load->library('pagination');
        $this->pagination->initialize($config);

        $data = array(
            'pengadaan_data' => $pengadaan,
            'q' => $q,
            'pagination' => $this->pagination->create_links(),
            'total_rows' => $config['total_rows'],
            'start' => $start,
        );
        $this->template->load('template', 'pengadaan/tbl_pengadaan_obat_alkes_bhp_list', $data);
    }

    public function read($id)
    {
        $row = $this->Tbl_pengadaan_obat_alkes_bhp_model->get_by_id($id);
        if ($row) {
            $data = array(
                'no_faktur' => $row->no_faktur,
                'tanggal' => $row->tanggal,
                'kode_supplier' => $row->kode_supplier,
            );

            $suplier = $this->Tbl_supplier_model->get_by_id($data['kode_supplier']);
            $data['nama_supplier'] = $suplier->nama_supplier;

            $data['sql'] = "SELECT tb2.kode_barang,tb2.nama_barang,tb1.harga,tb1.qty,tb1.id_pengadaan,tbl_supplier.nama_supplier FROM tbl_pengadaan_detail as tb1, tbl_obat_alkes_bhp as tb2,tbl_pengadaan_obat_alkes_bhp, tbl_supplier  WHERE tb1.kode_barang=tb2.kode_barang AND tbl_pengadaan_obat_alkes_bhp.no_faktur = tb1.no_faktur AND tbl_supplier.kode_supplier = tbl_pengadaan_obat_alkes_bhp.kode_supplier AND tb1.no_faktur = '$id'";
            $this->template->load('template', 'pengadaan/tbl_pengadaan_obat_alkes_bhp_read', $data);
        } else {
            $this->session->set_flashdata('message', 'Record Not Found');
            redirect(site_url('pengadaan'));
        }
    }

    public function cetak($id)
    {
        $row = $this->Tbl_pengadaan_obat_alkes_bhp_model->get_by_id($id);
        if ($row) {
            $data = array(
                'no_faktur' => $row->no_faktur,
                'tanggal' => $row->tanggal,
                'kode_supplier' => $row->kode_supplier,
            );

            $suplier = $this->Tbl_supplier_model->get_by_id($data['kode_supplier']);
            $data['nama_supplier'] = $suplier->nama_supplier;

            $data['sql'] = "SELECT tb2.kode_barang,tb2.nama_barang,tb1.harga,tb1.qty,tb1.id_pengadaan,tbl_supplier.nama_supplier FROM tbl_pengadaan_detail as tb1, tbl_obat_alkes_bhp as tb2,tbl_pengadaan_obat_alkes_bhp, tbl_supplier  WHERE tb1.kode_barang=tb2.kode_barang AND tbl_pengadaan_obat_alkes_bhp.no_faktur = tb1.no_faktur AND tbl_supplier.kode_supplier = tbl_pengadaan_obat_alkes_bhp.kode_supplier AND tb1.no_faktur = '$id'";
            $this->load->view('pengadaan/cetak', $data);

            // $this->template->load('template','pengadaan/cetak', $data);
        } else {
            $this->session->set_flashdata('message', 'Record Not Found');
            redirect(site_url('pengadaan'));
        }
    }

    public function create()
    {
        $data = array(
            'button' => 'Simpan',
            'action' => site_url('pengadaan/create_action'),
            'no_faktur' => set_value('no_faktur'),
            'tanggal' => set_value('tanggal'),
            'kode_supplier' => set_value('kode_supplier'),
            'suppliers' => $this->db->get('tbl_supplier')->result(),
            'medicines' => $this->db->get('tbl_obat_alkes_bhp')->result(),
        );
        $this->template->load('template', 'pengadaan/form_create', $data);
    }

    public function getKodeSupplier($namaSupplier)
    {
        $this->db->where('nama_supplier', $namaSupplier);
        $data = $this->db->get('tbl_supplier')->row_array();
        return $data['kode_supplier'];
    }

    public function create_action()
    {
        $this->_rules();

        if ($this->form_validation->run() == false) {
            $this->create();
        } else {
            $data = array(
                'no_faktur' => $this->input->post('no_faktur', true),
                'tanggal' => $this->input->post('tanggal', true),
                'kode_supplier' => $this->getKodeSupplier($this->input->post('kode_supplier', true)),
            );

            $this->Tbl_pengadaan_obat_alkes_bhp_model->insert($data);
            $this->session->set_flashdata('message', 'Create Record Success 2');
            $id = $this->input->post('no_faktur', true);
            redirect(site_url('pengadaan/update/' . $id));
        }
    }

    public function update($id)
    {
        $row = $this->Tbl_pengadaan_obat_alkes_bhp_model->get_by_id($id);

        if ($row) {
            $data = array(
                'button' => 'Update',
                'action' => site_url('pengadaan/update_action'),
                'no_faktur' => set_value('no_faktur', $row->no_faktur),
                'tanggal' => set_value('tanggal', $row->tanggal),
                'kode_supplier' => set_value('kode_supplier', $row->kode_supplier),
                'obats' => $this->db->get('tbl_obat_alkes_bhp')->result(),
            );
            $this->template->load('template', 'pengadaan/tbl_pengadaan_obat_alkes_bhp_form', $data);
        } else {
            $this->session->set_flashdata('message', 'Record Not Found');
            redirect(site_url('pengadaan'));
        }
    }

    public function update_action()
    {
        $this->_rules();

        if ($this->form_validation->run() == false) {
            $this->update($this->input->post('no_faktur', true));
        } else {
            $data = array(
                'tanggal' => $this->input->post('tanggal', true),
                'kode_supplier' => $this->input->post('kode_supplier', true),
            );

            $this->Tbl_pengadaan_obat_alkes_bhp_model->update($this->input->post('no_faktur', true), $data);
            $this->session->set_flashdata('message', 'Update Record Success');
            redirect(site_url('pengadaan'));
        }
    }

    public function delete($id)
    {
        $row = $this->Tbl_pengadaan_obat_alkes_bhp_model->get_by_id($id);

        if ($row) {

            $this->db->where('no_faktur', $id);
            $this->db->delete('tbl_pengadaan_detail');

            $this->Tbl_pengadaan_obat_alkes_bhp_model->delete($id);
            $this->session->set_flashdata('message', 'Delete Record Success');
            redirect(site_url('pengadaan'));
        } else {
            $this->session->set_flashdata('message', 'Record Not Found');
            redirect(site_url('pengadaan'));
        }
    }

    public function _rules()
    {
        $this->form_validation->set_rules('tanggal', 'tanggal', 'trim|required');
        $this->form_validation->set_rules('kode_supplier', 'kode supplier', 'trim|required');

        $this->form_validation->set_rules('no_faktur', 'no_faktur', 'trim');
        $this->form_validation->set_error_delimiters('<span class="text-danger">', '</span>');
    }

    public function add_ajax()
    {
        $NamaBarang = $this->input->get('barang');
        $qty = $this->input->get('qty');
        $harga = $this->input->get('harga');
        $faktur = $this->input->get('faktur');
        // mencari kode barang berdasarkan nama barang
        $barang = $this->db->get_where('tbl_obat_alkes_bhp', array('nama_barang' => $NamaBarang))->row_array();

        $data = array('kode_barang' => $barang['kode_barang'], 'qty' => $qty, 'no_faktur' => $faktur, 'harga' => $harga);

        $this->db->insert('tbl_pengadaan_detail', $data);

        $dataBarang = array(

            'Stok' => $barang['Stok'] + $qty,
        );

        $this->Tbl_obat_alkes_bhp_model->update($barang['kode_barang'], $dataBarang);

    }

    public function list_pengadaan()
    {
        $faktur = $_GET['faktur'];
        echo "<table class='table table-bordered'>
                <tr><th>NO</th><th>NAMA OBAT</th><th>QTY</th><th>HARGA</th></tr>";
        $sql = "SELECT tb2.kode_barang,tb2.nama_barang,tb1.harga,tb1.qty,tb1.id_pengadaan
                FROM tbl_pengadaan_detail as tb1, tbl_obat_alkes_bhp as tb2
                WHERE tb1.kode_barang=tb2.kode_barang and tb1.no_faktur='$faktur'";

        $list = $this->db->query($sql)->result();
        $no = 1;
        foreach ($list as $row) {
            echo "<tr>
                <td width='10'>$no</td>
                <td>$row->nama_barang</td>
                <td width='20'>$row->qty</td>
                <td width='100'>$row->harga</td>
                <td width='100' onClick='hapus($row->id_pengadaan)'><button class='btn btn-danger btn-sm'>Hapus</button></td>
                </tr>";
            $no++;
        }
        echo " </table>";
    }

    public function hapus_ajax()
    {
        $id_pengadaan = $_GET['id_pengadaan'];
        $this->db->where('id_pengadaan', $id_pengadaan);
        $this->db->delete('tbl_pengadaan_detail');
    }

    public function filter()
    {

        $data['bulan'] = [
            'semua' => 'semua',
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

        $this->template->load('template', 'pengadaan/filter', $data);

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

        $sql = "SELECT * , sum(qty) as qty_total, sum(tbl_pengadaan_detail.harga) as harga_total FROM tbl_pengadaan_obat_alkes_bhp
            JOIN tbl_pengadaan_detail ON tbl_pengadaan_obat_alkes_bhp.no_faktur = tbl_pengadaan_detail.no_faktur
            JOIN tbl_obat_alkes_bhp ON tbl_pengadaan_detail.kode_barang = tbl_obat_alkes_bhp.kode_barang
            WHERE tbl_pengadaan_obat_alkes_bhp.tanggal LIKE '$param' GROUP BY nama_barang ";

        $data['list'] = $this->db->query($sql)->result();

        $data['obat_keluar'] = $this->db->query("SELECT sum(tbl_pengadaan_detail.qty) as total FROM tbl_pengadaan_obat_alkes_bhp
        JOIN tbl_pengadaan_detail ON tbl_pengadaan_obat_alkes_bhp.no_faktur = tbl_pengadaan_detail.no_faktur
        JOIN tbl_obat_alkes_bhp ON tbl_pengadaan_detail.kode_barang = tbl_obat_alkes_bhp.kode_barang
        WHERE tbl_pengadaan_obat_alkes_bhp.tanggal LIKE '$param'")->row();

        $data['total_pengeluaran'] = $this->db->query("SELECT sum(tbl_pengadaan_detail.harga) as total FROM tbl_pengadaan_obat_alkes_bhp
        JOIN tbl_pengadaan_detail ON tbl_pengadaan_obat_alkes_bhp.no_faktur = tbl_pengadaan_detail.no_faktur
        JOIN tbl_obat_alkes_bhp ON tbl_pengadaan_detail.kode_barang = tbl_obat_alkes_bhp.kode_barang
        WHERE tbl_pengadaan_obat_alkes_bhp.tanggal LIKE '$param'")->row();

        $data['obat_keluar_terbanyak'] = $this->db->query("SELECT nama_barang,sum(tbl_pengadaan_detail.qty) as total FROM tbl_pengadaan_obat_alkes_bhp
        JOIN tbl_pengadaan_detail ON tbl_pengadaan_obat_alkes_bhp.no_faktur = tbl_pengadaan_detail.no_faktur
        JOIN tbl_obat_alkes_bhp ON tbl_pengadaan_detail.kode_barang = tbl_obat_alkes_bhp.kode_barang
        WHERE tbl_pengadaan_obat_alkes_bhp.tanggal LIKE '$param'
        GROUP BY nama_barang ORDER BY total DESC
        LIMIT 1
        ")->row();

        $data['obat_sedikit_keluar'] = $this->db->query("SELECT nama_barang,sum(tbl_pengadaan_detail.qty) as total FROM tbl_pengadaan_obat_alkes_bhp
        JOIN tbl_pengadaan_detail ON tbl_pengadaan_obat_alkes_bhp.no_faktur = tbl_pengadaan_detail.no_faktur
        JOIN tbl_obat_alkes_bhp ON tbl_pengadaan_detail.kode_barang = tbl_obat_alkes_bhp.kode_barang
        WHERE tbl_pengadaan_obat_alkes_bhp.tanggal LIKE '$param'
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

        $this->load->view('pengadaan/cetak_rekap', $data);

    }

}

/* End of file Pengadaan.php */
/* Location: ./application/controllers/Pengadaan.php */
/* Please DO NOT modify this information : */
/* Generated by Harviacode Codeigniter CRUD Generator 2017-12-10 02:07:42 */
/* http://harviacode.com */