import 'package:shopping_app_manektech/model/shopping_card_response.dart';

class MainState{
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}

class MainInitialState extends MainState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ShoppingCardLoadingState extends MainState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ShoppingCardLoadedState extends MainState{
  ShoppingCardResponse shoppingCardResponse;
  ShoppingCardLoadedState({required this.shoppingCardResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ShoppingCardErrorState extends MainState{
  String msg;
  ShoppingCardErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}