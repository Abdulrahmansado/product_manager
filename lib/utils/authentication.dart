import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:product_manager/screens/view_product_screen.dart';

class Authentication {

  late final FirebaseApp app;
  late final FirebaseAuth auth;

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    final navigator = Navigator.of(context);
    WidgetsFlutterBinding.ensureInitialized();
    app = await Firebase.initializeApp(
        name: 'product-manager-6b80f',
        options: const FirebaseOptions(
          apiKey: "AIzaSyDNVyYO0lJrF28qgAn3cBUDTItFExpW4G4",
          appId: "1:1055825903032:android:77bda80feeda72b5fa634d",
          messagingSenderId: "1055825903032",
          authDomain: "product-manager-6b80f.feairebaspp.com",
          projectId: "product-manager-6b80f",
          databaseURL: 'https://product-manager-6b80f.firebaseapp.com',
          storageBucket: 'product-manager-6b80f.appspot.com',
          //measurementId: '',
        ));
    print('OSAMA');
    auth = FirebaseAuth.instanceFor(app: app);
    User? user =auth.currentUser;

    if (user != null) {
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => ViewProductScreen(user: user),
        ),
      );
    }

    return app;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    User? user;
    final messenger = ScaffoldMessenger.of(context);
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            messenger.showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            messenger.showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          messenger.showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
