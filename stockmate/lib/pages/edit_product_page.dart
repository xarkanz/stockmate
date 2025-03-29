import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockmate/database/database_helper.dart';
import 'package:stockmate/database/product.dart';
import 'package:stockmate/theme.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final List<String> _categories = [
    'Food and Baverages',
    'Medicine',
    'Health',
    'Stationary',
    'Electronics',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _barcodeController = TextEditingController(text: widget.product.barcode);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _selectedCategory = widget.product.category ?? 'Others';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    final updatedProduct = Product(
      id: widget.product.id,
      name: _nameController.text,
      barcode: _barcodeController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      imagePath: widget.product.imagePath,
      dateAdded: widget.product.dateAdded,
    );

    await _dbHelper.insertProduct(updatedProduct);
    Navigator.pop(context, updatedProduct);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
        backgroundColor: white_color,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
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
                        "Edit Product",
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
                child: SingleChildScrollView(
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

                      // Product Name Field
                      _buildTextField(
                        label: 'Product Name',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),

                      // Barcode Field
                      _buildTextField(
                        label: 'Barcode',
                        controller: _barcodeController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),

                      // Description Field
                      _buildTextField(
                        label: 'Description',
                        controller: _descriptionController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items:
                              _categories.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: _updateProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary_color,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            color: white_color,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return Column(
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
        TextField(
          style: TextStyle(
            color: dark_color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.5,
            height: 1.2,
          ),
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 1.5, color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 1.5, color: primary_color),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 1.5, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
