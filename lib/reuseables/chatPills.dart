


import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/noteModel.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';




Widget buildSingleMessage( {int num,  String message, NoteModel noteModel}) {
  return Row(
    mainAxisAlignment:  noteModel.admin_user != null ? MainAxisAlignment.start : MainAxisAlignment.end,
    children: <Widget>[
      Flexible(
        child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),


            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                    child: Text(message, style: TextStyle(color: blue , fontSize: 10),)),

                SizedBox(
                  width: 8.0,
                ),

                Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Text(
                    MyUtils.formatTime(noteModel.created_at),
                    style: TextStyle(fontSize: 8.0, color: orange),
                  ),
                ),

                SizedBox(
                  width: 8.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Text(
                    noteModel.admin_user != null ? "Admin": "You" ,
                    style: TextStyle(fontSize: 10.0, color: Colors.grey),
                  ),
                ),
              ],
            )),
      ),
    ],
  );
}