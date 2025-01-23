// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
// // import 'package:flappy_bird/Layouts/Widgets/widget_bird.dart';
// // import 'package:flappy_bird/Resources/strings.dart';
// import 'package:flappy_bird_main/Layouts/Widgets/widget_bird.dart';
// import 'package:flappy_bird_main/Resources/strings.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../../Global/constant.dart';
// import '../../Global/functions.dart';
// import '../Widgets/widget_gradient _button.dart';

// class StartScreen extends StatefulWidget {
//   const StartScreen({Key? key}) : super(key: key);
//   @override
//   State<StartScreen> createState() => _StartScreenState();
// }
// class _StartScreenState extends State<StartScreen> {

//   final myBox = Hive.box('user');

//   @override
//   void initState() {
//     // Todo : initialize the database  <---
//     init();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery
//         .of(context)
//         .size;
//     return Scaffold(
//       body: Container(
//         width: size.width,
//         height: size.height,
//         decoration: background(Str.image),
//         child: Column(
//           children: [
//             // Flappy bird text
//             Container(
//               margin: EdgeInsets.only(top: size.height * 0.25),
//                 child: myText("FlappyBird", Colors.white,70)),
//             Bird(yAxis, birdWidth, birdHeight),
//             _buttons(),
//             AboutUs(size: size,)
//           ],
//         ),
//       ),
//     );
//   }
// }

// // three buttons
// Column _buttons(){
//   return Column(
//     children: [
//       Button(buttonType: "text",height: 60,width: 278,icon: Icon(Icons.play_arrow_rounded,size: 60,color: Colors.green,),page: Str.gamePage,),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Button(buttonType: "icon",height: 60,width: 110,icon: Icon(Icons.settings,size: 40,color: Colors.grey.shade900,),page: Str.settings,),
//           Button(buttonType: "icon",height: 60,width: 110,icon: Icon(Icons.star,size: 40,color: Colors.deepOrange,),page: Str.rateUs,),
//         ],
//       ),
//     ],
//   );
// }

// class AboutUs extends StatelessWidget {
//   final Size size;
//   AboutUs({required this.size,Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       margin: EdgeInsets.only(top: size.height * 0.2),
//       child: GestureDetector(onTap: (){
//         showDialog(context: context, builder: (context) {
//           return dialog(context);
//         },);
//       },child: myText("About Us",Colors.white,20)),
//     );
//   }
// }
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
import 'package:flappy_bird_main/Layouts/Widgets/widget_bird.dart';
import 'package:flappy_bird_main/Resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../Global/constant.dart';
import '../../Global/functions.dart';
import '../Widgets/widget_gradient _button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final myBox = Hive.box('user'); // Hive box for user data
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    // Fetch user data from Hive
    setState(() {
      userData = {
        'email': myBox.get('email', defaultValue: 'Guest'),
        'highScore': myBox.get('highScore', defaultValue: 0),
        'achievements': myBox.get('achievements', defaultValue: ['First Flight']),
      };
    });
  }

  void updateHighScore(int newScore) {
    // Update high score in Hive if the new score is greater
    if (newScore > userData['highScore']) {
      setState(() {
        userData['highScore'] = newScore;
        myBox.put('highScore', newScore);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: background(Str.image),
        child: Column(
          children: [
            ProfileHeader(userData: userData, onEditProfile: (String newEmail) {
              setState(() {
                userData['email'] = newEmail;
                myBox.put('email', newEmail);
              });
            }),
            // Flappy Bird text
            Container(
              margin: EdgeInsets.only(top: size.height * 0.1),
              child: myText("FlappyBird", Colors.white, 70),
            ),
            Bird(yAxis, birdWidth, birdHeight),
            _buttons(),
            AchievementsDisplay(achievements: userData['achievements']),
            AboutUs(size: size),
            ElevatedButton(
              onPressed: () {
                // Mock updating the high score for testing
                updateHighScore(userData['highScore'] + 10); // Increment by 10
              },
              child: Text("Test Update High Score"),
            ),
          ],
        ),
      ),
    );
  }
}


// ProfileHeader with Edit Button
class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Function(String) onEditProfile;

  const ProfileHeader({required this.userData, required this.onEditProfile, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${userData['email']}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 5),
              Text(
                'High Score: ${userData['highScore']}',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  // Open dialog to edit email
                  showDialog(
                    context: context,
                    builder: (context) {
                      String newEmail = '';
                      return AlertDialog(
                        title: Text("Edit Profile"),
                        content: TextField(
                          decoration: InputDecoration(hintText: "Enter new email"),
                          onChanged: (value) {
                            newEmail = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              onEditProfile(newEmail);
                            },
                            child: Text("Save"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Icon(Icons.account_circle, size: 40, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}

// Achievements Display
class AchievementsDisplay extends StatelessWidget {
  final List<dynamic> achievements;

  const AchievementsDisplay({required this.achievements, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Achievements",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: achievements
                .map((achievement) => Chip(
                      label: Text(
                        achievement,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.deepOrange,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// Buttons for Play, Settings, and Rate Us
Column _buttons() {
  return Column(
    children: [
      Button(
        buttonType: "text",
        height: 60,
        width: 278,
        icon: Icon(Icons.play_arrow_rounded, size: 60, color: Colors.green),
        page: Str.gamePage,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Button(
            buttonType: "icon",
            height: 60,
            width: 110,
            icon: Icon(Icons.settings, size: 40, color: Colors.grey.shade900),
            page: Str.settings,
          ),
          // Button(
          //   buttonType: "icon",
          //   height: 60,
          //   width: 110,
          //   icon: Icon(Icons.star, size: 40, color: Colors.deepOrange),
          //   // page: Str.rateUs,
          // ),
        ],
      ),
    ],
  );
}

// About Us Section
class AboutUs extends StatelessWidget {
  final Size size;

  AboutUs({required this.size, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.2),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return dialog(context);
            },
          );
        },
        child: myText("About Us", Colors.white, 20),
      ),
    );
  }
}
//Start screen