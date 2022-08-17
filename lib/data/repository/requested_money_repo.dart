import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:user_app/data/api/api_client.dart';
import 'package:user_app/util/app_constants.dart';

class RequestedMoneyRepo{
  final ApiClient apiClient;

  RequestedMoneyRepo({@required this.apiClient});

  Future<Response> getRequestedMoneyList() async {
    return await apiClient.getData('${AppConstants.REQUESTED_MONEY_URI}');
  }
  Future<Response> getOwnRequestedMoneyList() async {
    return await apiClient.getData('${AppConstants.WON_REQUESTED_MONEY}');
  }
  Future<Response> approveRequestedMoney(int id, String pin) async {
    return await apiClient.postData('${AppConstants.ACCEPTED_REQUESTED_MONEY_URI}',{"id": id, "pin" :pin});
  }
  Future<Response> denyRequestedMoney(int id, String pin) async {
    return await apiClient.postData('${AppConstants.DENIED_REQUESTED_MONEY_URI}',{"id": id, "pin" :pin});
  }
}