import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glade_v2/core/constants.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:overlay_support/overlay_support.dart';

class AccountDetailsView extends StatelessWidget {
  final VoidCallback onTap;
  final LoginState loginState;
  final accountState;
  final BusinessState businessState;
  const AccountDetailsView({
    Key key, @required this.onTap, this.loginState, this.accountState, this.businessState
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: cyan.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: cyan,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  "${loginState.user.firstname[0]} ${loginState.user.lastname[0]}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${loginState.user.firstname} ${loginState.user.lastname}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blue,
                    fontSize: 15,
                  ),
                ),
                Container(
                  width: 170,
                  child: Text(
 accountState  == AccountState.business  ?  "${businessState.business.account_number} -${businessState.business.bank_name}"  :  "${ loginState.user.accountNum} - ${loginState.user.bank_name}",
                    style: TextStyle(
                      color: blue,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.file_copy_rounded,
                color: cyan,
              ),
              onPressed: () {

                Clipboard.setData(
                  new ClipboardData(
                    text:  accountState  == AccountState.business  ?  businessState.business.account_number:  loginState.user.accountNum,
                  ),
                );
                toast("Copied to Clipboard");
              },
            )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: lightBlue,
            border: Border.all(color: borderBlue.withOpacity(0.09))
        ),
      ),
    );
  }
}
