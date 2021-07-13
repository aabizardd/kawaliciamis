-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 13, 2021 at 06:46 AM
-- Server version: 10.4.18-MariaDB
-- PHP Version: 7.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `simrs`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `dokterr` (`id` INT)  BEGIN
DECLARE namadokter VARCHAR(50);
DECLARE kodedokter VARCHAR(10);
DECLARE spesialiss INT;
DECLARE hasil VARCHAR(255);
SELECT nama_dokter,id_spesialis into namadokter,spesialiss from tbl_dokter join tbl_spesialis using (id_spesialis) where kode_dokter=id;
SET hasil = concat('Kode Dokter :',id,'\r\n');
SET hasil = concat(hasil, 'Nama Dokter : ',namadokter,'\r\n');
SET hasil = concat(hasil, 'Spesialis  : ',spesialiss);
select hasil as 'keterangan';
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `laporan` ()  BEGIN
SELECT * from tbl_dokter;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fliat` (`tarif` INT) RETURNS VARCHAR(25) CHARSET utf8mb4 BEGIN
DECLARE hasil VARCHAR(50);
if tarif <=45000 THEN SET  hasil= "Biaya Murah";
ELSEIF tarif >45000 && tarif <=100000 THEN SET hasil="Biaya Standar";
ELSE SET hasil="Biaya Mahal";
END IF;
RETURN (hasil);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `labor` (`idd` INT) RETURNS VARCHAR(50) CHARSET utf8mb4 BEGIN
DECLARE hasil VARCHAR(50);
SELECT nama_dokter into hasil from tbl_dokter where id_spesialis=idd;
RETURN hasil ;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `auditlabor`
--

CREATE TABLE `auditlabor` (
  `id` int(11) NOT NULL,
  `kode_periksa` varchar(6) NOT NULL,
  `nama_periksa` varchar(255) NOT NULL,
  `tarif` int(11) NOT NULL,
  `tglubah` datetime DEFAULT NULL,
  `aksi` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `auditlabor`
--

INSERT INTO `auditlabor` (`id`, `kode_periksa`, `nama_periksa`, `tarif`, `tglubah`, `aksi`) VALUES
(1, 'DR', 'Darah Rutin', 0, '2020-04-27 23:39:59', 'update'),
(2, 'co', 'Tes DNA', 0, '2020-04-27 23:47:46', 'insert'),
(3, 'co', 'Tes DNA', 0, '2020-04-28 00:00:54', 'delete'),
(4, 'DR', 'Cuci Darah', 0, '2020-05-05 10:27:18', 'update'),
(5, 'ya', 'Cek Darah', 0, '2020-05-05 10:29:38', 'update'),
(6, 'fr', 'Foto Rontgen', 200000, '2020-05-05 10:34:53', 'update'),
(7, 'co', 'Check Up', 0, '2020-10-17 21:26:41', 'insert'),
(8, 'sb', 'Cek Urine', 0, '2020-12-04 06:21:11', 'insert');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_agama`
--

CREATE TABLE `tbl_agama` (
  `id_agama` int(11) NOT NULL,
  `agama` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_agama`
--

INSERT INTO `tbl_agama` (`id_agama`, `agama`) VALUES
(1, 'ISLAM'),
(2, 'KRISTEN'),
(3, 'HINDU'),
(4, 'BUDHA');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_bidang`
--

CREATE TABLE `tbl_bidang` (
  `id_bidang` int(11) NOT NULL,
  `nama_bidang` varchar(35) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_bidang`
--

INSERT INTO `tbl_bidang` (`id_bidang`, `nama_bidang`) VALUES
(1, 'BIDANG 1'),
(2, 'BIDANG 2'),
(3, 'bidang 33');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_departemen`
--

CREATE TABLE `tbl_departemen` (
  `id_departemen` int(11) NOT NULL,
  `nama_departemen` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_departemen`
--

INSERT INTO `tbl_departemen` (`id_departemen`, `nama_departemen`) VALUES
(1, 'DEPARTEMEN 1'),
(2, 'kemanan'),
(3, 'KEUANGAN');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_diagnosa_penyakit`
--

CREATE TABLE `tbl_diagnosa_penyakit` (
  `kode_diagnosa` varchar(6) NOT NULL,
  `nama_penyakit` varchar(50) NOT NULL,
  `ciri_ciri_penyakit` text NOT NULL,
  `keterangan` text NOT NULL,
  `ciri_ciri_umum` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_diagnosa_penyakit`
--

INSERT INTO `tbl_diagnosa_penyakit` (`kode_diagnosa`, `nama_penyakit`, `ciri_ciri_penyakit`, `keterangan`, `ciri_ciri_umum`) VALUES
('001', 'DEMAM', 'suhu tubuh tinggi di atas 28 derajat', 'panas sedang', 'merasa kediginan'),
('002', 'Corona', 'Suhu tubuh tinggi', 'Demam', 'Demam, sesak napas');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_dokter`
--

CREATE TABLE `tbl_dokter` (
  `kode_dokter` varchar(20) NOT NULL,
  `nama_dokter` varchar(30) NOT NULL,
  `jenis_kelamin` enum('L','P') NOT NULL,
  `tempat_lahir` varchar(30) NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `id_agama` int(11) NOT NULL,
  `alamat_tinggal` text NOT NULL,
  `no_hp` varchar(13) NOT NULL,
  `id_status_menikah` int(11) NOT NULL,
  `id_spesialis` int(11) NOT NULL,
  `no_izin_praktek` varchar(20) NOT NULL,
  `golongan_darah` varchar(2) NOT NULL,
  `alumni` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_dokter`
--

INSERT INTO `tbl_dokter` (`kode_dokter`, `nama_dokter`, `jenis_kelamin`, `tempat_lahir`, `tanggal_lahir`, `id_agama`, `alamat_tinggal`, `no_hp`, `id_status_menikah`, `id_spesialis`, `no_izin_praktek`, `golongan_darah`, `alumni`) VALUES
('0003', 'dr MUHAMMAD HAFIDZ MUZAKI', 'L', 'CIMAHI', '2017-11-09', 1, 'CIMAHI', '085642216978', 2, 4, '1234567123', 'AB', 'POLBAN'),
('0007', 'dr AZADA QUARTY ROWYA', 'L', 'DUMAI', '2017-11-28', 1, 'DUMAI', '081392075244', 1, 2, '1232323232', 'A', 'POLITEKNIK BANDUNG'),
('001', 'dr Dorhot', 'P', 'Surabaya', '2000-09-09', 1, 'Bandung', '082544746477', 2, 3, '789456232', 'A', 'Akper Jakarta'),
('009', 'dr Ana', 'P', 'Jakarta', '1998-02-03', 1, 'Bandung', '0890765434567', 2, 1, '4567899082', 'AB', 'Akper Jakarta');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_gedung_rawat_inap`
--

CREATE TABLE `tbl_gedung_rawat_inap` (
  `kode_gedung_rawat_inap` varchar(20) NOT NULL,
  `nama_gedung` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_gedung_rawat_inap`
--

INSERT INTO `tbl_gedung_rawat_inap` (`kode_gedung_rawat_inap`, `nama_gedung`) VALUES
('GDCND', 'GEDUNG CUT NYAK DHIEN'),
('GDMLYHT', 'GEDUNG MALAYAHATI'),
('TKMR', 'gedung teuku umar');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_jabatan`
--

CREATE TABLE `tbl_jabatan` (
  `id_jabatan` int(11) NOT NULL,
  `nama_jabatan` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_jabatan`
--

INSERT INTO `tbl_jabatan` (`id_jabatan`, `nama_jabatan`) VALUES
(1, 'JABATAN 1'),
(2, 'JABATAN 2'),
(3, 'penanggung jawab lab');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_jadwal_praktek_dokter`
--

CREATE TABLE `tbl_jadwal_praktek_dokter` (
  `id_jadwal` int(11) NOT NULL,
  `kode_dokter` varchar(20) NOT NULL,
  `hari` varchar(13) NOT NULL,
  `jam_mulai` varchar(13) NOT NULL,
  `jam_selesai` varchar(13) NOT NULL,
  `id_poliklinik` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_jadwal_praktek_dokter`
--

INSERT INTO `tbl_jadwal_praktek_dokter` (`id_jadwal`, `kode_dokter`, `hari`, `jam_mulai`, `jam_selesai`, `id_poliklinik`) VALUES
(1, '0001', 'SENIN', '08.00', '11.30', 3),
(2, '0003', 'RABU', '10.00', '12.00', 3),
(3, '0002', 'JUMAT', '11.00', '13.00', 2),
(4, '009', 'SENIN', '08.00', '12.00', 5),
(5, '001', 'SELASA', '08.00', '12.00', 1),
(6, '0007', 'SENIN', '08.00', '12.00', 2);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_jenis_bayar`
--

CREATE TABLE `tbl_jenis_bayar` (
  `id_jenis_bayar` int(11) NOT NULL,
  `jenis_bayar` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_jenis_bayar`
--

INSERT INTO `tbl_jenis_bayar` (`id_jenis_bayar`, `jenis_bayar`) VALUES
(1, 'Bayar Sendiri'),
(2, 'BPJS');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_jenjang`
--

CREATE TABLE `tbl_jenjang` (
  `kode_jenjang` varchar(10) NOT NULL,
  `nama_jenjang` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_jenjang`
--

INSERT INTO `tbl_jenjang` (`kode_jenjang`, `nama_jenjang`) VALUES
('J1', 'JENJANG 1'),
('J2', 'JENJANG 2'),
('j4', 'jenjang 4'),
('j5', 'JENJANG 34');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_jenjang_pendidikan`
--

CREATE TABLE `tbl_jenjang_pendidikan` (
  `id_jenjang_pendidikan` int(11) NOT NULL,
  `jenjang_pendidikan` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_jenjang_pendidikan`
--

INSERT INTO `tbl_jenjang_pendidikan` (`id_jenjang_pendidikan`, `jenjang_pendidikan`) VALUES
(1, 'SD'),
(2, 'SMP'),
(3, 'SMA'),
(4, 'D3'),
(5, 'D4'),
(6, 'S1'),
(7, 'S2');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_kategori_barang`
--

CREATE TABLE `tbl_kategori_barang` (
  `id_kategori_barang` int(11) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_kategori_barang`
--

INSERT INTO `tbl_kategori_barang` (`id_kategori_barang`, `nama_kategori`) VALUES
(1, 'obat penenang'),
(2, 'obat tidur');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_kategori_tindakan`
--

CREATE TABLE `tbl_kategori_tindakan` (
  `kode_kategori_tindakan` varchar(6) NOT NULL,
  `kategori_tindakan` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_kategori_tindakan`
--

INSERT INTO `tbl_kategori_tindakan` (`kode_kategori_tindakan`, `kategori_tindakan`) VALUES
('GG001', 'tindakan gigi'),
('JT001', 'tindakan jantung'),
('TES001', 'TEST INPUT KATEGORI TINDAKAN');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_menu`
--

CREATE TABLE `tbl_menu` (
  `id_menu` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `url` varchar(30) NOT NULL,
  `icon` varchar(30) NOT NULL,
  `is_main_menu` int(11) NOT NULL,
  `is_aktif` enum('y','n') NOT NULL COMMENT 'y=yes,n=no'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_menu`
--

INSERT INTO `tbl_menu` (`id_menu`, `title`, `url`, `icon`, `is_main_menu`, `is_aktif`) VALUES
(1, 'KELOLA MENU', 'kelolamenu', 'fa fa-server', 0, 'y'),
(2, 'KELOLA PENGGUNA', 'user', 'fa fa-user-o', 0, 'n'),
(3, 'level PENGGUNA', 'userlevel', 'fa fa-users', 0, 'n'),
(6, 'DATA JENJANG', 'jenjang', 'fa fa-area-chart', 19, 'y'),
(7, 'DATA JABATAN', 'jabatan', 'fa fa-briefcase', 19, 'y'),
(8, 'DATA PEGAWAI', 'pegawai', 'fa fa-users', 0, 'y'),
(9, 'Contoh Form', 'welcome/form', 'fa fa-id-card', 0, 'n'),
(13, 'DATA DOKTER', 'dokter', 'fa fa-graduation-cap', 0, 'y'),
(14, 'JADWAL PRAKTEK DOKTER', 'jadwalpraktek', 'fa fa-calendar', 0, 'y'),
(15, 'DATA POLIKLINIK', 'poliklinik', 'fa fa-university', 19, 'y'),
(16, 'DATA SPESIALIS', 'spesialis', 'fa fa-heartbeat', 19, 'y'),
(17, 'DATA DEPARTEMEN', 'departemen', 'fa fa-building', 19, 'y'),
(18, 'DATA BIDANG PEGAWAI', 'bidang', 'fa fa-binoculars', 19, 'y'),
(19, 'data master', '#', 'fa fa-id-card', 0, 'y'),
(20, 'data gedung', 'gedung', 'fa fa-building-o', 19, 'y'),
(21, 'data pasien', 'pasien', 'fa fa-id-card-o', 0, 'y'),
(22, 'form pendaftaran', 'pendaftaran/create', 'fa fa-sticky-note-o', 0, 'y'),
(23, 'data ruang rawat inap', 'ruangranap', 'fa fa-building', 19, 'y'),
(24, 'data tempat tidur', 'tempattidur', 'fa fa-bed', 0, 'y'),
(25, 'laporan rawat jalan', 'pendaftaran/index/ralan', 'fa fa-bed', 0, 'y'),
(26, 'laporan rawat inap', 'pendaftaran/index/ranap', 'fa fa-id-card', 0, 'y'),
(27, 'data obat', 'dataobat', 'fa fa-medkit', 30, 'y'),
(28, 'data kategori obat', 'kategoribarang', 'fa fa-picture-o', 30, 'y'),
(29, 'data satuan obat', 'datasatuan', 'fa fa-object-group', 30, 'y'),
(30, 'MODUL APOTEK', '#', 'fa fa-bed', 0, 'y'),
(31, 'LAPORAN PENGADAAN OBAT', 'pengadaan', 'fa fa-area-chart', 30, 'y'),
(32, 'laporan pengeluaran', 'penjualan', 'fa fa-money', 30, 'y'),
(33, 'Profile Rumah Sakit', 'profile/update/1', 'fa fa-id-card-o', 0, 'y'),
(34, 'Data Penyedia Obat', 'supplier', 'fa fa-area-chart', 30, 'y'),
(35, 'MENU TINDAKAN', '#', 'fa fa-graduation-cap', 0, 'y'),
(36, 'DATA DIGANOSA PENYAKIT', 'diagnosa', 'fa fa-bar-chart', 35, 'y'),
(37, 'data kategori tindakan', 'kategoritindakan', 'fa fa-microchip', 35, 'y'),
(38, 'data pemeriksaan laboratorium', 'periksalabor', 'fa fa-bed', 35, 'y'),
(39, 'data tindakan', 'data_tindakan', 'fa fa-map-o', 35, 'y');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_obat_alkes_bhp`
--

CREATE TABLE `tbl_obat_alkes_bhp` (
  `kode_barang` varchar(250) NOT NULL,
  `nama_barang` varchar(100) NOT NULL,
  `id_kategori_barang` int(11) NOT NULL,
  `id_satuan_barang` int(11) NOT NULL,
  `harga` int(11) NOT NULL,
  `Kadaluwarsa` date NOT NULL,
  `Stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_obat_alkes_bhp`
--

INSERT INTO `tbl_obat_alkes_bhp` (`kode_barang`, `nama_barang`, `id_kategori_barang`, `id_satuan_barang`, `harga`, `Kadaluwarsa`, `Stok`) VALUES
('001', 'BETADIN', 1, 1, 45000, '2020-12-08', 104),
('002', 'obat batuk', 1, 1, 40000, '2021-04-15', 114),
('003', 'thexametason', 1, 2, 30000, '2020-12-26', 110),
('8900', 'betadin', 2, 2, 123000, '2021-03-09', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pasien`
--

CREATE TABLE `tbl_pasien` (
  `no_rekamedis` varchar(10) NOT NULL,
  `nama_pasien` varchar(30) NOT NULL,
  `jenis_kelamin` enum('L','P') NOT NULL,
  `golongan_darah` varchar(3) NOT NULL,
  `tempat_lahir` varchar(30) NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `nama_ibu` varchar(30) NOT NULL,
  `alamat` text NOT NULL,
  `id_agama` int(11) NOT NULL,
  `status_menikah` int(11) NOT NULL,
  `no_hp` varchar(13) NOT NULL,
  `id_pekerjaan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_pasien`
--

INSERT INTO `tbl_pasien` (`no_rekamedis`, `nama_pasien`, `jenis_kelamin`, `golongan_darah`, `tempat_lahir`, `tanggal_lahir`, `nama_ibu`, `alamat`, `id_agama`, `status_menikah`, `no_hp`, `id_pekerjaan`) VALUES
('000001', 'INDRA NASUTION', 'L', 'A', 'LANGSA', '2017-11-08', 'NURSYIDAH', 'JL KENANGAN NO 24 LANGSA BAROE', 1, 2, '089699935552', 1),
('000002', 'SAMSUAR HASAN', 'L', 'A', 'LANGSA', '2017-12-13', 'SAMSIAH', 'bandung', 1, 1, '089693007396', 1),
('000003', 'samsiar udin', 'L', 'A', 'cimahi', '2017-12-04', 'juariah', 'jl pesantren cibabat cimahi utara', 1, 1, '085642216978', 1),
('000004', 'Ela', 'P', 'O', 'Jakarta', '2010-12-29', 'Ana', 'Bandung', 3, 2, '085322749697', 1),
('000005', 'Indah', 'P', 'A', 'Surabaya', '1999-10-20', 'Cici', 'Bogor', 1, 1, '0875689741234', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pegawai`
--

CREATE TABLE `tbl_pegawai` (
  `nik` int(20) NOT NULL,
  `nama_pegawai` varchar(50) NOT NULL,
  `jenis_kelamin` enum('L','P') NOT NULL,
  `npwp` varchar(25) NOT NULL,
  `id_jenjang_pendidikan` int(11) NOT NULL,
  `tempat_lahir` varchar(30) NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `id_jabatan` int(11) NOT NULL,
  `kode_jenjang` varchar(10) NOT NULL,
  `id_departemen` int(11) NOT NULL,
  `id_bidang` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_pegawai`
--

INSERT INTO `tbl_pegawai` (`nik`, `nama_pegawai`, `jenis_kelamin`, `npwp`, `id_jenjang_pendidikan`, `tempat_lahir`, `tanggal_lahir`, `id_jabatan`, `kode_jenjang`, `id_departemen`, `id_bidang`) VALUES
(0, 'JONO SITUMORANG SST', 'L', '2122434343437', 5, 'MEDAN', '2017-11-28', 3, 'J2', 3, 2),
(21224, 'RISNA M.Kom', 'P', '2122434343431', 1, '', '0000-00-00', 1, 'j2', 1, 1),
(123456789, 'HAFIDZ MUZAKI', 'L', '12345678910', 4, 'LANGSA', '2017-11-27', 1, 'J1', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pekerjaan`
--

CREATE TABLE `tbl_pekerjaan` (
  `id_pekerjaan` int(11) NOT NULL,
  `nama_pekerjaan` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_pekerjaan`
--

INSERT INTO `tbl_pekerjaan` (`id_pekerjaan`, `nama_pekerjaan`) VALUES
(1, 'PNS'),
(2, 'SWASTA');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pemeriksaan_laboratorium`
--

CREATE TABLE `tbl_pemeriksaan_laboratorium` (
  `kode_periksa` varchar(6) NOT NULL,
  `nama_periksa` varchar(100) NOT NULL,
  `tarif` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_pemeriksaan_laboratorium`
--

INSERT INTO `tbl_pemeriksaan_laboratorium` (`kode_periksa`, `nama_periksa`, `tarif`) VALUES
('aa', 'Periksa Urine', 100000),
('co', 'Check Up', 200000),
('DR', 'Cuci Darah', 45000),
('fr', 'Foto Rontgen', 50000),
('sb', 'Cek Urine', 70000),
('us', 'USG', 150000),
('ya', 'Cek Darah', 100000);

--
-- Triggers `tbl_pemeriksaan_laboratorium`
--
DELIMITER $$
CREATE TRIGGER `after_labor_insert` AFTER INSERT ON `tbl_pemeriksaan_laboratorium` FOR EACH ROW BEGIN
INSERT INTO auditLabor
SET aksi = 'insert',
kode_periksa = NEW.kode_periksa,
nama_periksa = NEW.nama_periksa,
tglubah = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_labor_delete` BEFORE DELETE ON `tbl_pemeriksaan_laboratorium` FOR EACH ROW BEGIN
INSERT INTO auditLabor
SET aksi = 'delete',
kode_periksa= OLD.kode_periksa,
nama_periksa = OLD.nama_periksa,
tglubah = NOW();
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_labor_update` BEFORE UPDATE ON `tbl_pemeriksaan_laboratorium` FOR EACH ROW BEGIN
INSERT INTO auditLabor 
SET aksi = 'update',
tarif = OLD.tarif,
kode_periksa = OLD.kode_periksa,
nama_periksa = OLD.nama_periksa,
tglubah = NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pendaftaran`
--

CREATE TABLE `tbl_pendaftaran` (
  `no_registrasi` varchar(10) NOT NULL,
  `no_rawat` varchar(18) NOT NULL,
  `no_rekamedis` varchar(6) NOT NULL,
  `cara_masuk` varchar(30) NOT NULL,
  `tanggal_daftar` datetime NOT NULL,
  `kode_dokter_penanggung_jawab` int(11) NOT NULL,
  `id_poli` int(11) NOT NULL,
  `nama_penanggung_jawab` varchar(30) NOT NULL,
  `hubungan_dengan_penanggung_jawab` varchar(30) NOT NULL,
  `alamat_penanggung_jawab` text NOT NULL,
  `id_jenis_bayar` int(11) NOT NULL,
  `asal_rujukan` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_pendaftaran`
--

INSERT INTO `tbl_pendaftaran` (`no_registrasi`, `no_rawat`, `no_rekamedis`, `cara_masuk`, `tanggal_daftar`, `kode_dokter_penanggung_jawab`, `id_poli`, `nama_penanggung_jawab`, `hubungan_dengan_penanggung_jawab`, `alamat_penanggung_jawab`, `id_jenis_bayar`, `asal_rujukan`) VALUES
('0002', '2017/12/04/0002', '000003', 'RAWAT JALAN', '2017-12-04 00:00:00', 2, 1, 'reza', 'saudara kandung', 'jl kenangan no 40', 2, 'pukesmas langsa'),
('0003', '2017/12/04/0003', '000002', 'RAWAT JALAN', '2017-12-04 00:00:00', 8, 1, 'reza husein', 'saudara kandung', 'sample text', 2, 'rs dustira'),
('0004', '2017/12/04/0004', '000004', 'RAWAT JALAN', '2017-12-04 00:00:00', 3, 1, 'LENI', 'saudara kandung', 'BANDUNG', 1, 'MEDAN'),
('0005', '2017/12/04/0005', '000005', 'RAWAT JALAN', '2017-12-04 00:00:00', 5, 1, 'HUSAINI', 'saudara kandung', 'BANDUNG', 1, 'MEDAN'),
('0005', '2017/12/05/0005', '000003', 'RAWAT INAP', '2017-12-05 00:00:00', 5, 1, 'nuris akbar', 'saudara kandung', 'cimahi', 1, 'seragen'),
('0001', '2020/04/20/0001', '000004', 'RAWAT JALAN', '2020-04-20 00:00:00', 5, 2, 'Ana', 'orang tua', 'Bandung', 1, '-'),
('0001', '2020/04/21/0001', '000005', 'RAWAT JALAN', '2020-04-21 00:00:00', 1, 1, 'Ibu', 'saudara kandung', 'Bogor', 1, '-'),
('0001', '2020/12/05/0001', '000003', 'RAWAT INAP', '2020-12-05 00:00:00', 9, 2, 'Ani', 'saudara kandung', 'oke', 1, 'RSJ'),
('0002', '2020/12/05/0002', '000005', 'RAWAT JALAN', '2021-01-02 00:00:00', 7, 5, 'Ani', 'orang tua', 'Oke', 2, 'RSJ');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pengadaan_detail`
--

CREATE TABLE `tbl_pengadaan_detail` (
  `id_pengadaan` int(11) NOT NULL,
  `kode_barang` varchar(6) NOT NULL,
  `qty` int(11) NOT NULL,
  `no_faktur` varchar(10) NOT NULL,
  `harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_pengadaan_detail`
--

INSERT INTO `tbl_pengadaan_detail` (`id_pengadaan`, `kode_barang`, `qty`, `no_faktur`, `harga`) VALUES
(82, '001', 1, '12', 25000),
(83, '002', 2, '12', 30000),
(84, '001', 12, '11', 10000);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pengadaan_obat_alkes_bhp`
--

CREATE TABLE `tbl_pengadaan_obat_alkes_bhp` (
  `no_faktur` varchar(250) NOT NULL,
  `tanggal` date NOT NULL,
  `kode_supplier` varchar(8) NOT NULL,
  `kode_obat` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_pengadaan_obat_alkes_bhp`
--

INSERT INTO `tbl_pengadaan_obat_alkes_bhp` (`no_faktur`, `tanggal`, `kode_supplier`, `kode_obat`) VALUES
('11', '2021-06-12', '0001', ''),
('12', '2021-06-06', '0001', ''),
('pobat60ed15464aab9', '2021-07-14', '0001', '001');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_penjualan_detail`
--

CREATE TABLE `tbl_penjualan_detail` (
  `id_penjualan` int(11) NOT NULL,
  `kode_barang` varchar(6) NOT NULL,
  `qty` int(11) NOT NULL,
  `no_faktur` varchar(8) NOT NULL,
  `aturan_pemakaian` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_penjualan_detail`
--

INSERT INTO `tbl_penjualan_detail` (`id_penjualan`, `kode_barang`, `qty`, `no_faktur`, `aturan_pemakaian`) VALUES
(3, '001', 1, '1234', NULL),
(4, '001', 1, '1234', NULL),
(36, '8900', 11, 'ekatr12', '3'),
(37, '003', 11, 'ekatr12', ''),
(38, '002', 12, 'eka1234', '3'),
(39, '003', 14, 'eka1234', ''),
(40, '003', 12, 'dfg333s', '2'),
(41, '001', 11, 'dfg333s', ''),
(44, '003', 1, '12344', '3x1 1'),
(45, '001', 1, '12344', '3x2'),
(46, '003', 10, 'initeslo', '11'),
(47, '002', 10, 'initeslo', '11'),
(48, '8900', 10, 'ssass', 'aa'),
(49, '001', 10, 'ssass', '11');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_penjualan_obat_alkes_bhp`
--

CREATE TABLE `tbl_penjualan_obat_alkes_bhp` (
  `no_faktur` varchar(250) NOT NULL,
  `tanggal` date NOT NULL,
  `nama_pasien` varchar(50) NOT NULL,
  `aturan_pemakaian` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_penjualan_obat_alkes_bhp`
--

INSERT INTO `tbl_penjualan_obat_alkes_bhp` (`no_faktur`, `tanggal`, `nama_pasien`, `aturan_pemakaian`) VALUES
('006', '2020-12-25', 'yuyi', '1 x sehari'),
('11111111', '2021-07-12', 'Indah', ''),
('1234', '2017-12-24', 'juned', '6'),
('12344', '2021-04-13', '11111222', ''),
('12345555', '2021-07-12', 'Ela', ''),
('333', '2020-12-25', 'Yuyi 1', '2 x sehari'),
('334', '2020-12-25', 'yusron', '2 x sehari'),
('3445', '2020-12-23', 'yuyi', '1 x sehari'),
('90999', '2020-12-04', 'alga', '1 x sehari'),
('adfg1312', '2021-04-13', '111', ''),
('asdas121', '2021-07-12', 'INDRA NASUTION', ''),
('dfg1312', '2021-04-13', '111', ''),
('dfg31', '2021-04-13', '111', ''),
('dfg312', '2021-04-13', '111', ''),
('dfg333dd', '2021-04-14', 'fgdf', ''),
('dfg333s', '2021-04-13', 'se', ''),
('eka1234', '1212-12-12', 'Ranto', ''),
('eka123dd', '0000-00-00', 'anton', ''),
('ekatr1', '2021-12-12', 'yuki', ''),
('ekatr12', '2021-12-12', 'yukis', ''),
('initeslo', '1111-11-11', '11', ''),
('ssass', '2021-04-15', 'se', ''),
('tr1221', '2021-12-11', 'gdgh', '2 x sehari'),
('tr122122', '2021-12-12', 'se', '2'),
('tr1221we', '2020-12-12', 'nyomana', '');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pj_riwayat_tindakan`
--

CREATE TABLE `tbl_pj_riwayat_tindakan` (
  `id` int(11) NOT NULL,
  `id_riwayat_tindakan` int(11) NOT NULL,
  `kode_pj` varchar(20) NOT NULL,
  `keterangan` enum('dokter','petugas','dokter_dan_petugas') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_pj_riwayat_tindakan`
--

INSERT INTO `tbl_pj_riwayat_tindakan` (`id`, `id_riwayat_tindakan`, `kode_pj`, `keterangan`) VALUES
(1, 6, '0002', 'dokter'),
(2, 7, '123456789', 'petugas'),
(3, 8, '0002', 'dokter'),
(4, 8, '123456789', 'petugas'),
(5, 9, '0002', 'dokter'),
(6, 10, '0002', 'dokter'),
(7, 11, '001', 'dokter'),
(8, 12, '001', 'dokter');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_poliklinik`
--

CREATE TABLE `tbl_poliklinik` (
  `id_poliklinik` int(11) NOT NULL,
  `nama_poliklinik` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_poliklinik`
--

INSERT INTO `tbl_poliklinik` (`id_poliklinik`, `nama_poliklinik`) VALUES
(1, 'POLI GIGI'),
(2, 'POLI ANAK'),
(3, 'POLI KIA'),
(4, 'POLI UMUM'),
(5, 'POLI IBU HAMIL');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_profil_rumah_sakit`
--

CREATE TABLE `tbl_profil_rumah_sakit` (
  `id` int(11) NOT NULL,
  `nama_rumah_sakit` varchar(50) NOT NULL,
  `alamat` text NOT NULL,
  `propinsi` varchar(30) NOT NULL,
  `kabupaten` varchar(30) NOT NULL,
  `no_telpon` varchar(13) NOT NULL,
  `logo` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_profil_rumah_sakit`
--

INSERT INTO `tbl_profil_rumah_sakit` (`id`, `nama_rumah_sakit`, `alamat`, `propinsi`, `kabupaten`, `no_telpon`, `logo`) VALUES
(1, 'PUSKESMAS KAWALI', 'kawali ciamis', 'jawa barat', 'ciamis', '021-32432323', 'logo-dinas-kesehatan-png-24.png');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_rawat_inap`
--

CREATE TABLE `tbl_rawat_inap` (
  `no_rawat` varchar(18) NOT NULL,
  `tanggal_masuk` datetime NOT NULL,
  `tanggal_keluar` datetime NOT NULL,
  `kode_tempat_tidur` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_rawat_inap`
--

INSERT INTO `tbl_rawat_inap` (`no_rawat`, `tanggal_masuk`, `tanggal_keluar`, `kode_tempat_tidur`) VALUES
('2017/12/05/0002', '2017-12-05 00:00:00', '0000-00-00 00:00:00', '004'),
('2017/12/05/0005', '2017-12-05 00:00:00', '0000-00-00 00:00:00', '004'),
('2017/12/05/0006', '2017-12-05 00:00:00', '0000-00-00 00:00:00', '001'),
('2020/12/04/0001', '2020-12-04 00:00:00', '0000-00-00 00:00:00', '006'),
('2020/12/05/0001', '2020-12-05 00:00:00', '0000-00-00 00:00:00', '006');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_riwayat_pemberian_obat`
--

CREATE TABLE `tbl_riwayat_pemberian_obat` (
  `id_riwayat` int(11) NOT NULL,
  `no_rawat` varchar(18) NOT NULL,
  `tanggal` date NOT NULL,
  `kode_barang` varchar(6) NOT NULL,
  `jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_riwayat_pemberian_obat`
--

INSERT INTO `tbl_riwayat_pemberian_obat` (`id_riwayat`, `no_rawat`, `tanggal`, `kode_barang`, `jumlah`) VALUES
(1, '2017/12/20/0001', '2017-12-20', '001', 1),
(2, '2017/12/20/0001', '2017-12-20', '002', 2),
(3, '2017/12/17/0001', '2017-12-21', '001', 1),
(4, '2017/12/17/0001', '2017-12-21', '001', 4),
(5, '', '2020-12-04', '002', 2),
(6, '2020/12/05/0001', '2020-12-05', '002', 12);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_riwayat_pemeriksaan_laboratorium`
--

CREATE TABLE `tbl_riwayat_pemeriksaan_laboratorium` (
  `id_riwayat` int(11) NOT NULL,
  `no_rawat` varchar(20) NOT NULL,
  `tanggal` date NOT NULL,
  `kode_periksa` varchar(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_riwayat_pemeriksaan_laboratorium`
--

INSERT INTO `tbl_riwayat_pemeriksaan_laboratorium` (`id_riwayat`, `no_rawat`, `tanggal`, `kode_periksa`) VALUES
(7, '2017/12/17/0001', '2017-12-21', 'DR'),
(9, '2017/12/04/0004', '2020-04-21', 'ya'),
(10, '2017/12/04/0004', '2020-04-21', 'aa'),
(11, '2020/04/21/0001', '2020-04-21', 'ya'),
(12, '2020/04/21/0001', '2020-04-21', 'aa'),
(13, '2017/12/04/0004', '2020-12-04', 'aa'),
(14, '', '2020-12-04', 'aa'),
(15, '2020/04/21/0001', '2020-12-04', 'us'),
(16, '', '2020-12-04', 'aa'),
(17, '2020/12/05/0001', '2020-12-05', 'aa'),
(18, '2020/12/05/0001', '2020-12-05', 'us'),
(19, '2020/12/05/0001', '2020-12-05', 'us'),
(20, '2020/12/05/0001', '2020-12-05', 'co'),
(21, '2020/12/05/0001', '2020-12-05', 'us'),
(22, '2020/12/05/0001', '2020-12-05', 'us'),
(23, '2020/12/05/0001', '2020-12-06', 'us'),
(24, '2020/12/05/0001', '2020-12-06', 'co');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_riwayat_pemeriksaan_laboratorium_detail`
--

CREATE TABLE `tbl_riwayat_pemeriksaan_laboratorium_detail` (
  `id_riwayat_detail` int(11) NOT NULL,
  `id_riwayat` int(18) NOT NULL,
  `kode_sub_periksa` varchar(6) NOT NULL,
  `hasil` int(11) NOT NULL,
  `keterangan` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_riwayat_pemeriksaan_laboratorium_detail`
--

INSERT INTO `tbl_riwayat_pemeriksaan_laboratorium_detail` (`id_riwayat_detail`, `id_riwayat`, `kode_sub_periksa`, `hasil`, `keterangan`) VALUES
(3, 7, 'gd', 10, 'ok'),
(4, 7, 'hg', 20, 'ok');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_riwayat_tindakan`
--

CREATE TABLE `tbl_riwayat_tindakan` (
  `id_riwayat_tindakan` int(11) NOT NULL,
  `kode_tindakan` varchar(6) NOT NULL,
  `no_rawat` varchar(18) NOT NULL,
  `hasil_periksa` varchar(100) NOT NULL,
  `perkembangan` varchar(100) NOT NULL,
  `tanggal` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_riwayat_tindakan`
--

INSERT INTO `tbl_riwayat_tindakan` (`id_riwayat_tindakan`, `kode_tindakan`, `no_rawat`, `hasil_periksa`, `perkembangan`, `tanggal`) VALUES
(6, '0003', '2017/12/17/0001', 'ok', 'ok', '2017-12-19 00:00:00'),
(7, '0002', '2017/12/17/0001', 'ok', 'ok', '2017-12-19 00:00:00'),
(8, '0001', '2017/12/17/0001', 'OK', 'OK', '2017-12-19 00:00:00'),
(9, '0002', '2017/12/20/0001', 'luka sudah kering', 'sudah lebih baik', '2017-12-20 00:00:00'),
(10, '0003', '2017/12/20/0001', 'suhu tubuh normal', 'normal', '2017-12-20 00:00:00'),
(11, '0001', '2017/12/04/0004', 'Gigi bolong', 'Udah ditambal', '2020-04-21 00:00:00'),
(12, '0004', '2017/12/04/0004', 'Lumayan sehat', 'Udah lumayan sehat', '2020-10-06 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_ruang_rawat_inap`
--

CREATE TABLE `tbl_ruang_rawat_inap` (
  `kode_ruang_rawat_inap` varchar(30) NOT NULL,
  `kode_gedung_rawat_inap` varchar(30) NOT NULL,
  `nama_ruangan` varchar(35) NOT NULL,
  `kelas` varchar(20) NOT NULL,
  `tarif` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_ruang_rawat_inap`
--

INSERT INTO `tbl_ruang_rawat_inap` (`kode_ruang_rawat_inap`, `kode_gedung_rawat_inap`, `nama_ruangan`, `kelas`, `tarif`) VALUES
('CNDMLT', 'GDCND', 'RUANGAN MELATI', 'KELAS 1', 50000),
('KMRSPT', 'TKMR', 'RUANG MELATI', 'VIP', 60000),
('MLHYTMWR', 'GDMLYHT', 'RUAG MAWAR', 'VIP', 100000),
('RKLSA', 'GDCND', 'RUANG TESTING', 'KELAS 2', 34000);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_satuan_barang`
--

CREATE TABLE `tbl_satuan_barang` (
  `id_satuan` int(11) NOT NULL,
  `nama_satuan` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_satuan_barang`
--

INSERT INTO `tbl_satuan_barang` (`id_satuan`, `nama_satuan`) VALUES
(1, 'botol'),
(2, 'ampul'),
(3, 'tablet'),
(4, 'kapsul');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_spesialis`
--

CREATE TABLE `tbl_spesialis` (
  `id_spesialis` int(11) NOT NULL,
  `spesialis` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_spesialis`
--

INSERT INTO `tbl_spesialis` (`id_spesialis`, `spesialis`) VALUES
(1, 'Ibu Hamil'),
(2, 'Anak'),
(3, 'Gigi dan Mulut'),
(4, 'Kesehatan Ibu dan Anak');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_status_menikah`
--

CREATE TABLE `tbl_status_menikah` (
  `id_status_menikah` int(11) NOT NULL,
  `status_menikah` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_status_menikah`
--

INSERT INTO `tbl_status_menikah` (`id_status_menikah`, `status_menikah`) VALUES
(1, 'kawin'),
(2, 'belum kawin'),
(3, 'duda'),
(4, 'janda');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sub_pemeriksaan_laboratoirum`
--

CREATE TABLE `tbl_sub_pemeriksaan_laboratoirum` (
  `kode_sub_periksa` varchar(6) NOT NULL,
  `kode_periksa` varchar(6) NOT NULL,
  `nama_pemeriksaan` varchar(50) NOT NULL,
  `satuan` varchar(10) NOT NULL,
  `nilai_rujukan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_sub_pemeriksaan_laboratoirum`
--

INSERT INTO `tbl_sub_pemeriksaan_laboratoirum` (`kode_sub_periksa`, `kode_periksa`, `nama_pemeriksaan`, `satuan`, `nilai_rujukan`) VALUES
('gd', 'DR', 'gula darah', 'mkl', 0),
('hg', 'DR', 'Hemoglobin', 'gdr', 0),
('sb', 'sb', 'tinggi suhu badan', 'celcius', 10),
('ss', 'DR', 'TESTING', 'mg', 10),
('TTS', 'DR', 'TEST KEDUA', 'MG', 10);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_supplier`
--

CREATE TABLE `tbl_supplier` (
  `kode_supplier` varchar(250) NOT NULL,
  `nama_supplier` varchar(60) NOT NULL,
  `alamat` text NOT NULL,
  `no_telpon` varchar(13) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_supplier`
--

INSERT INTO `tbl_supplier` (`kode_supplier`, `nama_supplier`, `alamat`, `no_telpon`) VALUES
('0001', 'kimia farma', 'jl bandung no 20 kota bandung', '021-34563'),
('667', 'kimifajaya', 'makas', '8790'),
('900', 'kimida', 'makas', '0986t6'),
('supp60ed186d3ef22', 'Hermina', 'Tangerang', '123123');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_tempat_tidur`
--

CREATE TABLE `tbl_tempat_tidur` (
  `kode_tempat_tidur` varchar(10) NOT NULL,
  `kode_ruang_rawat_inap` varchar(20) NOT NULL,
  `status` enum('kosong','diisi') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_tempat_tidur`
--

INSERT INTO `tbl_tempat_tidur` (`kode_tempat_tidur`, `kode_ruang_rawat_inap`, `status`) VALUES
('001', 'CNDMLT', 'diisi'),
('002', 'MLHYTMWR', 'kosong'),
('003', 'MLHYTMWR', 'kosong'),
('004', 'MLHYTMWR', 'kosong'),
('006', 'CNDMLT', 'diisi');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_tindakan`
--

CREATE TABLE `tbl_tindakan` (
  `kode_tindakan` varchar(6) NOT NULL,
  `jenis_tindakan` enum('rawat_jalan','rawat_inap','','') NOT NULL,
  `nama_tindakan` varchar(30) NOT NULL,
  `kode_kategori_tindakan` varchar(6) NOT NULL,
  `tarif` int(11) NOT NULL,
  `tindakan_oleh` enum('dokter','petugas','dokter_dan_petugas','') NOT NULL,
  `id_poliklinik` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_tindakan`
--

INSERT INTO `tbl_tindakan` (`kode_tindakan`, `jenis_tindakan`, `nama_tindakan`, `kode_kategori_tindakan`, `tarif`, `tindakan_oleh`, `id_poliklinik`) VALUES
('0001', 'rawat_jalan', 'PEMERIKSAAN GIGI', 'GG001', 45000, 'dokter', 1),
('0002', 'rawat_jalan', 'Pertolongan Pertama', 'TES001', 35000, 'dokter', 4),
('0003', 'rawat_inap', 'pemeriksaan suhu tubuh', 'JT001', 34000, 'petugas', 1),
('0004', 'rawat_jalan', 'Suntik vitamin', 'TES001', 100000, 'petugas', 4);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE `tbl_user` (
  `id_users` int(11) NOT NULL,
  `full_name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `images` text NOT NULL,
  `id_user_level` int(11) NOT NULL,
  `is_aktif` enum('y','n') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`id_users`, `full_name`, `email`, `password`, `images`, `id_user_level`, `is_aktif`) VALUES
(1, 'Puskesmas Kawali', 'nuris.akbar@gmail.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'download.png', 1, 'y'),
(3, 'Muhammad hafidz Muzaki', 'hafid@gmail.com', 'f2621da6b3d4f712bf5e29861f186c7c', '7.png', 2, 'y'),
(4, 'Puskesmas Kawali', 'puskesmas.kawali@gmail.com', '25f9e794323b453885f5181f1b624d0b', 'download5.png', 1, 'y'),
(5, 'puskesmas', 'kawali@gmail.com', '26812bbab71758210eb2de8ec1f6035f', '', 2, 'y');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_level`
--

CREATE TABLE `tbl_user_level` (
  `id_user_level` int(11) NOT NULL,
  `nama_level` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_user_level`
--

INSERT INTO `tbl_user_level` (`id_user_level`, `nama_level`) VALUES
(1, 'Super Admin'),
(2, 'Admin');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auditlabor`
--
ALTER TABLE `auditlabor`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_agama`
--
ALTER TABLE `tbl_agama`
  ADD PRIMARY KEY (`id_agama`);

--
-- Indexes for table `tbl_bidang`
--
ALTER TABLE `tbl_bidang`
  ADD PRIMARY KEY (`id_bidang`);

--
-- Indexes for table `tbl_departemen`
--
ALTER TABLE `tbl_departemen`
  ADD PRIMARY KEY (`id_departemen`);

--
-- Indexes for table `tbl_diagnosa_penyakit`
--
ALTER TABLE `tbl_diagnosa_penyakit`
  ADD PRIMARY KEY (`kode_diagnosa`);

--
-- Indexes for table `tbl_dokter`
--
ALTER TABLE `tbl_dokter`
  ADD PRIMARY KEY (`kode_dokter`),
  ADD KEY `id_agama` (`id_agama`),
  ADD KEY `id_spesialis` (`id_spesialis`),
  ADD KEY `id_status_menikah` (`id_status_menikah`);

--
-- Indexes for table `tbl_gedung_rawat_inap`
--
ALTER TABLE `tbl_gedung_rawat_inap`
  ADD PRIMARY KEY (`kode_gedung_rawat_inap`);

--
-- Indexes for table `tbl_jabatan`
--
ALTER TABLE `tbl_jabatan`
  ADD PRIMARY KEY (`id_jabatan`);

--
-- Indexes for table `tbl_jadwal_praktek_dokter`
--
ALTER TABLE `tbl_jadwal_praktek_dokter`
  ADD PRIMARY KEY (`id_jadwal`),
  ADD KEY `id_poliklinik` (`id_poliklinik`),
  ADD KEY `kode_dokter` (`kode_dokter`);

--
-- Indexes for table `tbl_jenis_bayar`
--
ALTER TABLE `tbl_jenis_bayar`
  ADD PRIMARY KEY (`id_jenis_bayar`);

--
-- Indexes for table `tbl_jenjang`
--
ALTER TABLE `tbl_jenjang`
  ADD PRIMARY KEY (`kode_jenjang`);

--
-- Indexes for table `tbl_jenjang_pendidikan`
--
ALTER TABLE `tbl_jenjang_pendidikan`
  ADD PRIMARY KEY (`id_jenjang_pendidikan`);

--
-- Indexes for table `tbl_kategori_barang`
--
ALTER TABLE `tbl_kategori_barang`
  ADD PRIMARY KEY (`id_kategori_barang`);

--
-- Indexes for table `tbl_kategori_tindakan`
--
ALTER TABLE `tbl_kategori_tindakan`
  ADD PRIMARY KEY (`kode_kategori_tindakan`);

--
-- Indexes for table `tbl_menu`
--
ALTER TABLE `tbl_menu`
  ADD PRIMARY KEY (`id_menu`);

--
-- Indexes for table `tbl_obat_alkes_bhp`
--
ALTER TABLE `tbl_obat_alkes_bhp`
  ADD PRIMARY KEY (`kode_barang`),
  ADD KEY `id_kategori_barang` (`id_kategori_barang`),
  ADD KEY `id_satuan_barang` (`id_satuan_barang`);

--
-- Indexes for table `tbl_pasien`
--
ALTER TABLE `tbl_pasien`
  ADD PRIMARY KEY (`no_rekamedis`),
  ADD KEY `id_agama` (`id_agama`),
  ADD KEY `id_pekerjaan` (`id_pekerjaan`),
  ADD KEY `status_menikah` (`status_menikah`);

--
-- Indexes for table `tbl_pegawai`
--
ALTER TABLE `tbl_pegawai`
  ADD PRIMARY KEY (`nik`),
  ADD KEY `id_bidang` (`id_bidang`),
  ADD KEY `id_departemen` (`id_departemen`),
  ADD KEY `id_jabatan` (`id_jabatan`),
  ADD KEY `id_pendidikan` (`id_jenjang_pendidikan`),
  ADD KEY `kode_jenjang` (`kode_jenjang`);

--
-- Indexes for table `tbl_pekerjaan`
--
ALTER TABLE `tbl_pekerjaan`
  ADD PRIMARY KEY (`id_pekerjaan`);

--
-- Indexes for table `tbl_pemeriksaan_laboratorium`
--
ALTER TABLE `tbl_pemeriksaan_laboratorium`
  ADD PRIMARY KEY (`kode_periksa`);

--
-- Indexes for table `tbl_pendaftaran`
--
ALTER TABLE `tbl_pendaftaran`
  ADD PRIMARY KEY (`no_rawat`),
  ADD KEY `id_jenis_bayar` (`id_jenis_bayar`),
  ADD KEY `id_poli` (`id_poli`),
  ADD KEY `no_rekamedis` (`no_rekamedis`);

--
-- Indexes for table `tbl_pengadaan_detail`
--
ALTER TABLE `tbl_pengadaan_detail`
  ADD PRIMARY KEY (`id_pengadaan`),
  ADD KEY `kode_barang` (`kode_barang`),
  ADD KEY `no_faktur` (`no_faktur`);

--
-- Indexes for table `tbl_pengadaan_obat_alkes_bhp`
--
ALTER TABLE `tbl_pengadaan_obat_alkes_bhp`
  ADD PRIMARY KEY (`no_faktur`),
  ADD KEY `kode_supplier` (`kode_supplier`);

--
-- Indexes for table `tbl_penjualan_detail`
--
ALTER TABLE `tbl_penjualan_detail`
  ADD PRIMARY KEY (`id_penjualan`),
  ADD KEY `kode_barang` (`kode_barang`),
  ADD KEY `no_faktur` (`no_faktur`);

--
-- Indexes for table `tbl_penjualan_obat_alkes_bhp`
--
ALTER TABLE `tbl_penjualan_obat_alkes_bhp`
  ADD PRIMARY KEY (`no_faktur`);

--
-- Indexes for table `tbl_pj_riwayat_tindakan`
--
ALTER TABLE `tbl_pj_riwayat_tindakan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_riwayat_tindakan` (`id_riwayat_tindakan`);

--
-- Indexes for table `tbl_poliklinik`
--
ALTER TABLE `tbl_poliklinik`
  ADD PRIMARY KEY (`id_poliklinik`);

--
-- Indexes for table `tbl_profil_rumah_sakit`
--
ALTER TABLE `tbl_profil_rumah_sakit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_rawat_inap`
--
ALTER TABLE `tbl_rawat_inap`
  ADD PRIMARY KEY (`no_rawat`),
  ADD KEY `kode_tempat_tidur` (`kode_tempat_tidur`);

--
-- Indexes for table `tbl_riwayat_pemberian_obat`
--
ALTER TABLE `tbl_riwayat_pemberian_obat`
  ADD PRIMARY KEY (`id_riwayat`),
  ADD KEY `kode_barang` (`kode_barang`);

--
-- Indexes for table `tbl_riwayat_pemeriksaan_laboratorium`
--
ALTER TABLE `tbl_riwayat_pemeriksaan_laboratorium`
  ADD PRIMARY KEY (`id_riwayat`),
  ADD KEY `kode_periksa` (`kode_periksa`);

--
-- Indexes for table `tbl_riwayat_pemeriksaan_laboratorium_detail`
--
ALTER TABLE `tbl_riwayat_pemeriksaan_laboratorium_detail`
  ADD PRIMARY KEY (`id_riwayat_detail`),
  ADD KEY `kode_sub_periksa` (`kode_sub_periksa`),
  ADD KEY `id_riwayat` (`id_riwayat`);

--
-- Indexes for table `tbl_riwayat_tindakan`
--
ALTER TABLE `tbl_riwayat_tindakan`
  ADD PRIMARY KEY (`id_riwayat_tindakan`),
  ADD KEY `kode_tindakan` (`kode_tindakan`);

--
-- Indexes for table `tbl_ruang_rawat_inap`
--
ALTER TABLE `tbl_ruang_rawat_inap`
  ADD PRIMARY KEY (`kode_ruang_rawat_inap`),
  ADD KEY `kode_gedung_rawat_inap` (`kode_gedung_rawat_inap`);

--
-- Indexes for table `tbl_satuan_barang`
--
ALTER TABLE `tbl_satuan_barang`
  ADD PRIMARY KEY (`id_satuan`);

--
-- Indexes for table `tbl_spesialis`
--
ALTER TABLE `tbl_spesialis`
  ADD PRIMARY KEY (`id_spesialis`);

--
-- Indexes for table `tbl_status_menikah`
--
ALTER TABLE `tbl_status_menikah`
  ADD PRIMARY KEY (`id_status_menikah`);

--
-- Indexes for table `tbl_sub_pemeriksaan_laboratoirum`
--
ALTER TABLE `tbl_sub_pemeriksaan_laboratoirum`
  ADD PRIMARY KEY (`kode_sub_periksa`),
  ADD KEY `kode_periksa` (`kode_periksa`);

--
-- Indexes for table `tbl_supplier`
--
ALTER TABLE `tbl_supplier`
  ADD PRIMARY KEY (`kode_supplier`);

--
-- Indexes for table `tbl_tempat_tidur`
--
ALTER TABLE `tbl_tempat_tidur`
  ADD PRIMARY KEY (`kode_tempat_tidur`),
  ADD KEY `kode_ruang_rawat_inap` (`kode_ruang_rawat_inap`);

--
-- Indexes for table `tbl_tindakan`
--
ALTER TABLE `tbl_tindakan`
  ADD PRIMARY KEY (`kode_tindakan`),
  ADD KEY `kode_kategori_tindakan` (`kode_kategori_tindakan`),
  ADD KEY `id_poliklinik` (`id_poliklinik`);

--
-- Indexes for table `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`id_users`),
  ADD KEY `id_user_level` (`id_user_level`);

--
-- Indexes for table `tbl_user_level`
--
ALTER TABLE `tbl_user_level`
  ADD PRIMARY KEY (`id_user_level`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auditlabor`
--
ALTER TABLE `auditlabor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tbl_agama`
--
ALTER TABLE `tbl_agama`
  MODIFY `id_agama` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_bidang`
--
ALTER TABLE `tbl_bidang`
  MODIFY `id_bidang` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_departemen`
--
ALTER TABLE `tbl_departemen`
  MODIFY `id_departemen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_jabatan`
--
ALTER TABLE `tbl_jabatan`
  MODIFY `id_jabatan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_jadwal_praktek_dokter`
--
ALTER TABLE `tbl_jadwal_praktek_dokter`
  MODIFY `id_jadwal` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_jenis_bayar`
--
ALTER TABLE `tbl_jenis_bayar`
  MODIFY `id_jenis_bayar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_jenjang_pendidikan`
--
ALTER TABLE `tbl_jenjang_pendidikan`
  MODIFY `id_jenjang_pendidikan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_kategori_barang`
--
ALTER TABLE `tbl_kategori_barang`
  MODIFY `id_kategori_barang` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_menu`
--
ALTER TABLE `tbl_menu`
  MODIFY `id_menu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `tbl_pekerjaan`
--
ALTER TABLE `tbl_pekerjaan`
  MODIFY `id_pekerjaan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_pengadaan_detail`
--
ALTER TABLE `tbl_pengadaan_detail`
  MODIFY `id_pengadaan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `tbl_penjualan_detail`
--
ALTER TABLE `tbl_penjualan_detail`
  MODIFY `id_penjualan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `tbl_pj_riwayat_tindakan`
--
ALTER TABLE `tbl_pj_riwayat_tindakan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tbl_poliklinik`
--
ALTER TABLE `tbl_poliklinik`
  MODIFY `id_poliklinik` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_riwayat_pemberian_obat`
--
ALTER TABLE `tbl_riwayat_pemberian_obat`
  MODIFY `id_riwayat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_riwayat_pemeriksaan_laboratorium`
--
ALTER TABLE `tbl_riwayat_pemeriksaan_laboratorium`
  MODIFY `id_riwayat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `tbl_riwayat_pemeriksaan_laboratorium_detail`
--
ALTER TABLE `tbl_riwayat_pemeriksaan_laboratorium_detail`
  MODIFY `id_riwayat_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_riwayat_tindakan`
--
ALTER TABLE `tbl_riwayat_tindakan`
  MODIFY `id_riwayat_tindakan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tbl_satuan_barang`
--
ALTER TABLE `tbl_satuan_barang`
  MODIFY `id_satuan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_spesialis`
--
ALTER TABLE `tbl_spesialis`
  MODIFY `id_spesialis` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_status_menikah`
--
ALTER TABLE `tbl_status_menikah`
  MODIFY `id_status_menikah` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `id_users` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_user_level`
--
ALTER TABLE `tbl_user_level`
  MODIFY `id_user_level` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_dokter`
--
ALTER TABLE `tbl_dokter`
  ADD CONSTRAINT `tbl_dokter_ibfk_1` FOREIGN KEY (`id_agama`) REFERENCES `tbl_agama` (`id_agama`),
  ADD CONSTRAINT `tbl_dokter_ibfk_2` FOREIGN KEY (`id_spesialis`) REFERENCES `tbl_spesialis` (`id_spesialis`),
  ADD CONSTRAINT `tbl_dokter_ibfk_3` FOREIGN KEY (`id_status_menikah`) REFERENCES `tbl_status_menikah` (`id_status_menikah`);

--
-- Constraints for table `tbl_obat_alkes_bhp`
--
ALTER TABLE `tbl_obat_alkes_bhp`
  ADD CONSTRAINT `tbl_obat_alkes_bhp_ibfk_1` FOREIGN KEY (`id_kategori_barang`) REFERENCES `tbl_kategori_barang` (`id_kategori_barang`),
  ADD CONSTRAINT `tbl_obat_alkes_bhp_ibfk_2` FOREIGN KEY (`id_satuan_barang`) REFERENCES `tbl_satuan_barang` (`id_satuan`);

--
-- Constraints for table `tbl_pasien`
--
ALTER TABLE `tbl_pasien`
  ADD CONSTRAINT `tbl_pasien_ibfk_1` FOREIGN KEY (`id_agama`) REFERENCES `tbl_agama` (`id_agama`),
  ADD CONSTRAINT `tbl_pasien_ibfk_2` FOREIGN KEY (`id_pekerjaan`) REFERENCES `tbl_pekerjaan` (`id_pekerjaan`),
  ADD CONSTRAINT `tbl_pasien_ibfk_3` FOREIGN KEY (`status_menikah`) REFERENCES `tbl_status_menikah` (`id_status_menikah`);

--
-- Constraints for table `tbl_pendaftaran`
--
ALTER TABLE `tbl_pendaftaran`
  ADD CONSTRAINT `tbl_pendaftaran_ibfk_1` FOREIGN KEY (`id_jenis_bayar`) REFERENCES `tbl_jenis_bayar` (`id_jenis_bayar`),
  ADD CONSTRAINT `tbl_pendaftaran_ibfk_2` FOREIGN KEY (`id_poli`) REFERENCES `tbl_poliklinik` (`id_poliklinik`),
  ADD CONSTRAINT `tbl_pendaftaran_ibfk_3` FOREIGN KEY (`no_rekamedis`) REFERENCES `tbl_pasien` (`no_rekamedis`);

--
-- Constraints for table `tbl_pengadaan_detail`
--
ALTER TABLE `tbl_pengadaan_detail`
  ADD CONSTRAINT `tbl_pengadaan_detail_ibfk_1` FOREIGN KEY (`kode_barang`) REFERENCES `tbl_obat_alkes_bhp` (`kode_barang`),
  ADD CONSTRAINT `tbl_pengadaan_detail_ibfk_2` FOREIGN KEY (`no_faktur`) REFERENCES `tbl_pengadaan_obat_alkes_bhp` (`no_faktur`);

--
-- Constraints for table `tbl_pengadaan_obat_alkes_bhp`
--
ALTER TABLE `tbl_pengadaan_obat_alkes_bhp`
  ADD CONSTRAINT `tbl_pengadaan_obat_alkes_bhp_ibfk_1` FOREIGN KEY (`kode_supplier`) REFERENCES `tbl_supplier` (`kode_supplier`);

--
-- Constraints for table `tbl_penjualan_detail`
--
ALTER TABLE `tbl_penjualan_detail`
  ADD CONSTRAINT `tbl_penjualan_detail_ibfk_1` FOREIGN KEY (`kode_barang`) REFERENCES `tbl_obat_alkes_bhp` (`kode_barang`),
  ADD CONSTRAINT `tbl_penjualan_detail_ibfk_2` FOREIGN KEY (`no_faktur`) REFERENCES `tbl_penjualan_obat_alkes_bhp` (`no_faktur`);

--
-- Constraints for table `tbl_pj_riwayat_tindakan`
--
ALTER TABLE `tbl_pj_riwayat_tindakan`
  ADD CONSTRAINT `tbl_pj_riwayat_tindakan_ibfk_1` FOREIGN KEY (`id_riwayat_tindakan`) REFERENCES `tbl_riwayat_tindakan` (`id_riwayat_tindakan`);

--
-- Constraints for table `tbl_rawat_inap`
--
ALTER TABLE `tbl_rawat_inap`
  ADD CONSTRAINT `tbl_rawat_inap_ibfk_1` FOREIGN KEY (`kode_tempat_tidur`) REFERENCES `tbl_tempat_tidur` (`kode_tempat_tidur`);

--
-- Constraints for table `tbl_riwayat_pemberian_obat`
--
ALTER TABLE `tbl_riwayat_pemberian_obat`
  ADD CONSTRAINT `tbl_riwayat_pemberian_obat_ibfk_1` FOREIGN KEY (`kode_barang`) REFERENCES `tbl_obat_alkes_bhp` (`kode_barang`);

--
-- Constraints for table `tbl_riwayat_pemeriksaan_laboratorium`
--
ALTER TABLE `tbl_riwayat_pemeriksaan_laboratorium`
  ADD CONSTRAINT `tbl_riwayat_pemeriksaan_laboratorium_ibfk_1` FOREIGN KEY (`kode_periksa`) REFERENCES `tbl_pemeriksaan_laboratorium` (`kode_periksa`);

--
-- Constraints for table `tbl_riwayat_pemeriksaan_laboratorium_detail`
--
ALTER TABLE `tbl_riwayat_pemeriksaan_laboratorium_detail`
  ADD CONSTRAINT `tbl_riwayat_pemeriksaan_laboratorium_detail_ibfk_1` FOREIGN KEY (`kode_sub_periksa`) REFERENCES `tbl_sub_pemeriksaan_laboratoirum` (`kode_sub_periksa`),
  ADD CONSTRAINT `tbl_riwayat_pemeriksaan_laboratorium_detail_ibfk_2` FOREIGN KEY (`id_riwayat`) REFERENCES `tbl_riwayat_pemeriksaan_laboratorium` (`id_riwayat`);

--
-- Constraints for table `tbl_riwayat_tindakan`
--
ALTER TABLE `tbl_riwayat_tindakan`
  ADD CONSTRAINT `tbl_riwayat_tindakan_ibfk_1` FOREIGN KEY (`kode_tindakan`) REFERENCES `tbl_tindakan` (`kode_tindakan`);

--
-- Constraints for table `tbl_ruang_rawat_inap`
--
ALTER TABLE `tbl_ruang_rawat_inap`
  ADD CONSTRAINT `tbl_ruang_rawat_inap_ibfk_1` FOREIGN KEY (`kode_gedung_rawat_inap`) REFERENCES `tbl_gedung_rawat_inap` (`kode_gedung_rawat_inap`);

--
-- Constraints for table `tbl_sub_pemeriksaan_laboratoirum`
--
ALTER TABLE `tbl_sub_pemeriksaan_laboratoirum`
  ADD CONSTRAINT `tbl_sub_pemeriksaan_laboratoirum_ibfk_1` FOREIGN KEY (`kode_periksa`) REFERENCES `tbl_pemeriksaan_laboratorium` (`kode_periksa`);

--
-- Constraints for table `tbl_tempat_tidur`
--
ALTER TABLE `tbl_tempat_tidur`
  ADD CONSTRAINT `tbl_tempat_tidur_ibfk_1` FOREIGN KEY (`kode_ruang_rawat_inap`) REFERENCES `tbl_ruang_rawat_inap` (`kode_ruang_rawat_inap`);

--
-- Constraints for table `tbl_tindakan`
--
ALTER TABLE `tbl_tindakan`
  ADD CONSTRAINT `tbl_tindakan_ibfk_1` FOREIGN KEY (`kode_kategori_tindakan`) REFERENCES `tbl_kategori_tindakan` (`kode_kategori_tindakan`),
  ADD CONSTRAINT `tbl_tindakan_ibfk_2` FOREIGN KEY (`id_poliklinik`) REFERENCES `tbl_poliklinik` (`id_poliklinik`);

--
-- Constraints for table `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD CONSTRAINT `tbl_user_ibfk_1` FOREIGN KEY (`id_user_level`) REFERENCES `tbl_user_level` (`id_user_level`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
