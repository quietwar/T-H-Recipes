import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:food_app/model/state.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:food_app/register/register_form.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();


Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }


  Future<void> signInWithCredentials(String fullName, String userName, String celly, String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      //userName: userName,
      email: email,
      password: password,
    );
  }

  Future<void> signUp({String fullName, String userName, String celly, String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      // userName: userName,
      // fullName: fullName,
      // celly: celly,
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }
}

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;
  final Widget data;

  StateWidget({
    @required this.child,
    this.state, this.data,

    
  });

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   return null;
  // }
static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
            as _StateDataWidget)
        .data;
  }
  

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  
   
  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      //initUser();
      
    }
  }

  Future<List<String>> getFavorites() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('favorites') &&
        querySnapshot.data['favorites'] is List) {
      // Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot.data['favorites']);
    }
    return [];
  }
 

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}