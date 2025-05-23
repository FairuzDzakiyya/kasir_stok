import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityProvider with ChangeNotifier {
  bool _kunciRiwayatTransaksi = false;
  bool _kunciProduk = false;
  bool _kunciTambahKategori = false;
  bool _tambahProduk = false;
  bool _tambahStokProduk = false;
  bool _hapusStokProduk = false;
  bool _editProduk = false;
  bool _hapusProduk = false;
  bool _kunciKategori = false;
  bool _editKategori = false;
  bool _hapusKategori = false;
  bool _kunciPengeluaran = false;
  bool _tambahPengeluaran = false;
  bool _editPengeluaran = false;
  bool _hapusPengeluaran = false;
  bool _kunciPemasukan = false;
  bool _tambahPemasukan = false;
  bool _editPemasukan = false;
  bool _hapusPemasukan = false;
  bool _sembunyikanProfit = false;
  bool _tanggalTransaksi = false;
  bool _batalkanTransaksi = false;
  bool _editTransaksi = false;
  bool _hapusTransaksi = false;
  bool _tambahMetode = false;
  bool _editMetode = false;
  bool _hapusMetode = false;
  bool _kunciCetakStruk = false;
  bool _kunciBagikanStruk = false;
  bool _kunciLaporan = false;
  bool _kunciPengaturanToko = false;
  bool _kunciRestoreData = false;
  bool _sembunyikanHapusBackup = false;
  bool _sembunyikanLogout = false;

  // true
  bool _kunciGantiPassword = true;

  bool get kunciRiwayatTransaksi => _kunciRiwayatTransaksi;
  bool get kunciProduk => _kunciProduk;
  bool get tambahProduk => _tambahProduk;
  bool get tambahStokProduk => _tambahStokProduk;
  bool get hapusStokProduk => _hapusStokProduk;
  bool get editProduk => _editProduk;
  bool get hapusProduk => _hapusProduk;
  bool get kunciKategori => _kunciKategori;
  bool get kunciTambahKategori => _kunciTambahKategori;
  bool get editKategori => _editKategori;
  bool get hapusKategori => _hapusKategori;
  bool get kunciPengeluaran => _kunciPengeluaran;
  bool get tambahPengeluaran => _tambahPengeluaran;
  bool get editPengeluaran => _editPengeluaran;
  bool get hapusPengeluaran => _hapusPengeluaran;
  bool get kunciPemasukan => _kunciPemasukan;
  bool get tambahPemasukan => _tambahPemasukan;
  bool get editPemasukan => _editPemasukan;
  bool get hapusPemasukan => _hapusPemasukan;
  bool get sembunyikanProfit => _sembunyikanProfit;
  bool get tanggalTransaksi => _tanggalTransaksi;
  bool get batalkanTransaksi => _batalkanTransaksi;
  bool get editTransaksi => _editTransaksi;
  bool get hapusTransaksi => _hapusTransaksi;
  bool get tambahMetode => _tambahMetode;
  bool get editMetode => _editMetode;
  bool get hapusMetode => _hapusMetode;
  bool get kunciCetakStruk => _kunciCetakStruk;
  bool get kunciBagikanStruk => _kunciBagikanStruk;
  bool get kunciLaporan => _kunciLaporan;
  bool get kunciPengaturanToko => _kunciPengaturanToko;
  bool get kunciGantiPassword => _kunciGantiPassword;
  bool get kunciRestoreData => _kunciRestoreData;
  bool get sembunyikanHapusBackup => _sembunyikanHapusBackup;
  bool get sembunyikanLogout => _sembunyikanLogout;

  void reloadPreferences() async {
    await loadPreferences();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _kunciRiwayatTransaksi = prefs.getBool('kunciRiwayatTransaksi') ?? false;
    _kunciProduk = prefs.getBool('kunciProduk') ?? false;
    _tambahProduk = prefs.getBool('tambahProduk') ?? false;
    _tambahStokProduk = prefs.getBool('tambahStokProduk') ?? false;
    _hapusStokProduk = prefs.getBool('hapusStokProduk') ?? false;
    _editProduk = prefs.getBool('editProduk') ?? false;
    _hapusProduk = prefs.getBool('hapusProduk') ?? false;
    _kunciTambahKategori = prefs.getBool('kunciTambahKategori') ?? false;
    _kunciKategori = prefs.getBool('kunciKategori') ?? false;
    _editKategori = prefs.getBool('editKategori') ?? false;
    _hapusKategori = prefs.getBool('hapusKategori') ?? false;
    _kunciPengeluaran = prefs.getBool('kunciPengeluaran') ?? false;
    _tambahPengeluaran = prefs.getBool('tambahPengeluaran') ?? false;
    _editPengeluaran = prefs.getBool('editPengeluaran') ?? false;
    _hapusPengeluaran = prefs.getBool('hapusPengeluaran') ?? false;
    _kunciPemasukan = prefs.getBool('kunciPemasukan') ?? false;
    _tambahPemasukan = prefs.getBool('tambahPemasukan') ?? false;
    _editPemasukan = prefs.getBool('editPemasukan') ?? false;
    _hapusPemasukan = prefs.getBool('hapusPemasukan') ?? false;
    _sembunyikanProfit = prefs.getBool('sembunyikanProfit') ?? false;
    _tanggalTransaksi = prefs.getBool('tanggalTransaksi') ?? false;
    _batalkanTransaksi = prefs.getBool('batalkanTransaksi') ?? false;
    _editTransaksi = prefs.getBool('editTransaksi') ?? false;
    _hapusTransaksi = prefs.getBool('hapusTransaksi') ?? false;
    _tambahMetode = prefs.getBool('tambahMetode') ?? false;
    _editMetode = prefs.getBool('editMetode') ?? false;
    _hapusMetode = prefs.getBool('hapusMetode') ?? false;
    _kunciCetakStruk = prefs.getBool('kunciCetakStruk') ?? false;
    _kunciBagikanStruk = prefs.getBool('kunciBagikanStruk') ?? false;
    _kunciLaporan = prefs.getBool('kunciLaporan') ?? false;
    _kunciPengaturanToko = prefs.getBool('kunciPengaturanToko') ?? false;
    _kunciGantiPassword = prefs.getBool('kunciGantiPassword') ?? false;
    _kunciRestoreData = prefs.getBool('kunciRestoreData') ?? false;
    _sembunyikanHapusBackup = prefs.getBool('sembunyikanHapusBackup') ?? false;
    _sembunyikanLogout = prefs.getBool('sembunyikanLogout') ?? false;
    notifyListeners();
  }
}
