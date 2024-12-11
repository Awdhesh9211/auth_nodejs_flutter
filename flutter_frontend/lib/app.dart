
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/cubit_and_state/auth_cubit.dart';
import 'package:flutter_frontend/page/home_page.dart';
import 'package:flutter_frontend/page/login_page.dart';
import 'package:flutter_frontend/page/register_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()..checkAuthStatus(),
      child: MaterialApp(
        title: 'Flutter Auth App',
        debugShowCheckedModeBanner:false,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomePage(),
        },
      ),
    );
  }
}
