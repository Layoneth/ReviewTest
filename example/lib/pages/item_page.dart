import 'package:flutter/material.dart';
import 'package:reviewstest/item.dart';
import 'package:reviewstest/review.dart';
import 'package:reviewstest/reviewstest.dart';

class ItemPage extends StatefulWidget {
  final Item item;
  final String uid;
  const ItemPage({Key key, this.item, this.uid}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final fbS = Reviewtest();
  final _formKey = GlobalKey<FormState>();
  String comment;
  int valueC;

  @override
  void initState() { 
    super.initState();
    fbS.getReviews(widget.item.id);
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Review>>(
                stream: fbS.movieStream,
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return CircularProgressIndicator();
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final rev = snapshot.data.elementAt(index);
                    return Row(
                      children: <Widget>[
                        Text(rev.valoracion.toString()),
                        SizedBox(width: 20.0),
                        rev.comentario != null ? Text(rev.comentario) : Container(),
                      ],
                    );
                  },
                  );
                }
              ),
            ),
            RaisedButton(
              child: Text('Ver más'),
              onPressed: (){
                setState(() {
                  fbS.loadMoreReviews( widget.item.id );
                });
              }
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Comment'
                    ),
                    onChanged: (value){
                      comment = value;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Value'
                    ),
                    validator: (value){
                      //Asegurandome que el valor esté entre 1-5
                      int valueTemp;
                      valueTemp = int.parse(value);
                      if(valueTemp > 0 && valueTemp < 6){
                        valueC = valueTemp;
                        return null;
                      }else{
                        return 'error';
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text('Save'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        final rev = Review(comment, valueC, widget.uid, DateTime.now());
                        final a = await fbS.setReview( rev, widget.item.id );
                        if(a){
                          setState(() {});
                        }
                      }
                    }
                  )
                ]
              )
            ),
          ]
        ),
      ),
    );
  }
}