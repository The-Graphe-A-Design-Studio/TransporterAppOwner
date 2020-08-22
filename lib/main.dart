import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ownerapp/RouteGenerator.dart';
import 'package:ownerapp/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(StartApp());
}

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transportation App',
      theme: ThemeData(
        primaryColor: Color(0xff252427),
        canvasColor: Colors.transparent,
        accentColor: Colors.black12,
        accentColorBrightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      home: SplashScreen(),
    );
  }
}
