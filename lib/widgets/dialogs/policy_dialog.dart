import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roi_test/constants.dart';

class PolicyDialog extends StatelessWidget {
  final double radius;
  final String mdFileName;
  PolicyDialog({Key? key, this.radius = 8, required this.mdFileName})
      : assert(
            mdFileName.contains('.md'), 'The file must contain .md extension'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 150)).then((value) {
              return rootBundle.loadString('assets/$mdFileName');
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Markdown(data: snapshot.data.toString());
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("CLOSE",
                style: GoogleFonts.poppins(
                    color: cyan, fontSize: 18, fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }
}
