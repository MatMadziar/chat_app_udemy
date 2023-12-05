// gia na kanw import to authentication screen
import 'package:chat_app/screens/auth.dart';
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
        home: AuthScreen());
  }
}
