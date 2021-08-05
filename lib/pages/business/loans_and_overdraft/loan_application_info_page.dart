import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/loanHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/LoanAndOverdraft/noteModel.dart';
import 'package:glade_v2/provider/Business/loanAndOverdraftState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/reuseables/chatPills.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';
import 'package:glade_v2/utils/widgets/custom_text_field.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LoansApplicationInfoPage extends StatefulWidget {

  CreditHistory creditHistory;

  LoansApplicationInfoPage({this.creditHistory});
  @override
  _LoansApplicationInfoPageState createState() =>
      _LoansApplicationInfoPageState();
}

class _LoansApplicationInfoPageState extends State<LoansApplicationInfoPage> with TickerProviderStateMixin, AfterLayoutMixin<LoansApplicationInfoPage> {
  LoanAndOverdraftState loanAndOverdraftState;
  TextEditingController note = TextEditingController();
  ScrollController controller = ScrollController();
  LoginState loginState;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String newNote;
  bool isLoading = false;
List<NoteModel> notes = [];
  bool isGetNoteLoading = false;
  String reason;
  bool isCancelled = false;
  @override
  void initState() {
    // controller.animateTo(controller.position.maxScrollExtent,
    //     duration: Duration(seconds: 2), curve: Curves.easeIn);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    loanAndOverdraftState = Provider.of<LoanAndOverdraftState>(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Header(
                text: "Application Info",
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Amount",
                                style: TextStyle(
                                  color: blue,
                                ),
                              ),
                            ),
                            Text(
                             MyUtils.formatAmount(widget.creditHistory.amount),
                              style: TextStyle(
                                color: blue,
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Type",
                                style: TextStyle(
                                  color: blue,
                                ),
                              ),
                            ),
                            Text(
                                CommonUtils.capitalize(widget.creditHistory.type),
                              style: TextStyle(
                                color: blue,
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Date",
                                style: TextStyle(
                                  color: blue,
                                ),
                              ),
                            ),
                            Text(
                            MyUtils.formatDate(widget.creditHistory.created_at),
                              style: TextStyle(
                                color: blue,
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Status",
                                style: TextStyle(
                                  color: blue,
                                ),
                              ),
                            ),
                            // 'pending','under-review','awaiting-user-response','approved','active','paused','cancelled','rejected','closed'
                            Text(
                              CommonUtils.capitalize(widget.creditHistory.status),
                              style: TextStyle(
                                color: widget.creditHistory.status == "pending" || widget.creditHistory.status == "pause" ||   widget.creditHistory.status == "awaiting-user-response" || widget.creditHistory.status == "under-review"   ?  Colors.yellow[900] :
                                widget.creditHistory.status == "approved" || widget.creditHistory.status == "active" ? Colors.green
                                    : widget.creditHistory.status == "cancelled" || widget.creditHistory.status == "rejected" || widget.creditHistory.status == "closed" ?Colors.red : Colors.black12  ,
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Reason",
                                style: TextStyle(
                                  color: blue,
                                ),
                              ),
                            ),
                            Text(
                              widget.creditHistory.details,
                              style: TextStyle(
                                color: blue,
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 20),
                      ],
                    ),


                    isCancelled || widget.creditHistory.status == "cancelled" ? SizedBox() :    Text("Notes",   style: TextStyle(color: blue, fontSize: 12),),
                    SizedBox(height: 4),
                    isCancelled || widget.creditHistory.status == "cancelled" ? SizedBox() :      Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: borderBlue.withOpacity(0.5)),
                          color: lightBlue,
                          borderRadius: BorderRadius.circular(5)),
                      height: 100,

                      child:isGetNoteLoading  ? CupertinoActivityIndicator() : notes.length == 0 ?  Text("No notes") :  SingleChildScrollView(
                        reverse: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                        controller: controller ,
                          itemCount: notes.length,
                          itemBuilder: (context ,index){
                            return buildSingleMessage(noteModel: notes[index], message: notes[index].remark );
                          },
                        ),
                      )
                    ),





                    Divider(),
                    SizedBox(height: 20),

                    // Column(
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Expanded(
                    //           child: Text(
                    //             "Note",
                    //             style: TextStyle(
                    //               color: blue,
                    //             ),
                    //           ),
                    //         ),
                    //         Text(
                    //           widget.creditHistory.details,
                    //           style: TextStyle(
                    //             color: blue,
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //     Divider(),
                    //     SizedBox(height: 20),
                    //   ],
                    // ),

                      // Column(
                      //   children: notes.map((e) {
                      //     return Text(e.remark);
                      //   }).toList(),
                      // ),







                  ],
                ),
              ),
              isCancelled || widget.creditHistory.status == "cancelled" ? SizedBox() :
              CustomButton(
                text: isLoading ? "Adding ... Please Wait " : "Add note",
                onPressed: () {
                  // if(_formKey.currentState.validate()){
                  //       setState(() {
                  //         note.clear();
                  //       });
                  //     addNewNote();
                  // }

                  showAddLoanBottomSheet(context, onAddItem: (v){
                    print(v);
                    setState(() {
                      newNote = v;
                      if(newNote.isNotEmpty || reason != null){
                        addNewNote();
                      }
                    });

                  });

                },
                color: cyan,
              ),
              SizedBox(height: 10),


              isCancelled  || widget.creditHistory.status == "cancelled" ? SizedBox() :      CustomButton(
                onPressed: () {
                  showCancelLoanBottomSheet(context, onAddItem: (v){
                    print(v);
                      setState(() {
                        reason = v;

                        if(reason.isNotEmpty || reason != null){

                          cancelCredit();
                        }
                      });

                  });
                },
                text: "Cancel",
                type: ButtonType.outlined,
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


  void addNewNote()async{
    setState(() {
      isLoading = true;
    });
    var result = await loanAndOverdraftState.addNote(token: loginState.user.token, credit_id: widget.creditHistory.id, narration: newNote, business_uuid: loginState.user.business_uuid);

    setState(() {
      isLoading = false;
    });
        if(result["error"] == false){
          setState(() {
            getNewNote2();
            // notes.add(NoteModel(remark:newNote, admin_user: null, created_at: DateTime.now()));
          });
        }else{
          CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
        }
  }

  void getNewNote()async{
    setState(() {
      isGetNoteLoading = true;
    });
    var result = await loanAndOverdraftState.getNote(token: loginState.user.token, credit_id: widget.creditHistory.id,  business_uuid: loginState.user.business_uuid);

    setState(() {
      isGetNoteLoading = false;
    });
    if(result["error"] == false){
      setState(() {
        notes = result["noteModel"];
      });
    }else{

    }
  }

  void getNewNote2()async{

    var result = await loanAndOverdraftState.getNote(token: loginState.user.token, credit_id: widget.creditHistory.id,  business_uuid: loginState.user.business_uuid);


    if(result["error"] == false){
      setState(() {
        notes = result["noteModel"];
      });
    }else{

    }
  }




  void cancelCredit()async{
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
    var result = await loanAndOverdraftState.cancelLoan(token: loginState.user.token, credit_id: widget.creditHistory.id, reason: reason, business_uuid: loginState.user.business_uuid);
    pop(context);
    setState(() {
      isLoading = false;
    });
    if(result["error"] == false){
      setState(() {
        isCancelled = true;
widget.creditHistory.status = "cancelled";
        CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.green );
      });
    }else{
      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:_scaffoldKey, snackColor: Colors.red );
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
  getNewNote();
  }







}
