import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kas_mini_flutter_app/model/transaction.dart';
import 'package:kas_mini_flutter_app/services/database_service.dart';
import 'package:kas_mini_flutter_app/utils/colors.dart';
import 'package:kas_mini_flutter_app/view/page/detail_history_transaction.dart';
import 'package:kas_mini_flutter_app/view/widget/Notfound.dart';
import 'package:kas_mini_flutter_app/view/widget/card_report_transaction.dart';
import 'package:kas_mini_flutter_app/view/widget/custom_textfield.dart';
import 'package:kas_mini_flutter_app/view/widget/date_from_to/fromTo_v2.dart';
import 'package:kas_mini_flutter_app/view/widget/refresWidget.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class RiwayatTransaksi extends StatefulWidget {
  const RiwayatTransaksi({super.key});

  @override
  State<RiwayatTransaksi> createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color _Color = const Color(0xff2ECC71);
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();
  DateTime tanggalAwal_delete = DateTime.now();
  DateTime tanggalAkhir_delete = DateTime.now();

  final DatabaseService _databaseService = DatabaseService.instance;

  Future<List<TransactionData>> _getTransactionsData() async {
    try {
      return await _databaseService.getTransaction();
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  late Future<List<TransactionData>> transactions;

  @override
  void initState() {
    super.initState();
    transactions = _getTransactionsData();

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _Color = const Color(0xff2ECC71);
            break;
          case 1:
            _Color = const Color(0xffFFC107);
            break;
          case 2:
            _Color = const Color(0xffFF5733);
            break;
          case 3:
            _Color = const Color(0xffA14747);
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [secondaryColor, primaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                WidgetDateFromTo_v2(
                  initialStartDate: dateFrom,
                  initialEndDate: dateTo,
                  bg: Colors.transparent,
                  title: 'RIWAYAT TRANSAKSI',
                  onDateRangeChanged: (start, end) {
                    setState(() {
                      dateFrom = start;
                      dateTo = end;
                    });
                  },
                ),
              ],
            ),
          ),
          Gap(5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 8.h,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                  )
                ]),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    controller: _tabController,
                    labelColor: const Color(0xfffffaf5),
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      color: _Color,
                      border: null,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    indicatorColor: Colors.transparent,
                    indicatorWeight: 0,
                    indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: -15, vertical: 0),
                    tabs: [
                      Tab(
                        child: Text(
                          "Selesai",
                          style: GoogleFonts.poppins(fontSize: 15.sp),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Belum Lunas",
                          style: GoogleFonts.poppins(fontSize: 15.sp),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Belum Dibayar",
                          style: GoogleFonts.poppins(fontSize: 15.sp),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Dibatalkan",
                          style: GoogleFonts.poppins(fontSize: 15.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const Gap(5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextField(
              suffixIcon: null,
              maxLines: null,
              obscureText: false,
              hintText: "Cari Transaksi",
              hintStyle: GoogleFonts.poppins(fontSize: 14.sp),
              prefixIcon: Icon(Icons.search),
              controller: null,
              fillColor: Colors.white,
            ),
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionPage('Selesai'),
                _buildTransactionPage('Belum Lunas'),
                _buildTransactionPage('Belum Dibayar'),
                _buildTransactionPage('Dibatalkan'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionPage(String title) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<TransactionData>>(
            future: _getTransactionsData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                    child: CustomRefreshWidget(child: NotFoundPage()));
              } else {
                // Filter transactions based on the selected date range and transaction status
                final transactions = snapshot.data!.where((transaction) {
                  try {
                    String dateStr = transaction.transactionDate.split(', ')[1];
                    DateTime transactionDate =
                        DateFormat("dd/MM/yyyy HH:mm").parse(dateStr).toLocal();
                    DateTime startDate = DateTime(dateFrom.year, dateFrom.month,
                            dateFrom.day, 0, 0, 0)
                        .toLocal();
                    DateTime endDate = DateTime(
                            dateTo.year, dateTo.month, dateTo.day, 23, 59, 59)
                        .toLocal();

                    return (transactionDate.isAfter(startDate) ||
                            transactionDate.isAtSameMomentAs(startDate)) &&
                        (transactionDate.isBefore(endDate) ||
                            transactionDate.isAtSameMomentAs(endDate)) &&
                        transaction.transactionStatus == title;
                  } catch (e) {
                    print(
                        "Error parsing date: ${transaction.transactionDate}, Error: $e");
                    return false;
                  }
                }).toList();

                if (transactions.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_outlined,
                        size: 60,
                        color: Colors.black,
                      ),
                      Text(
                        'Tidak ada transaksi yang ditemukan',
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ));
                }

                return Column(
                  children: [
                    Expanded(
                      child: CustomRefreshWidget(
                        child: ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return Column(children: [
                              Gap(10),
                              ZoomTapAnimation(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailHistoryTransaction(
                                                transactionDetail:
                                                    transactions[index],
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: CardReportTransactions(
                                      transaction: transaction),
                                ),
                              ),
                            ]);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
