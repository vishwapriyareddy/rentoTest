import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Serachbarwidget extends StatelessWidget {
  const Serachbarwidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xFF1B1F2E).withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(30)),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            Expanded(
              child: Text(
                "Search for home service...",
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: GoogleFonts.montserrat(color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child:
                  Icon(Icons.search, color: Color.fromARGB(255, 53, 69, 133)),
            ),
          ],
        ),
      ),
    );
  }
}
