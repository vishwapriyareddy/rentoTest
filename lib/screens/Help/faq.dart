//import 'dart:html'
import 'package:flutter/material.dart';
import 'package:roi_test/colors.dart';

class Faq extends StatefulWidget {
  static const String id = 'FAQ';

  const Faq({Key? key}) : super(key: key);

  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  // List<ExpansionItem> items = <ExpansionItem>[
  //   ExpansionItem(headerValue: "Header", body: "This is first description"),
  //   ExpansionItem(headerValue: "Header2", body: "This is 2 description"),
  //   ExpansionItem(headerValue: "Header3", body: "This is 3 description"),
  //   ExpansionItem(headerValue: "Header4", body: "This is 4 description"),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("FAQs",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        children: [
          ExpansionTile(
            title: Text("Panel 0"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 1"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 2"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 3"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("o"),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 4"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("o"),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 5"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("o"),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 6"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("o"),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 7"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("o"),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 8"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("o"),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 9"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("o"),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 10"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("o"),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 11"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("o"),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 12"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("o"),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 13"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("o"),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Panel 14"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
              )
            ],
          ),
          SizedBox(
            height: 30,
          )
        ],
      )),
    );
  }
}

// class ExpansionItem {
//   String body;
//   String headerValue;
//   bool isExpanded;
//   ExpansionItem(
//       {required this.body, required this.headerValue, this.isExpanded = false});
// }
