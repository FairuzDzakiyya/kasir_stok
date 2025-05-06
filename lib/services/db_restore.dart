import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.request();
  if (!status.isGranted) {
    throw Exception('Izin akses penyimpanan ditolak');
  }
}

Future<void> restoreDB() async {
  await requestStoragePermission();

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.any,
    allowMultiple: false,
  );

  if (result != null) {
    File zipFile = File(result.files.single.path!);
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final appDir = await getApplicationDocumentsDirectory();

    final productDir = Directory('${appDir.path}/files/product');
    final tokoDir = Directory('${appDir.path}/files/toko');
    await productDir.create(recursive: true);
    await tokoDir.create(recursive: true);

    for (var file in archive) {
      if (file.isFile) {
        final filePath = '${appDir.path}/${file.name}';
        final directoryPath = Directory(filePath.substring(0, filePath.lastIndexOf('/')));
        await directoryPath.create(recursive: true);

        final outputFile = File(filePath);
        await outputFile.writeAsBytes(file.content as List<int>);

        if (file.name == 'mycash.db') {
          final dbPath = await getDatabasesPath();
          final dbFile = File('$dbPath/master_db.db');
          await dbFile.writeAsBytes(file.content as List<int>);
          print('Database berhasil dipulihkan!');
        }

        if (file.name.startsWith('files/product/')) {
          print('Gambar produk dipulihkan: $filePath');
        }

        if (file.name.startsWith('files/toko/')) {
          print('Gambar toko dipulihkan: $filePath');
        }
      }
    }

    print('Restore selesai!');
  } else {
    print('Tidak ada file yang dipilih');
  }
}
