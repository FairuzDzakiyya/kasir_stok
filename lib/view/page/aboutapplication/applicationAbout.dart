import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:kas_mini_flutter_app/model/product.dart';
import 'package:kas_mini_flutter_app/providers/appVersionProvider.dart';
import 'package:kas_mini_flutter_app/services/database_service.dart';
import 'package:kas_mini_flutter_app/services/db.copy.dart';
import 'package:kas_mini_flutter_app/utils/colors.dart';
import 'package:kas_mini_flutter_app/utils/responsif/fsize.dart';
import 'package:kas_mini_flutter_app/view/widget/back_button.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  DatabaseService db = DatabaseService.instance;

  String appVersion = "Loading..";

  @override
  void initState() {
    super.initState();
    var appVersionProvider = AppVersionProvider();

    appVersionProvider.getAppVersion().then((_) {
      setState(() {
        appVersion = appVersionProvider.appVersion;
      });
    });
  }

  bool test = false;
  bool updated = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(38, 58, 158, 255),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment(0, 2),
            end: Alignment(-0, -2),
          ),
        ),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/bg-splash-screen-without-opacity.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            Stack(
              children: [
                   AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 4,
                        width: 4,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.white, Colors.white],
                              begin: Alignment(0, 2),
                              end: Alignment(-0, -2)),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Stack(
                              children: const [
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  left: 6,
                                  bottom: 0,
                                  child: Center(
                                      child: Iconify(
                                          MaterialSymbols
                                              .arrow_back_ios_rounded,
                                          color: primaryColor)),
                                )
                              ],
                            ))),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Laris Kas",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text("Versi $appVersion",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      const SizedBox(height: 20),
                      Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "assets/images/Logo-Kasmini.jpg",
                            width: 100,
                            height: 100,
                          )),
                      const SizedBox(height: 20),
                      // const Text("Update Terakhir : 1.0.0", style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 20),
                 
                      ElevatedButton(
                        onPressed: () async {
                          List<Product> products =
                              await db.getProducts(); // Punya productImage
                          await copyDatabaseToStorage(context, products);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: Text(
                          "Backup Raw Database",
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                     
                    ],
                  ),
                ),
              ],
            ),
           
          ],
        ),
      ),
    );
  }
}
