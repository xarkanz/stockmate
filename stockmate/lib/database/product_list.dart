import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockmate/pages/each_product_page.dart';
import 'package:stockmate/theme.dart';
import 'package:stockmate/widgets/children_tile_cat.dart';
import 'database_helper.dart';
import 'product.dart';

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

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> _productList;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _productList = DatabaseHelper.instance.getAllProducts();
    });
  }

  void _confirmDeleteProduct(int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text("Delete Product"),
            content: Text("Are you sure you want to delete this product?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  _deleteProduct(id);
                  Navigator.pop(context);
                },
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _deleteProduct(int id) async {
    await DatabaseHelper.instance.deleteProduct(id);
    _loadProducts();
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
              decoration: BoxDecoration(color: primary_color),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.03,
                        vertical: MediaQuery.of(context).size.height * 0.03,
                      ),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 25,
                        color: white_color,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      "Product List",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: white_color,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No Product Added."));
                  }

                  final products = snapshot.data!;

                  return RefreshIndicator(
                    onRefresh: _loadProducts,
                    child: ListView.builder(
                      itemCount: products.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: 2,
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
                                              product.imagePath!.isNotEmpty
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
                              SizedBox(width: 20),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
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
                                              SizedBox(height: 2),
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
                                          SizedBox(height: 2),
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
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed:
                                              () => _confirmDeleteProduct(
                                                product.id!,
                                              ),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(30, 30),
                                          ),
                                          icon: Icon(
                                            Icons.delete,
                                            color: white_color,
                                            size: 15,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ProductDetailPage(
                                                          product: product,
                                                        ),
                                              ),
                                            );
                                          },
                                          style: IconButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                              255,
                                              79,
                                              174,
                                              94,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(30, 30),
                                          ),
                                          icon: Icon(
                                            Icons.edit,
                                            size: 15,
                                            color: white_color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
