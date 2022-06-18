import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

import 'user_details.dart' as details;

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Register',
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.

            // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),

            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: Colors.white,

            // brightness: Brightness.dark,

            primaryColor: Colors.deepPurple,
            fontFamily: 'Georgia',
            textTheme: TextTheme(
              headline1: const TextStyle(fontSize: 50.0),
              bodyText1: GoogleFonts.raleway(),
            )),
        home: SplashScreen(
          seconds: 5,
          navigateAfterSeconds:
              const MyHomePage(title: 'App Registration Page'),
          title: const Text(
            'SplashScreen Page',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
  final nameInputController = TextEditingController();
  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();

  String errorMessage = "";
  bool valid = true;

  void dispose() {
    nameInputController.dispose();
    emailInputController.dispose();
    passwordInputController.dispose();
    confirmPasswordInputController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    errorMessage = "";
    valid = true;

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailInputController.text,
        password: passwordInputController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address entered is invalid.';
      }
      valid = false;
    }

    if (valid) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MyLoginPage(title: 'Login Page')));

      details.fullName = nameInputController.text;
      details.emailAddress = emailInputController.text;
      details.password = passwordInputController.text;
    }
  }

  void _registerUser() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _authenticate();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Name and Surname',
              textAlign: TextAlign.left,
              // textScaleFactor: 1.25,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              width: 500,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your full name here',
                  labelText: 'Full Name',
                ),
                controller: nameInputController,
              ),
            ),
            Text(
              'Email Address',
              textAlign: TextAlign.left,
              // textScaleFactor: 1.25,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              width: 500,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email address here',
                  labelText: 'Email Address',
                ),
                controller: emailInputController,
              ),
            ),
            Text(
              'Password',
              textAlign: TextAlign.left,
              // textScaleFactor: 1.25,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              width: 500,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password here',
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ),
            Text(
              'Confirm Password',
              textAlign: TextAlign.left,
              // textScaleFactor: 1.25,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              width: 500,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Confirm your password here',
                  labelText: 'Confirm Password',
                ),
                controller: passwordInputController,
                obscureText: true,
              ),
            ),
            SizedBox(
                width: 500,
                child: Text(errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 30),
            ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Register',
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: _registerUser,
                      child: const Text('Register'),
                    ),
                  ),
                ]))
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _registerUser,
      //   tooltip: 'Register',
      //   child: const Icon(Icons.app_registration_sharp),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation
      //     .centerDocked, // This trailing comma makes auto-formatting nicer for build methods.
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();

  String errorMessage = "";
  bool valid = true;

  void dispose() {
    emailInputController.dispose();
    passwordInputController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    valid = true;

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailInputController.text,
          password: passwordInputController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email entered is not valid';
      }
      valid = false;
    }

    if (valid) {
      errorMessage = "";
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MyDashboard(title: 'Dashboard')));
    }
  }

  void _loginUser() {
    setState(() {
      _signIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Email Address',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              width: 500,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your account email here',
                  labelText: 'Account Email',
                ),
                controller: emailInputController,
              ),
            ),
            Text(
              'Password',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              width: 500,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your account password here',
                  labelText: 'Password',
                ),
                controller: passwordInputController,
                obscureText: true,
              ),
            ),
            SizedBox(
                width: 500,
                child: Text(errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 30),
            ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 153, 132, 189),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Login',
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: _loginUser,
                      child: const Text('Login'),
                    ),
                  ),
                ]))
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _goToDashboard,
//        tooltip: 'Login',
//        child: const Icon(Icons.app_registration_sharp),
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation
//          .centerDocked, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyDashboard extends StatefulWidget {
  const MyDashboard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.featured_play_list),
            tooltip: "Feature 1",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyFeatureOne(title: 'Feature 1 Page')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.featured_play_list),
            tooltip: "Feature 2",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyFeatureTwo(title: 'Feature 2 Page')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Open Profile",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyProfilePage(title: 'Profile Page')));
            },
          ),
        ],
      ),
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Dashboard',
              textAlign: TextAlign.left,
              textScaleFactor: 2,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyFeatureTwo extends StatefulWidget {
  const MyFeatureTwo({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyFeatureTwo> createState() => _MyFeatureTwoState();
}

class _MyFeatureTwoState extends State<MyFeatureTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu_open),
            tooltip: "Open Dashboard",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyDashboard(title: 'Dashboard Page')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Open Profile",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyProfilePage(title: 'Profile Page')));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Feature 2',
              textAlign: TextAlign.left,
              textScaleFactor: 2,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyFeatureOne extends StatefulWidget {
  const MyFeatureOne({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyFeatureOne> createState() => _MyFeatureOneState();
}

class _MyFeatureOneState extends State<MyFeatureOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu_open),
            tooltip: "Open Dashboard",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyDashboard(title: 'Dashboard Page')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Open Profile",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyProfilePage(title: 'Profile Edit')));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Feature 1',
              textAlign: TextAlign.left,
              textScaleFactor: 2,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final nameInputController = TextEditingController();
  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();

  void dispose() {
    nameInputController.dispose();
    emailInputController.dispose();
    passwordInputController.dispose();
    confirmPasswordInputController.dispose();
    super.dispose();
  }

  void _confirmChanges() {
    details.fullName = nameInputController.text;
    details.emailAddress = emailInputController.text;
    details.password = passwordInputController.text;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyDashboard(title: 'Dashboard Page')));
  }

  @override
  Widget build(BuildContext context) {
    nameInputController.text = details.fullName;
    emailInputController.text = details.emailAddress;
    // passwordInputController.text = details.password;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Edit Name and Surname',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              width: 500,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your full name here',
                ),
                controller: nameInputController,
              ),
            ),
            Text(
              'Edit Email Address',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              width: 500,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your new email address here',
                ),
                controller: emailInputController,
              ),
            ),
            Text(
              'Edit Password',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              width: 500,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your new password here',
                ),
                controller: passwordInputController,
                obscureText: true,
              ),
            ),
            Text(
              'Confirm New Password',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              width: 500,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Confirm your new password here',
                ),
                controller: confirmPasswordInputController,
                obscureText: true,
              ),
            ),
            const SizedBox(height: 30),
            ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Confirm Changes',
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: _confirmChanges,
                      child: const Text('Confirm Changes'),
                    ),
                  ),
                ]))
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) =>
//                      const MyDashboard(title: 'Dashboard Page')));
//        },
//        tooltip: 'Confirm Changes',
//        child: const Icon(Icons.confirmation_num),
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation
//          .centerDocked, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
