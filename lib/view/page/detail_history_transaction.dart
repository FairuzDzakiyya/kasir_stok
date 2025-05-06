import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kas_mini_flutter_app/model/transaction.dart';
import 'package:kas_mini_flutter_app/providers/bluetoothProvider.dart';
import 'package:kas_mini_flutter_app/providers/securityProvider.dart';
import 'package:kas_mini_flutter_app/services/database_service.dart';
import 'package:kas_mini_flutter_app/utils/bluetoothAlert.dart';
import 'package:kas_mini_flutter_app/utils/colors.dart';
import 'package:kas_mini_flutter_app/utils/pinModalWithAnimation.dart';
import 'package:kas_mini_flutter_app/utils/printer_helper.dart';
import 'package:kas_mini_flutter_app/utils/successAlert.dart';
import 'package:kas_mini_flutter_app/view/widget/pinModal.dart';
import 'package:provider/provider.dart';

class DetailHistoryTransaction extends StatefulWidget {
  final TransactionData? transactionDetail;
  const DetailHistoryTransaction({super.key, this.transactionDetail});

  @override
  State<DetailHistoryTransaction> createState() =>
      _DetailHistoryTransactionState();
}

class _DetailHistoryTransactionState extends State<DetailHistoryTransaction> {
  @override
  Widget build(BuildContext context) {
    var bluetoothProvider = Provider.of<BluetoothProvider>(context);
    var securityProvider = Provider.of<SecurityProvider>(context);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [secondaryColor, primaryColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_outlined),
                          color: Colors.white),
                      Text("DETAIL TRANSAKSI",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ID Transaksi: # ${widget.transactionDetail!.transactionId}",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(Icons.person_2_outlined,
                                        size: 20, color: secondaryColor),
                                  ],
                                ),
                                Divider(
                                  color: secondaryColor,
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Jumlah Pesanan: ${widget.transactionDetail!.transactionQuantity}",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Gap(2),
                                Row(
                                  children: [
                                    Text("Total Harga: ",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Gap(2),
                                Row(
                                  children: [
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp. ',
                                                decimalDigits: 0)
                                            .format(widget.transactionDetail!
                                                .transactionTotal),
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 14, color: secondaryColor),
                                      Text(
                                          " ${widget.transactionDetail!.transactionDate}",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "Status: ${widget.transactionDetail!.transactionStatus}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              Text(
                                  "Antrian: ${widget.transactionDetail!.transactionQueueNumber}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      Gap(10),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRect(
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Icon(Icons.person,
                                            color: Colors.white, size: 24),
                                      ),
                                    ),
                                    Gap(10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Nama Kasir : ${widget.transactionDetail!.transactionCashier}",
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            "Metode Bayar : ${widget.transactionDetail!.transactionPaymentMethod}",
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: secondaryColor,
                                  thickness: 1,
                                ),
                                Row(
                                  children: [
                                    Text(
                                        "Jumlah Bayar : ${NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0).format(widget.transactionDetail!.transactionPayAmount)}",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                )
                              ],
                            ),
                          )),
                      Gap(10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            Text("Detail Pesanan",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            Spacer(),
                            InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 80,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("Pesan Ulang",
                                            style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                )),
                            Gap(6),
                            InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 80,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("Edit Pesanan",
                                            style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        widget.transactionDetail!.transactionProduct.length,
                    itemBuilder: (context, index) {
                      var product =
                          widget.transactionDetail!.transactionProduct[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['product_name'],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Divider(
                                color: secondaryColor,
                                thickness: 1,
                              ),
                              Text(
                                "${product['quantity']} x ${NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0).format(product['product_sell_price'])}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Subtotal: ',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp. ',
                                        decimalDigits: 0)
                                    .format(product['product_sell_price']),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                  //               if (securityProvider.kunciCetakStruk) {
                  //   showPinModalWithAnimation(context,
                  //       pinModal: PinModal(onTap: () {
                  //     if (bluetoothProvider.isConnected) {
                  //       PrinterHelper.printReceiptAndOpenDrawer(
                  //           context, bluetoothProvider.connectedDevice!,
                  //           products: widget.products ?? []);

                  //       showSuccessAlert(context,
                  //           "Berhasil mencetak, silahkan tunggu sebentar!.");
                  //     }
                  //   }));
                  // } else {
                  //   if (bluetoothProvider.isConnected) {
                  //     PrinterHelper.printReceiptAndOpenDrawer(
                  //         context, bluetoothProvider.connectedDevice!,
                  //         products: widget.products ?? []);

                  //     showSuccessAlert(context,
                  //         "Berhasil mencetak, silahkan tunggu sebentar!.");
                  //   } else {
                  //     showBluetoothAlert2(context);
                  //   }
                  // }
                              },
                              child: Container(
                                width: 120,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.print_outlined,
                                          color: Colors.white, size: 24),
                                      Gap(4),
                                      Text("Cetak",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.print_outlined,
                                        color: Colors.white, size: 24),
                                    Gap(4),
                                    Text("Antrian",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.share_outlined,
                                        color: Colors.white, size: 24),
                                    Gap(4),
                                    Text("Bagikan",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  DatabaseService.instance
                                      .updateTransactionStatus(
                                          widget
                                              .transactionDetail!.transactionId,
                                          "Dibatalkan");
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.close_outlined,
                                            color: Colors.white, size: 24),
                                        Gap(4),
                                        Text("Batalkan Pesanan",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Gap(4),
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete_outline_outlined,
                                          color: primaryColor, size: 24),
                                      Gap(4),
                                      Text("Hapus Pesanan",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
