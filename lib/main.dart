import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_ecom_app/bloc/cart/bloc/cart_bloc.dart';
import 'package:mini_ecom_app/bloc/product/bloc/product_bloc.dart';
import 'package:mini_ecom_app/screens/cart_screen.dart';
import 'package:mini_ecom_app/screens/product_list_page.dart';
import 'package:mini_ecom_app/repository/product_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Mini E-commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ProductListScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/cart': (context) => CartScreen(),
        },
      ),
    );
  }
}
