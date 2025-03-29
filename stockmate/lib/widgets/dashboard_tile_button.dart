import 'package:flutter/material.dart';
import 'package:stockmate/theme.dart';

class ButtonDashboardTile extends StatefulWidget {
  final String Maintext;
  final String Secondarytext;
  final Color tilecolor;
  final Widget destinationPage;
  const ButtonDashboardTile({
    super.key,
    required this.Maintext,
    required this.Secondarytext,
    required this.tilecolor,
    required this.destinationPage
  });

  @override
  State<ButtonDashboardTile> createState() => _ButtonDashboardTileState();
}

class _ButtonDashboardTileState extends State<ButtonDashboardTile> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.destinationPage),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        minimumSize: Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Container(
        width: (MediaQuery.of(context).size.width - 60) / 3,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.tilecolor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.Maintext,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: white_color,
                fontSize: 9,
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.Secondarytext,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: white_color,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
