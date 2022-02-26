import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/models/cart_details.dart';
import 'package:roi_test/providers/auth_provider.dart';
import 'package:roi_test/providers/cart_provider.dart';
import 'package:roi_test/providers/location_provider.dart';
import 'package:roi_test/providers/order_provider.dart';
import 'package:roi_test/providers/service_store.dart';
import 'package:roi_test/screens/Help/contactUs.dart';
import 'package:roi_test/screens/Help/faq.dart';
import 'package:roi_test/screens/Help/help.dart';
import 'package:roi_test/screens/Help/mapLocation.dart';
import 'package:roi_test/screens/cart_screen.dart';
import 'package:roi_test/screens/home_screen.dart';
import 'package:roi_test/screens/landing_screen.dart';
import 'package:roi_test/screens/login_screen.dart';
import 'package:roi_test/screens/main_screen.dart';
import 'package:roi_test/screens/map_screen.dart';
import 'package:roi_test/screens/my_orders_screen.dart';
import 'package:roi_test/screens/network/connectivity.dart';
import 'package:roi_test/screens/payment/payment_failed.dart';
import 'package:roi_test/screens/payment/payment_home.dart';
import 'package:roi_test/screens/payment/razorpayment_screen.dart';
import 'package:roi_test/screens/product_details_screen.dart';
import 'package:roi_test/screens/product_list.dart';
import 'package:roi_test/screens/profile_screen.dart';
import 'package:roi_test/screens/profile_update.dart';
import 'package:roi_test/screens/splash_screen.dart';
import 'package:roi_test/screens/vendor_home_screen.dart';
import 'package:roi_test/models/product_display.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot? document;
    return OverlaySupport.global(
        child: MultiProvider(
            providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => ServiceStore()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          StreamProvider<ConnectivityStatus>(
              create: (_) => ConnectivityService().streamController.stream,
              initialData: ConnectivityStatus.Offline),
          //  ChangeNotifierProvider(create: (_) => NotificationService()),
        ],
            child: Consumer(builder: (_, notifier, child) {
              return Builder(builder: (context) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                      primaryColor: Color(0xff09A3B8), fontFamily: 'Lato'),
                  initialRoute: SplashScreen.id,
                  onGenerateRoute: (settings) {
                    if (settings.name == ProductDetailsScreen.id) {
                      // Cast the arguments to the correct
                      // type: ScreenArguments.
                      final args = settings.arguments as ProductDetails;

                      // Then, extract the required data from
                      // the arguments and pass the data to the
                      // correct screen.
                      return MaterialPageRoute(
                        builder: (context) {
                          return ProductDetailsScreen(
                            document: args.document,
                          );
                        },
                      );
                    }
                    if (settings.name == CartScreen.id) {
                      // Cast the arguments to the correct
                      // type: ScreenArguments.
                      final args = settings.arguments as CartDetails;

                      // Then, extract the required data from
                      // the arguments and pass the data to the
                      // correct screen.
                      return MaterialPageRoute(
                        builder: (context) {
                          return CartScreen(
                            document: args.document,
                          );
                        },
                      );
                    }
                    assert(false, 'Need to implement ${settings.name}');
                    return null;
                  },
                  routes: {
                    SplashScreen.id: (context) => SplashScreen(),
                    HomeScreen.id: (context) => HomeScreen(),
                    WelcomeScreen.id: (context) => WelcomeScreen(),
                    MapScreen.id: (context) => MapScreen(),
                    LoginScreen.id: (context) => LoginScreen(),
                    VendorHomeScreen.id: (context) => VendorHomeScreen(),
                    ProductList.id: (context) => ProductList(),
                    MainScreen.id: (context) => MainScreen(),
                    ProfileScreen.id: (context) => ProfileScreen(),
                    // ExistingCardsPage.id: (context) => ExistingCardsPage(),
                    PaymentHomePage.id: (context) => PaymentHomePage(),
                    RazorPaymentScreen.id: (context) => RazorPaymentScreen(),
                    MyOrders.id: (context) => MyOrders(),
                    LandingScreen.id: (context) => LandingScreen(),
                    // CartScreen.id: (context) => CartScreen(
                    //     document: document!,
                    // )
                    UpdateProfile.id: (context) => UpdateProfile(),
                    PaymentFailed.id: (context) => PaymentFailed(),
                    ContactUs.id: (context) => ContactUs(),
                    Faq.id: (context) => Faq(), Help.id: (context) => Help(),
                    MapLoaction.id: (context) => MapLoaction()
                  },
                  builder: EasyLoading.init(),
                );
              });
            })));
  }
}
