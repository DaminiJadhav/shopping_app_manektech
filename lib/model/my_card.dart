import 'package:shopping_app_manektech/database/database_helper.dart';

class MyCard {
  int? id;
  String ?productName;
  String ?productImage;
  int ?price;
  int ?quatity;

  MyCard(this.id, this.productName, this.productImage,this.price,this.quatity);

  MyCard.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    productName = map['productName'];
    productImage = map['productImage'];
    price = map['price'];
    quatity = map['quatity'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: productName,
      DatabaseHelper.columnImage: productImage,
      DatabaseHelper.columnPrice: price,
      DatabaseHelper.columnQuatity: quatity,

    };
  }
}