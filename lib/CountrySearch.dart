import 'dart:async';
import 'dart:convert';

import 'package:demoapp/service_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  String flag;
  Search(this.flag);
  @override
  _SearchState createState() => new _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController editingController = TextEditingController();

  // List<String> items = getCountryList();
  final String url = "https://unpkg.com/country-flag-emoji-json@1.0.2/json/flag-emojis.pretty.json";

  List data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http
      .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      getSWData();
    });
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        List dummySearchList = List();
        dummySearchList.addAll(data);
        // print(dummySearchList);
        List dummyListData = List();
        dummySearchList.forEach((item) {
          var itemStr = item.toLowerCase();
          if (itemStr.contains(query)) {
            dummyListData.add(item);
          }
        });
        setState(() {
          data.clear();
          data.addAll(dummyListData);
        });
        return;
      }
    } else {
      setState(() {
        data.clear();
        data.addAll(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        width: MediaQuery
          .of(context)
          .size
          .width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context,
                        '${data[index]['emoji'] + "  " + data[index]['name']}');
                      setState(() {
                        if(widget.flag=='from'){
                          countryFrom ='${data[index]['emoji'] + "  " + data[index]['name']}';
                        }else{
                          countryTo ='${data[index]['emoji'] + "  " + data[index]['name']}';
                        }
                      });
                    },
                    title: new Text(
                      data[index]['emoji'] + "  " + data[index]['name']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
