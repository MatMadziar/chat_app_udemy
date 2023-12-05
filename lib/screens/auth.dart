import 'package:flutter/material.dart';
// I need to import packade for firebase for authentication
import 'package:firebase_auth/firebase_auth.dart';

// After adding a auth. package I need to make a GLOBAL (gia auto einai edw panw) final variable
// I put it here because I can use it over and over again in my entire code
// otan bazw "_"brosta apo to variable to mono gia auto to dart file
//The underscore before the variable name is a convention in Dart to indicate that
//the variable is private to its library.
//It means that the variable is intended for use only within the same Dart file.
// den borw nato kanw import
final _firebase = FirebaseAuth.instance;

// its stateful Widget because i will make a form and i will collect the users data
// we will use some features that requires statefull widget
class AuthScreen extends StatefulWidget {
// createstate
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = true;
  // I will add 2 empty string values
  var _enteredEmail = '';
  var _enteredPassword = '';
  //
  //
  // I want to make sure that the values are safe and I get hold the entered values
  // For this reason I create a key which will be connected to Form State.
  // I will use this formkey in the Form Widget
  final _formKey = GlobalKey<FormState>();
  // void type because don't return something
  void _submit() async {
    //cannot be null
    // returns a boolean which tell us if is null or not
    final isValid = _formKey.currentState!.validate();

// to kanw etsi gia aplotota
// to avoid adding too many levels of nested "if" statements
// ean h eisodos den einai Valid tote paketo. allios kanw seve thn eisodo parakatw
    if (!isValid) {
      return;
    }
    //if my input is valid, I will save the current state
    _formKey.currentState!.save();
    // tsekarw an o user einai Login. edw px borw na ritmisw an o user einai login na mhn tou zitaw ta stoixeia tou ksana.
    // gia arxh den exw users opote doulebw me to else block

    try {
      // bazw olo se try catch block
      if (_isLogin) {
        //----SOS----//
        //
        // I need tro se the video again. some errors
        //https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/learn/lecture/37736618#content
        //
        //

        // log users in
        // kanw to authentication tou user me basi to emial kai to password
        // ta bazw se mia metablith kai borei na exei idio onoma me to signIn
        // ta bazw kai se ena try catch gia na apofigw ta errors
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(userCredentials); // emfanizw ta user credential sto debug console
      } else {
        // try the code in bracelets, catch an exeption
        // this could fail so I need to wrap this in try and catch block
        // I create an user with email and password and I assign it to the value userCredentials
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(userCredentials); // emfanizw ta user credential sto debug console
      }
    }
    //---------- GIA ISSUE ERROR me to AUTHENTICATION START ------------//
    //--------//
    // the "on" keyword allwo us to define the type of error
    // when using try{} on .. cach exeptions of the provided type (FirebaseAuthExeption in this case)
    // will be caught & handled
    on FirebaseAuthException catch (error) {
      // Gia ta error koita to "createUserWithEmailAndPassword"
      // Gia na kanw to error handling gia specific situations
      if (error.code == 'email-already-in-use') {
        // .. na ektiponete kati gia auto to error
      }
      if (error.code == 'invalid-email') {
        //..
      }
      // gia emfanish tou error kata to authentication. analoga me ton typo tou error
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? 'Authentication failed.'),
      ));
    }
    //---------- GIA ISSUE ERROR me to AUTHENTICATION END ------------//

    // I want to print the email and password in debug console
    // Later we will send it to Firebase and not printing
    // print(_enteredEmail); // ta ekuponw sto debug console
    // print(_enteredPassword); // ta ekuponw sto debug console
  }

  // build
  @override
  Widget build(BuildContext context) {
    // Scaffold gia na exw wraio design. na pianei olh thn othoni
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Email Address'),
                            // edw orizw ton typo eisodou dedomenon pou tha balei o xrhsths
                            // edw px na einai email type
                            keyboardType: TextInputType.emailAddress,
                            // na mhn exw kefalea grammata
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            // elegxos sostou inpout type.
                            // this will return the error
                            validator: (value) {
                              // I use trim to be sure that white space is removed
                              // episis tsekarw an exei @ alliws den einai email. borw na balw k allous periorismous
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address!';
                              }
                              // an ola einia ok sthn eisodo tou xrhsth oso afora to email tote epistrefw tpt
                              return null;
                            },
                            onSaved: (value) {
                              // to "!" sto telos apo katw einai gt den prepei na einia null. kai as to exw tsekarei apo panw
                              _enteredEmail = value!;
                              // den xrisimopoiw to set state gia na mhn exw update sto UI
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            // edw orizw ton typo eisodou dedomenon pou tha balei o xrhsths
                            // edw px na einai password type
                            // na mhn fenonde auto pou grafei o xrhsths
                            obscureText: true,
                            // edw kathorizw thn eisodo tou xrhsth oso afora to password
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // to "!" sto telos apo katw einai gt den prepei na einia null. kai as to exw tsekarei apo panw
                              _enteredPassword = value!;
                              // den xrisimopoiw to set state gia na mhn exw update sto UI
                            },
                          ),
                          SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _submit,
                            // I will be back later

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            // to kanwm gia na allazete to text an o xrhsths pathsei oti exei logariasmo ekei
                            child: Text(_isLogin ? 'Login' : 'SignUp'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin =
                                    !_isLogin; // I check for the opposite_isLogin ? false :true;
                              });
                            },
                            // ean uparxcei logariasmos se auto to email tote emfanise oti exei auto to account.
                            // alliws emfanise create account
                            child: Text(_isLogin
                                ? 'Create an account'
                                : 'I already have an account'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
