import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flappy_bird_main/Routes/app_routes.dart';
import 'package:flappy_bird_main/firebase_crud_service.dart';
import 'package:flappy_bird_main/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'Layouts/Pages/page_start_screen.dart'; // Import the StartScreen
import 'package:flappy_bird_main/DefaultFirebaseOptions.dart' as default_options;
import 'package:firebase_core/firebase_core.dart';
import 'package:flappy_bird_main/Resources/strings.dart';
import 'package:flappy_bird_main/firebase_options.dart';



Future main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('user');

  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: default_options.DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key, this.isLogin = true});

  final bool isLogin;

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isLogin = true;
  String email = '';
  String password = '';

  void _toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: LoginScreen(isLogin: isLogin),
      debugShowCheckedModeBanner: false,
      initialRoute: Str.home,
      onGenerateRoute: AppRoute().generateRoute,
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
  final bool isLogin;

  LoginScreen({required this.isLogin});
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool isLogin = true;
  String email = '';
  String password = '';
  String confirmPassword = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (isLogin) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passController.text.trim(),
          );
        } else {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passController.text.trim(),
          );
        }
        // Navigate to the home screen or show a success message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StartScreen()),
        );
      } catch (e) {
        String errorMessage = 'An unexpected error occurred';
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'invalid-email':
              errorMessage = 'The email address is invalid. Please check and try again.';
              break;
            case 'user-not-found':
              errorMessage = 'No user found for that email.';
              break;
            case 'wrong-password':
              errorMessage = 'Incorrect password. Please try again.';
              break;
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }


// // editing CRUD
// Future<void> _updateProfile() async {
//   final FirebaseCrudService crudService = FirebaseCrudService();
//   final userId = FirebaseAuth.instance.currentUser!.uid;

//   // Example update: Update the username
//   final updates = {'username': 'NewUsername'};
//   await crudService.updatePlayerProfile(userId, updates);

//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text('Profile updated successfully')),
//   );
// }


// Future<void> _loadProfile() async {
//   final FirebaseCrudService crudService = FirebaseCrudService();
//   final userId = FirebaseAuth.instance.currentUser!.uid;

//   final profileData = await crudService.readPlayerProfile(userId);
//   if (profileData != null) {
//     print('Player Profile: $profileData');
//     // Use the data in the UI (e.g., show username or high score)
//   }
// }
// Future<void> _deleteProfile() async {
//   final FirebaseCrudService crudService = FirebaseCrudService();
//   final userId = FirebaseAuth.instance.currentUser!.uid;

//   await crudService.deletePlayerProfile(userId);

//   // Optionally, delete the user's authentication record
//   await FirebaseAuth.instance.currentUser!.delete();

//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text('Profile deleted successfully')),
//   );
// }

// // editing CRUD




//   Future<void> _submitForm() async {
//   if (_formKey.currentState!.validate()) {
//     _formKey.currentState!.save();
//     try {
//       final FirebaseCrudService crudService = FirebaseCrudService();

//       if (isLogin) {
//         // Login existing user
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passController.text.trim(),
//         );
//       } else {
//         // Register new user
//         final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passController.text.trim(),
//         );

//         // Create a new profile in Firestore
//         final playerId = userCredential.user!.uid;
//         final profileData = {
//           'playerId': playerId,
//           'email': _emailController.text.trim(),
//           'username': 'Player ${DateTime.now().millisecondsSinceEpoch}', // Default username
//           'highScore': 0,
//           'joinedDate': DateTime.now().toIso8601String(),
//         };

//         await crudService.createPlayerProfile(playerId, profileData);
//       }

//       // Navigate to the home screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => StartScreen()),
//       );
//     } catch (e) {
//       String errorMessage = 'An unexpected error occurred';
//       if (e is FirebaseAuthException) {
//         switch (e.code) {
//           case 'invalid-email':
//             errorMessage = 'The email address is invalid. Please check and try again.';
//             break;
//           case 'user-not-found':
//             errorMessage = 'No user found for that email.';
//             break;
//           case 'wrong-password':
//             errorMessage = 'Incorrect password. Please try again.';
//             break;
//         }
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(errorMessage)),
//       );
//     }
//   }
// }

// Future<void> _submitForm() async {
//   if (_formKey.currentState!.validate()) {
//     _formKey.currentState!.save();
//     try {
//       UserCredential userCredential;
//       if (isLogin) {
//         userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passController.text.trim(),
//         );
//       } else {
//         userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passController.text.trim(),
//         );
//         // Save new user data to Firestore
//         await FirebaseCrudService().saveUserData(userCredential.user!.uid, {
//           'email': userCredential.user!.email,
//           'highScore': 0,
//           'achievements': [],
//         });
//       }
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => StartScreen()),
//       );
//     } catch (e) {
//       String errorMessage = 'An unexpected error occurred';
//       if (e is FirebaseAuthException) {
//         switch (e.code) {
//           case 'invalid-email':
//             errorMessage = 'The email address is invalid. Please check and try again.';
//             break;
//           case 'user-not-found':
//             errorMessage = 'No user found for that email.';
//             break;
//           case 'wrong-password':
//             errorMessage = 'Incorrect password. Please try again.';
//             break;
//         }
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(errorMessage)),
//       );
//     }
//   }
// }



  void _toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/pics/flappyLogin.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Flappy Bird Game',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          color: Colors.black45,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          isLogin ? 'Login' : 'Sign Up',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: 16),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email, color: Colors.green[800]),
                                  filled: true,
                                  fillColor: Colors.lightGreen[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Email is required';
                                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _passController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock, color: Colors.green[800]),
                                  filled: true,
                                  fillColor: Colors.lightGreen[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              if (!isLogin)
                                Column(
                                  children: [
                                    SizedBox(height: 16),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Confirm Password',
                                        prefixIcon: Icon(Icons.lock_outline, color: Colors.green[800]),
                                        filled: true,
                                        fillColor: Colors.lightGreen[100],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value != _passController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 36),
                                  backgroundColor: Colors.green[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  isLogin ? 'Login' : 'Sign Up',
                                  style: TextStyle(fontSize: 18, color: Colors.yellowAccent),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextButton(
                                onPressed: _toggleForm,
                                child: Text(
                                  isLogin ? 'Don\'t have an account? Sign Up' : 'Already have an account? Login',
                                  style: TextStyle(color: Colors.green[600]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),


              
            ),
          ),
        ],
      ),
    );
  }
}