
import 'package:flutter/material.dart';
import 'package:shopping_app_manektech/database/database_helper.dart';

class MyCardDetailsScreen extends StatefulWidget {
  List<Map<String, dynamic>> listofcard;
  MyCardDetailsScreen({Key? key,required this.listofcard}) : super(key: key);

  @override
  _MyCardDetailsScreenState createState() => _MyCardDetailsScreenState();
}

class _MyCardDetailsScreenState extends State<MyCardDetailsScreen> {
  ScrollController myCardController=new ScrollController();
  int total=0,grandTotal=0;
  int price=0,totalItems=0;
  final dbHelper = DatabaseHelper.instance;
  late var allRows;
  int totalMyCard=0;
  List<Map<String, dynamic>> listofcard=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      listofcard=widget.listofcard;
    });

    for(int i=0;i<widget.listofcard.length;i++){
      setState(() {
        total=widget.listofcard[i]['price'];
        grandTotal=grandTotal+total;
        price=widget.listofcard[i]['quatity'];
        totalItems=totalItems+price;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Card"),
      ),
      body: _myCard(),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          padding: EdgeInsets.only(left: 10,right: 10),
          height: 65,
          color: Colors.blue[300],
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Text("Total Items  : ${grandTotal}",style: TextStyle(fontSize: 16),),
              Text("Grand Total  : ${totalItems}",style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  _myCard(){
    return SingleChildScrollView(
      child: ListView.builder(
        controller: myCardController,
        shrinkWrap: true,
          itemCount:listofcard.length ,
          itemBuilder: (contxext,index){
            return Card(
              elevation: 4,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Container(
                         padding: EdgeInsets.only(left: 10),
                         child: Image.network(listofcard[index]['productImage'],height: 100,width: 80,/*fit: BoxFit.fill,*/),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text('${listofcard[index]['productName']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
                                  IconButton(
                                      onPressed: (){
                                        dbHelper.delete(listofcard[index]['id']);
                                        _query();
                                      },
                                      icon: Icon(Icons.delete,color: Colors.grey[600],)
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0,bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Price'),
                                    Text("${listofcard[index]['price']}")
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Quatity'),
                                  Text("${widget.listofcard[index]['quatity']}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }
       ),
    );
  }

  void _query() async {
    setState(() {
      grandTotal=0;
      totalItems=0;
      // listofcard.clear();
    });
    allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
    setState(() {
      listofcard=allRows;
      for(int i=0;i<allRows.length;i++){
        setState(() {
          total=allRows[i]['price'];
          grandTotal=grandTotal+total;
          price=allRows[i]['quatity'];
          totalItems=totalItems+price;
        });
      }
    });

  }
}
