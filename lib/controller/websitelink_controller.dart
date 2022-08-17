
import 'package:user_app/data/api/api_checker.dart';
import 'package:user_app/data/model/websitelink_models.dart';
import 'package:user_app/data/repository/websitelink_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WebsiteLinkController extends GetxController implements GetxService{
  final WebsiteLinkRepo websiteLinkRepo;
  WebsiteLinkController({@required this.websiteLinkRepo});
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<WebsiteLinkModel> _websiteList = [];
  List<WebsiteLinkModel> get websiteList => _websiteList;
  Future getWebsiteList()async{
    if(_websiteList.isEmpty) {
        _isLoading = true;
        _websiteList = [];
        Response response = await websiteLinkRepo.getWebsiteListApi();
        if(response.body != null && response.body != {} && response.statusCode == 200){
          _websiteList = [];
          response.body.forEach((website) {_websiteList.add(WebsiteLinkModel.fromJson(website));});
        }else{
          ApiChecker.checkApi(response);

        }
        _isLoading = false;
        update();

    }


    }

  }