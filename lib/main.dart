import 'package:azoozyapp/constants/app_colors.dart';
import 'package:azoozyapp/services/database.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:azoozyapp/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Azoozy.com',
        theme: ThemeData(
          primarySwatch:  buildMaterialColor(AppColors.primarySwatch),
        ),
        home: const SplashScreen(),
      ),

    );
  }

   MaterialColor buildMaterialColor(Color color) {
     List strengths = <double>[.05];
     Map<int, Color> swatch = {};
     final int r = color.red, g = color.green, b = color.blue;

     for (int i = 1; i < 10; i++) {
       strengths.add(0.1 * i);
     }
     for (var strength in strengths) {
       final double ds = 0.5 - strength;
       swatch[(strength * 1000).round()] = Color.fromRGBO(
         r + ((ds < 0 ? r : (255 - r)) * ds).round(),
         g + ((ds < 0 ? g : (255 - g)) * ds).round(),
         b + ((ds < 0 ? b : (255 - b)) * ds).round(),
         1,
       );
     }
     return MaterialColor(color.value, swatch);
   }
}




