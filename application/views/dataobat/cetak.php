<!DOCTYPE html>

<html>
<head>
    
	<title>Cetak Data Obat</title>
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
               <center> <h3 class="box-title">LAPORAN DATA OBAT <br> 
               
               
              
               
            </h3></center>
            </div>

            <table class="border" width="100%" border="1">       
                
                
            </table></form>        </div>
        <div class="box box-warning box-solid">
            <div class="box-header with-border">
                <h3 class="box-title">DAFTAR DATA OBAT </h3>
            </div>
            <?php
            echo "<table width='100%' class='border' border='1'>
                <tr>
                <th>NO</th>
                <th>KODE OBAT</th>
                <th>NAMA OBAT</th>
                <th>NAMA KATEGORI</th>
                <th>STOK TERSEDIA</th>
                <th>SATUAN</th>
                <th>HARGA</th>
                </tr>";
        $no=1;
        foreach ($list as $row){
            echo "<tr>
                <td width='2'>$no</td>
                <td width='30'>$row->kode_barang</td>
                <td width='30'>$row->nama_barang</td>
                <td width='30'>$row->nama_kategori</td>
                <td width='20'>$row->Stok</td>
                <td width='20'>$row->nama_satuan</td>
                <td width='100'>$row->harga</td>
                </td>
                </tr>";
            $no++;
        }
        echo" 
     
        </table>";


        ?>

<br>
<br>
        <table class="border" width="100%" border="1">          
            <tr>
                <td>OBAT YANG AKAN HABIS</td>
                <td>
                <ul>
                
                <?php 
                if($stokMauHabis!=null){
                    foreach ($stokMauHabis as $row){

                        echo "<li>".$row->nama_barang."</li>";
    
                     }
                }else{
                    echo "Tidak ada Obat yang akan Habis";
                }


                
                ?>
                </ul>
                </td>

               

            </tr>
            <tr>
            <td> STOK YANG HARUS DITAMBAH</td>
                <td>
                <ul>
                
                <?php 
                if($stokHabis!=null){
                    foreach ($stokHabis as $row){

                        echo "<li>".$row->nama_barang."</li>";
    
                     }
                }else{
                    echo "Tidak ada Obat yang harus ditambah";
                }


                
                ?>
                </ul>
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