
import 'package:flutter/material.dart';
import 'package:ftltask/screens/HomeScreen.dart';
import 'package:ftltask/screens/OperationsScreen.dart';
import 'package:ftltask/utils/ThemeChanger.dart';
import 'package:provider/provider.dart';

void main()
{
  runApp(
      ChangeNotifierProvider<ThemeState>
        (
        create: (context)=> ThemeState(),

        child: MyApp(),

      ),
  );

}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeState>(context).theme == ThemeType.DARK
      ? ThemeData.dark()
          : ThemeData.light(),

        title: 'To DO',
      debugShowCheckedModeBanner: false,


      // theme: ThemeData.light(),

      initialRoute: HomeScreen.id,
      routes: {

          HomeScreen.id : (context) => HomeScreen(),
          // OperationsScreen.id : (context) => OperationsScreen(""),
      },
    );
  }
}
