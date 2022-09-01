import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_manektech/bloc/main_bloc.dart';
import 'package:shopping_app_manektech/bloc/main_event.dart';
import 'package:shopping_app_manektech/bloc/main_state.dart';
import 'package:shopping_app_manektech/database/database_helper.dart';
import 'package:shopping_app_manektech/model/my_card.dart';
import 'package:shopping_app_manektech/model/shopping_card_response.dart';
import 'package:shopping_app_manektech/screens/my_card_details_screen.dart';

class ShoppingHomeScreen extends StatefulWidget {
  const ShoppingHomeScreen({Key? key}) : super(key: key);

  @override
  _ShoppingHomeScreenState createState() => _ShoppingHomeScreenState();
}

class _ShoppingHomeScreenState extends State<ShoppingHomeScreen> {
  bool _isLoading = false;
  late MainBloc _mainBloc;
  int _page = 1;
  final int _pageSize = 10;
  ScrollController scrollController=new ScrollController();
  ScrollController shoppingController=new ScrollController();
  final dbHelper = DatabaseHelper.instance;
  List<Datum>? shoppingList=[];
  List<MyCard> cars = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int totalMyCard=0;
   late var allRows;

  void _showMessageInScaffold(String message){
    _query();
    _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(message),
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);
    _query();

    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent==scrollController.offset){
        setState(() {
          print("Scroll ${_page}");
          _getshoppings();
        });

      }
    });
    _getshoppings();
  }

  _getshoppings(){
    _mainBloc.add(ShoppingCardEvents(pagesize: _pageSize,page:_page ,token: "eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz"));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Shopping Mall"),
        actions: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              IconButton(
                  onPressed: (){
                    _query();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) =>
                            MyCardDetailsScreen(listofcard: allRows,))
                    );
                  },
                  icon: Icon(Icons.shopping_cart_outlined)
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red
                ),
                child: Text(totalMyCard.toString()),
              )
            ],
          )

        ],
      ),
      body: BlocListener<MainBloc, MainState>(
        listener:(context,state){
          if (state is ShoppingCardLoadingState) {
            setState(() {
              _isLoading=true;

            });
          }else  if (state is ShoppingCardLoadedState) {
            setState(() {
              _isLoading=false;
              shoppingList!.addAll(state.shoppingCardResponse.data!);
              _page++;
            });
          }else  if (state is ShoppingCardErrorState) {
            setState(() {
              _isLoading=false;

            });
          }
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: shoppingList!.length==0 ? Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )) :Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(12.0),
                    child: GridView.builder(
                      controller: shoppingController,
                      shrinkWrap: true,
                      itemCount: shoppingList!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0
                      ),
                      itemBuilder: (BuildContext context, int index){
                        return Card(
                          elevation: 4,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.blue,
                                      child: Image.network(shoppingList![index].featuredImage!),
                                    ),
                                  ),
                                  // Image.network(src);
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text('${shoppingList![index].title!}')
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            _insert(shoppingList![index].title,shoppingList![index].featuredImage,shoppingList![index].price,1);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 6.0),
                                            child: Icon(Icons.shopping_cart_sharp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
                _isLoading ? CircularProgressIndicator() : Container()

              ],
            ),
          ),
        ),
      ),
    );
  }
  void _insert(productname, productImage,price,quantity) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: productname,
      DatabaseHelper.columnImage: productImage,
      DatabaseHelper.columnPrice: price,
      DatabaseHelper.columnQuatity: quantity,
    };
    MyCard myCard = MyCard.fromMap(row);
    final id = await dbHelper.insert(myCard);
    _showMessageInScaffold('Item added to card : $productname');
  }


  void _query() async {
     allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
    setState(() {
      totalMyCard=allRows.length;
    });

  }
}
