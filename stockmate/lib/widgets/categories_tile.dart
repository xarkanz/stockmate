import 'package:flutter/material.dart';
import 'package:stockmate/theme.dart';

class CategoriesTile extends StatefulWidget {
  final Color color_cat;
  final String text_cat;
  const CategoriesTile({
    super.key,
    required this.color_cat,
    required this.text_cat,
  });

  @override
  State<CategoriesTile> createState() => _CategoriesTileState();
}

class _CategoriesTileState extends State<CategoriesTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: widget.color_cat,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            widget.text_cat,
            style: TextStyle(
              fontSize: 10,
              color: white_color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}