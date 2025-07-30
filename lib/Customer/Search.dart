import 'package:flutter/material.dart';
import 'ucalender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(
      home: SearchList(),
    ));

class SearchList extends StatefulWidget {
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget appBarTitle = Text(
    "Search Businesses",
    style: TextStyle(color: Colors.white),
  );
  Icon icon = Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _list;
  bool _isSearching;
  String searchText = "";
  List searchresult = List();
  List _location = [];
  List _users = [];
  List _imgurl = [];
  _SearchListState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          searchText = _controller.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getbusilist().then((value) {
      setState(() {
        _list = value;
      });
    });
    getloclist().then((value) {
      setState(() {
        _location = value;
      });
    });
    getuserlist().then((value) {
      setState(() {
        _users = value;
      });
    });
    getimglist().then((value) {
      setState(() {
        _imgurl = value;
      });
    });
    _isSearching = false;
    setState(() {
      this.appBarTitle = TextField(
        autofocus: true,
        controller: _controller,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white),
            hintText: "Search Buisness...",
            hintStyle: TextStyle(color: Colors.white)),
        onChanged: searchOperation,
      );
      _handleSearchStart();
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: getbusilist(),
        builder: (context, _events) {
          if (_events.hasData) {
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              key: globalKey,
              appBar: buildAppBar(context),
              body: Container(
                // Add box decoration
                decoration: BoxDecoration(
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.1, 0.4, 0.7, 1.0],
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      const Color(0xff0D37C1),
                      Colors.deepPurpleAccent,
                      Colors.deepPurple,
                      Colors.purple,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                          child: searchresult.isNotEmpty ||
                                  _controller.text.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: searchresult.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String listData = searchresult[index];
                                    String location = _location[index];
                                    String img = _imgurl[index];
                                    String user = _users[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            width: 5.0,
                                            color: Colors.green,
                                          ),
                                          bottom: BorderSide(
                                            width: 1.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 30.0,
                                            backgroundImage:
                                                NetworkImage(img.toString()),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          title: Text(listData.toString()),
                                          subtitle: Text(location.toString()),
                                          trailing:
                                              Icon(Icons.keyboard_arrow_right),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UCalendarPage(
                                                          title: user)),
                                            );
                                          }),
                                    );
                                  },
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _list.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String listData = _list[index];
                                    String location = _location[index];
                                    String img = _imgurl[index];
                                    String user = _users[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            width: 5.0,
                                            color: Colors.green,
                                          ),
                                          bottom: BorderSide(
                                            width: 1.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                            radius: 30.0,
                                            backgroundImage:
                                                NetworkImage(img.toString()),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          title: Text(listData.toString()),
                                          subtitle: Text(location.toString()),
                                          trailing:
                                              Icon(Icons.keyboard_arrow_right),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UCalendarPage(
                                                          title: user)),
                                            );
                                          }),
                                    );
                                  },
                                ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              key: _scaffoldKey,
              appBar: PreferredSize(
                child: Container(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: ButtonTheme.bar(
                    child: ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            //nothing
                          },
                          child: Icon(
                            Icons.list,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          elevation: 0,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Search',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2.0,
                          color: Colors.white,
                        ),
                      ),
                      gradient: LinearGradient(
                          colors: [Colors.deepPurple, const Color(0xff0D37C1)]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          blurRadius: 3.0,
                          spreadRadius: 1.0,
                        )
                      ]),
                ),
                preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
              ),
              body: Container(
                // Add box decoration
                decoration: BoxDecoration(
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.1, 0.4, 0.7, 1.0],
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      const Color(0xff0D37C1),
                      Colors.deepPurpleAccent,
                      Colors.deepPurple,
                      Colors.purple,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                      Text('Loading...')
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );

  Widget buildAppBar(BuildContext context) {
    return AppBar(title: appBarTitle);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }

  Future<List> getbusilist() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("users")
        .orderBy('business')
        .getDocuments();
    var doc = querySnapshot.documents;
    var list = List.generate(doc.length, (int index) => doc[index]['business']);
    return list;
  }

  Future<List> getloclist() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("users")
        .orderBy('business')
        .getDocuments();
    var doc = querySnapshot.documents;
    var list =
        List.generate(doc.length, (int index) => '${doc[index]['location']}');
    return list;
  }

  Future<List> getuserlist() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("users")
        .orderBy('business')
        .getDocuments();
    var doc = querySnapshot.documents;
    var list = List.generate(doc.length, (int index) => doc[index]['username']);
    return list;
  }

  Future<List> getimglist() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("users")
        .orderBy('business')
        .getDocuments();
    var doc = querySnapshot.documents;
    var list = List.generate(doc.length, (int index) => doc[index]['img']);
    return list;
  }
}
