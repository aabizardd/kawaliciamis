<!DOCTYPE html>

<html>
<head>
    
	<title>Cetak SPP</title>
        <style>
            table.border,  table.border th,  table.border td {
              border: 1px solid black;
              border-collapse: collapse;
            }
            table.no-border{
                border:none;
            }
            </style>
</head>
<body style="margin:30px 100px;">
<div class="content-wrapper">

    <section class="content">
        <div class="box box-warning box-solid">
            <div class="box-header with-border">
                <h3 class="box-title">FORM PENGADAAN OBAT </h3>
            </div>

            <table class="border" width="100%" border="1">       
                   <tr><td>No Faktur</td><td><?php echo $no_faktur; ?></td></tr>
                <tr><td width='100'>Tanggal <?php echo form_error('tanggal') ?></td>
                    <td><?php echo date("d-m-Y", strtotime($tanggal)); ?></td></tr>
                <tr><td width='100'>Penyedia <?php echo form_error('kode_supplier') ?></td>
                    <td><?php echo $nama_supplier; ?></td></tr>
                
                
            </table></form>        </div>
        <div class="box box-warning box-solid">
            <div class="box-header with-border">
                <h3 class="box-title">DAFTAR ITEM YANG DIBELI </h3>
            </div>
            <?php
            echo "<table width='100%' class='border' border='1'>
                <tr><th>NO</th><th>NAMA BARANG</th><th>QTY</th><th>HARGA</th></tr>";
        $list = $this->db->query($sql)->result();
        $no=1;
        foreach ($list as $row){
            echo "<tr>
                <td width='2'>$no</td>
                <td width='30'>$row->nama_barang</td>
                <td width='20'>$row->qty</td>
                <td width='100'>$row->harga</td>
                </td>
                </tr>";
            $no++;
        }
        echo" </table>";
            ?>


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