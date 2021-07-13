<!doctype html>
<html>
    <head>
        <title>harviacode.com - codeigniter crud generator</title>
        <link rel="stylesheet" href="<?php echo base_url('assets/bootstrap/css/bootstrap.min.css') ?>"/>
        <style>
            .word-table {
                border:1px solid black !important; 
                border-collapse: collapse !important;
                width: 100%;
            }
            .word-table tr th, .word-table tr td{
                border:1px solid black !important; 
                padding: 5px 10px;
            }
        </style>
    </head>
    <body>
        <h2>Tbl_obat_alkes_bhp List</h2>
        <table class="word-table" style="margin-bottom: 10px">
            <tr>
                <th>No</th>
		<th>Nama Obat</th>
		<th>Id Kategori Obat</th>
		<th>Id Satuan Obat</th>
		<th>Harga</th>
        <th>Kadaluwarsa</th>
        <th>Stok</th>
        <th>Status Stok</th>
		
            </tr><?php
            foreach ($dataobat_data as $dataobat)
            {
                ?>
                <tr>
		      <td><?php echo ++$start ?></td>
		      <td><?php echo $dataobat->nama_barang ?></td>
		      <td><?php echo $dataobat->id_kategori_barang ?></td>
		      <td><?php echo $dataobat->id_satuan_barang ?></td>
		      <td><?php echo $dataobat->harga ?></td>	
              <td><?php echo $dataobat->Kadaluwarsa ?></td>	
              <td><?php echo $dataobat->Stok ?></td>	
              <td><?php if($dataobat->Stok < 15){
                  echo '<label class="label label-warning">Obat Menipis</label>';

              }else{
                 echo '<label class="label label-primary">Obat Tersedia</label>';

              } ?></td>	
                </tr>
                <?php
            }
            ?>
        </table>
    </body>
</html>