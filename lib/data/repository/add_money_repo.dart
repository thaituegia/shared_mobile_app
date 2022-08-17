
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:user_app/data/api/api_client.dart';
import 'package:user_app/util/app_constants.dart';

class AddMoneyRepo {
  final ApiClient apiClient;

  AddMoneyRepo({@required this.apiClient});

  // Future<Response>  pinVerifyApi({@required String pin}) async {
  //   Map<String, Object> body = {'pin': pin};
  //   return await apiClient.postData(AppConstants.CUSTOMER_PIN_VERIFY,body);
  // }
  Future<Response>  addMoneyApi({@required String amount}) async {
    Map<String, Object> body = {'amount': amount};
    return await apiClient.postData(AppConstants.CUSTOMER_ADD_MONEY,body);
  }



}