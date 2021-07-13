<!DOCTYPE html>

<html>

    <head>

        <title>Cetak SPP</title>
        <style>
        table.border,
        table.border th,
        table.border td {
            border: 1px solid black;
            border-collapse: collapse;
        }

        table.no-border {
            border: none;
        }
        </style>
    </head>

    <body style="margin:30px 100px;">
        <div class="content-wrapper">

            <section class="content">
                <div class="box box-warning box-solid">
                    <div class="box-header with-border">
                        <center>
                            <h3 class="box-title">LAPORAN PENGADAAN OBAT <br>


                                <?php

if ($bulan == 'semua' and $tahun = 'semua') {
    echo 'dalam Semua Periode';

} else if ($bulan == 'semua' and $tahun != 'semua') {
    echo 'Tahun : ' . $tahun;

} else if ($bulan != 'semua' and $tahun == 'semua') {
    echo 'Bulan : ' . $bulan;
} else {
    echo $bulan . ' ' . $tahun;
}

?></h3>
                        </center>
                    </div>

                    <table class="border" width="100%" border="1">
                        <!-- <tr><td>No Faktur</td><td><?php echo $no_faktur; ?></td></tr>
                <tr><td width='100'>Tanggal <?php echo form_error('tanggal') ?></td>
                    <td><?php echo date("d-m-Y", strtotime($tanggal)); ?></td></tr>
                <tr><td width='100'>Penyedia <?php echo form_error('kode_supplier') ?></td>
                    <td><?php echo $nama_supplier; ?></td></tr>
                 -->

                    </table>
                    </form>
                </div>
                <div class="box box-warning box-solid">
                    <div class="box-header with-border">
                        <h3 class="box-title">DAFTAR ITEM YANG DIBELI </h3>
                    </div>
                    <?php
echo "<p>Tanggaal Cetak: " . date('d F Y') . "</p> <p>Penanggung Jawab: " . $pj . "</p>
<table width='100%' class='border' border='1'>
                <tr><th>NO</th><th>KODE OBAT</th><th>NAMA OBAT</th><th>QTY</th><th>HARGA</th></tr>";
$no = 1;
foreach ($list as $row) {
    echo "<tr>
                <td width='2'>$no</td>
                <td width='30'>$row->kode_barang</td>
                <td width='30'>$row->nama_barang</td>
                <td width='20'>$row->qty_total</td>
                <td width='100' style='text-align:right'>" . "Rp " . number_format($row->harga_total, 2, ',', '.') . "</td>
                </td>
                </tr>";
    $no++;
}
echo "
        <tr>
        <td colspan='3'>Total Transaksi : </td>
        <td colspan='2' style='text-align:right'>" . "Rp " . number_format($total_pengeluaran->total, 2, ',', '.') . " </td>
        </tr>
        </table>";

?>

                    <br>
                    <br>
                    <table class="border" width="100%" border="1">
                        <tr>
                            <td>Total Biaya Pengadaan</td>
                            <td><?php echo ($total_pengeluaran->total == null) ? 'Tidak Ada Pembelian Obat' : "Rp " . number_format($total_pengeluaran->total, 2, ',', '.'); ?>
                            </td>

                        </tr>

                        <tr>
                            <td>Jumlah obat yang Masuk</td>
                            <td><?php echo ($obat_keluar->total == null) ? 'Tidak Ada Obat Keluar' : $obat_keluar->total; ?>
                            </td>


                        </tr>

                        <tr>
                            <td>Obat yang Paling Banyak Masuk</td>
                            <td><?php echo ($obat_keluar_terbanyak == null) ? 'Tidak Ada Obat Keluar' : $obat_keluar_terbanyak->nama_barang; ?>
                            </td>

                        </tr>

                        <tr>
                            <td>Obat yang Paling Sedikit Masuk</td>
                            <td><?php echo ($obat_sedikit_keluar == null) ? 'Tidak Ada Obat Keluar' : $obat_sedikit_keluar->nama_barang; ?>
                            </td>


                        </tr>

                    </table>


                </div>
        </div>
        </div>

    </body>

    <script src="<?php echo base_url('assets/js/jquery-1.11.2.min.js') ?>"></script>
    <script src="<?php echo base_url('assets/datatables/jquery.dataTables.js') ?>"></script>
    <script src="<?php echo base_url('assets/datatables/dataTables.bootstrap.js') ?>"></script>

    <script>
    window.print();
    </script>