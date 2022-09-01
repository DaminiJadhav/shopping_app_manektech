class MainEvent{

}

class ShoppingCardEvents extends MainEvent{
  int pagesize;
  int page;
  String token;
  ShoppingCardEvents({required this.pagesize,required this.page,required this.token});
}
