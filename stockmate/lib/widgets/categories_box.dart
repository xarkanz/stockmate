// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:stockmate/theme.dart';

class BoxCategories extends StatefulWidget {
  final String box_text1_categories;
  final String box_text2_categories;
  final String box_text3_categories;
  final Color box_border_categories;
  final String box_image_categories;

  final Widget categoriesTile;
  const BoxCategories({
    super.key,
    required this.box_text1_categories,
    required this.box_text2_categories,
    required this.box_text3_categories,
    required this.box_border_categories,
    required this.box_image_categories,
    required this.categoriesTile,
  });

  @override
  State<BoxCategories> createState() => _BoxCategoriesState();
}

class _BoxCategoriesState extends State<BoxCategories> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(width: 2, color: widget.box_border_categories),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: primary_color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.box_image_categories,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 20),

              Expanded(
                child: Container(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.box_text1_categories,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: dark_color,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            widget.box_text2_categories,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: dark_color,
                            ),
                          ),
                          Text(
                            widget.box_text3_categories,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: dark_color,
                            ),
                          ),
                        ],
                      ),
                      widget.categoriesTile
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
