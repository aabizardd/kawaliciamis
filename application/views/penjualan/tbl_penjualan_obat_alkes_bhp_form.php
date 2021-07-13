<div class="content-wrapper">

    <section class="content">
        <div class="box box-warning box-solid">
            <div class="box-header with-border">
                <h3 class="box-title">FORM PENGELUARAN OBAT</h3>
            </div>
            <form action="<?php echo $action; ?>" method="post">

                <table class='table table-bordered>'>
                    <tr>
                        <td>No Faktur</td>
                        <td><input id="nofaktur" onKeyup="load()" placeholder="Masukan No Faktur" class="form-control"
                                type="text" name="no_faktur" value="<?php echo uniqid('faktur'); ?>" readonly /> </td>
                    </tr>
                    <tr>
                        <td width='200'>Tanggal <?php echo form_error('tanggal') ?></td>
                        <td><input type="date" class="form-control" name="tanggal" id="tanggal" placeholder="Tanggal"
                                value="<?php echo $tanggal; ?>" /></td>
                    </tr>
                    <tr>
                        <td width='200'>Nama Pasien <?php echo form_error('nama_pasien') ?>
                        </td>
                        <td>


                            <select class="form-control" id="inputGroupSelect01" name="nama_pasien">
                                <option selected>Choose...</option>
                                <?php foreach ($pasiens as $pasien): ?>
                                <option value="<?=$pasien->nama_pasien?>"><?=strtoupper($pasien->nama_pasien)?>
                                </option>
                                <?php endforeach;?>

                            </select>

                            <!-- <input type="Text" class="form-control" name="nama_pasien" id="nama_pasien"
                                placeholder="Nama Pasien" value="<?php echo $nama_pasien; ?>" /> -->
                        </td>
                    </tr>

                </table>


                <div class="form-group fieldGroup barang-grup1">
                    <div class="input-group">
                        <div class="col-md-row">
                            <div class="form-group col-md-4">

                                <label for="exampleInputEmail1">Obat</label>

                                <select class="form-control" id="inputGroupSelect01" name="kode_barang[]" id="barang1">
                                    <option selected value="">Choose...</option>
                                    <?php foreach ($obats as $obat): ?>
                                    <option value="<?=$obat->nama_barang?>"><?=$obat->nama_barang?> | Satuan :
                                        <?=$obat->nama_satuan?> |
                                        Stok : <?=$obat->Stok?> |
                                    </option>
                                    <?php endforeach;?>

                                </select>

                                <!-- <input type="text" id="barang1" placeholder="Masukan Nama Obat" name="kode_barang[]"
                                    class="form-control obats"> -->

                                <!-- <select class="form-control select2" name="kode_barang[]" id="">
                                        <option value="">--Pilih--</option>
                                        <?php
foreach ($obat as $key => $value) {

    echo ' <option value="' . $value->kode_barang . '">' . $value->nama_barang . '</option>';
}

?> -->


                                </select>
                            </div>

                            <!-- <div class="form-group col-md-2">
                                <label for="exampleInputEmail1">Satuan Obat</label>
                                <input type="text" class="form-control" name="satuan_obat[]" placeholder="Ex: botol"
                                    readonly>
                            </div>

                            <div class="form-group col-md-2">
                                <label for="exampleInputEmail1">Stok Obat</label>
                                <input type="text" class="form-control" name="stok_obat[]" placeholder="Ex: 100"
                                    readonly>
                            </div> -->

                            <div class="form-group col-md-4">
                                <label for="exampleInputEmail1">Aturan Pakai</label>
                                <input type="text" class="form-control" name="aturan_pemakaian[]"
                                    placeholder="Ex: 3 x 1" id="satuan_obat">
                            </div>

                            <div class="form-group col-md-4">
                                <label for="exampleInputEmail1">QTY</label>
                                <input type="number" class="form-control" name="qty[]" placeholder="jumlah">
                            </div>

                        </div>


                        <div class="input-group-addon ml-3">
                            <a href="javascript:void(0)" class="btn btn-success addMore"><i class="fa fa-plus"></i></a>
                        </div>

                    </div>
                </div>
                <div style="margin:10px;">
                    <button type="submit" class="btn btn-danger">
                        <i class="fa fa-floppy-o"></i>
                        <?php echo $button ?>
                    </button>

                    <a href="<?php echo site_url('penjualan') ?>" class="btn btn-info"><i class="fa fa-sign-out"></i>
                        Kembali</a></td>
                    </tr>
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



    //autocomplete
    $("#barang1").autocomplete({
        source: "<?php echo base_url() ?>index.php/dataobat/autocomplate",
        minLength: 1
    });
});

function loadobat(param) {
    var selector = '#barang' + param;
    $(selector).autocomplete({
        source: "<?php echo base_url() ?>index.php/dataobat/autocomplate",
        minLength: 1
    });
}
</script>

<script type="text/javascript">
function add() {
    var barang = $("#barang").val();
    var harga = $("#harga").val();
    var qty = $("#qty").val();
    var faktur = $("#nofaktur").val();
    $.ajax({
        url: "<?php echo base_url() ?>index.php/penjualan/add_ajax",
        data: "barang=" + barang + "&qty=" + qty + "&harga=" + harga + "&faktur=" + faktur,
        success: function(html) {
            load();
        }
    });

}

function load() {
    var faktur = $("#nofaktur").val();
    $.ajax({
        url: "<?php echo base_url() ?>index.php/penjualan/list_penjualan",
        data: "faktur=" + faktur,
        success: function(html) {
            $("#list").html(html);
        }
    });
}

function hapus(id) {
    $.ajax({
        url: "<?php echo base_url() ?>index.php/penjualan/hapus_ajax",
        data: "id_penjualan=" + id,
        success: function(html) {
            load();
        }
    });
}
</script>

<script type="text/javascript">
$(document).ready(function() {
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
$(document).ready(function() {
    // membatasi jumlah inputan
    var maxGroup = 10;
    //melakukan proses multiple input
    $(".addMore").click(function() {
        var jumlah = $('body').find('.fieldGroup').length + 1;
        if ($('body').find('.fieldGroup').length < maxGroup) {



            var myvar =
                '				    <div class="input-group">' +
                '                            <div class="col-md-row">' +
                '                                    <div class="form-group col-md-4">' +
                '                                        <label for="exampleInputEmail1">Obat</label>' +
                '                                        <select id="barang' + jumlah +
                '"name="kode_barang[]" class="yahud form-control">' +
                '<option selected>Pilih...</option>' +
                <?php foreach ($obats as $obat): ?> '<option value="<?=$obat->nama_barang?>"><?=$obat->nama_barang?> | Satuan : <?=$obat->nama_satuan?> | Stok : <?=$obat->Stok?> |</option>' +
                <?php endforeach;?> '</select>' +
                '                                    </div>' +
                '                                    <div class="form-group col-md-4">' +
                '                                        <label for="exampleInputEmail1">Aturan Pakai</label>' +
                '                                        <input type="text" class="form-control" name="aturan_pemakaian[]" placeholder="Ex: 3 x 1">' +
                '                                    </div>' +
                '                                    <div class="form-group col-md-4">' +
                '                                        <label for="exampleInputEmail1">QTY</label>' +
                '                                        <input type="number" class="form-control" name="qty[]"  placeholder="jumlah">' +
                '                                    </div>' +
                '                                ' +
                '                            </div>' +
                '                            <div class="input-group-addon"> ' +
                '                                <a href="javascript:void(0)" class="btn btn-danger remove"><i class="fa fa-trash"></i></a>' +
                '                            </div>' +
                '				    </div>';


            var fieldHTML = '<div class="form-group fieldGroup barang-grup' + jumlah + '">' + myvar +
                '</div>';
            $('body').find('.fieldGroup:last').after(fieldHTML);
            loadobat(jumlah);
        } else {
            alert('Maximum ' + maxGroup + ' groups are allowed.');
        }
    });

    //remove fields group
    $("body").on("click", ".remove", function() {
        $(this).parents(".fieldGroup").remove();
    });
});
</script>

<script>
var log = document.getElementsByName('kode_barang[]');
var atr = document.getElementsByName('aturan_pemakaian[]');

document.addEventListener('keyup', logKey);

function logKey(e) {
    var vals = [];
    for (var i = 0, n = log.length; i < n; i++) {

        // vals += "," + log[i].value + "idx" + i;

        var va = log[i].value



        vals.push(va);



    }
    console.log(document.getElementsByName('kode_barang').value)

    // console.log(vals)




}
</script>