
import 'dart:convert';

import 'package:flutter/cupertino.dart';

class States{
int state_id;
 String  state_name;


 States({this.state_id, this.state_name});
 factory States.fromJson(Map <String,  dynamic> json) => States(
   state_id: json["state_id"],

   state_name: json["state_name"],
 );



}

// "id": 277,
// "state_id": 15,
// "city_name": "Balanga",
// "city_id": 277,
// "status": 1,

class LGA{
  int id;
  int  state_id;
  String city_name;
  int city_id;



  LGA({this.id, this.state_id,this.city_id, this .city_name});
  factory LGA.fromJson(Map <String,  dynamic> json) => LGA(
    id: json["id"],
    city_name: json["city_name"],
  );



}