import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_matkapaivakirja/view/public_trip_list.dart';
import 'package:flutter_matkapaivakirja/view/settings_screen.dart';
import 'package:flutter_matkapaivakirja/view/weather.dart';
import 'package:get/get.dart';
import 'package:flutter_matkapaivakirja/data/trip_list_manager.dart';
import 'package:flutter_matkapaivakirja/view/add_trip.dart';
import 'package:flutter_matkapaivakirja/view/trip_list.dart';
import 'package:flutter_matkapaivakirja/view/map_screen.dart';
import 'package:flutter_matkapaivakirja/view/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Get.put(SettingsController());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
        create: (context) {
          var model = TripListManager();
          model.init(); // Initialize TripListManager on app start
          return model;
        },
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];

    void onSignedIn(BuildContext context) {
      Provider.of<TripListManager>(context, listen: false).init();
      Navigator.pushReplacementNamed(context, '/home');
    }

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute:
              FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
          getPages: [
            GetPage(name: '/home', page: () => HomeScreen()),
            GetPage(name: '/add-trip', page: () => AddTripView()),
            GetPage(name: '/settings', page: () => SettingsScreen()),
            GetPage(name: '/trip-list', page: () => TripListView()),
            GetPage(name: '/maps', page: () => MapsScreen()),
            GetPage(name: '/weather', page: () => WeatherView()),
            GetPage(
                name: '/public-trip-list', page: () => PublicTripListView()),
            GetPage(
              name: '/sign-in',
              page: () => SignInScreen(
                providers: providers,
                actions: [
                  AuthStateChangeAction<UserCreated>((context, state) {
                    onSignedIn(context);
                    //Get.offAllNamed('/home');
                  }),
                  AuthStateChangeAction<SignedIn>((context, state) {
                    onSignedIn(context);
                    //Get.offAllNamed('/home');
                  }),
                ],
              ),
            ),
            GetPage(
              name: '/profile',
              page: () => ProfileScreen(
                providers: providers,
                actions: [
                  SignedOutAction((context) {
                    Provider.of<TripListManager>(context, listen: false)
                        .clearItems();
                    FirebaseAuth.instance.setPersistence(Persistence.NONE);
                    Get.offAllNamed('/sign-in');
                  }),
                ],
              ),
            ),
          ],
        ));
  }
}
