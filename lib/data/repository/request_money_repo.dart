
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/data/api/api_client.dart';
import 'package:user_app/data/model/response/contact_model.dart';
import 'package:user_app/util/app_constants.dart';

class RequestMoneyRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  RequestMoneyRepo({@required this.apiClient, @required this.sharedPreferences});


  Future<Response>  getPurposeListApi() async {
    return await apiClient.getData(AppConstants.CUSTOMER_PURPOSE_URL);
  }
  Future<Response>  requestMoneyApi({@required String phoneNumber, @required double amount}) async {
    Map<String, Object> body = {'phone' : phoneNumber, 'amount' : amount};
    return await apiClient.postData(AppConstants.CUSTOMER_REQUEST_MONEY, body);
  }
  Future<Response>  pinVerifyApi({@required String pin}) async {
    Map<String, Object> body = {'pin': pin};
    return await apiClient.postData(AppConstants.CUSTOMER_PIN_VERIFY, body);
  }

  List<ContactModel> getSuggestList()  {
    List<String> suggests  = [];
    if(sharedPreferences.containsKey(AppConstants.REQUEST_MONEY_SUGGEST_LIST) ){
      suggests =  sharedPreferences.getStringList(AppConstants.REQUEST_MONEY_SUGGEST_LIST);

    }
    if(suggests != null){
      List<ContactModel> contactList = [];
      suggests.forEach((contact) => contactList.add(ContactModel.fromJson(jsonDecode(contact))));
      return  contactList;

    }return null;

  }

  void addToSuggestList(List<ContactModel> contactModelList) async {
    List<String> suggests  = [];
    contactModelList.forEach((contactModel) => suggests.add(jsonEncode(contactModel)));
    sharedPreferences.setStringList(AppConstants.REQUEST_MONEY_SUGGEST_LIST, suggests);
  }
}