import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualTransaction.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';

class SeeMoreVirtualCardTransactionsPage extends StatefulWidget {
  final List <VirtualCardTransaction> virtualCardTransaction;
  SeeMoreVirtualCardTransactionsPage({this.virtualCardTransaction});
  @override
  _SeeMoreVirtualCardTransactionsPageState createState() => _SeeMoreVirtualCardTransactionsPageState();
}

class _SeeMoreVirtualCardTransactionsPageState extends State<SeeMoreVirtualCardTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Header(
                text: "Card Transactions",
              ),
              SizedBox(height: 10),
              Expanded(
                child: Builder(
                  builder: (context) {
                    bool isEmpty = false;
                    if (widget.virtualCardTransaction.isNotEmpty) {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          return transactionItem(context, widget.virtualCardTransaction[index]);
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 20),
                        itemCount: widget.virtualCardTransaction.length,
                      );
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/images/pig.svg"),
                        SizedBox(height: 5),
                        Text(
                          "No Reserve Fund Yet.",
                          style: TextStyle(
                              color: blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        Text(
                          "Click the button below to create new stash and \nget started",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: blue, fontSize: 11),
                        )
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget transactionItem(BuildContext context, VirtualCardTransaction  virtualCardTransaction) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: lightBlue,
          border: Border.all(
            color: borderBlue.withOpacity(0.05),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                       MyUtils.formatDate(virtualCardTransaction.created_at),
                    style: TextStyle(color: blue, fontSize: 10),
                  ),
                  SizedBox(height: 3),
                  Text(
                    virtualCardTransaction.product,
                    style: TextStyle(color: blue),
                  )
                ],
              ),
            ),
            Text(
              "${virtualCardTransaction.currency} ${virtualCardTransaction.amount.toString()}",
              style: TextStyle(color: blue, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
