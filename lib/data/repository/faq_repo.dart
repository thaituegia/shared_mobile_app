import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:user_app/data/api/api_client.dart';
import 'package:user_app/util/app_constants.dart';

class FaqRepo{
  final ApiClient apiClient;

  FaqRepo({@required this.apiClient});

  Future<Response> getFaqList() async {
    return await apiClient.getData(AppConstants.FAQ_URI);
  }
}