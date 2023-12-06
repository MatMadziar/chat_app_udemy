// gia na kanw import to authentication screen
import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/screens/chat.dart';
// gia import tou SplashScreen
import 'package:chat_app/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ta kanw import gia na xrhsimopoihsw to Firebase.
// to kanw META afou exw setarei mesw tou terminal
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//

void main() async {
  // to bazw extradaki an kolisei sto anoigma ths efarmoghs meta apo sindesh me to firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // mexri edw to extradaki gia th xrhsh firebase
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // an den exw to token tpu authantication tote tou bgazw to AuthScreen
      // Alliws otan o user exei kanei authentication kai den exei kanei logout,
      // tote ton metaferw sth kanoniki s elida san na exei perasei to login klp
      //home: AuthScreen());
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        // to snapshot krataei ta user data (px to credential an einai loged in,
        // an einia loged out tote einai adio)
        builder: (ctx, snapshot) {
          //
          // pernaw sto Splash Screen mexri na fortosoun ta dedomena apo to fierebase
          // mexri na fortothei to token apo to sdk tou Firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          // tsekarw an to adikeimeno snaphot exei stoixeia tou user
          // an exei data tote den ton paw sto login na perasei authentication
          // ton metaferw kateuthian sto kedriko menu
          if (snapshot.hasData) {
            // to const den einai aparetito alla einai strongly recomended- to kanw apla bazw ton key contructor
            return const ChatScreen();
          }
          // otan den exw perasei authentication h exw kanei logout tote to pernaw apo authscreeen
          else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
