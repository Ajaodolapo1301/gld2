import 'package:flutter/material.dart';
import 'package:glade_v2/pages/business/pos/tabs/pendingRequest.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/widgets/custom_button.dart';

import 'approvedRequest.dart';

class POSHistoryTAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: 20),
          CustomButton(
            text: "Approved Request",
            onPressed: () {
              pushTo(context, ApprovedPos());
            },
            type: ButtonType.outlined,
          ),
          SizedBox(height: 20),
          CustomButton(
            text: "Pending Request",
            onPressed: () {
              pushTo(context, PendingPos());
            },
            type: ButtonType.outlined,
          ),
        ],
      ),
    );
  }
}
