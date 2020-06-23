import 'package:flutter/material.dart';
import 'package:reviewstest/reviewstest.dart';
import 'item_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fbS = Reviewtest();
    String uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews')
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FutureBuilder<List>(
            future: fbS.getItems(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) return CircularProgressIndicator();
              return Container(
                height: 100,
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data.elementAt(index).name),
                    onTap: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => ItemPage(
                            item: snapshot.data.elementAt(index),
                            uid: uid
                          )
                        ),
                      );
                    },
                  );
                  },
                ),
              );
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'User id'
            ),
            onChanged: (val){
              uid = val;
            },
          ),
        ]
      ),
    );
  }
}