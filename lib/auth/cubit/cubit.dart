import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../car_screen.dart';
import '../scan_family.dart';
import 'state.dart';
class AuthCubit extends Cubit<AuthMainState> {
  AuthCubit() : super(AuthInitState());
  static AuthCubit get(context) => BlocProvider.of(context);
  ValueNotifier<dynamic> result = ValueNotifier(null);
  bool hidePasse=false;
  Map myProfileData={};
  List <String> list= [
    "Insurance",
    "Ministry of Interior",
    "the traffic",
  ];
  List screens=const[
    CardScreen(),
    ScanFamily(),
  ];
  int index=0;
  String userType="Insurance";
  screenCubit(i){
    index=i;
    emit(ScreanState());
  }
  dropDownSubCategory(value){
    userType=value;
    print(userType);
    emit(DropDownSubCategory());
  }
  Map<String,dynamic>  data={};
  hidePass(){
    hidePasse=!hidePasse;
    emit(HidePasswordState());
  }
  signInCubit(emailAddress, password) async {
    emit(EmptyLoginState());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: "$emailAddress@gmail.com", password: password);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    emit(SignInState());
  }

  signUpCubit(emailAddress, password,name,userLayer) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "$emailAddress",
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    print("e");
    createProfile(FirebaseAuth.instance.currentUser!.uid,name,emailAddress,userLayer);
    emit(SignUpState());
  }
  createProfile(uid,name,emailAddress,userLayer)async{
    await FirebaseFirestore.instance.collection("Profile").doc(uid).set(
        {
          "name":name,
          "national_id":emailAddress,
          "userLayer":userLayer,
        }
    );
  }
  myProfile()async{
    await FirebaseFirestore.instance.collection("Profile").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      myProfileData=value.data()!;
    });
    emit(MyProfileState());
  }

  redar(userLayer){
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
      FirebaseFirestore.instance
          .collection("Profile").where("card",isEqualTo: result.value.toString()).get().then((value) {
        notficationFire(value.docs[0].data()["token"],value.docs[0].data()["name"]);
        print("Profile info ${value.docs[0].data()} ");
        value.docs.forEach((element) async{
              element.reference.collection("my_cards").doc(userLayer).get().then((value){
                data= value.data()!;
              });
            });
      });
      FirebaseFirestore.instance
          .collection("Profile").where("card",isEqualTo: result.value.toString()).get().then((value) {
        value.docs.forEach((element) {
          element.reference.collection("my_cards").doc("national_card").get().then((value){
            data=value.data()!;
          });
        });
      });

      FirebaseFirestore.instance
          .collection("Profile").where(
          "card", isEqualTo: result.value.toString())
          .get().then((value) {
        value.docs.forEach((element) {
          element.reference.collection("History")
              .add({"history": DateTime.now().toString()});
        });
      });
      await FirebaseMessaging.instance.getToken().then((value1){
        FirebaseFirestore.instance
          .collection("Profile").where(
          "card", isEqualTo: result.value.toString())
          .get().then((value) {
        value.docs.forEach((element) {
          element.reference.collection("notification")
              .add({
            "Acces": myProfileData["userLayer"],
            "Message":" we need to see your ${myProfileData["userLayer"]}",
            "history": DateTime.now().toString(),
            "token":value1,

          });
        });
      });
      });
    });
    print(data.toString());
    emit(RederState());
  }
  notficationFire(token,name)async{
    String x="";
   await FirebaseMessaging.instance.getToken().then((value){
      print(value);
    });
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAhoUh0pw:APA91bF0F5ZVehD3NOzp4O5nWZkZOWwl0cIxDQ3WN2jRRyZsiABKNizSnyVrY_61phx5dDksasFuvZAxm84tjPyqBunoK-V1UiEe4067lgr_fyXJe_lkmrsP1PtsbWcpakJ41fx61llh',
    };
    final bodyData = {
      'notification': {
        'title': "hi $name we need access to see ${myProfileData["userLayer"]}",
        "data":{
          "admin_token":"ss",
        },
        'body': "aaaaa",
      },
      'to': token,
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(bodyData),
    );
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.body}');
    }

  }

}
