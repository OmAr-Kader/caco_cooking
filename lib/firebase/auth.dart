import 'dart:async';
import 'package:caco_cooking/common/const.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/firebase_options.dart';
import 'package:caco_cooking/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

////////////////////////////////////✅/////////////////////////**signIn**///////////////////////////////////////////////////////////////////////////////

signIn(email, password, Function(String, String? docId) done, Function(Object?) failed) async {
  try {
    doSignIn(email, password, done, failed);
  } on PlatformException catch (e) {
    failed(e);
  }
}

doSignIn(email, password, Function(String, String? docId) done, Function(Object?) failed) async {
  FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password)
      .then((value) => ensureDoSignIn(value, email, done, failed))
      .catchError((error) => {failed(error)});
}

ensureDoSignIn(UserCredential value, email, Function(String, String? docId) done, Function(Object?) failed) {
  if (value.user != null) {
    fetchDocID(value, email, done, failed);
  } else {
    failed(null);
  }
}

fetchDocID(UserCredential vale, email, Function(String, String? docId) done, Function(Object?) failed) {
  FirebaseFirestore.instance
      .collection(COLLECTION_USER_DETAILS)
      .get()
      .then((value) => ensereFetchDocID(value, vale, email, done, failed))
      .catchError((error) => {failed(error)});
}

ensereFetchDocID(value, UserCredential vale, email, Function(String, String? docId) done, Function(Object?) failed) {
  if (value.docs.isNotEmpty) {
    doFetchDocID(value, email, (user, docID) => messageToken(user, docID, done, failed), failed);
  } else {
    failed(null);
  }
}

messageToken(UserBase userBase, String? docID, Function(String, String? docId) done, Function(Object?) failed) {
  if (docID == null) {
    failed(null);
  }
  if (kIsWeb) {
    done(userBase.id, docID);
    return;
  }
  FirebaseMessaging.instance
      .getToken(vapidKey: KEY_PAIR)
      .then((newToken) => ensureToken(newToken, userBase, docID!, done, failed)).catchError((error) => failed(error));
}

ensureToken(String? newToken, UserBase userBase, String docID, Function(String, String? docId) done, Function(Object?) failed) {
  if (newToken != null) {
    updateToken(UserBase.toRegBackToken(newToken: newToken, user: userBase), docID, done, failed);
  } else {
    failed(null);
  }
}

updateToken(UserBase userBase, String docID, Function(String, String? docId) done, Function(Object?) failed) async {
  FirebaseFirestore.instance
      .collection(COLLECTION_USER_DETAILS)
      .doc(docID)
      .update(userBase.toJson())
      .then((value) => done(userBase.id, docID))
      .catchError((error) => failed(error));
}

doFetchDocID(QuerySnapshot<Map<String, dynamic>> an, String email, Function(UserBase user, String? docId) done, Function(Object?) failed) {
  List<Map<String, UserBase>> a = listOfMap(an);
  Map<String, UserBase>? element = a.find((it) => email == it.values.first.email);
  element != null ? done(element.values.first, element.keys.first) : failed(null);
}

List<Map<String, UserBase>> listOfMap(QuerySnapshot<Map<String, dynamic>> a) {
  return a.docs.map((e) => <String, UserBase>{ e.id: UserBase.fromJson(e.data(), e.id)}).toList();
}

signInWithGmail(Function(String, String? docId) done, Function(Object?) failed) {
  GoogleSignIn(scopes: <String>["email"]).signIn()
      .then((value) => ensureSignIn(value, done, failed))
      .catchError((error) => failed(error));
}

ensureSignIn(GoogleSignInAccount? valu, Function(String, String? docId) done, Function(Object?) failed) {
  if (valu != null) {
    valu.authentication
        .then((value) => doneForSignIn(value, valu.email, done, failed))
        .catchError((error) => failed(error));
  } else {
    failed(null);
  }
}

doneForSignIn(GoogleSignInAuthentication value, String email, Function(String, String? docId) done, Function(Object?) failed) {
  FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(accessToken: value.accessToken, idToken: value.idToken))
      .then((value) => fetchDocID(value, email, done, failed))
      .catchError((error) => failed(error));
}

/////////////////////////////////////////////////////////////**register**/////////////////////////////////////////////////////////////////////////////

register(UserBase user, password, Function(UserBase?, String? docId) done, Function(Object?) failed) {
  try {
    doRegister(user, password, done, failed);
  } on PlatformException catch (e) {
    failed(e);
  }
}

doRegister(UserBase user, password, Function(UserBase?, String? docId) done, Function(Object?) failed) {
  FirebaseAuth.instance
      .fetchSignInMethodsForEmail(user.email)
      .then((value) => ensuerdoRegister(value, user, password, done, failed))
      .catchError((error) => failed(error));
}

ensuerdoRegister(List<String> value, UserBase user, password, Function(UserBase?, String? docId) done, Function(Object?) failed) {
  if (value.isEmpty) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: user.email, password: password)
        .then((value) => ensureCreateUserWithEmailAnd(value, user, done, failed))
        .catchError((error) => failed(error));
  } else {
    sigInstadIfRegister(user, password, done, failed);
  }
}

ensureCreateUserWithEmailAnd(UserCredential value, UserBase u, Function(UserBase?, String? docId) done, Function(Object?) failed) {
  if (value.user != null) {
    registerMessage(UserBase.toRegBack(newId: value.user!.uid, user: u), done, failed);
  } else {
    failed(null);
  }
}

sigInstadIfRegister(UserBase user, password, Function(UserBase?, String docId) done, Function(Object?) failed) {
  FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: password)
      .then((value) => ensureSigInstadIfRegister(value, user, done, failed))
      .catchError((error) => done(null, user.id)); // Already Registered
}

ensureSigInstadIfRegister(UserCredential value, UserBase user, Function(UserBase?, String docId) done, Function(Object?) failed) {
  if (value.user != null) {
    registerMessage(UserBase.toRegBack(newId: value.user!.uid, user: user), done, failed);
  } else {
    done(null, user.id); // Already Registered
  }
}

registerMessage(UserBase user, Function(UserBase?, String docId) done, Function(Object?) failed) async {
  if (kIsWeb) {
    saveRegisterUser(user, done, failed);
  } else {
    FirebaseMessaging.instance
        .getToken(vapidKey: KEY_PAIR)
        .then((newToken) => ensureRegisterMessage(newToken, user, done, failed)).catchError((error) => failed(error));
  }
}

ensureRegisterMessage(String? newToken, UserBase user, Function(UserBase?, String docId) done, Function(Object?) failed) {
  if (newToken != null) {
    saveRegisterUser(UserBase.toRegBackToken(newToken: newToken, user: user), done, failed);
  } else {
    failed(null);
  }
}

saveRegisterUser(UserBase user, Function(UserBase?, String docId) done, Function(Object?) failed) async {
  FirebaseFirestore.instance
      .collection(COLLECTION_USER_DETAILS)
      .add(user.toJson())
      .then((value) => done(user, value.id))
      .catchError((error) => failed(error));
}

udpaterUser(UserBase user, Function(UserBase userBase) done, Function(Object?) failed) async {
  FirebaseFirestore.instance
      .collection(COLLECTION_USER_DETAILS)
      .doc(user.idDoc)
      .update(user.toJson())
      .then((value) => done(user))
      .catchError((error) => failed(error));
}

registerWithGmail(UserBase user, Function(UserBase?, String? docId) done, Function(Object?) failed) {
  //, "https://www.googleapis.com/auth/userinfo.profile"
  GoogleSignIn(
      scopes: <String>["email"], clientId: FETCH_CLIENT_ID)
      .signIn()
      .then((value) => ensureRegister(value, user, done, failed))
      .catchError((error) => failed(error));
}

ensureRegister(GoogleSignInAccount? valu, UserBase us, Function(UserBase?, String? docId) done, Function(Object?) failed) {
  if (valu != null && valu.displayName != null) {
    UserBase u = UserBase.toFullGmail(user: us, newName: valu.displayName!, newEmail: valu.email);
    valu.displayName;
    valu.authentication
        .then((value) => doneForRegister(value, u, done, failed))
        .catchError((error) => failed(error));
  } else {
    failed(null);
  }
}

doneForRegister(GoogleSignInAuthentication value, UserBase u, Function(UserBase?, String docId) done, Function(Object?) failed) {
  FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(accessToken: value.accessToken, idToken: value.idToken))
      .then((value) => registerMessage(UserBase.toRegBack(newId: value.user!.uid, user: u), done, failed))
      .catchError((error) => failed(error));
}

/////////////////////////////////////////////////////////////**fetchUserDetails**/////////////////////////////////////////////////////////////////////

Future<UserBase?> fetchUserDetails({required String? docID}) async {
  if (docID == null) {
    return null;
  } else {
    try {
      return fetchUserDetailsFirebase(docID: docID);
    } on PlatformException catch (_) {
      return null;
    }
  }
}

Future<UserBase?> fetchUserDetailsFirebase({required String? docID}) async {
  if (docID == null) {
    return null;
  } else {
    final a = await FirebaseFirestore.instance.collection(COLLECTION_USER_DETAILS).doc(docID).get();
    final da = a.data();
    if (da == null) {
      return null;
    } else {
      return UserBase.fromJson(da, a.id);
    }
  }
}

Future<List<UserBase>?> fetchAllUserNow() async {
  try {
    return fetchAllUserNowFirebase();
  } on PlatformException catch (_) {
    return null;
  }
}

Future<List<UserBase>?> fetchServerUserNow(String currentDocid) async {
  try {
    final a = await FirebaseFirestore.instance.collection(COLLECTION_USER_DETAILS)
        .where('userType', isEqualTo: 2)
        .get();
    if (a.docs.isNotEmpty) {
      return listWithId(a).filter((user) => user.idDoc != currentDocid);
    } else {
      return null;
    }
  } on PlatformException catch (_) {
    return null;
  }
}

Future<List<UserBase>?> fetchAllUserNowFirebase() async {
  try {
    final a = await FirebaseFirestore.instance.collection(COLLECTION_USER_DETAILS).get();
    if (a.docs.isNotEmpty) {
      return list(a);
    } else {
      return null;
    }
  } catch (_) {
    return null;
  }
}

fetchAllUser(Function(List<UserBase> list) done, Function(Object?) failed) {
  try {
    FirebaseFirestore.instance
        .collection(COLLECTION_USER_DETAILS)
        .get()
        .then((value) => ensureFetchAllUser(value, done, failed))
        .catchError((error) => failed(error));
  } catch (e) {
    failed(e);
  }
}

ensureFetchAllUser(QuerySnapshot<Map<String, dynamic>> value, Function(List<UserBase> list) done, Function(Object?) failed) {
  if (value.docs.isNotEmpty) {
    done(list(value));
  } else {
    failed(null);
  }
}

List<UserBase> list(QuerySnapshot<Map<String, dynamic>> a) => a.docs.map((e) => UserBase.fromJson(e.data(), e.id)).toList();

List<UserBase> listWithId(QuerySnapshot<Map<String, dynamic>> a) => a.docs.map((e) => UserBase.fromJson(e.data(), e.id)).toList();

signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    logProv(e, tag: signOut);
  }
}