import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_manektech/bloc/main_bloc.dart';
import 'package:shopping_app_manektech/screens/shopping_home_screen.dart';
import 'package:shopping_app_manektech/service/web_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  BlocProvider(
          create: (context) {
            return MainBloc(webService: WebService());
          },
          child:ShoppingHomeScreen()
      ),
    );
  }
}

