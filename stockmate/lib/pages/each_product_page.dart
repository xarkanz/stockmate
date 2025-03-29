import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockmate/database/database_helper.dart';
import 'package:stockmate/database/product.dart';
import 'package:stockmate/pages/edit_product_page.dart';
import 'package:stockmate/theme.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete this product?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'DELETE',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      try {
        await DatabaseHelper.instance.deleteProduct(widget.product.id!);
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete: ${e.toString()}')),
          );
        }
      }
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
                      "Detail Product",
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
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child:
                          widget.product.imagePath != null &&
                                  widget.product.imagePath!.isNotEmpty
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(widget.product.imagePath!),
                                  fit: BoxFit.cover,
                                ),
                              )
                              : Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Product Name
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: dark_color,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category Chip
                  Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.transparent),
                    ),
                    backgroundColor: _getCategoryColor(widget.product.category),
                    label: Text(
                      widget.product.category ?? 'Unknown',
                      style: TextStyle(
                        color: white_color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Details Section
                  _buildDetailRow(
                    Icons.qr_code,
                    'Barcode',
                    widget.product.barcode,
                  ),
                  _buildDetailRow(
                    Icons.description_rounded,
                    'Description',
                    widget.product.description ?? 'No description available',
                  ),
                  _buildDetailRow(
                    Icons.category_rounded,
                    'Category',
                    widget.product.category ?? 'Unknown',
                  ),
                  _buildDetailRow(
                    Icons.calendar_today_rounded,
                    'Date Added',
                    _formatDate(widget.product.dateAdded),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          onPressed: () => _confirmDelete(context),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: white_color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final updatedProduct = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditProductPage(
                                        product: widget.product,
                                      ),
                                ),
                              );

                              if (updatedProduct != null && mounted) {
                                // Refresh the page if product was updated
                                Navigator.pop(context, updatedProduct);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 79, 174, 94),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.transparent),
                              ),
                            ),
                            child: Text(
                              'Edit Product',
                              style: TextStyle(
                                color: white_color,
                                fontWeight: FontWeight.w700,
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
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: primary_color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: dark_color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}
