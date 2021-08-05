import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/beneficiaryList.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class BeneficiaryBottomSheet extends StatefulWidget {
  List<BeneficiaryList> beneficiaryList;
  Function(BeneficiaryList beneficiaryList)onBeneficiarySelected;
  BeneficiaryBottomSheet({this.beneficiaryList, this.onBeneficiarySelected});

  @override
  _BeneficiaryBottomSheetState createState() => _BeneficiaryBottomSheetState();
}

class _BeneficiaryBottomSheetState extends State<BeneficiaryBottomSheet> {

TextEditingController textEditingController = TextEditingController();
List<BeneficiaryList> _tempList = [];
String search = "";
  @override
  Widget build(BuildContext context) {
    if (_tempList.isEmpty) {
      // when widget is built and bank list isn't loaded immediately
      setState(() {
        _tempList = widget.beneficiaryList;
      });
    }
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 30,
      ),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    onChanged: (v) {
                      if (v.isNotEmpty) {
                        setState(() {
                          _tempList = widget.beneficiaryList
                              .where((beneficiary) => beneficiary.account_name
                              .toString()
                              .toLowerCase()
                              .contains(v))
                              .toList();
                        });
                      } else {
                        setState(() {
                          _tempList = widget.beneficiaryList;
                        });
                      }
                    },
                    cursorHeight: 18.0,
                    style: TextStyle(
                        color: blue,
                        fontSize: 14
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: "Search",
                      hintStyle: TextStyle(
                        color: blue,
                        fontSize: 14
                      )
                    ),
                  ),
                ),
                SizedBox(width: 10),
             search.isEmpty ?       Icon(
             Icons.search_rounded  ,
                  color: orange,
                  size: 20,
                ) : GestureDetector(
                  onTap: (){
                    setState(() {
                      textEditingController.clear();
                    });

                  },
                  child: Icon(Icons.close,
                    color: orange,
                    size: 20,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderBlue.withOpacity(0.1))
            ),
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Builder(
              builder: (context){
                if(widget.beneficiaryList.isEmpty){
                  return Center(child: Text("No beneficiary saved"),);
                }
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){

                        pop(context);
                        widget.onBeneficiarySelected(_tempList[index]);


                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: borderBlue.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tempList[index].account_name,
                              style: TextStyle(
                                color: blue,


                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                             "${ _tempList[index].account_number} - ${_tempList[index].bank_name}",
                              style: TextStyle(color: blue),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemCount: _tempList.length,
                );
              },

            ),
          ),
        ],
      ),
    );
  }


List<BeneficiaryList> _buildSearchList(String userSearchTerm) {
  List<BeneficiaryList> _searchList = List();

  for (int i = 0; i < widget.beneficiaryList.length; i++) {
    String name = widget.beneficiaryList[i].bank_name;
    // String code = bankList[i].bank_code;
//  print("name ${name}  code ${code}");
    if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
      _searchList.add(widget.beneficiaryList[i]);
    }
  }
  return _searchList;
}

}
