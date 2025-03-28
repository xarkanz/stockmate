import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stockmate/database/database_helper.dart';
import 'package:stockmate/database/product.dart';
import 'package:stockmate/database/product_list.dart';
import 'package:stockmate/pages/page_electronics.dart';
import 'package:stockmate/pages/page_foodandbaverages.dart';
import 'package:stockmate/pages/page_health.dart';
import 'package:stockmate/pages/page_medicine.dart';
import 'package:stockmate/pages/page_others.dart';
import 'package:stockmate/pages/page_stationary.dart';
import 'package:stockmate/pages/scan_result.dart';
import 'package:stockmate/theme.dart';
import 'package:stockmate/widgets/categories_box.dart';
import 'package:stockmate/widgets/categories_tile.dart';
import 'package:stockmate/widgets/children_tile_cat.dart';
import 'package:stockmate/widgets/dashboard_tile_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
                            "800",
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
                          Maintext: "Food and Baverages",
                          Secondarytext: "90",
                          tilecolor: food_and_baverages,
                          destinationPage: PageFoodandbaverages(),
                        ),
                        ButtonDashboardTile(
                          Maintext: "Medicine",
                          Secondarytext: "90",
                          tilecolor: medicine,
                          destinationPage: PageMedicine(),
                        ),
                        ButtonDashboardTile(
                          Maintext: "Health",
                          Secondarytext: "90",
                          tilecolor: health,
                          destinationPage: PageHealth(),
                        ),
                        ButtonDashboardTile(
                          Maintext: "Stationary",
                          Secondarytext: "90",
                          tilecolor: stationary,
                          destinationPage: PageStationary(),
                        ),
                        ButtonDashboardTile(
                          Maintext: "Electronics",
                          Secondarytext: "90",
                          tilecolor: electronics,
                          destinationPage: PageElectronics(),
                        ),
                        ButtonDashboardTile(
                          Maintext: "Others",
                          Secondarytext: "90",
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
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: white_color),
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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

                      BoxCategories(
                        box_image_categories: "assets/images/cookies.jpeg",
                        box_text1_categories: "Goodtime",
                        box_text2_categories: "Snack and Cookies",
                        box_text3_categories: "12/03/2024",
                        box_border_categories: food_and_baverages,
                        categoriesTile: TileFoodAndBeverages(),
                      ),

                      BoxCategories(
                        box_image_categories: "assets/images/medicine.jpeg",
                        box_text1_categories: "Paracetamol",
                        box_text2_categories: "Medicine",
                        box_text3_categories: "13/03/2024",
                        box_border_categories: medicine,
                        categoriesTile: TileMedicine(),
                      ),

                      BoxCategories(
                        box_image_categories: "assets/images/cookies.jpeg",
                        box_text1_categories: "Goodtime",
                        box_text2_categories: "Snack and Cookies",
                        box_text3_categories: "12/03/2024",
                        box_border_categories: food_and_baverages,
                        categoriesTile: TileFoodAndBeverages(),
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
                                print("object");
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
                          builder:
                              (context) => AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.5,
                                      width: MediaQuery.of(context).size.width,
                                      child: MobileScanner(
                                        controller: scanner,
                                        onDetect: (capture) async {
                                          final List<Barcode> barcodes =
                                              capture.barcodes;
                                          if (barcodes.isNotEmpty) {
                                            String scannedCode =
                                                barcodes.first.rawValue ??
                                                "Unknown";
                                            scanner.dispose();
                                            Navigator.pop(context);

                                            Product? existingProduct =
                                                await DatabaseHelper.instance
                                                    .getProductByBarcode(
                                                      scannedCode,
                                                    );

                                            if (existingProduct != null) {
                                              Future.delayed(Duration.zero, () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                        title: Text(
                                                          "Product Already Exist",
                                                        ),
                                                        content: Text(
                                                          "Products with this barcode have been added previously.",
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                            child: Text("OK"),
                                                          ),
                                                        ],
                                                      ),
                                                );
                                              });
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          ScannerResult(
                                                            scannedCode:
                                                                scannedCode,
                                                          ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
