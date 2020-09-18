import 'dart:async';
import 'dart:convert';

import 'package:demoapp/CountrySearch.dart';
import 'package:demoapp/country_model.dart';
import 'package:demoapp/service_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List moreOptionIcons = [
    Icons.location_on,
    Icons.supervised_user_circle,
    Icons.chat
  ];
  List moreOptionsName = ['Locate Branch', 'Promotions', 'Chat with us'];
  String _selectedCountry;
  final _amountControllerFrom = TextEditingController();
  final _amountControllerTo = TextEditingController();
  FocusNode amountFocusFrom;
  FocusNode amountFocusTo;

  bool isConnected = false;
  TextEditingController controller = new TextEditingController();
  CountryModel countryModel=CountryModel();
 // String _countryTo = "";
 // String _countryFrom = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amountFocusTo = FocusNode();
    amountFocusFrom = FocusNode();
    countryFrom="";
    countryTo="";
    Timer.run(() {
      getSWData();
    });
  }

  void dispose() {
    _amountControllerFrom.dispose();
    _amountControllerTo.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      /*     appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text(widget.title),
        backgroundColor: Colors.indigo[50],
      ),*/
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.vertical,
                left: 16,
                right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Hello",
                  textAlign: TextAlign.start,
                ),
                Icon(Icons.account_circle)
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16),
            child: Text(
              "Guest",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),
          currencyCardFrom(),
           currencyCardTo(),
          txtHint(),
          SizedBox(
            height: 32,
          ),
          sendMoneyButton(),
          SizedBox(
            height: 32,
          ),
          Container(
            height: MediaQuery.of(context).size.width / 3,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: moreOptionIcons.length,
                itemBuilder: (BuildContext context, int index) {
                  return moreOptionsCard(index);
                }),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget txtHint() {
    return Center(
        child: Text(
      "Exchange rates are indicative",
      style: TextStyle(color: Colors.indigo),
    ));
  }

  Widget sendMoneyButton() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () {},
        child: Text(
          "Send Money",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.indigo,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.indigo)),
      ),
    );
  }

  Widget currencyCardFrom() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Expanded(
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      countryFrom.isEmpty || countryFrom == null?  TextField(
                        enabled: false,
                        readOnly: true,
                        keyboardType: TextInputType.text,
                        style: Theme.of(context).textTheme.body1,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          labelStyle: TextStyle(fontSize: 19),
                          contentPadding: const EdgeInsets.fromLTRB(6, 6, 48, 6), // 48 -> icon width
                        ),
                      ): TextField(
                        enabled: false,
                        readOnly: true,
                        keyboardType: TextInputType.text,
                        style: Theme.of(context).textTheme.body1,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 19),
                          labelText: countryFrom,
                          contentPadding: const EdgeInsets.fromLTRB(6, 6, 48, 6), // 48 -> icon width
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          showLogoutDialog(context,"from");
                          //_navigateAndDisplaySelectionFrom(context);
                        },
                      ),
                    ],
                  ),                  Row(
                    children: <Widget>[
                      Text(
                        "US".toUpperCase(),
                        style: TextStyle(fontSize: 23),
                      ),
                      _showAmountFrom()
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget currencyCardTo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.centerRight,
                  children: <Widget>[
                    countryTo.isEmpty || countryTo == null?  TextField(
                      enabled: false,
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.body1,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        labelStyle: TextStyle(fontSize: 19),
                        contentPadding: const EdgeInsets.fromLTRB(6, 6, 48, 6), // 48 -> icon width
                      ),
                    ): TextField(
                      enabled: false,
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.body1,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: countryTo,
                        labelStyle: TextStyle(fontSize: 19),
                        contentPadding: const EdgeInsets.fromLTRB(6, 6, 48, 6), // 48 -> icon width
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        showLogoutDialog(context,"to");
                      },
                    ),
                  ],
                ),
                 //_showCountryTo(),
                Row(
                  children: <Widget>[
                    Text(
                      "INR".toUpperCase(),
                      style: TextStyle(fontSize: 23),
                    ),
                    _showAmountTo()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget moreOptionsCard(index) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      width: MediaQuery.of(context).size.width / 3.5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 3,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(
                  moreOptionIcons[index],
                  color: Colors.indigo,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  moreOptionsName[index],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  String _mySelectionFrom;
  String _mySelectionTo;

  Widget _showCountryFrom() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
        child: DropdownButtonHideUnderline(
          child: Expanded(
            child: new DropdownButton(
              items: data.map((item) {
                return new DropdownMenuItem(
                  child: new Text(item['emoji']+"  "+item['name']),
                  value: item['name'].toString(),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _mySelectionFrom = newVal;
                });
              },
              value: _mySelectionFrom,
            ),
          ),
        ),
      ),
    );
  }


  Widget _showAmountFrom() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
      width: MediaQuery.of(context).size.width / 2,
      child: new TextFormField(
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,
        controller: _amountControllerFrom,
        maxLines: 1,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
            labelText: "Amount",
            labelStyle: TextStyle(fontWeight: FontWeight.w600)),
        focusNode: amountFocusFrom,
        style: TextStyle(fontSize: 23),
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(amountFocusFrom);
        },
        onSaved: (value) => _amountControllerFrom.text = value,
      ),
    );
  }

  Widget _showAmountTo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
      width: MediaQuery.of(context).size.width / 2,
      child: new TextFormField(
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,
        controller: _amountControllerTo,
        maxLines: 1,
        style: TextStyle(fontSize: 23),
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
            labelText: "Amount",
            labelStyle: TextStyle(fontWeight: FontWeight.w600)),
        focusNode: amountFocusTo,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(amountFocusTo);
        },
        onSaved: (value) => _amountControllerTo.text = value,
      ),
    );
  }
  showLogoutDialog(context,flag) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content:Container(width:MediaQuery.of(context).size.width,child: Search(flag))
        );
      },
    );
  }

}
