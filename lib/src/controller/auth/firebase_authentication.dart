import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // =========================
  // EMAIL SIGNUP
  // =========================

  Future<UserCredential> signUpWithEmail({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user!.sendEmailVerification();

    await _createUserDocument(
      uid: credential.user!.uid,
      fullName: fullName,
      email: email,
      phone: phone,
      loginMethod: "email",
    );

    return credential;
  }

  // =========================
  // EMAIL LOGIN
  // =========================

  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await updateLastLogin();

    return credential;
  }

  // =========================
  // GOOGLE LOGIN
  // =========================

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.initialize();

      final GoogleSignInAccount account = await signIn.authenticate();

      final auth = account.authentication;

      final credential = GoogleAuthProvider.credential(idToken: auth.idToken);

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
      return null;
    }
  }
  // =========================
  // PHONE LOGIN
  // =========================

  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException e) onFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },

      verificationFailed: onFailed,

      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    final doc = await _db
        .collection("users")
        .doc(userCredential.user!.uid)
        .get();

    if (!doc.exists) {
      await _createUserDocument(
        uid: userCredential.user!.uid,
        fullName: "",
        email: "",
        phone: userCredential.user!.phoneNumber ?? "",
        loginMethod: "phone",
      );
    }

    return userCredential;
  }

  // =========================
  // FORGOT PASSWORD
  // =========================

  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // =========================
  // CHANGE PASSWORD
  // =========================

  Future<void> changePassword(String newPassword) async {
    await _auth.currentUser!.updatePassword(newPassword);
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  Future<void> updateProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection("users").doc(uid).update(data);
  }

  // =========================
  // DELETE ACCOUNT
  // =========================

  Future<void> deleteAccount() async {
    final uid = _auth.currentUser!.uid;

    await _db.collection("users").doc(uid).update({
      "status": "deleted",

      "deletedAt": FieldValue.serverTimestamp(),
    });

    await _auth.signOut();
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize();

    await googleSignIn.disconnect();

    await FirebaseAuth.instance.signOut();
  }

  // =========================
  // GET CURRENT USER
  // =========================

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // =========================
  // IS LOGGED IN
  // =========================

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // =========================
  // UPDATE LAST LOGIN
  // =========================

  Future<void> updateLastLogin() async {
    if (_auth.currentUser == null) {
      return;
    }

    await _db.collection("users").doc(_auth.currentUser!.uid).update({
      "lastLogin": FieldValue.serverTimestamp(),
    });
  }

  // =========================
  // CREATE USER DOC
  // =========================

  Future<void> _createUserDocument({
    required String uid,
    required String fullName,
    required String email,
    required String phone,
    required String loginMethod,
  }) async {
    await _db.collection("users").doc(uid).set({
      "uid": uid,

      "fullName": fullName,

      "email": email,

      "phone": phone,

      "loginMethod": loginMethod,

      "role": "user",

      "status": "active",

      "emailVerified": _auth.currentUser?.emailVerified ?? false,

      "phoneVerified": phone.isNotEmpty,

      "failedLoginAttempts": 0,

      "lockUntil": null,

      "createdAt": FieldValue.serverTimestamp(),

      "updatedAt": FieldValue.serverTimestamp(),

      "lastLogin": FieldValue.serverTimestamp(),
    });
  }
}
