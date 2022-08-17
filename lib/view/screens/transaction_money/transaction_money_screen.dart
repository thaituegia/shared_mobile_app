import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/controller/auth_controller.dart';
import 'package:user_app/controller/qr_code_scanner_controller.dart';
import 'package:user_app/controller/splash_controller.dart';
import 'package:user_app/controller/transaction_controller.dart';
import 'package:user_app/data/model/response/contact_model.dart';
import 'package:user_app/util/color_resources.dart';
import 'package:user_app/util/dimensions.dart';
import 'package:user_app/util/images.dart';
import 'package:user_app/util/styles.dart';
import 'package:user_app/view/base/CustomImage.dart';
import 'package:user_app/view/base/contact_view.dart';
import 'package:user_app/view/base/custom_app_bar.dart';
import 'package:user_app/view/base/custom_country_code_picker.dart';
import 'package:user_app/view/base/custom_ink_well.dart';
import 'package:user_app/view/base/custom_snackbar.dart';
import 'package:user_app/view/screens/transaction_money/widget/scan_button.dart';
import 'package:user_app/view/screens/transaction_money/widget/transaction_money_balance_input.dart';

class TransactionMoneyScreen extends StatefulWidget {
  final bool fromEdit;
  final String phoneNumber;
  final String transactionType;
  TransactionMoneyScreen({Key key, this.fromEdit, this.phoneNumber, this.transactionType}) : super(key: key);

  @override
  State<TransactionMoneyScreen> createState() => _TransactionMoneyScreenState();
}

class _TransactionMoneyScreenState extends State<TransactionMoneyScreen> {
  String customerImageBaseUrl = Get.find<SplashController>().configModel.baseUrls.customerImageUrl;

  String agentImageBaseUrl = Get.find<SplashController>().configModel.baseUrls.agentImageUrl;

  @override
  Widget build(BuildContext context) {

     final TextEditingController _searchController = TextEditingController();
     String _countryCode = '';


     _countryCode = Get.find<AuthController>().getCustomerCountryCode();
     widget.fromEdit? _searchController.text = widget.phoneNumber:SizedBox();
     final qrScannerController = Get.find<QrCodeScannerController>();
     final transactionMoneyController = Get.find<TransactionMoneyController>();

    return Container(
      child: Scaffold(
        appBar:  CustomAppbar(title: widget.transactionType == "send_money" ? 'send_money'.tr : widget.transactionType =='cash_out'? 'cash_out'.tr : 'request_money'.tr),
        body: CustomScrollView(
          // controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(
                    child: Column(children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT), color: ColorResources.getGreyBaseGray3(),
                        child: Row(
                            children: [
                          Expanded(
                              child: TextField(
                                  controller: _searchController,
                                  onChanged: (inputText) => transactionMoneyController.searchContact(searchTerm: inputText.toLowerCase()),
                                  keyboardType: widget.transactionType=='cash_out' ? TextInputType.phone : TextInputType.name,
                                  decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                                      hintText: widget.transactionType == 'cash_out'? 'Enter Agent Number' : 'enter_name_or_number'.tr,
                                      hintStyle: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getGreyBaseGray1()),
                                      prefixIcon: CustomCountryCodePiker(onChanged: (code) => _countryCode = code.toString()))
                              )),
                          Icon(Icons.search, color: ColorResources.getGreyBaseGray1()),
                        ]),
                      ),
                      Divider(height: Dimensions.DIVIDER_SIZE_SMALL, color: ColorResources.BACKGROUND_COLOR),

                      Container(
                        color: ColorResources.getWhiteColor(),
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ScanButton(onTap: ()=> qrScannerController.scanQR(transactionType: widget.transactionType, isHome: false)),

                              InkWell(
                                onTap: () {
                                  if(_searchController.text.isEmpty){
                                    showCustomSnackBar('input_field_is_empty'.tr,isError: true);
                                  }else {
                                    String phoneNumber = _countryCode + _searchController.text.trim();
                                    if (widget.transactionType == "cash_out") {
                                      Get.find<TransactionMoneyController>().checkAgentNumber(phoneNumber: phoneNumber).then((value) {
                                        if (value.isOk) {
                                          String _agentName = value.body['data']['name'];
                                          String _agentImage = value.body['data']['image'];
                                          Get.to(() => TransactionMoneyBalanceInput(transactionType: widget.transactionType,
                                              contactModel: ContactModel(phoneNumber: _countryCode + _searchController.text,name: _agentName,avatarImage: _agentImage)));
                                        }
                                      });
                                    } else {
                                      Get.find<TransactionMoneyController>().checkCustomerNumber(phoneNumber: phoneNumber).then((value) {
                                        if (value.isOk) {
                                          String _customerName = value.body['data']['name'];
                                          String _customerImage = value.body['data']['image'];
                                          Get.to(() =>  TransactionMoneyBalanceInput(transactionType: widget.transactionType,
                                              contactModel: ContactModel(phoneNumber: _countryCode + _searchController.text,name: _customerName,avatarImage: _customerImage)));
                                        }
                                      });
                                    }
                                  }

                                },

                                child: GetBuilder<TransactionMoneyController>(
                                  builder: (checkController) {
                                    return checkController.isButtonClick ? SizedBox(width: Dimensions.RADIUS_SIZE_OVER_LARGE,height:  Dimensions.RADIUS_SIZE_OVER_LARGE,
                                        child: Center(child: CircularProgressIndicator(color: ColorResources.getPrimaryTextColor())))
                                        : Container(width: Dimensions.RADIUS_SIZE_OVER_LARGE,height:  Dimensions.RADIUS_SIZE_OVER_LARGE,
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).secondaryHeaderColor),
                                        child: Icon(Icons.arrow_forward, color: ColorResources.blackColor));
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                    )


                )),

            SliverToBoxAdapter(
              child: Column(children: [
                transactionMoneyController.sendMoneySuggestList.isNotEmpty &&  widget.transactionType == 'send_money'?
                GetBuilder<TransactionMoneyController>(builder: (sendMoneyController) {
                  return  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL, horizontal: Dimensions.PADDING_SIZE_LARGE),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                          child: Text('suggested'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                        ),
                        Container(height: 80.0,
                          child: ListView.builder(itemCount: sendMoneyController.sendMoneySuggestList.length, scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index)=> CustomInkWell(
                                radius : Dimensions.RADIUS_SIZE_VERY_SMALL,
                                highlightColor: ColorResources.getPrimaryTextColor().withOpacity(0.3),
                                onTap: () {
                                  sendMoneyController.suggestOnTap(index, widget.transactionType);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                  child: Column(children: [
                                    SizedBox(
                                      height: Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,width:Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                                      child: ClipRRect(
                                        child: FadeInImage.assetNetwork(
                                          fit: BoxFit.cover,
                                          image: "$customerImageBaseUrl/${sendMoneyController.sendMoneySuggestList[index].avatarImage.toString()}",
                                          placeholder: Images.avatar,
                                          imageErrorBuilder: (context, url, error) => Image.asset(Images.avatar, fit: BoxFit.cover,),
                                        ),
                                       borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_OVER_LARGE),
                                      ),
                                    ), Padding(padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                                      child: Text(sendMoneyController.sendMoneySuggestList[index].name == null ? sendMoneyController.sendMoneySuggestList[index].phoneNumber : sendMoneyController.sendMoneySuggestList[index].name ,
                                          style: sendMoneyController.sendMoneySuggestList[index].name == null ? rubikLight.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL) : rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                                    )
                                  ],
                                  ),
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  );
                }
                ) :
                ((transactionMoneyController.requestMoneySuggestList.isNotEmpty) && widget.transactionType == 'request_money') ?
                GetBuilder<TransactionMoneyController>(builder: (requestMoneyController) {
                  return requestMoneyController.isLoading ? Center(child: CircularProgressIndicator()) : Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL, horizontal: Dimensions.PADDING_SIZE_LARGE),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                          child: Text('suggested'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                        ),
                        Container(height: 80.0,
                          child: ListView.builder(itemCount: requestMoneyController.requestMoneySuggestList.length, scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index)=> CustomInkWell(
                                radius : Dimensions.RADIUS_SIZE_VERY_SMALL,
                                highlightColor: ColorResources.getPrimaryTextColor().withOpacity(0.3),
                                onTap: () {
                                  requestMoneyController.suggestOnTap(index, widget.transactionType);
                                  },
                                child: Container(
                                  margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                  child: Column(children: [
                                    SizedBox(
                                      height: Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,width:Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                                      child: ClipRRect(
                                        child: CustomImage(image: "$customerImageBaseUrl/${requestMoneyController.requestMoneySuggestList[index].avatarImage.toString()}",
                                          fit: BoxFit.cover, placeholder: Images.avatar), borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_OVER_LARGE),
                                      ),
                                    ),

                                    Padding(padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                                      child: Text(requestMoneyController.requestMoneySuggestList[index].name == null ? requestMoneyController.requestMoneySuggestList[index].phoneNumber : requestMoneyController.requestMoneySuggestList[index].name ,
                                          style: requestMoneyController.requestMoneySuggestList[index].name == null ? rubikLight.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE) : rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    )
                                  ],
                                  ),
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  );
                }
                ):
                ((transactionMoneyController.cashOutSuggestList.isNotEmpty) && widget.transactionType == 'cash_out')?
                GetBuilder<TransactionMoneyController>(builder: (cashOutController) {
                  return cashOutController.isLoading ? Center(child: CircularProgressIndicator()) : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL, horizontal: Dimensions.PADDING_SIZE_LARGE),
                        child: Text('recent_agent'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ),
                      ListView.builder(
                          itemCount: cashOutController.cashOutSuggestList.length, scrollDirection: Axis.vertical, shrinkWrap:true,physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index)=> CustomInkWell(
                            highlightColor: ColorResources.getPrimaryTextColor().withOpacity(0.3),
                            onTap: () => cashOutController.suggestOnTap(index, widget.transactionType),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: Dimensions.PADDING_SIZE_SMALL),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                SizedBox(
                                  height: Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,width:Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                                  child: ClipRRect(
                                    child: FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      image: "$agentImageBaseUrl/${cashOutController.cashOutSuggestList[index].avatarImage.toString()}",
                                      placeholder: Images.avatar,
                                      imageErrorBuilder: (context, url, error) => Image.asset(Images.avatar, fit: BoxFit.cover,),
                                    ),
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_OVER_LARGE),
                                  ),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cashOutController.cashOutSuggestList[index].name == null ?'Unknown':cashOutController.cashOutSuggestList[index].name,style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,color: ColorResources.getBlackColor())),
                                    Text(cashOutController.cashOutSuggestList[index].phoneNumber != null ? cashOutController.cashOutSuggestList[index].phoneNumber : 'No Number',style: rubikLight.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,color: ColorResources.getGreyBaseGray1()),),
                                  ],
                                )
                              ],
                              ),
                            ),
                          )

                      ),
                    ],
                  );
                }
                ):SizedBox(),

                widget.transactionType != "cash_out"?
                GetBuilder<TransactionMoneyController>(
                  builder: (contactController) {
                    return ConstrainedBox(
                      constraints: contactController.filterdContacts.length > 0 ?
                      BoxConstraints(maxHeight: double.parse(Get.find<TransactionMoneyController>().filterdContacts.length.toString()) * 100)
                          :BoxConstraints(maxHeight: 10),
                        child: ContactView(transactionType: widget.transactionType, contactController: contactController));
                  }
                ) : SizedBox(),
              ],),

            ),
          ],
        ),
      ),
    );
  }
}



class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 120 || oldDelegate.minExtent != 120 || child != oldDelegate.child;
  }
}
