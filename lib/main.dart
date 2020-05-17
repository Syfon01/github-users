import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:github_users/model/user_model.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<GithubUsers>> getData() async {
    String url = 'https://api.github.com/users?language=flutter';
    final per = await http.get(url);
    if (per.statusCode == 200) {
      final Iterable json = jsonDecode(per.body);
    // print(jsonDecode(per.body));
      return json.map((person) => GithubUsers.fromJson(person)).toList();
    }
    print('nothing to show');
    return null;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Github Users',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black),
        body: FutureBuilder<List<GithubUsers>>(
          future: getData(),
          builder: (context, snapshot) {            
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                        leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage('${snapshot.data[index].avatarUrl}'),
                      ),
                        title: Text('${snapshot.data[index].login}',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),),
                        subtitle: Text(
                          'No Location found'
                        ),
                        trailing: Container(
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.circular(22.0),
                                border: Border.all(
                                  width:
                                      2, //                   <--- border width here
                                ),
                              ),
                              padding: EdgeInsets.all(10.0),
                              child: GestureDetector(
                                  child: Wrap( 
                                     spacing: 6,
                                    children: <Widget>[                              
                                    Text("View Profile",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600)),
                                    Icon(
                                      MdiIcons.github,
                                      size: 20,
                                      color: Colors.black,),
                                    ]),
                                  onTap: () {
                                    launch(snapshot.data[index].htmlUrl);
                                  }))
                        
                      ),
                  );
                },
              );
            }
            return SpinKitPouringHourglass(
              color: Colors.blueGrey,
              size: 70,
            );
          },
        ));
  }
}
