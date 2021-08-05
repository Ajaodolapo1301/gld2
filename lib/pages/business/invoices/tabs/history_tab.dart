import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:glade_v2/core/models/apiModels/Business/Invoice/InvoiceHistory.dart';
import 'package:glade_v2/provider/Business/addBusinessState.dart';
import 'package:glade_v2/provider/Business/invoiceState.dart';
import 'package:glade_v2/provider/appState.dart';
import 'package:glade_v2/provider/loginState.dart';
import 'package:glade_v2/utils/functions/bottom_sheet_utils.dart';
import 'package:glade_v2/utils/functions/commonUtils.dart';
import 'package:glade_v2/utils/myUtils/myUtils.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/loader/preloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart' as Page;
import 'package:pdf/widgets.dart' as PdfWid;
class InvoiceHistoryTab extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  InvoiceHistoryTab({this.scaffoldKey});
  @override
  _InvoiceHistoryTabState createState() => _InvoiceHistoryTabState();
}

class _InvoiceHistoryTabState extends State<InvoiceHistoryTab> with AfterLayoutMixin<InvoiceHistoryTab> {
  InvoiceState invoiceState;
  LoginState  loginState;
  BusinessState businessState;
List<InvoiceHistory> history = [];
  // List<InvoiceItemsModel> itemsModel = [];
bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    invoiceState = Provider.of<InvoiceState>(context);
    loginState = Provider.of<LoginState>(context);
    businessState = Provider.of<BusinessState>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child:  Column(
        children: [
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showSelectRangeBottomSheet(context: context, onDateSelected: (v){

              } );
            },
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: orange,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Select Range",
                    style: TextStyle(
                      color: blue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
    isLoading ? CircularProgressIndicator() :      Expanded(
            child: Builder(builder: (context) {
              bool isEmpty = false;
              if (history.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      "No history yet.",
                      style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    Text(
                      "Make transactions to see history",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: blue, fontSize: 11),
                    )
                  ],
                );
              }
              return ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 20,
                ),
                itemCount: history.length,
                itemBuilder: (context, index) {

                  // return Text("");
                  return invoiceItem(context, history[index]);
                  // );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget invoiceItem(BuildContext context, InvoiceHistory invoiceHistory ) {
    return GestureDetector(
      onTap: () {
        showSingleInvoiceBottomSheet(context, textColor: orange, invoiceHistory: invoiceHistory, businessState: businessState);
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
                   MyUtils.formatDate(invoiceHistory.created_at) ,
                    style: TextStyle(color: blue, fontSize: 10),
                  ),
                  SizedBox(height: 3),
                  Text(
                    invoiceHistory.invoice_no ?? "",
                    style: TextStyle(color: blue),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  invoiceHistory.total_value,
                  style: TextStyle(color: blue, fontWeight: FontWeight.bold),
                ),
                 SizedBox(height: 3),
                  Text(
                    invoiceHistory.status,
                    style: TextStyle(color: blue, fontSize: 12),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
      getHistory();
  }

  getHistory() async{
      setState(() {
        isLoading = true;
      });
    var result = await invoiceState.history(token: loginState.user.token, business_uuid: businessState.business.business_uuid);
      setState(() {
        isLoading = false;
      });
    if(result["error"] == false){
          setState(() {
          history = result["invoiceHistory"];




          });
    }else{

      CommonUtils.showMsg(body:result["message"], context: context, scaffoldKey:widget.scaffoldKey, snackColor: Colors.red );

    }
  }
}


class InvoiceItemExternal {
  final InvoiceHistory item;
   AppState state;
  PdfWid.Page page;
  BusinessState businessState;
  PdfWid.Document pdf = PdfWid.Document();

  InvoiceItemExternal({this.item, this.businessState}) {
    // print(state.logo);
    // try{
    //   logoProvider =  NetworkImage(state.logo ?? " ");
    // }catch(e){}
    buildScreen();
  }

  final imageProvider = const AssetImage("assets/images/receipt/logoC.png");
  var logoProvider;
  Page.PdfImage image;
  Page.PdfImage logoImage;


  requestPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
//    Material.debugPrint("Permission: $permissions");
  }

  Future<void> getImage() async {
    image = await pdfImageFromImageProvider(
        pdf: pdf.document, image: imageProvider);
    try{
      logoImage = await pdfImageFromImageProvider(
          pdf: pdf.document, image: logoProvider);
    }catch(e){}
  }

  Future<void> buildScreen() async {
    pdf = PdfWid.Document();
    await getImage();
    page = PdfWid.MultiPage(
      pageFormat: Page.PdfPageFormat.a4,
      build: (context) {
        return [
          PdfWid.Row(
            children: [
              PdfWid.Expanded(
                child: PdfWid.Column(
                  crossAxisAlignment: PdfWid.CrossAxisAlignment.start,
                  children: [
                    PdfWid.Text(
                      "INVOICE",
                      style: PdfWid.TextStyle(
                        fontSize: 25,
                        fontWeight: PdfWid.FontWeight.bold,
                        color: PdfColor.fromHex("#0D3E53"),
                      ),
                    ),
                    PdfWid.Text(
                     MyUtils.formatDate(item.items[0].created_at),
                      style: PdfWid.TextStyle(
                        fontSize: 15,
                        fontWeight: PdfWid.FontWeight.bold,
                        color: PdfColor.fromHex("#6D83A5"),
                      ),
                    ),
                    PdfWid.Text(
                      item.txn_ref ?? "",
                      style: PdfWid.TextStyle(
                        fontSize: 15,
                        fontWeight: PdfWid.FontWeight.bold,
                        color: PdfColor.fromHex("#6D83A5"),
                      ),
                    ),
                  ],
                ),
              ),
              PdfWid.Container(
                height: 100,
                width: 100,
                child: PdfWid.Center(
                  child: logoImage != null ?PdfWid.Image(logoImage, fit: PdfWid.BoxFit.cover) : PdfWid.SizedBox(),
                ),
              ),
            ],
          ),
          PdfWid.SizedBox(height: 10),
          PdfWid.Divider(color: PdfColor.fromHex("#00ACEC"), thickness: 0.2),
          PdfWid.SizedBox(height: 10),
          PdfWid.Row(children: [
            PdfWid.Expanded(
              child: PdfWid.Column(
                  crossAxisAlignment: PdfWid.CrossAxisAlignment.start,
                  children: [
                    PdfWid.Text(
                      businessState.business.contact_phone ?? "",
                      style: PdfWid.TextStyle(
                        fontSize: 12,
                        fontWeight: PdfWid.FontWeight.bold,
                        color: PdfColor.fromHex("#6D83A5"),
                      ),
                    ),
                    PdfWid.Text(
                     businessState.business.business_address.toString(),
                      style: PdfWid.TextStyle(
                        fontSize: 12,
                        fontWeight: PdfWid.FontWeight.bold,
                        color: PdfColor.fromHex("#6D83A5"),
                      ),
                    )
                  ]
              ),
            ),
            PdfWid.Column(
                crossAxisAlignment: PdfWid.CrossAxisAlignment.end,
                children: [
                  PdfWid.Text(
                    "BILL TO",
                    style: PdfWid.TextStyle(
                      fontSize: 16,
                      fontWeight: PdfWid.FontWeight.bold,
                      color: PdfColor.fromHex("#0D3E53"),
                    ),
                  ),
                  PdfWid.Text(
                    item.email,
                    style: PdfWid.TextStyle(
                      fontSize: 12,
                      fontWeight: PdfWid.FontWeight.bold,
                      color: PdfColor.fromHex("#6D83A5"),
                    ),
                  ),
                  PdfWid.Text(
                    item.phone,
                    style: PdfWid.TextStyle(
                      fontSize: 12,
                      fontWeight: PdfWid.FontWeight.bold,
                      color: PdfColor.fromHex("#6D83A5"),
                    ),
                  ),
                ])
          ]),
          PdfWid.SizedBox(height: 20),
          PdfWid.Container(
              padding:
              PdfWid.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: PdfColor.fromHex("#00ACEC"),
              child: PdfWid.Row(children: [
                PdfWid.Expanded(
                  child: PdfWid.Text("Description",
                      style: PdfWid.TextStyle(
                          color: PdfColors.white,
                          fontWeight: PdfWid.FontWeight.bold,
                          fontSize: 15)),
                ),
                PdfWid.Container(
                  width: 50,
                  child: PdfWid.Text("Qty",
                      style: PdfWid.TextStyle(
                          color: PdfColors.white,
                          fontWeight: PdfWid.FontWeight.bold,
                          fontSize: 15)),
                ),
                PdfWid.Container(
                  width: 100,
                  child: PdfWid.Text("Price",
                      style: PdfWid.TextStyle(
                          color: PdfColors.white,
                          fontWeight: PdfWid.FontWeight.bold,
                          fontSize: 15)),
                ),
                PdfWid.Container(
                    width: 100,
                    child: PdfWid.Text("Total",
                        textAlign: PdfWid.TextAlign.right,
                        style: PdfWid.TextStyle(
                            color: PdfColors.white,
                            fontWeight: PdfWid.FontWeight.bold,
                            fontSize: 15))),
              ])),
          ...List.generate(item.items.length, (index) {
            InvoiceItems i = item.items[index];
            print(item.items.length);
            return PdfWid.Container(
                padding:
                PdfWid.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: PdfWid.Row(children: [
                  PdfWid.Expanded(
                    child: PdfWid.Text(i.description,
                        style: PdfWid.TextStyle(
                            color: PdfColor.fromHex("#6D83A5"), fontSize: 15)),
                  ),
                  PdfWid.Container(
                    width: 50,
                    child: PdfWid.Text(i.quantity.toString(),
                        style: PdfWid.TextStyle(
                            color: PdfColor.fromHex("#6D83A5"), fontSize: 15)),
                  ),
                  PdfWid.Container(
                    width: 100,
                    child: PdfWid.Text(i.unit_cost,
                        style: PdfWid.TextStyle(
                            color: PdfColor.fromHex("#6D83A5"), fontSize: 15)),
                  ),
                  PdfWid.Container(
                      width: 100,
                      child: PdfWid.Text((int.parse(i.quantity.toString()) *double.parse(i.unit_cost)).toString(),
                          textAlign: PdfWid.TextAlign.right,
                          style: PdfWid.TextStyle(
                              color: PdfColor.fromHex("#0D3E53"),
                              fontWeight: PdfWid.FontWeight.bold,
                              fontSize: 15))),
                ]));
          }),
          PdfWid.SizedBox(height: 20),
          PdfWid.Divider(color: PdfColor.fromHex("#00ACEC"), thickness: 0.2),
          PdfWid.SizedBox(height: 25),
          PdfWid.Row(
              mainAxisAlignment: PdfWid.MainAxisAlignment.end,
              children: [
                PdfWid.Column(
                    crossAxisAlignment: PdfWid.CrossAxisAlignment.start,
                    children: [
                      PdfWid.Text("Sub total",
                          textAlign: PdfWid.TextAlign.right,
                          style: PdfWid.TextStyle(
                              color: PdfColor.fromHex("#0D3E53"),
                              fontWeight: PdfWid.FontWeight.bold,
                              fontSize: 15)),
                      PdfWid.Text("Tax",
                          textAlign: PdfWid.TextAlign.right,
                          style: PdfWid.TextStyle(
                              color: PdfColor.fromHex("#0D3E53"),
                              fontWeight: PdfWid.FontWeight.bold,
                              fontSize: 15))
                    ]),
                PdfWid.SizedBox(width: 20),
                PdfWid.Column(
                    crossAxisAlignment: PdfWid.CrossAxisAlignment.end,
                    children: [
                      PdfWid.Text(
                          "${item.currency} ${MyUtils.formatAmount((item.total_value).toString())}",
                          textAlign: PdfWid.TextAlign.right,
                          style: PdfWid.TextStyle(
                              color: PdfColor.fromHex("#0D3E53"),
                              fontWeight: PdfWid.FontWeight.bold,
                              fontSize: 15)),
                      PdfWid.Text("${item.currency} ${ MyUtils.formatAmount(item.vat.toString())}",
                          textAlign: PdfWid.TextAlign.right,
                          style: PdfWid.TextStyle(
                              color: PdfColor.fromHex("#0D3E53"),
                              fontWeight: PdfWid.FontWeight.bold,
                              fontSize: 15))
                    ])
              ]),
          PdfWid.SizedBox(height: 20),
          PdfWid.Row(
            mainAxisAlignment: PdfWid.MainAxisAlignment.end,
            children: [
              PdfWid.Container(
                color: PdfColor.fromHex("#00ACEC"),
                alignment: PdfWid.Alignment.centerRight,
                padding:
                PdfWid.EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: PdfWid.Row(
                  mainAxisAlignment: PdfWid.MainAxisAlignment.end,
                  mainAxisSize: PdfWid.MainAxisSize.min,
                  children: [
                    PdfWid.Text(
                      "Total",
                      style: PdfWid.TextStyle(
                        color: PdfColors.white,
                        fontWeight: PdfWid.FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    PdfWid.SizedBox(width: 20),
                    PdfWid.Text(
                      "${item.currency.toUpperCase()} ${MyUtils.formatAmount(((double.parse(item.total_value)+  double.parse(item.vat)) ).toString())}",
                      style: PdfWid.TextStyle(
                        color: PdfColors.white,
                        fontWeight: PdfWid.FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          PdfWid.SizedBox(height: 25),
          PdfWid.Container(
              width: double.maxFinite,
              padding: PdfWid.EdgeInsets.all(10),
              color: PdfColors.blueGrey50,
              child: PdfWid.Column(
                  crossAxisAlignment: PdfWid.CrossAxisAlignment.start,
                  children: [
                    PdfWid.Text(
                      "EXTRA NOTE",
                      style: PdfWid.TextStyle(
                        fontSize: 16,
                        fontWeight: PdfWid.FontWeight.bold,
                        color: PdfColor.fromHex("#0D3E53"),
                      ),
                    ),
                    PdfWid.SizedBox(height: 5),
                    PdfWid.Text(
                      "Should this document be falsified or manipulated. Glade will not be held responsible",
                      style: PdfWid.TextStyle(
                        fontSize: 12,
                        fontWeight: PdfWid.FontWeight.bold,
                        color: PdfColor.fromHex("#6D83A5"),
                      ),
                    ),
                  ])),
          PdfWid.SizedBox(height: 30),
          PdfWid.Row(
            mainAxisAlignment: PdfWid.MainAxisAlignment.end,
            children: [
              PdfWid.Transform.translate(
                offset: PdfPoint(24, 0),
                child: PdfWid.Text(
                  "Powered By",
                  style: PdfWid.TextStyle(
                      color: PdfColors.grey,
                      fontSize: 20,
                      fontWeight: PdfWid.FontWeight.bold),
                ),
              ),
              PdfWid.Container(
                height: 50,
                child: PdfWid.Center(
                  child: PdfWid.Image(image, fit: PdfWid.BoxFit.contain),
                ),
              ),
            ],
          ),
        ];
      },
    );
    pdf.addPage(page);
  }

  Future<bool> download() async {
    await buildScreen();
    Directory output = await getApplicationDocumentsDirectory();

    File file ;

    if(Platform.isIOS){
      file = File("${output.path}/${item.txn_ref.replaceAll("|", "_")}.pdf");
    }
    file = File(
        "/storage/emulated/0/Download/${item.txn_ref.replaceAll("|", "\|")}.pdf");
    await file.writeAsBytes(pdf.save());

    //
    // final file = File(
    //     "/storage/emulated/0/Download/Invoice-${item.txn_ref}-${DateTime.now().toString()}.pdf");
    // await file.writeAsBytes(pdf.save());
    return true;
  }

  sharePdf() async {
    // wait for name to load
    await buildScreen();
    await Printing.sharePdf(
      bytes: pdf.save(),
      filename: "${item.txn_ref.replaceAll("|", "\|")}.pdf",
    );
  }

  printPdf() async {
    // wait for name to load
    await buildScreen();
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
