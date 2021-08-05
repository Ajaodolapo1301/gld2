






import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/AirtimeAndBills/airtimeAndBills.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/beneficiaryList.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';

class AirtimeBeneficiaryBottomSheet extends StatefulWidget {
  List<BeneficiaryAirtime> beneficiaryList;
  Function(BeneficiaryAirtime beneficiaryList)onBeneficiarySelected;
  AirtimeBeneficiaryBottomSheet({this.beneficiaryList, this.onBeneficiarySelected});

  @override
  _AirtimeBeneficiaryBottomSheetState createState() => _AirtimeBeneficiaryBottomSheetState();
}

class _AirtimeBeneficiaryBottomSheetState extends State<AirtimeBeneficiaryBottomSheet> {

  TextEditingController textEditingController = TextEditingController();
  List<BeneficiaryList> _tempList = [];
  String search = "";
  @override
  Widget build(BuildContext context) {

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
                    onChanged: (v){
                      setState(() {
                        search = v;
                      });
                    },
                    cursorHeight: 18.0,
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
                        widget.onBeneficiarySelected(widget.beneficiaryList[index]);


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
                              widget.beneficiaryList[index].title ?? "",
                              style: TextStyle(
                                color: blue,


                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${ widget.beneficiaryList[index].reference} - ${widget.beneficiaryList[index].title}",
                              style: TextStyle(color: blue),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemCount: widget.beneficiaryList.length,
                );
              },

            ),
          ),
        ],
      ),
    );
  }


//   List<BeneficiaryList> _buildSearchList(String userSearchTerm) {
//     List<BeneficiaryList> _searchList = List();
//
//     for (int i = 0; i < widget.beneficiaryList.length; i++) {
//       String name = widget.beneficiaryList[i].bank_name;
//       // String code = bankList[i].bank_code;
// //  print("name ${name}  code ${code}");
//       if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
//         _searchList.add(widget.beneficiaryList[i]);
//       }
//     }
//     return _searchList;
//   }

}
