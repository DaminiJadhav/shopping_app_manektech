import 'package:shopping_app_manektech/bloc/main_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_manektech/bloc/main_state.dart';
import 'package:shopping_app_manektech/service/web_service.dart';

class MainBloc extends Bloc<MainEvent,MainState> {
  MainBloc({required this.webService}) : super(MainInitialState()) {
    on<ShoppingCardEvents>((event, emit) async{
      await _getShoppingDetails(emit,event);
    });
  }
  WebService webService;


  Future<void> _getShoppingDetails(var apiResponse,ShoppingCardEvents event) async {
    emit(ShoppingCardLoadingState());
    try {
      var shoppingCardResponse = await webService.getshoppingDetails(event.pagesize,event.page,event.token);
      emit(ShoppingCardLoadedState(shoppingCardResponse: shoppingCardResponse));
    } catch (e) {
      emit (ShoppingCardErrorState(msg: (e.toString())));
    }
  }
}