import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kas_mini_flutter_app/constants/apiConstants.dart';
import 'package:kas_mini_flutter_app/providers/userProvider.dart';
import 'package:kas_mini_flutter_app/utils/null_data_alert.dart';
import 'package:kas_mini_flutter_app/utils/toast.dart';
import 'package:kas_mini_flutter_app/view/page/login.dart';
import 'package:kas_mini_flutter_app/view/page/splash_screen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  final api = ApiConstants.baseUrl;
  bool isTokenExpired(BuildContext context, String token) {
    try {
      final tokenParts = token.split('.');
      if (tokenParts.length != 3) {
        throw Exception('Invalid token format');
      }
      final payload = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(tokenParts[1]))));
      final exp = payload['exp'];
      if (exp == null) {
        throw Exception('Token does not contain expiration');
      }
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      if (now.isAfter(expiryDate)) {
        showNullDataAlert(context,
            message: "Token kadaluwarsa, silahkan login kembali!");
        return true; // Token sudah kedaluwarsa
      } else {
        final remainingTime = expiryDate.difference(now);
        final hours = remainingTime.inHours;
        final minutes = remainingTime.inMinutes % 60;
        final seconds = remainingTime.inSeconds % 60;
        print(
            'Token masih valid. Sisa waktu: ${hours} jam, ${minutes} menit, ${seconds} detik');
        return false; // Token masih valid
      }
    } catch (e) {
      print('Error checking token expiration: $e');
      return true; // Anggap expired jika ada error
    }
  }

  Future<void> loginWithSerialNumber(
      context, String serialNumber, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${api}/api/serial-number/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'serialNumber': serialNumber, 'password': password}),
      );

      if (response.statusCode == 200) {
        print("Fetched from ${api}");
        final data = jsonDecode(response.body);
        await storage.write(key: 'token', value: data['token']);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.fetchAndDecodeToken();
        await userProvider.getSerialNumberAsUser(context);
        final tokenParts = data['token'].split('.');
        if (tokenParts.length == 3) {
          final payload = jsonDecode(utf8
              .decode(base64Url.decode(base64Url.normalize(tokenParts[1]))));
          print('Token payload: $payload');
        } else {
          throw Exception('Invalid token format');
        }
        print('Login successful with token: ${data['token']}');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            errorData['message'] ?? 'Failed to login with serial number');
      }
      // successToastFilledColor(context as BuildContext, "Berhasil Login", "Berhasil Login!");
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }

  Future<void> logout(context) async {
    await storage.delete(key: 'token');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SplashScreen()));
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }
}
