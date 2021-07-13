<div class="content-wrapper">

    <section class="content">
        <div class="box box-warning box-solid">
            <div class="box-header with-border">
                <h3 class="box-title">FORM PENGELUARAN OBAT</h3>
            </div>
            <form action="<?php echo $action; ?>" method="post">

                <table class='table table-bordered>'>
                       <tr><td>No Faktur</td><td><input id="nofaktur" onKeyup="load()" placeholder="Masukan No Faktur" class="form-control" type="text" name="no_faktur" value="<?php echo $no_faktur; ?>" /> </td></tr>
                    <tr><td width='200'>Tanggal <?php echo form_error('tanggal') ?></td><td><input type="date" class="form-control" name="tanggal" id="tanggal" placeholder="Tanggal" value="<?php echo $tanggal; ?>" /></td></tr>
                    <tr>
                        <td width='200'>Nama Pasien <?php echo form_error('nama_pasien') ?>
                        </td>
                        <td>
                        <input type="Text" class="form-control" name="nama_pasien" id="nama_pasien" placeholder="Nama Pasien" value="<?php echo $nama_pasien; ?>" />
                        </td>
                    </tr>

                     
                          
                </table>
                
                <?php 
                $no = 1;
                
                foreach($detail as $key => $item) { 
                    
                    
                    $classDiv = '';
                    $btn='';

                    if($key == 0){

                        $classDiv="fieldGroup";
                        $btn ='<a href="javascript:void(0)" class="btn btn-success addMore"><i class="fa fa-plus"></i></a>';
                    }else{
                        $classDiv="fieldGroup";
                        $btn ='<a href="javascript:void(0)" class="btn btn-danger remove"><i class="fa fa-trash"></i></a>';

                    }

                    ?>

                    
                <div class="form-group <?php echo $classDiv?>">
				        <div class="input-group">
                            <div class="col-md-row">
                                    <div class="form-group col-md-6">
                                        <label for="exampleInputEmail1">Obat</label>
                                        

                                        <input type="text"  id="barang<?php echo $no?>"  class="form-control" name="kode_barang[]" value="<?php echo $item->nama_barang;?>">



                                    </div>
                                    <div class="form-group col-md-3">
                                        <label for="exampleInputEmail1">Aturan Pakai</label>
                                        <input type="text" class="form-control" name="aturan_pemakaian[]" value="<?php echo $item->aturan_pemakaian;?>" placeholder="Ex: 3 x 1">
                                    </div>
                                    <div class="form-group col-md-3">
                                        <label for="exampleInputEmail1">QTY</label>
                                        <input type="number" class="form-control" name="qty[]" value="<?php echo $item->qty;?>" placeholder="jumlah">
                                    </div>
                                
                            </div>
                           
                           
				            <div class="input-group-addon ml-3"> 
                            <?php echo $btn?>

				            </div>
				        </div>
				</div>

                

                <?php $no++;} ?>


    <div style="margin:10px;">
    <button type="submit" class="btn btn-danger"><i class="fa fa-floppy-o"></i> <?php echo $button ?></button> 
                        <a href="<?php echo site_url('penjualan') ?>" class="btn btn-info"><i class="fa fa-sign-out"></i> Kembali</a></td></tr>
    </div>
    
                     
                </form>  
                
            


                      </div>
       


        </div>
</div>
</div>

<script src="<?php echo base_url('assets/js/jquery-1.11.2.min.js') ?>"></script>
<script src="<?php echo base_url('assets/datatables/jquery.dataTables.js') ?>"></script>
<script src="<?php echo base_url('assets/datatables/dataTables.bootstrap.js') ?>"></script>


<script type="text/javascript">
    $(function() {
        

       			<?php for($i=1; $i<=$no; $i++) {?>
        //autocomplete
        $("#barang<?php echo $i;?>").autocomplete({
            source: "<?php echo base_url() ?>index.php/dataobat/autocomplate",
            minLength: 1
        });		
        
        <?php } ?>
    });

    function loadobat(param){
        var selector='#barang'+param;
        $(selector).autocomplete({
            source: "<?php echo base_url() ?>index.php/dataobat/autocomplate",
            minLength: 1
        });		
    }
</script>

<script type="text/javascript">
    $(function() {
        //autocomplete
        $("#barang").autocomplete({
            source: "<?php echo base_url() ?>index.php/dataobat/autocomplate",
            minLength: 1
        });				
    });
</script>

<script type="text/javascript">
    function add(){
        var barang = $("#barang").val();
        var harga = $("#harga").val();
        var qty = $("#qty").val();
        var faktur = $("#nofaktur").val();
        $.ajax({
            url:"<?php echo base_url() ?>index.php/penjualan/add_ajax",
            data:"barang=" + barang + "&qty="+ qty+"&harga=" + harga + "&faktur="+ faktur ,
            success: function(html)
            {
                load();
            }
        });
    
    }
    
    function load(){
    var faktur = $("#nofaktur").val();
        $.ajax({
            url:"<?php echo base_url() ?>index.php/penjualan/list_penjualan",
            data:"faktur="+faktur ,
            success: function(html)
            {
                $("#list").html(html);
            }
        });
    }
        
    function hapus(id){
        $.ajax({
            url:"<?php echo base_url() ?>index.php/penjualan/hapus_ajax",
            data:"id_penjualan=" + id ,
            success: function(html)
            {
                load();
            }
        });
    }

</script>

<script type="text/javascript">
    $(document).ready(function(){
        //load();             
    });
</script>

<script type="text/javascript">
    $(function() {
        //autocomplete
        $("#kode_supplier").autocomplete({
            source: "<?php echo base_url() ?>index.php/supplier/autocomplate",
            minLength: 1
        });				
    });
</script>


<script>
		$(document).ready(function(){
    // membatasi jumlah inputan
    var maxGroup = 10;
    //melakukan proses multiple input 
    $(".addMore").click(function(){
        var jumlah = $('body').find('.fieldGroup').length +1 ;
        if($('body').find('.fieldGroup').length < maxGroup){
            
var myvar = 
'				    <div class="input-group">'+
'                            <div class="col-md-row">'+
'                                    <div class="form-group col-md-6">'+
'                                        <label for="exampleInputEmail1">Obat</label>'+
'                                        <input type="text" id="barang'+jumlah+'" placeholder="Masukan Nama Barang" name="kode_barang[]" class="yahud form-control">'+
''+
'                                       '+
'                                    </div>'+
'                                    <div class="form-group col-md-3">'+
'                                        <label for="exampleInputEmail1">Aturan Pakai</label>'+
'                                        <input type="text" class="form-control" name="aturan_pemakaian[]" placeholder="Ex: 3 x 1">'+
'                                    </div>'+
'                                    <div class="form-group col-md-3">'+
'                                        <label for="exampleInputEmail1">QTY</label>'+
'                                        <input type="number" class="form-control" name="qty[]"  placeholder="jumlah">'+
'                                    </div>'+
'                                '+
'                            </div>'+
'                            <div class="input-group-addon"> '+
'                                <a href="javascript:void(0)" class="btn btn-danger remove"><i class="fa fa-trash"></i></a>'+
'                            </div>'+
'				    </div>';
	

            var fieldHTML = '<div class="form-group fieldGroup barang-grup'+jumlah+'">'+myvar+'</div>';
            $('body').find('.fieldGroup:last').after(fieldHTML);
            loadobat(jumlah);
        }else{
            alert('Maximum '+maxGroup+' groups are allowed.');
        }
    });
    
    //remove fields group
    $("body").on("click",".remove",function(){ 
        $(this).parents(".fieldGroup").remove();
    });
});
	</script>