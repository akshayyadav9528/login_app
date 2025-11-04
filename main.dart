import 'package:flutter/material.dart';
import 'package:project/utilities/theme.dart';
import 'package:get/get.dart';
import 'utilities/dependencies.dart' as dependencies;
import 'package:project/utilities/routes.dart' as routes;
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'backend project',
    theme: customTheme,
    debugShowCheckedModeBanner: false,
    initialBinding: dependencies.InitialBindings(),
    getPages: routes.getPages,
    home: const Homepage(),
    );
  }
}

