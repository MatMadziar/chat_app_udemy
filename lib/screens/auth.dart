import 'package:chat_app/widgets/user_image_picker.dart';
// I need this in order to use the firebase cloud firestore database
import 'package:cloud_firestore/cloud_firestore.dart';
// I need this in order to use Firebase Storage package
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// I need to import packade for firebase for authentication
import 'package:firebase_auth/firebase_auth.dart';
// gia na kanw xrhsh to File
import 'dart:io';

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
  const AuthScreen({super.key});

// createstate
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = true;
  // I will add 2 empty string values
  // the "_" before the varialbes names meants that they are private. can be used only inthis dart file
  var _enteredEmail = '';
  var _enteredPassword = '';
  // variablie for userName
  var _entredUserName = '';
  // Add Photo, file not null
  File? _selectedImage;
  // isUpploading is false gt den fortonei kati mexri na patisw to sign in
  var _isAuthenticating = false;
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
// if not valid - or (not in login mode -ara new user signin mode) kai epilegmenh eikona einai keno tote paketo h sindesh
    if (!isValid || (!_isLogin && _selectedImage == null)) {
      // I can show en error message if I want
      return;
    }

//-----------  ta kanw 1 if CHECK START //
    /* 
    if (!isValid) {
      return;
    }

// I want to check the existence of the image only in SignIN (Create account), not every time when logging
// ean den einai sto login mode (are o xrhsths kanei Sign IN kai h epilegmenh eikona einai keno) paketo
    if (!_isLogin && _selectedImage == null) {
      return;
    }
    */
//-----  ta kanw 1 if CHECK END ---------//

    //if my input is valid, I will save the current state
    _formKey.currentState!.save();
    // tsekarw an o user einai Login. edw px borw na ritmisw an o user einai login na mhn tou zitaw ta stoixeia tou ksana.
    // gia arxh den exw users opote doulebw me to else block

    try {
      // oso tsekarw an ola einai ok borw na rithmisw na fainetai kai kapoio loading spinner
      // oso kanw uppload to image h ta dedomena genika sto firebase
      // bazw olo se try catch block
      setState(() {
        // to bazw na piasei kai to login kai to sign in gt kai sto sign in stelnw dedomena sto firebase
        // kai borei na uparxei kathisterish kai ekei
        _isAuthenticating = true;
      });

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
        // print(userCredentials); // emfanizw ta user credential sto debug console
      } else {
        // try the code in bracelets, catch an exeption
        // this could fail so I need to wrap this in try and catch block
        // I create an user with email and password and I assign it to the value userCredentials
        // bazw to await gia na parw ta stoixeia apo to firebase
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        // print(userCredentials); // emfanizw ta user credential sto debug console
        //
        // I want to uppload photo. First create account then add extra info
        //
        //
        // ----------------------- UPLOAD IMAGE START ---------------------------------//
        //edw ftiaxnw to path - OPOS sto kotlin - Upload to Firebase Storage
        // Ftiaxnw to reference kai to bazw sth metablith storageRef
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('profile_photo')
            .child('${userCredentials.user!.uid}.jpeg');
        // borw kai email// "!" gia na mhn einai keno

        // wait this uppload to finish (await)
        await storageRef.putFile(_selectedImage!);
        // I want the URL which can help me later to display image that was stored on Firebase
        final imageUrl = await storageRef.getDownloadURL();
        print(imageUrl); // to ektipwnw sth consola

        // ----------------------- UPLOAD IMAGE END ----------------------------------//
        // Sindesh me to FireßstoreDatabase
        // FirebaseFirestore.instance.collection('users').doc(''); // with fixed document name
        // dynamic name tou document: (na allazei me bazei to user UID credentials automata)
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _entredUserName,
          'email': _enteredEmail,
          'image_url': imageUrl,
          'user_UID': userCredentials.user!.uid,
        });
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      // to bazw gia na epistepsw sthn arxikh katastash.
      // aliws o user den tha exei thn dinatothta na ksanadei ta koubia gia na kanei
      // ti diadikasia tou authentication
      setState(() {
        _isAuthenticating = false;
      });
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
                          // only if we are SignIN (during creation new account ONLY)
                          // to epitigxanw me. th xrish "!"
                          if (!_isLogin)
                            // ean einai se epomeno login tote den emfanizetai
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                // thats how we hold the image in the form here
                                _selectedImage = pickedImage;
                              },
                            ),
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
                          // this should be show ONLY when we are in SIGN IN MODE
                          // NOT when we are Login in (epanasindesh)
                          if (!_isLogin)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 4) {
                                  return 'Please enter a valid username (at least 4 characters)';
                                }
                                // Othervise return null
                                // dld an ola OK tote mhn epistrepeis kapoio minima error
                                return null;
                              },
                              // we need this onSaved mode
                              onSaved: (value) {
                                _entredUserName = value!;
                              },
                            ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
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
                          // if IS authanticating, show me the progress indicator
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          // if NOT authenticated show me the button
                          if (!_isAuthenticating)
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
                          // if NOT authenticated show me the textButton
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
