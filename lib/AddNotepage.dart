import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:noteappapi/homepage.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController a = TextEditingController();
  TextEditingController b = TextEditingController();
  getfn()async{
    final url="http://192.168.29.151:8080/addNotes";
    var body={
      "title":a.text,
      "content":b.text,
    };
    var response=await post(Uri.parse(url),body: jsonEncode(body));
    print(response.body);

    if(response.statusCode==200){
      var message=jsonDecode(response.body);
      if(message["message"]=="inserted"){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }), (route) => false);
      }
    }
  }

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
                if (a.text.isNotEmpty && b.text.isNotEmpty) {
                  getfn();



                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Your Note has been saved successfully")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Note is unwritten")));
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }), (route) => false);
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
        child: SafeArea(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 44,
              margin: EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              child: TextFormField(
                validator: (v) {},
                cursorColor: Colors.black,
                cursorHeight: 28,
                // cursorRadius: Radius.circular(10),
                controller: a,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.only(left: 8, top: 8),
                    hintText: " Title ",
                    hintStyle: TextStyle(
                        color: Colors.black45,
                        // fontWeight: FontWeight.w,
                        fontSize: 20)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (v) {},
              cursorColor: Colors.black,
              cursorHeight: 28,
              controller: b,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 8, top: 8),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: "Note Write...",
                  hintStyle: TextStyle(
                      color: Colors.black45,
                      // fontWeight: FontWeight.w,
                      fontSize: 20)),
              maxLines: 50,
            ),
          ),
        ])),
      ),
    );
  }
}
