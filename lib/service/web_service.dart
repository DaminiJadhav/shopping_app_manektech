import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_app_manektech/model/shopping_card_response.dart';

class WebService {


  Future<ShoppingCardResponse> getshoppingDetails(int pagesize,int page,String token) async {
    String apiUrl="http://205.134.254.135/~mobile/MtProject/public/api/product_list.php";
    print(apiUrl);

    final response = await http.post(
      Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': "Bearer ${token}",
        },
        body: jsonEncode(<String, int>{
          "page":page,
          "perPage":pagesize
        }),

    );

    print(response.body);
    return ShoppingCardResponse.fromJson(jsonDecode(response.body));

  }

}