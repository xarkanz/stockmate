import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stockmate/database/database_helper.dart';
import 'package:stockmate/database/product.dart';
import 'package:stockmate/database/product_list.dart';
import 'package:stockmate/pages/each_product_page.dart';
import 'package:stockmate/pages/page_electronics.dart';
import 'package:stockmate/pages/page_foodandbaverages.dart';
import 'package:stockmate/pages/page_health.dart';
import 'package:stockmate/pages/page_medicine.dart';
import 'package:stockmate/pages/page_others.dart';
import 'package:stockmate/pages/page_stationary.dart';
import 'package:stockmate/pages/scan_result.dart';
import 'package:stockmate/theme.dart';
import 'package:stockmate/widgets/children_tile_cat.dart';
import 'package:stockmate/widgets/dashboard_tile_button.dart';

Color _getCategoryColor(String? category) {
  switch (category) {
    case "Food and Baverages":
      return food_and_baverages;
    case "Medicine":
      return medicine;
    case "Health":
      return health;
    case "Stationary":
      return stationary;
    case "Electronics":
      return electronics;
    case "Others":
      return others;
    default:
      return Colors.grey;
  }
}

String _formatDate(String dateAdded) {
  try {
    DateTime dateTime = DateTime.parse(dateAdded);
    return DateFormat("dd/MM/yyyy HH:mm").format(dateTime);
  } catch (e) {
    return dateAdded;
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalStock = 0;
  int foodBeveragesStock = 0;
  int medicineStock = 0;
  int healthStock = 0;
  int stationaryStock = 0;
  int electronicsStock = 0;
  int othersStock = 0;

  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadTotalStock();
    _loadProducts();
  }

  void _loadProducts() async {
    List<Product> productList = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      products = productList;
    });
  }

  void _loadTotalStock() async {
    int total = await DatabaseHelper.instance.getTotalStock();
    int totalFood = await DatabaseHelper.instance.getTotalStockByCategory(
      "Food and Baverages",
    );
    int totalMedicine = await DatabaseHelper.instance.getTotalStockByCategory(
      "Medicine",
    );
    int totalHealth = await DatabaseHelper.instance.getTotalStockByCategory(
      "Health",
    );
    int totalStationary = await DatabaseHelper.instance.getTotalStockByCategory(
      "Stationary",
    );
    int totalElectronics = await DatabaseHelper.instance
        .getTotalStockByCategory("Electronics");
    int totalOthers = await DatabaseHelper.instance.getTotalStockByCategory(
      "Others",
    );

    setState(() {
      totalStock = total;
      foodBeveragesStock = totalFood;
      medicineStock = totalMedicine;
      healthStock = totalHealth;
      stationaryStock = totalStationary;
      electronicsStock = totalElectronics;
      othersStock = totalOthers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
        backgroundColor: white_color,
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              decoration: BoxDecoration(color: primary_color),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/logo.png', height: 20),
                    SizedBox(height: 20),
                    Text(
                      "Welcome to",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: white_color,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "StockMate!",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: white_color,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: white_color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Stock",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: dark_color,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            "$totalStock",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: dark_color,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    Wrap(
                      spacing: MediaQuery.of(context).size.width * 0.02,
                      runSpacing: MediaQuery.of(context).size.width * 0.02,
                      children: [
                        ButtonDashboardTile(
                          Maintext: "Food and Beverages",
                          Secondarytext: "$foodBeveragesStock",
                          tilecolor: food_and_baverages,
                          destinationPage: PageFoodandbaverages(),
                        ),
                        ButtonDashboardTile(
                          Maintext: "Medicine",
                          Secondarytext: "$medicineStock",
                          tilecolor: medicine,
                          destinationPage: PageMedicine(),
                        ),
                        ButtonDashboardTile(
                          Maintext: "Health",
                          Secondarytext: "$healthStock",
                          tilecolor: health,
                          destinationPage: PageHealth(),
                        ),
                        ButtonDashboardTile(
                          Maintext: "Stationary",
                          Secondarytext: "$stationaryStock",
                          tilecolor: stationary,
                          destinationPage: PageStationary(),
                        ),
                        ButtonDashboardTile(
                          Maintext: "Electronics",
                          Secondarytext: "$electronicsStock",
                          tilecolor: electronics,
                          destinationPage: PageElectronics(),
                        ),
                        ButtonDashboardTile(
                          Maintext: "Others",
                          Secondarytext: "$othersStock",
                          tilecolor: others,
                          destinationPage: PageOthers(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _loadTotalStock();
                  _loadProducts();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: white_color),
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Last Stock",
                        style: TextStyle(
                          color: primary_color,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            ProductDetailPage(product: product),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.5,
                                    color: _getCategoryColor(product.category),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child:
                                            product.imagePath != null &&
                                                    product
                                                        .imagePath!
                                                        .isNotEmpty
                                                ? Image.file(
                                                  File(product.imagePath!),
                                                  fit: BoxFit.cover,
                                                )
                                                : Container(
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    size: 40,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Container(
                                      height: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: dark_color,
                                                  fontSize: 17,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "${product.description}",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: dark_color,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                _formatDate(product.dateAdded),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: dark_color,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              if (product.category ==
                                                  "Food and Baverages")
                                                TileFoodAndBeverages(),
                                              if (product.category ==
                                                  "Medicine")
                                                TileMedicine(),
                                              if (product.category == "Health")
                                                TileHealth(),
                                              if (product.category ==
                                                  "Stationary")
                                                TileStationary(),
                                              if (product.category ==
                                                  "Electronics")
                                                TileElectronics(),
                                              if (product.category == "Others")
                                                TileOthers(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  color: primary_color,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListPage(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.dashboard_rounded,
                                color: white_color,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      title: Text(
                                        "Created by XARKAN",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.settings_rounded,
                                color: white_color,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -25,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primary_color,
                      shape: BoxShape.circle,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        final scanner = MobileScannerController();

                        showDialog(
                          context: context,
                          builder: (context) {
                            bool _isFlashOn = false;

                            return StatefulBuilder(
                              builder: (context, setStateDialog) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Stack(
                                          children: [
                                            MobileScanner(
                                              controller: scanner,
                                              onDetect: (capture) async {
                                                final List<Barcode> barcodes =
                                                    capture.barcodes;
                                                if (barcodes.isNotEmpty) {
                                                  String scannedCode =
                                                      barcodes.first.rawValue ??
                                                      "Unknown";
                                                  scanner.dispose();
                                                  Navigator.pop(
                                                    context,
                                                  );

                                                  Product? existingProduct =
                                                      await DatabaseHelper
                                                          .instance
                                                          .getProductByBarcode(
                                                            scannedCode,
                                                          );

                                                  if (existingProduct != null) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (
                                                              context,
                                                            ) => ProductDetailPage(
                                                              product:
                                                                  existingProduct,
                                                            ),
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (
                                                              context,
                                                            ) => ScannerResult(
                                                              scannedCode:
                                                                  scannedCode,
                                                            ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: IconButton(
                                                onPressed: () {
                                                  setStateDialog(() {
                                                    _isFlashOn = !_isFlashOn;
                                                  });
                                                  scanner.toggleTorch();
                                                },
                                                icon: Icon(
                                                  _isFlashOn
                                                      ? Icons.flash_on_rounded
                                                      : Icons.flash_off_rounded,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: white_color),
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/scanner.png",
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
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
