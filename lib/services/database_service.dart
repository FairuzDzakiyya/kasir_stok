import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:kas_mini_flutter_app/model/cashier.dart';
import 'package:kas_mini_flutter_app/model/category.dart';
import 'package:kas_mini_flutter_app/model/expenceModel.dart';
import 'package:kas_mini_flutter_app/model/expense.dart';
import 'package:kas_mini_flutter_app/model/income.dart';
import 'package:kas_mini_flutter_app/model/paymentMethod.dart';
import 'package:kas_mini_flutter_app/model/product.dart';
import 'package:kas_mini_flutter_app/model/setting.dart';
import 'package:kas_mini_flutter_app/model/stock_addition.dart';
import 'package:kas_mini_flutter_app/model/transaction.dart';
import 'package:kas_mini_flutter_app/utils/failedAlert.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final _dbLock = Lock();

//table product
  final String _productsTable = "products";
  final String _productsId = "product_id";
  final String _productsName = "product_name";
  final String _productsBarcode = "product_barcode";
  final String _productsBarcodeType = "product_barcode_type";
  final String _productsPurchasePrice = "product_purchase_price";
  final String _productsUnit = "product_unit";
  final String _productsSellPrice = "product_sell_price";
  final String _productsImage = "product_image";
  final String _productsStock = "product_stock";
  final String _productsDateAdded = "product_date_added";
  final String _productsSold = "product_sold";

  // table categories and product include this
  final String _categoryId = "category_id";

  //table category
  final String _categoryTable = "categories";

  final String _categoryName = "category_name";
  final String _categoryDateAdded = "category_date_added";

  //table user
  final String _userTable = "users";
  final String _userId = "user_id";
  final String _userName = "username";
  final String _userSecurityPin = "user_security_pin";
  final String _userRole = "user_role";
  final String _userImage = "user_image";

  //table transaction
  final String _transactionTable = "transactions";
  final String _transactionId = "transaction_id";
  final String _transactionDate = "transaction_date";
  final String _transactionCashier = "transaction_cashier";
  final String _transactionCustomerName = "transaction_customer_name";
  final String _transactionTotal = "transaction_total";
  final String _transactionPayAmount = "transaction_pay_amount";
  final String _transactionDiscount = "transaction_discount";
  final String _transactionMethod = "transaction_method";
  final String _transactionTax = "transaction_tax";
  final String _transactionNote = "transaction_note";
  final String _transactionStatus = "transaction_status";
  final String _transactionQuantity = "transaction_quantity";
  final String _transactionProducts = "transaction_products";
  final String _transactionQueueNumber = "transaction_queue_number";
  final String _transactionProfit = "transaction_profit";

  // table expense
  final String _expenseTable = "expenses";
  final String _expenseId = "expense_id";
  final String _expenseName = "expense_name";
  final String _expenseDateAdded = "expense_date_added";
  final String _expenseDate = "expense_date";
  final String _expenseAmount = "expense_amount";
  final String _expenseNote = "expense_note";

  // table income
  final String _incomeTable = "incomes";
  final String _incomeId = "income_id";
  final String _incomeName = "income_name";
  final String _incomeDateAdded = "income_date_added";
  final String _incomeDate = "income_date";
  final String _incomeAmount = "income_amount";
  final String _incomeNote = "income_note";

  //table security
  final String _securityTable = "security";
  final String _securityPassword = "security_password";

  // table settings
  final String _settingTable = "settings";
  final String _settingImage = "setting_image";
  final String _settingName = "setting_name";
  final String _settingAddress = "setting_address";
  final String _settingFooterMessage = "setting_footer_message";
  final String _settingReceipt = "setting_template_receipt";
  final String _settingReceiptSize = "setting_receipt_size";
  final String _settingPrint = "setting_printer";
  final String _settingSound = "setting_sound";
  final String _settingProfit = "setting_type_profit";
  final String _settingPrinterAutoCut = "setting_printer_auto_cut";
  final String _settingCashdrawer = "setting_cashdrawer";

  // table profit

  // table payment method
  final String _paymentMethodTable = "payment_method";
  final String _paymentId = "payment_method_id";
  final String _paymentName = "payment_method_name";
  final String _paymentNote = "payment_method_note";

  //table addition stock product
  final String _stockAdditionTable = "stock_addition_table";
  final String _stockAdditionId = "stock_addition_id";
  final String _stockAdditionName = "stock_addition_name";
  final String _stockAdditionDate = "stock_addition_date";
  final String _stockAdditionAmount = "stock_addition_amount";
  final String _stockAdditionNote = "stock_addition_note";
  final String _stockAdditionProductId = "stock_addition_product_id";

  // table cashier
  final String _cashierTable = "cashier";
  final String _cashierId = "cashier_id";
  final String _cashierName = "cashier_name";
  final String _cashierPhoneNumber = "cashier_phone_number";
  final String _cashierImage = "cashier_image";
  final String _cashierTotalTransaction = "cashier_total_transaction";
  final String _cashierTotalTransactionMoney =
      "cashier_total_transaction_money";
  final String _cashierPin = "cashier_pin";
  final String _cashierSelesai = "selesai";
  final String _cashierProses = "proses";
  final String _cashierPending = "pending";
  final String _cashierBatal = "batal";

  // table cashier
  final String _currentCashierTable = "currentCashier";
  // id
  // name
  
  final String _serialNumberTable = "serialNumberTable";
  final String _serialNumberId = "serialNumberId";
  final String _serialNumberImage = "serialNumberImage";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasepath = join(databaseDirPath, "master_db.db");
    final database =
        await openDatabase(databasepath, version: 1, onCreate: (db, version) {
      // products
      db.execute('''
          CREATE TABLE $_productsTable (
            $_productsId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_productsBarcode TEXT NOT NULL,
            $_productsBarcodeType TEXT NOT NULL,
            $_productsName TEXT NOT NULL,
            $_productsStock INTEGER NOT NULL,
            $_productsUnit TEXT NOT NULL,
            $_productsSold INTEGER NOT NULL,
            $_productsPurchasePrice INTEGER NOT NULL,
            $_productsSellPrice INTEGER NOT NULL,
            $_productsDateAdded TEXT NOT NULL,
            $_productsImage TEXT NOT NULL,
            $_categoryName TEXT NOT NULL
          )
        ''');

      // category
      db.execute('''
        CREATE TABLE $_categoryTable (
          $_categoryId INTEGER PRIMARY KEY AUTOINCREMENT, 
            $_categoryName TEXT NOT NULL UNIQUE,
          $_categoryDateAdded TEXT NOT NULL
        )
        ''');

      // user
      db.execute('''
        CREATE TABLE $_userTable (
          $_userId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_userName TEXT PRIMARY KEY, 
          $_userSecurityPin TEXT NOT NULL,
          $_userRole TEXT NOT NULL,
          $_userImage TEXT NOT NULL
        )
       ''');

      // transaction
      db.execute('''
        CREATE TABLE $_transactionTable (
          $_transactionId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_transactionDate TEXT NOT NULL,
          $_transactionCashier TEXT NOT NULL,
          $_transactionCustomerName TEXT NOT NULL,
          $_transactionTotal INTEGER NOT NULL,
          $_transactionPayAmount INTEGER NOT NULL,
          $_transactionDiscount INTEGER NOT NULL,
          $_transactionMethod TEXT NOT NULL,
          $_transactionTax INTEGER NOT NULL,
          $_transactionNote TEXT NOT NULL,
          $_transactionStatus TEXT NOT NULL,
          $_transactionQuantity INTEGER NOT NULL,
          $_transactionProducts TEXT NOT NULL,
          $_transactionQueueNumber INTEGER NOT NULL,
          $_transactionProfit INTEGER NOT NULL
        )
        ''');

      // cashier
      db.execute('''
            CREATE TABLE $_cashierTable (
          $_cashierId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_cashierName TEXT NOT NULL,
          $_cashierPhoneNumber INTEGER NOT NULL,
          $_cashierImage TEXT NOT NULL,
          $_cashierTotalTransaction INTEGER NOT NULL,
          $_cashierTotalTransactionMoney INTEGER NOT NULL,
          $_cashierPin INTEGER NOT NULL,
          $_cashierSelesai INTEGER NOT NULL,
          $_cashierProses INTEGER NOT NULL,
          $_cashierPending INTEGER NOT NULL,
          $_cashierBatal INTEGER NOT NULL
            )
        ''');

      db.insert(_cashierTable, {
        _cashierName: 'Owner',
        _cashierPhoneNumber: 1234567890,
        _cashierImage: 'assets/profiles/profile-1.png',
        _cashierTotalTransaction: 0,
        _cashierTotalTransactionMoney: 0,
        _cashierPin: 123456,
        _cashierSelesai: 0,
        _cashierProses: 0,
        _cashierPending: 0,
        _cashierBatal: 0,
      });

      db.execute('''
            CREATE TABLE $_currentCashierTable (
          $_cashierId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_cashierName TEXT NOT NULL
            )
        ''');

      db.insert(_currentCashierTable, {_cashierId: 1, _cashierName: 'Owner'});

      // expense
      db.execute('''
        CREATE TABLE $_expenseTable (
          $_expenseId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_expenseName TEXT NOT NULL,
          $_expenseDateAdded TEXT NOT NULL,
          $_expenseDate TEXT NOT NULL,
          $_expenseAmount INTEGER NOT NULL,
          $_expenseNote TEXT NOT NULL
        );
      ''');

      // income
      db.execute('''
        CREATE TABLE $_incomeTable (
          $_incomeId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_incomeName TEXT NOT NULL,
          $_incomeDateAdded TEXT NOT NULL,
          $_incomeDate TEXT NOT NULL,
          $_incomeAmount INTEGER NOT NULL,
          $_incomeNote TEXT NOT NULL
        );
      ''');

      // addition stock
      db.execute('''
        CREATE TABLE $_stockAdditionTable (
          $_stockAdditionId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_stockAdditionName TEXT NOT NULL,
          $_stockAdditionDate TEXT NOT NULL,
          $_stockAdditionAmount INTEGER NOT NULL,
          $_stockAdditionNote TEXT NOT NULL,
          $_stockAdditionProductId INTEGER NOT NULL
          )
      ''');

      // security
      // STATUS = 1 AND 0
      // db.execute('''
      //   CREATE TABLE $_securityTable (
      //     $_securityName TEXT NOT NULL,
      //     $_securityStatus INTEGER NOT NULL
      //     )
      // ''');
      //! SECURITY DIGANTI BUKAN DENGAN DATABASE, JADI NYA PAKAI  SharedPreferences (ini package)

      // setting (not security)
      db.execute('''
        CREATE TABLE $_settingTable (
          $_settingImage TEXT NOT NULL,
          $_settingName TEXT NOT NULL,
          $_settingAddress TEXT NOT NULL,
          $_settingFooterMessage TEXT NOT NULL,
          $_settingProfit TEXT NOT NULL,
          $_settingReceipt TEXT NOT NULL,
          $_settingReceiptSize TEXT NOT NULL,
          $_settingPrint TEXT NOT NULL,
          $_settingPrinterAutoCut TEXT NOT NULL,
          $_settingCashdrawer TEXT NOT NULL,
          $_settingSound TEXT NOT NULL
        )
      ''');

      // serial number
      // db.execute('''
      //   CREATE TABLE $_serialNumberTable (
      //     $_serialNumberId TEXT PRIMARY KEY AUTOINCREMENT,
      //     $_serialNumberImage TEXT NOT NULL TEXT PRIMARY KEY AUTOINCREMENT
      //   )
      // ''');

      db.insert(_settingTable, {
        _settingImage: 'assets/products/no-image.png',
        _settingName: '',
        _settingAddress: '',
        _settingFooterMessage: '',
        _settingPrint: '',
        _settingProfit: "omzetModal",
        _settingReceipt: 'default',
        _settingReceiptSize: '58',
        _settingCashdrawer: 'false',
        _settingPrinterAutoCut: 'false',
        _settingSound: 'false'
      });

      db.execute('''
        CREATE TABLE $_paymentMethodTable (
          $_paymentId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_paymentName TEXT NOT NULL UNIQUE,
          $_paymentNote TEXT NOT NULL
        )
      ''');

      //  default data (not able to delete)
      db.insert(_paymentMethodTable, {
        _paymentId: "1",
        _paymentName: "Cash",
        _paymentNote: '',
      });
      db.insert(_paymentMethodTable, {
        _paymentId: "2",
        _paymentName: "Transfer",
        _paymentNote: '',
      });
    });
    return database;
  }

  // truncate table
  /// Deletes all rows from the [table] named table.
  ///
  /// This is used to clear the products table when the user logs out.
  ///
  /// The [table] parameter should be the name of the table to be deleted.
  ///
  /// The function returns a [Future] that resolves after the table has been cleared.
  ///
  /// If the table does not exist, the function returns without throwing an error.
  Future<void> truncateTable(String table) async {
    final db = await database;
    try {
      await db.delete(table);
      print("Success deleted $table table");
    } catch (e) {
      print("Error: $e");
    }
  }

  //* PRODUCT SECTION
  //? ALL PRODUCT METHODS ARE HERE
  //? //* //* //* //* //* //* //* //* // //

  void addProducts(
    String image,
    String name,
    String barcode,
    String barcodeType,
    int stock,
    String unit,
    int sold,
    int purchasePrice,
    int sellPrice,
    String category,
    String dateAdded,
  ) async {
    final db = await database;
    await db.insert(_productsTable, {
      _productsName: name,
      _productsImage: image,
      _productsBarcode: barcode,
      _productsBarcodeType: barcodeType,
      _productsStock: stock,
      _productsUnit: unit,
      _productsSold: sold,
      _productsPurchasePrice: purchasePrice,
      _productsSellPrice: sellPrice,
      _categoryName: category,
      _productsDateAdded: dateAdded,
    });
    print("Berhasil Menambahkan produk:");
  }

  Future<void> deleteProduct(int productId) async {
    final db = await database;
    try {
      await db.delete(_productsTable,
          where: '$_productsId = ?', whereArgs: [productId]);
      print("Berhasil menghapus product dengan id $productId");
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(_productsTable, product.toJson(),
        where: '$_productsId = ?', whereArgs: [product.productId]);
  }

  Future<int> getProductStockByName(String productName) async {
  final db = await database;
  var result = await db.query(
    'products',
    columns: ['product_stock'],
    where: 'product_name = ?',
    whereArgs: [productName],
  );
  if (result.isNotEmpty) {
    return result.first['product_stock'] as int;
  } else {
    throw Exception('Product not found');
  }
}

  Future<void> updateProductStock(int productId, int newStock) async {
    final db = await database;
    await db.update(
        _productsTable,
        {
          _productsStock: newStock,
        },
        where: '$_productsId = ?',
        whereArgs: [productId]);
  }

    Future<void> updateProductStockByProductName(String productName, int newStock) async {
    final db = await database;
    await db.update(
        _productsTable,
        {
          _productsStock: newStock,
        },
        where: '$_productsName = ?',
        whereArgs: [productName]);
  }

  Future<List<Product>> getProductsSorted(
      String column, String sortOrder, bool productOrCategory) async {
    final db = await database;
    String initColumn;
    if (productOrCategory) {
      initColumn = "p";
    } else {
      initColumn = "c";
    }
    final data = await db.rawQuery('''
      SELECT
        p.*,
        c.category_name
      FROM $_productsTable p
      JOIN $_categoryTable c ON p.category_name = c.category_name
      ORDER BY $initColumn.$column $sortOrder
      ''');

    List<Product> products = data
        .map((e) => Product(
              productId: e['product_id'] as int,
              productBarcode: e['product_barcode'] as String,
              productBarcodeType: e['product_barcode_type'] as String,
              productName: e['product_name'] as String,
              productStock: e['product_stock'] as int,
              productUnit: e['product_unit'] as String,
              productSold: e['product_sold'] as int,
              productPurchasePrice: e['product_purchase_price'] as int,
              productSellPrice: e['product_sell_price'] as int,
              productDateAdded: e['product_date_added'] as String,
              productImage: e['product_image'] as String,
              categoryName: e["category_name"] as String,
            ))
        .toList();

    return products;
  }

  Future<List<Product>> getProductsByCategory(String categoryName) async {
    final db = await database;
    final data = await db.rawQuery('''
      SELECT
        *
    
      FROM $_productsTable 
      WHERE $_categoryName LIKE '$categoryName'
      ''');

    List<Product> products = data
        .map((e) => Product(
              productId: e['product_id'] as int,
              productBarcode: e['product_barcode'] as String,
              productBarcodeType: e['product_barcode_type'] as String,
              productName: e['product_name'] as String,
              productStock: e['product_stock'] as int,
              productUnit: e['product_unit'] as String,
              productSold: e['product_sold'] as int,
              productPurchasePrice: e['product_purchase_price'] as int,
              productSellPrice: e['product_sell_price'] as int,
              productDateAdded: e['product_date_added'] as String,
              productImage: e['product_image'] as String,
              categoryName: e["category_name"] as String,
            ))
        .toList();
    return products;
  }

  Future<List<Product>> getProductsByBarcode(String productBarcode) async {
    final db = await database;
    final data = await db.rawQuery('''
      SELECT
        *
    
      FROM $_productsTable 
      WHERE $_productsBarcode LIKE '$productBarcode'
      ''');

    List<Product> products = data
        .map((e) => Product(
              productId: e['product_id'] as int,
              productBarcode: e['product_barcode'] as String,
              productBarcodeType: e['product_barcode_type'] as String,
              productName: e['product_name'] as String,
              productStock: e['product_stock'] as int,
              productUnit: e['product_unit'] as String,
              productSold: e['product_sold'] as int,
              productPurchasePrice: e['product_purchase_price'] as int,
              productSellPrice: e['product_sell_price'] as int,
              productDateAdded: e['product_date_added'] as String,
              productImage: e['product_image'] as String,
              categoryName: e["category_name"] as String,
            ))
        .toList();
    return products;
  }


  Future<Product> getProductById(int productId) async {
    final db = await database;
    final data = await db.query(_productsTable,
        where: '$_productsId = ?', whereArgs: [productId]);
    return Product.fromJson(data.first);
  }

  // ini untuk mengambil data produk tersusun berdasarkan kapan di tambahkannya (terawal)
  // biasanya desc karena kebalik gitu karna dia string
  Future<List<Product>> getProducts() async {
    final db = await database;
    final data = await db.rawQuery('''
    SELECT 
     *
    FROM $_productsTable 
    ORDER BY $_productsDateAdded DESC
  ''');

    List<Product> products = data
        .map((e) => Product(
              productId: e['product_id'] as int,
              productBarcode: e['product_barcode'] as String,
              productBarcodeType: e['product_barcode_type'] as String,
              productName: e["product_name"] as String,
              productStock: e["product_stock"] as int,
              productUnit: e['product_unit'] as String,
              productSold: e["product_sold"] as int,
              productPurchasePrice: e["product_purchase_price"] as int,
              productSellPrice: e["product_sell_price"] as int,
              productDateAdded: e["product_date_added"] as String,
              productImage: e["product_image"] as String,
              categoryName: e["category_name"] as String,
            ))
        .toList();

    return products;
  }

  //* CATEGORY SECTION
  //? ALL CATEGORY METHODS ARE HERE
  //? //* //* //* //* //* //* //* //* // //

  //method lapran metode pembahayaran
  Future<List<Map<String, dynamic>>> getpaymedmethodandcount() async {
    final db = await database;

    final result = await db.rawQuery("""
    SELECT 
      $_transactionMethod as paymentName,
      COALESCE(SUM($_transactionTotal), 0) AS total_amount
    from 
      $_transactionTable 
    group by
      $_transactionMethod
    """);
    // Mengubah hasil query menjadi List<Map<String, dynamic>>
    return result.map((row) {
      return {
        'payment_name': row['paymentName'] as String,
        'count': row['total_amount'] as int,
      };
    }).toList();
  }

  // method laporran product terjual
  Future<List<TransactionData>> getproductsell() async {
    final db = await database;
    final data = await db.query(_transactionTable);

    List<TransactionData> transactions = data
        .map((e) => TransactionData(
            transactionId: e['transaction_id'] as int,
            transactionDate: e['transaction_date'] as String,
            transactionTotal: e['transaction_total'] as int,
            transactionPayAmount: e['transaction_pay_amount'] as int,
            transactionPaymentMethod: e['transaction_method'] as String,
            transactionCashier: e['transaction_cashier'] as String,
            transactionCustomerName: e['transaction_customer_name'] as String,
            transactionDiscount: e['transaction_discount'] as int,
            transactionNote: e['transaction_note'] as String,
            transactionTax: e['transaction_tax'] as int,
            transactionStatus: e['transaction_status'] as String,
            transactionQuantity: e['transaction_quantity'] as int,
            transactionProduct: e['transaction_products'] is String
                ? jsonDecode(e['transaction_products'] as String)
                : (e['transaction_products'] is List
                    ? e['transaction_products']
                    : []),
            transactionQueueNumber: e['transaction_queue_number'] as int,
            transactionProfit: e['transaction_profit'] as int))
        .toList();

    return transactions;
  }

// method laporan pengeluaran

  Future<List<Expensemodel>> getExpenseList() async {
    final db = await database;
    final data = await db.query(_expenseTable);
    List<Expensemodel> expenses =
        data.map((e) => Expensemodel.fromJson(e)).toList();
    return expenses;
  }

  // method laporran Category
  Future<List<Map<String, dynamic>>> getCategoryNameAndCount() async {
    final db = await database;

    final result = await db.rawQuery("""
    SELECT 
      category_name as categoryName,
      count(category_name) as count
    from 
      $_productsTable 
    group by
      category_name
    """);

    // Mengubah hasil query menjadi List<Map<String, dynamic>>
    return result.map((row) {
      return {
        'categoryName': row['categoryName'] as String,
        'count': row['count'] as int,
      };
    }).toList();
  }

  Future<Map<String, int>> getTotalStock() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT SUM($_productsStock) as totalStock, sum($_productsPurchasePrice * $_productsStock) as totalsellprice FROM $_productsTable');
    final totalstock = result.first['totalStock'] as int;
    final totalnilai = result.first['totalsellprice'] as int;

    return {
      'totalStock': totalstock,
      'totalNilaiStock': totalnilai,
    };
  }

  Future<List<Product>> getallProductsandSUM() async {
    final db = await database;
    final result = await db.rawQuery(
        'select *, (select sum($_productsStock) from $_productsTable) as tstock from $_productsTable');

    List<Product> products = result
        .map((e) => Product(
              productId: e['product_id'] as int,
              productBarcode: e['product_barcode'] as String,
              productBarcodeType: e['product_barcode_type'] as String,
              productName: e["product_name"] as String,
              productStock: e["product_stock"] as int,
              productUnit: e['product_unit'] as String,
              productSold: e["product_sold"] as int,
              productPurchasePrice: e["product_purchase_price"] as int,
              productSellPrice: e["product_sell_price"] as int,
              productDateAdded: e["product_date_added"] as String,
              productImage: e["product_image"] as String,
              categoryName: e["category_name"] as String,
            ))
        .toList();

    return products;
  }

  Future<List<Categories>> getCategoriesSorted(
      String column, String sortOrder, bool productOrCategory) async {
    final db = await database;
    String initColumn;
    if (productOrCategory) {
      initColumn = "p";
    } else {
      initColumn = "c";
    }
    final data = await db.rawQuery('''
      SELECT
      *
      FROM $_categoryTable
      ''');

    List<Categories> categories = data
        .map((e) => Categories(
              categoryId: e['category_id'] as int,
              categoryName: e['category_name'] as String,
              dateAdded: e['category_date_added'] as String,
            ))
        .toList();

    return categories;
  }

  Future<void> addCategory(String name, String dateAdded) async {
    final db = await database;
    try {
      await db.insert(
          _categoryTable, {_categoryName: name, _categoryDateAdded: dateAdded});
      // debugPrint("Berhasil menambahkan kategori $name");
      print("Berhasil menambahkan kategori $name");
    } catch (e) {
      // show error message (debug only) in console
      print("Error: $e");
    }
  }

  Future<void> updateCategory(Categories category) async {
    final db = await database;
    await db.update(_categoryTable, category.toJson(),
        where: '$_categoryId = ?', whereArgs: [category.categoryId]);
  }

  Future<void> deleteCategory(String categoryName) async {
    final db = await database;
    try {
      await db.delete(_categoryTable,
          where: '$_categoryName = ?', whereArgs: [categoryName]);
      print("Berhasil menghapus kategori dengan nama $categoryName");
    } catch (e) {
      print("Error $e");
    }
  }

  Future<List<Categories>> getCategoryName(String categoryName) async {
    final db = await database;

    final data = await db.rawQuery('''
      SELECT
      *
      FROM $_categoryTable WHERE $_categoryName = $categoryName
      ''');

    List<Categories> categories = data
        .map((e) => Categories(
              categoryId: e['category_id'] as int,
              categoryName: e['category_name'] as String,
              dateAdded: e['category_date_added'] as String,
            ))
        .toList();

    return categories;
  }

  Future<List<Categories>> getCategory() async {
    final db = await database;

    final data = await db.rawQuery('''
    SELECT 
      $_categoryId AS category_id,
      $_categoryName AS category_name,
      $_categoryDateAdded AS category_date_added
    FROM $_categoryTable ORDER BY $_categoryDateAdded desc
  ''');

    List<Categories> categories = data
        .map((e) => Categories(
              categoryId: e['category_id'] as int,
              categoryName: e['category_name'] as String,
              dateAdded: e['category_date_added'] as String,
            ))
        .toList();

    return categories;
  }

  //* EXPENSE SECTION
  //? ALL EXPENSE METHODS ARE HERE
  //? //* //* //* //* //* //* //* //* // //

  Future<void> addExpense(String name, String dateAdded, String note,
      String date, int amount) async {
    final db = await database;
    await db.insert(
      _expenseTable,
      {
        'expense_name': name,
        'expense_date_added': dateAdded,
        'expense_note': note,
        'expense_date': date,
        'expense_amount': amount,
      },
    );
  }

  Future<void> addProductStock(Map<String, dynamic> stockAdditionData) async {
    final db = await database;
    await db.insert(
      _stockAdditionTable,
      {
        'stock_addition_name': stockAdditionData['stock_addition_name'],
        'stock_addition_date': stockAdditionData['stock_addition_date'],
        'stock_addition_amount': stockAdditionData['stock_addition_amount'],
        'stock_addition_note': stockAdditionData['stock_addition_note'],
        'stock_addition_product_id':
            stockAdditionData['stock_addition_product_id'],
      },
    );
  }

  Future<List<StockAdditionData>> getStockAddition() async {
    final db = await database;
    final data = await db.rawQuery('SELECT * FROM $_stockAdditionTable');

    if (data.isEmpty) {
      return []; // Kembalikan list kosong daripada null
    }

    return data
        .map((e) => StockAdditionData(
              stockAdditionId: e['stock_addition_id'] as int,
              stockAdditionName: e['stock_addition_name'] as String,
              stockAdditionDate: e['stock_addition_date'] as String,
              stockAdditionAmount: e['stock_addition_amount'] as int,
              stockAdditionNote: e['stock_addition_note'] as String,
              stockAdditionProductId: e['stock_addition_product_id'].toString(),
            ))
        .toList();
  }

  Future<List<Expense>> getExpense() async {
    final db = await database;
    final data = await db.rawQuery('SELECT * FROM $_expenseTable');

    List<Expense> expense = data
        .map((e) => Expense(
              expenseId: e['expense_id'] as int,
              expenseName: e['expense_name'] as String,
              expenseDateAdded: e['expense_date_added'] as String,
              expenseDate: e['expense_date'] as String,
              expenseAmount: e['expense_amount'] as int,
              expenseNote: e['expense_note'] as String,
            ))
        .toList();
    return expense;
  }

  Future<void> deleteExpense() async {}

  //* PAYMENT METHOD SECTION
  //? ALL PAYMENT METHOD METHODS ARE HERE
  //? //* //* //* //* //* //* //* //* // //

  Future<void> addPaymentMethod(String name, String note) async {
    final db = await database;
    await db.insert(
      _paymentMethodTable,
      {
        'payment_method_name': name,
        'payment_method_note': note,
      },
    );
  }

  // Function insert transaction data to table transaction
  Future<void> addTransaction(Map<String, dynamic> transactionData) async {
    final db = await database;
    await db.insert(_transactionTable, {
      'transaction_date': transactionData['transaction_date'],
      'transaction_cashier': transactionData['transaction_cashier'],
      'transaction_customer_name': transactionData['transaction_customer_name'],
      'transaction_total': transactionData['transaction_total'],
      'transaction_pay_amount': transactionData['transaction_pay_amount'],
      'transaction_discount': transactionData['transaction_discount'],
      'transaction_method': transactionData['transaction_method'],
      'transaction_note': transactionData['transaction_note'],
      'transaction_tax': transactionData['transaction_tax'],
      'transaction_status': transactionData['transaction_status'],
      'transaction_quantity': transactionData['transaction_quantity'],
      'transaction_products': transactionData['transaction_products'],
      'transaction_queue_number': transactionData['transaction_queue_number'],
      'transaction_profit': transactionData['transaction_profit'],
    });
  }

  Future<List<TransactionData>> getTransaction() async {
    return await _dbLock.synchronized(() async {
      final db = await database;
      final data = await db.query(_transactionTable);

      List<TransactionData> transactions = [];

      for (var e in data) {
        List<Map<String, dynamic>> productList = [];
        try {
          final productJsonString = e['transaction_products'] as String;
          productList =
              List<Map<String, dynamic>>.from(jsonDecode(productJsonString))
                  .map((product) {
            return product.map((key, value) {
              if (value is String && int.tryParse(value) != null) {
                return MapEntry(key, int.parse(value));
              }
              return MapEntry(key, value);
            });
          }).toList();
        } catch (error) {
          print('Error decoding products in getTransaction: $error');
        }

        transactions.add(TransactionData(
          transactionId: e['transaction_id'] as int,
          transactionDate: e['transaction_date'] as String,
          transactionTotal: e['transaction_total'] as int,
          transactionPayAmount: e['transaction_pay_amount'] as int,
          transactionPaymentMethod: e['transaction_method'] as String,
          transactionCashier: e['transaction_cashier'] as String,
          transactionCustomerName: e['transaction_customer_name'] as String,
          transactionDiscount: e['transaction_discount'] as int,
          transactionNote: e['transaction_note'] as String,
          transactionTax: e['transaction_tax'] as int,
          transactionStatus: e['transaction_status'] as String,
          transactionQuantity: e['transaction_quantity'] as int,
          transactionProduct: productList,
          transactionQueueNumber: e['transaction_queue_number'] as int,
          transactionProfit: e['transaction_profit'] as int,
        ));
      }

    return transactions;
  });
}

Future<void> deleteTransaction(int transactionId) async {
  final db = await database;
  try {
    await db.delete(
      _transactionTable,
      where: '$_transactionId = ?',
      whereArgs: [transactionId],
    );
    print("Successfully deleted transaction with id $transactionId");
  } catch (e) {
    print("Error: $e");
  }
}

Future<void> updateTransactionStatus(int transactionId, String newStatus) async {
  final db = await database;
  try {
    await db.update(
      _transactionTable,
      {_transactionStatus: newStatus},
      where: '$_transactionId = ?',
      whereArgs: [transactionId],
    );
    print("Successfully updated transaction status for id $transactionId");
  } catch (e) {
    print("Error updating transaction status: $e");
  }
}

Future<void> updateTransactionPayAmount(int transactionId, int newPayAmount) async {
  final db = await database;
  try {
    await db.update(
      _transactionTable,
      {_transactionPayAmount: newPayAmount},
      where: '$_transactionId = ?',
      whereArgs: [transactionId],
    );
    print("Successfully updated transaction pay amount for id $transactionId");
  } catch (e) {
    print("Error updating transaction pay amount: $e");
  }
}

Future<List<TransactionData>> getTransactionsByCashierAndStatus(
  String cashierName) async {
  return await _dbLock.synchronized(() async {
  final db = await database;
  final data = await db.query(
    _transactionTable,
    where: '$_transactionCashier = ?',
    whereArgs: [cashierName],
  );

  return data.map((e) {
    List<Map<String, dynamic>> productList = [];
    try {
    productList = List<Map<String, dynamic>>.from(
      jsonDecode(e['transaction_products'] as String),
    );
    } catch (error) {
    print('Error decoding products: $error');
    }

    return TransactionData(
    transactionId: e['transaction_id'] as int,
    transactionDate: e['transaction_date'] as String,
    transactionTotal: e['transaction_total'] as int,
    transactionPayAmount: e['transaction_pay_amount'] as int,
    transactionPaymentMethod: e['transaction_method'] as String,
    transactionCashier: e['transaction_cashier'] as String,
    transactionCustomerName: e['transaction_customer_name'] as String,
    transactionDiscount: e['transaction_discount'] as int,
    transactionNote: e['transaction_note'] as String,
    transactionTax: e['transaction_tax'] as int,
    transactionStatus: e['transaction_status'] as String,
    transactionQuantity: e['transaction_quantity'] as int,
    transactionProduct: productList,
    transactionQueueNumber: e['transaction_queue_number'] as int,
    transactionProfit: e['transaction_profit'] as int,
    );
  }).toList();
  });
}

Future<List<TransactionData>> getTransactionsByStatus(
  String statusTransaction) async {
  return await _dbLock.synchronized(() async {
    final db = await database;
    List<Map<String, dynamic>> data;

    if (statusTransaction == "Semua") {
      data = await db.query(_transactionTable);
    } else {
      data = await db.query(
        _transactionTable,
        where: '$_transactionStatus = ?',
        whereArgs: [statusTransaction],
      );
    }

    return data.map((e) {
      List<Map<String, dynamic>> productList = [];
      try {
        productList = List<Map<String, dynamic>>.from(
          jsonDecode(e['transaction_products'] as String),
        );
      } catch (error) {
        print('Error decoding products: $error');
      }

      return TransactionData(
        transactionId: e['transaction_id'] as int,
        transactionDate: e['transaction_date'] as String,
        transactionTotal: e['transaction_total'] as int,
        transactionPayAmount: e['transaction_pay_amount'] as int,
        transactionPaymentMethod: e['transaction_method'] as String,
        transactionCashier: e['transaction_cashier'] as String,
        transactionCustomerName: e['transaction_customer_name'] as String,
        transactionDiscount: e['transaction_discount'] as int,
        transactionNote: e['transaction_note'] as String,
        transactionTax: e['transaction_tax'] as int,
        transactionStatus: e['transaction_status'] as String,
        transactionQuantity: e['transaction_quantity'] as int,
        transactionProduct: productList,
        transactionQueueNumber: e['transaction_queue_number'] as int,
        transactionProfit: e['transaction_profit'] as int,
      );
    }).toList();
  });
}


Future<List<TransactionData>> getTransactionByDateRange(String fromDate, String toDate) async {
  return await _dbLock.synchronized(() async {
    final db = await database;
    final data = await db.query(
      _transactionTable,
      where: '$_transactionDate >= ? AND $_transactionDate <= ?',
      whereArgs: [fromDate, toDate],
    );

    List<TransactionData> transactions = [];

    for (var e in data) {
      List<Map<String, dynamic>> productList = [];
      try {
        final productJsonString = e['transaction_products'] as String;
        productList = List<Map<String, dynamic>>.from(jsonDecode(productJsonString)).map((product) {
          return product.map((key, value) {
            if (value is String && int.tryParse(value) != null) {
              return MapEntry(key, int.parse(value));
            }
            return MapEntry(key, value);
          });
        }).toList();
      } catch (error) {
        print('Error decoding products in getTransactionByDateRange: $error');
      }

      transactions.add(TransactionData(
        transactionId: e['transaction_id'] as int,
        transactionDate: e['transaction_date'] as String,
        transactionTotal: e['transaction_total'] as int,
        transactionPayAmount: e['transaction_pay_amount'] as int,
        transactionPaymentMethod: e['transaction_method'] as String,
        transactionCashier: e['transaction_cashier'] as String,
        transactionCustomerName: e['transaction_customer_name'] as String,
        transactionDiscount: e['transaction_discount'] as int,
        transactionNote: e['transaction_note'] as String,
        transactionTax: e['transaction_tax'] as int,
        transactionStatus: e['transaction_status'] as String,
        transactionQuantity: e['transaction_quantity'] as int,
        transactionProduct: productList,
        transactionQueueNumber: e['transaction_queue_number'] as int,
        transactionProfit: e['transaction_profit'] as int,
      ));
    }

    return transactions;
  });
}



  Future<Map<String, int>> getTodayTotalOmzet() async {
    return await _dbLock.synchronized(() async {
      final db = await database;
      final result = await db.rawQuery(
          'SELECT COALESCE(SUM($_transactionTotal), 0) as totalOmzet FROM $_transactionTable');
          
      final totalOmzet = result.first['totalOmzet'] as int? ?? 0;

      return {
        'totalOmzet': totalOmzet
      };
    });
  }

  //* SETTING SECTION
  //? ALL SETTING METHOD ARE HERE
  //? //* //* //* //* //* //* //* //* // //

  Future<SettingModel?> getAllSettings() async {
    final db = await database;
    final result = await db.query(_settingTable);
    if (result.isNotEmpty) {
      return SettingModel.fromJson(result.first);
    }
    return null;
  }

  Future<String?> getSettingProfit() async {
    final db = await database;
    final result = await db.query(
      _settingTable,
      columns: [_settingProfit],
    );
    if (result.isNotEmpty) {
      return result.first[_settingProfit] as String?;
    }
    return null;
  }

  Future<void> updateSettingProfit(String newProfit) async {
    final db = await database;
    await db.update(
      _settingTable,
      {_settingProfit: newProfit},
    );
  }

  Future<Map<String, String?>> getSettingProfile() async {
    final db = await database;
    final result = await db.query(_settingTable, columns: [
      _settingName,
      _settingAddress,
      _settingFooterMessage,
      _settingImage,
    ]);

    if (result.isNotEmpty) {
      return {
        'settingName': result.first[_settingName] as String?,
        'settingAddress': result.first[_settingAddress] as String?,
        'settingFooter': result.first[_settingFooterMessage] as String?,
        'settingImage': result.first[_settingImage] as String?,
      };
    }

    return {
      _settingName: null,
      _settingAddress: null,
      _settingFooterMessage: null,
      _settingImage: null,
    };
  }

  Future<void> updateSettingProfile(
      String name, String address, String footer, String image) async {
    final db = await database;
    try {
      await db.update(_settingTable, {
        _settingName: name,
        _settingAddress: address,
        _settingFooterMessage: footer,
        _settingImage: image,
      });
      print("Success, updated Settings");
    } catch (e) {
      print("Error brow: $e");
    }
  }

  Future<Map<String, String?>> getSettingReceipt() async {
    final db = await database;
    final result = await db.query(
      _settingTable,
      columns: [_settingReceipt, _settingReceiptSize, _settingImage],
    );
    if (result.isNotEmpty) {
      return {
        'settingReceipt': result.first[_settingReceipt] as String?,
        'settingReceiptSize': result.first[_settingReceiptSize] as String?,
        'settingImage': result.first[_settingImage] as String?,
      };
    }
    return {
      _settingReceipt: null,
      _settingReceiptSize: null,
    };
  }

  Future<void> updateSettingTemplate(String newTemplate, String newSize) async {
    final db = await database;
    await db.update(_settingTable,
        {_settingReceipt: newTemplate, _settingReceiptSize: newSize});
  }

  //* PAYMENT METHOD SECTION
  //? ALL PAYMENT M METHODS ARE HERE
  //? //* //* //* //* //* //* //* //* // //

  Future<List<PaymentMethod>> getPaymentMethods() async {
    final db = await database;

    /// This function executes a query on the database using `db.query()`.
    /// It retrieves all records from the specified table.
    ///
    /// Returns:
    ///   A list of maps, where each map represents a row in the table.
    final data = await db.query(_paymentMethodTable);
    List<PaymentMethod> paymentMethods = data
        .map((e) => PaymentMethod(
              paymentMethodId: e['payment_method_id'] as int,
              paymentMethodName: e['payment_method_name'] as String,
              paymentMethodNote: e['payment_method_note'] as String,
            ))
        .toList();
    return paymentMethods;
  }

  void insertPaymentMethod(String paymentName, String paymentNote) async {
    final db = await database;
    await db.insert(_paymentMethodTable, {
      _paymentName: paymentName,
      _paymentNote: paymentNote,
    });
  }

  Future<void> deletePaymentMethod(int paymentMethodId) async {
    final db = await database;
    try {
      await db.delete(_paymentMethodTable,
          where: '$_paymentId = ?', whereArgs: [paymentMethodId]);
      print("Successfully deleted payment method with id $paymentMethodId");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updatePaymentMethodName(
      int paymentMethodId, String newName) async {
    final db = await database;
    await db.update(
      _paymentMethodTable,
      {_paymentName: newName},
      where: '$_paymentId = ?',
      whereArgs: [paymentMethodId],
    );
  }

  // V1B3479063

  Future<void> addIncome(String incomeName, String iso8601string,
      String incomeNote, String iso8601string2, int parse) async {
    final db = await database;
    await db.insert(
      _incomeTable,
      {
        'income_name': incomeName,
        'income_date_added': iso8601string,
        'income_date': iso8601string2,
        'income_amount': parse,
        'income_note': incomeNote,
      },
    );
  }

  Future<List<Income>> getIncome() async {
    final db = await database;
    final data = await db.rawQuery('''
    SELECT
    *
    FROM $_incomeTable
    ''');

    List<Income> income = data
        .map((e) => Income(
              incomeId: e['income_id'] as int,
              incomeName: e['income_name'] as String,
              incomeDateAdded: e['income_date_added'] as String,
              incomeDate: e['income_date'] as String,
              incomeAmount: e['income_amount'] as int,
              incomeNote: e['income_note'] as String,
            ))
        .toList();
    return income;
  }

  //* CASHIER METHOD SECTION
  //? ALL CASHIER M METHODS ARE HERE
  //? //* //* //* //* //* //* //* //* // //

  //! HATI HATI DISINI SUKA ERROR CAST
  Future<void> insertCashier(Map<String, dynamic> cashierData) async {
    final db = await database;
    await db.insert(_cashierTable, {
      _cashierName: cashierData['cashier_name'],
      _cashierPhoneNumber: cashierData['cashier_phone_number'],
      _cashierImage: cashierData['cashier_image'],
      _cashierTotalTransaction: cashierData['cashier_total_transaction'],
      _cashierTotalTransactionMoney:
          cashierData['cashier_total_transaction_money'],
      _cashierPin: cashierData['cashier_pin'],
      _cashierSelesai: cashierData['cashier_selesai'],
      _cashierProses: cashierData['cashier_proses'],
      _cashierPending: cashierData['cashier_pending'],
      _cashierBatal: cashierData['cashier_batal'],
    });
  }

  Future<List<CashierData>> getCashiers() async {
    final db = await database;
    final data = await db.query(_cashierTable);
    List<CashierData> cashiers = data
        .map((e) => CashierData(
              cashierId: e['cashier_id'] as int,
              cashierName: e['cashier_name'] as String,
              cashierPhoneNumber: e['cashier_phone_number'] as int,
              cashierImage: e['cashier_image'] as String,
              cashierTotalTransaction: e['cashier_total_transaction'] as int,
              cashierTotalTransactionMoney:
                  e['cashier_total_transaction_money'] as int,
              cashierPin: e['cashier_pin'] as int,
              selesai: e['selesai'] as int,
              proses: e['proses'] as int,
              pending: e['pending'] as int,
              batal: e['batal'] as int,
            ))
        .toList();
    print("Successfully retrieved cashiers: $cashiers");
    return cashiers;
  }

  Future<void> deleteCashier(int cashierId) async {
    final db = await database;
    try {
      await db.delete(_cashierTable,
          where: '$_cashierId = ?', whereArgs: [cashierId]);
      print("Successfully deleted cashier with id $cashierId");
    } catch (e) {
      print(e);
      showFailedAlert(context as BuildContext,
          message: "Ada kesalahan, Silahkan Lapor Admin");
    }
  }

  Future<void> updateCashier(CashierData cashier) async {
    final db = await database;
    await db.update(
      _cashierTable,
      {
        _cashierName: cashier.cashierName,
        _cashierPhoneNumber: cashier.cashierPhoneNumber,
        _cashierImage: cashier.cashierImage,
        _cashierTotalTransaction: cashier.cashierTotalTransaction,
        _cashierTotalTransactionMoney: cashier.cashierTotalTransactionMoney,
        _cashierPin: cashier.cashierPin,
        _cashierSelesai: cashier.selesai,
        _cashierProses: cashier.proses,
        _cashierPending: cashier.pending,
        _cashierBatal: cashier.batal,
      },
      where: '$_cashierId = ?',
      whereArgs: [cashier.cashierId],
    );
    print("Successfully updated cashier with id ${cashier.cashierId}");
  }

  Future<Map<String, dynamic>?> getCurrentCashier() async {
    final db = await database;
    final data = await db.query(
      _currentCashierTable,
    );

    if (data.isNotEmpty) {}
  }
}
