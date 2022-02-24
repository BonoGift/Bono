import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/provider/chat_provider.dart';
import 'package:bono_gifts/provider/feeds_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/routes/custom_routes.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:bono_gifts/views/gift/history.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WooCommerceMarketPlaceProvider>(
          create: (context) => WooCommerceMarketPlaceProvider(),
        ),
        ChangeNotifierProvider<SignUpProvider>(
          create: (context) => SignUpProvider(),
        ),
        ChangeNotifierProvider<FeedsProvider>(
          create: (context) => FeedsProvider(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider<BuyProvider>(
          create: (context) => BuyProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bono gifts',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: CustomRoutes.allRoutes,
        initialRoute: laoding,
        // home: HistoryPage(),
      ),
    );
  }
}
