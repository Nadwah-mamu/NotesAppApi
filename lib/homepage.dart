import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:noteappapi/AddNotepage.dart';
import 'package:noteappapi/EditingPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getdel(int id)async{
    final url="http://192.168.29.151:8080/removeNotes";
    var body={
      "id": id
    };
    var response=await post(Uri.parse(url),body: jsonEncode(body));
    print(response.body);

    if(response.statusCode==200){
      var message=jsonDecode(response.body);
      if(message["message"]=="deleted"){
        setState(() {

        });
      }

    }
  }
   Future <dynamic>gethttp()async{
    final url="http://192.168.29.151:8080/getNotes";
    var response=await get(Uri.parse(url));
    if(response.statusCode==200){
      print(response.body);
      var body=jsonDecode(response.body);

      if(body["message"][0].isNotEmpty){
        return body;
      }

    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // centerTitle: true,
        title:
        Text("Daily Notes",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.white
          ),),

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        // foregroundColor: Colors.black,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddNote();
          }));
        },
        child: Icon(Icons.add,color: Colors.black,),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: gethttp(),
          builder: (context,AsyncSnapshot snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.hasData){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Recently Added",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                        ),),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: ()async {


                        },
                        child: Container(
                          height: 30,
                          width: 60,
                          margin: EdgeInsets.only(right: 7),
                          color: Colors.black12,
                          child: Center(
                            child: Text(
                              "Clear",style: TextStyle(
                                color: Colors.black45
                            ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2
                        ),
                        itemCount:snapshot.data["message"].length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return EditPage(titleedit:snapshot.data["message"][index]["title"]
                                  ,descrptnedit:snapshot.data["message"][index]["content"] ,index: snapshot.data["message"][index]["id"]);
                              }));
                            },
                            child: Container(
                              margin: EdgeInsets.all(15),
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.orange.shade300
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                          onTap: (){
                                            getdel(snapshot.data["message"][index]["id"]);

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.delete,
                                              color: Colors.black54,),
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(snapshot.data["message"][index]["title"],style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18
                                        ),),
                                      ],
                                    ),
                                  ),
                                  Text(snapshot.data["message"][index]["content"])
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ],
              );
            }
            else
              {
                return Center(
                  child: Text(" There is no notes"),
                );
              }

          }
        ),
      ),

    );

  }
}
