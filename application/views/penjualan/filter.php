<div class="content-wrapper">

    <section class="content">
        <div class="box box-info box-solid">
            <div class="box-header with-border">
                <h3 class="box-title">FORM FILTER LAPORAN PENGELUARAN </h3>
            </div>

            <div class="box-body">
                <form class="form" action="<?php echo site_url('penjualan/cetak_action') ?>" method="get">

                    <div class="form-group col-md-3">
                        <label for="exampleInputEmail1">Penanggung Jawab</label>

                        <select class="form-control" name="pj" id="">
                            <?php foreach ($employees as $empl): ?>

                            <option value="<?=$empl->nama_pegawai?>"><?=$empl->nama_pegawai?></option>

                            <?php endforeach?>

                        </select>

                    </div>



                    <div class="form-group col-md-3">
                        <label for="exampleInputEmail1">Bulan</label>

                        <select class="form-control" name="bulan" id="">
                            <?php foreach ($bulan as $key => $value) {
    echo '<option value="' . $key . '">' . $value . ' </option>';
}

?>

                        </select>
                    </div>

                    <div class="form-group col-md-3">
                        <label for="exampleInputEmail1">Tahun</label>

                        <select class="form-control" name="tahun" id="">
                            <?php foreach ($tahun as $key => $value) {
    echo '<option value="' . $key . '">' . $value . ' </option>';
}

?>

                        </select>
                    </div>


                    <div class="col-md-3 form-group" style="margin-top:25px;">
                        <button type="submit" class="btn btn-info"><i class="fa fa-floppy-o"></i> Filter</button>
                    </div>

                </form>
            </div>

        </div>
</div>


<script src="<?php echo base_url('assets/js/jquery-1.11.2.min.js') ?>"></script>
<script src="<?php echo base_url('assets/datatables/jquery.dataTables.js') ?>"></script>
<script src="<?php echo base_url('assets/datatables/dataTables.bootstrap.js') ?>"></script>

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
        if ($('body').find('.fieldGroup').length < maxGroup) {
            var fieldHTML = '<div class="form-group fieldGroup">' + $(".fieldGroupCopy").html() +
                '</div>';
            $('body').find('.fieldGroup:last').after(fieldHTML);
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