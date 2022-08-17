import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:user_app/data/model/response/contact_model.dart';
import 'package:user_app/util/dimensions.dart';
import 'package:user_app/view/screens/transaction_money/widget/transaction_money_balance_input.dart';

class QrCodeScannerController extends GetxController implements GetxService{

  String _name;
  String _phone;
  String _type;
  String _image;

  String get name => _name;
  String get phone => _phone;
  String get type => _type;
  String get image => _image;
  String _transactionType;
  String get transactionType => _transactionType;



  Future<void> scanQR({String transactionType, @required bool isHome}) async{

    try{
      String scannedQrcode = await FlutterBarcodeScanner.scanBarcode('#003E47', 'cancel', false, ScanMode.QR);
      if(scannedQrcode != "-1"){
        var a = jsonDecode(scannedQrcode);
        _name = a['name'];
        _phone = a['phone'];
        _type = a['type'];
        _image = a['image'];

          if(_type == "customer"){
              _transactionType = transactionType;
          }else if(_type == "agent"){
            _transactionType = "cash_out";
          }
          if(isHome && _type != "agent") {
            Get.defaultDialog(
              title: 'select_a_transaction'.tr,
              content: TransactionSelect(contactModel: ContactModel(phoneNumber: _phone, name: _name,avatarImage: _image)),
              barrierDismissible: false,
              radius: Dimensions.RADIUS_SIZE_DEFAULT,
            );
          }else {
            Get.to(()=>  TransactionMoneyBalanceInput(transactionType: _transactionType,contactModel: ContactModel(phoneNumber: _phone, name: _name,avatarImage: _image)));
          }

      }
    }
    on PlatformException{}
  }

}

class TransactionSelect extends StatelessWidget {
  final ContactModel contactModel;
  const TransactionSelect({Key key, this.contactModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(title: Text('send_money'.tr), minVerticalPadding: 0,
          onTap: () =>  Get.off(()=>  TransactionMoneyBalanceInput(transactionType: 'send_money',contactModel: contactModel))),

        ListTile(title: Text('request_money'.tr), minVerticalPadding: 0,
          onTap: () =>  Get.off(()=>  TransactionMoneyBalanceInput(transactionType: 'request_money',contactModel: contactModel))),
      ],
    );
  }
}
