import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockmate/database/database_helper.dart';
import 'package:stockmate/database/product.dart';
import 'package:stockmate/pages/each_product_page.dart';
import 'package:stockmate/theme.dart';
import 'package:stockmate/widgets/children_tile_cat.dart';

class PageFoodandbaverages extends StatefulWidget {
  const PageFoodandbaverages({super.key});

  @override
  State<PageFoodandbaverages> createState() => _PageFoodandbaveragesState();
}

class _PageFoodandbaveragesState extends State<PageFoodandbaverages> {
  Future<List<Product>>? _productsFuture;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _fetchFoodAndBeveragesProducts();
      setState(() {
        _productsFuture = Future.value(products);
      });
    } catch (e) {
      setState(() {
        _productsFuture = Future.error(e);
      });
    }
  }

  Future<List<Product>> _fetchFoodAndBeveragesProducts() async {
    final allProducts = await _dbHelper.getAllProducts();
    return allProducts
        .where((product) => product.category == 'Food and Baverages')
        .toList();
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'Food and Baverages':
        return food_and_baverages;
      case 'Medicine':
        return medicine;
      case 'Health':
        return health;
      case 'Stationary':
        return stationary;
      case 'Electronics':
        return electronics;
      case 'Others':
        return others;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
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
                      "Food and Beverages",
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
              child:
                  _productsFuture == null
                      ? const Center(child: CircularProgressIndicator())
                      : FutureBuilder<List<Product>>(
                        future: _productsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No products found'),
                            );
                          }
                          final products = snapshot.data!;
                          return RefreshIndicator(
                            onRefresh: _loadProducts,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.03,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ProductDetailPage(
                                                product: product,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                        0,
                                        0,
                                        0,
                                        10,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1.5,
                                          color: _getCategoryColor(
                                            product.category,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: SizedBox(
                                              width: 100,
                                              height: 100,
                                              child:
                                                  product.imagePath != null &&
                                                          product
                                                              .imagePath!
                                                              .isNotEmpty
                                                      ? Image.file(
                                                        File(
                                                          product.imagePath!,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )
                                                      : Container(
                                                        color: Colors.grey[300],
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          size: 40,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Container(
                                            height: 100,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: dark_color,
                                                        fontSize: 17,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      product.description ?? '',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: dark_color,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      _formatDate(
                                                        product.dateAdded,
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: dark_color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    if (product.category ==
                                                        "Food and Baverages")
                                                      TileFoodAndBeverages(),
                                                    if (product.category ==
                                                        "Medicine")
                                                      TileMedicine(),
                                                    if (product.category ==
                                                        "Health")
                                                      TileHealth(),
                                                    if (product.category ==
                                                        "Stationary")
                                                      TileStationary(),
                                                    if (product.category ==
                                                        "Electronics")
                                                      TileElectronics(),
                                                    if (product.category ==
                                                        "Others")
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
