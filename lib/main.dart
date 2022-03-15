import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/provider/chat_provider.dart';
import 'package:bono_gifts/provider/feeds_provider.dart';
import 'package:bono_gifts/provider/paypal_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/routes/custom_routes.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:bono_gifts/views/gift/controller/history_controller.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        ChangeNotifierProvider<PaypalProvider>(
          create: (context) => PaypalProvider(),
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
        ChangeNotifierProvider<HistoryProvider>(
          create: (context) => HistoryProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Bono gifts',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          CountryLocalizations.delegate,
        ],
        onGenerateRoute: CustomRoutes.allRoutes,
        initialRoute: splashPage,
        // home: HistoryPage(),
      ),
    );
  }
}
