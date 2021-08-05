import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/api/AccountStatement/accountStatement.dart';
import 'package:glade_v2/core/models/apiModels/AirtimeAndBills/airtimeAndBills.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/beneficiaryList.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/transactionHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/Invoice/InvoiceHistory.dart';
import 'package:glade_v2/core/models/apiModels/Business/Invoice/invoice.dart';
import 'package:glade_v2/core/models/apiModels/Business/VirtualCard/VirtualCardModel.dart';
import 'package:glade_v2/core/models/apiModels/Personal/ReserveFund/reserve.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/reuseables/addNote.dart';
import 'package:glade_v2/reuseables/singleTransferWidget.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/AirtimeBeneficiaryBottomSheet.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/add_invoice_item_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/add_recipient_to_bulk_transfer_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/beneficiary_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/cancel_loan_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/more_from_virtual_card_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/paymnet_link_options_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/reserve_funds_actions_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/select_range_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/singleInvoiceBottomSheet.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/single_transaction_bottom_sheet.dart';
import 'package:glade_v2/utils/widgets/bottom_sheets/transaction_pin_bottom_sheet.dart';

var _roundedRectangleBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(25),
    topLeft: Radius.circular(25),
  ),
);

void showTransactionPinBottomSheet(BuildContext context,
    {@required TransactionBottomSheetDetails details,
    @required Function(String pin) onButtonPressed,
    int minuValue}) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return TransactionPinBottomSheet(
        details: details,
        onButtonPressed: onButtonPressed,
        minusValue: minuValue,
      );
    },
  );
}

void showSingleTransactionBottomSheet(BuildContext context, {Color textColor, Statement statement}) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return SingleTransactionBottomSheet(
        textColor: textColor,
        statement: statement,
      );
    },
  );
}



void showSingleInvoiceBottomSheet(BuildContext context, {Color textColor, InvoiceHistory invoiceHistory, BusinessState businessState}) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return SingleInvoiceBottomSheet(
        textColor: textColor,
        invoiceHistory: invoiceHistory,
        businessState: businessState,

      );
    },
  );
}





void showSingleFundTransfer(BuildContext context, {Color textColor, TransferHistory transferHistory}) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return SingleFundTransfer(
        textColor: textColor,
        transferHistory: transferHistory,
      );
    },
  );
}



void showBeneficiaryBottomSheet({BuildContext context, List<BeneficiaryList> beneficiaryList, Function onBeneficiarySelect}) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return BeneficiaryBottomSheet(beneficiaryList: beneficiaryList, onBeneficiarySelected: onBeneficiarySelect,   );
    },
  );
}




void showBeneficiaryBottomSheetAirtime({BuildContext context, List<BeneficiaryAirtime> beneficiaryList, Function onBeneficiarySelect}) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return AirtimeBeneficiaryBottomSheet(beneficiaryList: beneficiaryList, onBeneficiarySelected: onBeneficiarySelect);
    },
  );
}


void showSelectRangeBottomSheet(
    {BuildContext context,
    Function(Map<String, dynamic> value) onDateSelected}) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return SelectRangeBottomSheet( onDateSelected: onDateSelected,);
    },
  );
}

void showAddRecipientToBulkTransferBottomSheet({BuildContext context, Function(Map<String, dynamic>) onBulkItem}) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return AddRecipientToBulkTransferBottomSheet(onBulkItem: onBulkItem,);
    },
  );
}


void showAddInvoiceItemBottomSheet(BuildContext context, {Function(Map<String, dynamic> value) onAddItem}) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return AddInvoiceItemBottomSheet(onAddItem: onAddItem,);
    },
  );
}

void showMoreFromVirtualCardBottomSheet(BuildContext context, VirtualCardModel virtualCardModel, scaffoldKey) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return MoreFromVirtualCardBottomSheet(
        virtualCardModel: virtualCardModel,
        scaffoldKey: scaffoldKey,
      );
    },
  );
}

void showPaymentLinkOptionsBottomSheet(BuildContext context, paymentLinkHistory) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return PaymentLinkOptionsBottomSheet(paymentLinkHistory: paymentLinkHistory,);
    },
  );
}

void showReserveActionsBottomSheet(BuildContext context, ReserveDetails reserveDetails) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return ReserveFundsActionBottomSheet(reserveDetails: reserveDetails,);
    },
  );
}

void showCancelLoanBottomSheet(BuildContext context, {Function(String value) onAddItem} ) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return CancelLoanBottomSheet(onAddItem: onAddItem,);
    },
  );
}



void showAddLoanBottomSheet(BuildContext context, {Function(String value) onAddItem} ) {
  showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: _roundedRectangleBorder,
    isScrollControlled: true,
    builder: (context) {
      return AddNoteLoanBottomSheet(onAddItem: onAddItem,);
    },
  );
}