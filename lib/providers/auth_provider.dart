import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Import Firestore

class AuthManager extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance
  User? _user;
  bool _isLoading = false;
  String? _role; // New local variable for role

  AuthManager() {
    _initAuth();
  }

  void _initAuth() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        // Fetch role if user is logged in
        _fetchUserRole(user.uid);
      }
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get role => _role; // Getter for role

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
    } catch (e) {
      // Handle sign-in errors
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      await _auth.signOut();
      _user = null;
      _role = null; // Clear role on sign out
    } catch (e) {
      // Handle sign-out errors
      debugPrint('Error signing out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      //Handle Error
      debugPrint('Password Reset failed');
    }
  }

  Future<void> _fetchUserRole(String uid) async {
    try {
      // Fetch user document from Firestore
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        // If user document exists, get role field
        _role = userSnapshot['role'];
        notifyListeners(); // Notify listeners after role is fetched
      }
    } catch (e) {
      // Handle error
      debugPrint('Error fetching user role: $e');
    }
  }
}
