<div class="content-wrapper">

    <section class="content">
        <div class="box box-warning box-solid">
            <div class="box-header with-border">
                <h3 class="box-title">INPUT DATA PENYEDIA IBAT</h3>
            </div>
            <form action="<?php echo $action; ?>" method="post">

                <table class='table table-bordered>'>
                    <tr>
                        <td>Kode Penyedia</td>
                        <td><input type="text" class="form-control" placeholder="Kode Penyedia" name="kode_supplier"
                                value="<?php echo "KPA" . rand(10, 1000); ?>" readonly /></td>
                    <tr>
                    <tr>
                        <td width='200'>Nama Penyedia <?php echo form_error('nama_supplier') ?></td>
                        <td><input type="text" class="form-control" name="nama_supplier" id="nama_supplier"
                                placeholder="Nama Penyedia" value="<?php echo $nama_supplier; ?>" /></td>
                    </tr>

                    <tr>
                        <td width='200'>Alamat <?php echo form_error('alamat') ?></td>
                        <td> <textarea class="form-control" rows="3" name="alamat" id="alamat"
                                placeholder="Alamat"><?php echo $alamat; ?></textarea></td>
                    </tr>
                    <tr>
                        <td width='200'>No Telepon <?php echo form_error('no_telpon') ?></td>
                        <td><input type="text" class="form-control" name="no_telpon" id="no_telpon"
                                placeholder="No Telepon" value="<?php echo $no_telpon; ?>" /></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <button type="submit" class="btn btn-danger"><i class="fa fa-floppy-o"></i>
                                <?php echo $button ?></button>
                            <a href="<?php echo site_url('supplier') ?>" class="btn btn-info"><i
                                    class="fa fa-sign-out"></i> Kembali</a>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
</div>
</div>