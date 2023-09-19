import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:noteappapi/homepage.dart';

class EditPage extends StatefulWidget {
  String titleedit;
  String descrptnedit;
  int index;
  EditPage(
      {required this.titleedit,
      required this.descrptnedit,
      required this.index});
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  getpost() async {
    final url = "http://192.168.29.151:8080/updateNotes";
    var body = {
      "title": a.text,
      "content": b.text,
      "id": widget.index.toString()
    };
    var response = await post(Uri.parse(url), body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      var message = jsonDecode(response.body);
      if (message["message"] == "note updated") {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }), (route) => false);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    a.text = widget.titleedit;
    b.text = widget.descrptnedit;
  }

  TextEditingController a = TextEditingController();
  TextEditingController b = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent.shade200,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "/ Note /",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        actions: [
          GestureDetector(
              onTap: () async {
                if(a.text.isNotEmpty && b.text.isNotEmpty){
                  getpost();

                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.save,
                  color: Colors.black,
                  size: 30,
                ),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 44,
              margin: EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              child: TextField(
                cursorColor: Colors.black,
                cursorHeight: 28,
                // cursorRadius: Radius.circular(10),
                controller: a,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.only(left: 8, top: 8),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Colors.black,
              cursorHeight: 28,
              controller: b,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 8, top: 8),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              maxLines: 50,
            ),
          ),
        ]),
      ),
    );
  }
}
