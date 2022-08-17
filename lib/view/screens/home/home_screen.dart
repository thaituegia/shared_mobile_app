
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/controller/banner_controller.dart';
import 'package:user_app/controller/home_controller.dart';
import 'package:user_app/controller/notification_controller.dart';
import 'package:user_app/controller/profile_screen_controller.dart';
import 'package:user_app/controller/requested_money_controller.dart';
import 'package:user_app/controller/splash_controller.dart';
import 'package:user_app/controller/transaction_controller.dart';
import 'package:user_app/controller/transaction_history_controller.dart';
import 'package:user_app/controller/websitelink_controller.dart';
import 'package:user_app/util/color_resources.dart';
import 'package:user_app/util/dimensions.dart';
import 'package:user_app/view/screens/home/widget/app_bar.dart';
import 'package:user_app/view/screens/home/widget/bottom_sheet/expandable_contant.dart';
import 'package:user_app/view/screens/home/widget/bottom_sheet/persistent_header.dart';
import 'package:user_app/view/screens/home/widget/first_card_portion.dart';
import 'package:user_app/view/screens/home/widget/linked_website_portion.dart';
import 'package:user_app/view/screens/home/widget/secend_card_portion.dart';
import 'package:user_app/view/screens/home/widget/shimmer/web_site_shimmer.dart';
import 'package:user_app/view/screens/home/widget/third_card_portion.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFirst = true;
  Future<void> _loadData(BuildContext context, bool reload) async {


    await Get.find<ProfileController>().profileData(loading: true).then((value) {
      if(value.isOk){
         Get.find<BannerController>().getBannerList(reload);
         Get.find<RequestedMoneyController>().getRequestedMoneyList(1,context ,reload: reload );
         Get.find<RequestedMoneyController>().getOwnRequestedMoneyList(1 ,reload: reload );
         Get.find<TransactionHistoryController>().getTransactionData(1, reload: reload);
         Get.find<WebsiteLinkController>().getWebsiteList();
         Get.find<NotificationController>().getNotificationList();
         Get.find<TransactionMoneyController>().getPurposeList();
        Get.find<TransactionMoneyController>().fetchContact();
        if(reload) {
          Get.find<SplashController>().getConfigData();
        }
      }
    });



  }
  @override
  void initState() {
    _loadData(context, true);
    isFirst = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<HomeController>(
        builder: (controller) {
          return Scaffold(
            //backgroundColor: Theme.of(context).canvasColor,
             backgroundColor: ColorResources.getBackgroundColor(),
            appBar: AppBarBase(),
            body: ExpandableBottomSheet(
                enableToggle: true,
                background: RefreshIndicator(
                  onRefresh: () async {
                    await _loadData(context, true);
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: GetBuilder<SplashController>(builder: (splashController) {
                        return Column(
                          children: [
                            splashController.configModel.themeIndex == '1'
                                ? GetBuilder<ProfileController>(builder: (profile)=> FirstCardPortion(profileController: profile))
                                : splashController.configModel.themeIndex == '2' ? SecondCardPortion() : splashController.configModel.themeIndex == '3' ? ThirdCardPortion() :
                            GetBuilder<ProfileController>(builder: (profile)=> FirstCardPortion(profileController: profile)),

                            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                            GetBuilder<WebsiteLinkController>(builder: (websiteLinkController){
                              return websiteLinkController.isLoading ?
                              WebSiteShimmer() : websiteLinkController.websiteList.length > 0 ?  LinkedWebsite(websiteLinkController: websiteLinkController) : SizedBox();
                            }),
                            const SizedBox(height: 80),
                          ],
                        );
                      }
                    ),
                  ),
                ),
                persistentContentHeight: 70,
                persistentHeader: CustomPersistentHeader(),
                expandableContent: CustomExpandableContant()
            ),
          );
        });
  }

}

