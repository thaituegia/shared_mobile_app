import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:user_app/controller/add_money_controller.dart';
import 'package:user_app/controller/localization_controller.dart';
import 'package:user_app/controller/profile_screen_controller.dart';
import 'package:user_app/controller/transaction_controller.dart';
import 'package:user_app/controller/splash_controller.dart';
import 'package:user_app/data/model/purpose_models.dart';
import 'package:user_app/data/model/response/contact_model.dart';
import 'package:user_app/helper/hexa_color.dart';
import 'package:user_app/helper/price_converter.dart';
import 'package:user_app/util/color_resources.dart';
import 'package:user_app/util/dimensions.dart';
import 'package:user_app/util/images.dart';
import 'package:user_app/util/styles.dart';
import 'package:user_app/view/base/CustomImage.dart';
import 'package:user_app/view/base/custom_app_bar.dart';
import 'package:user_app/view/base/custom_snackbar.dart';
import 'package:user_app/view/base/input_field_shimmer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user_app/view/screens/transaction_money/widget/purpose_widget.dart';
import 'package:user_app/view/screens/transaction_money/widget/transaction_money_confirmation.dart';

import 'for_person_widget.dart';
import 'next_button.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class TransactionMoneyBalanceInput extends StatefulWidget {
  final String transactionType;
  final ContactModel contactModel;
   TransactionMoneyBalanceInput({Key key, this.transactionType ,this.contactModel}) : super(key: key);
  @override
  State<TransactionMoneyBalanceInput> createState() => _TransactionMoneyBalanceInputState();
}

class _TransactionMoneyBalanceInputState extends State<TransactionMoneyBalanceInput> {
  final TextEditingController _inputAmountController = TextEditingController();

 
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    final SplashController splashController = Get.find<SplashController>();
    final LocalizationController localizationController = Get.find<LocalizationController>();
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppbar(title: widget.transactionType=='send_money'?'send_money'.tr : widget.transactionType=='cash_out' ? 'cash_out'.tr : widget.transactionType=='request_money' ? 'request_money'.tr : 'add_money'.tr),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             widget.transactionType != 'add_money' ? ForPersonWidget(contactModel: widget.contactModel) : SizedBox.shrink(),
              GetBuilder<TransactionMoneyController>(
                builder: (controller) {
                  return controller.isLoading ? widget.transactionType =='cash_out' && widget.transactionType != 'add_money' ? SizedBox() : InputFieldShimmer() :
                  Column(
                    children: [ Stack(
                        children: [
                          Container( color: widget.transactionType !='cash_out' && widget.transactionType !='add_money'? HexColor(controller.purposeList.isEmpty ? Purpose().color : controller.purposeList[controller.selectedItem].color) : ColorResources.getWhiteAndBlack(),
                            child: Column(
                              children: [ Container( width: size.width * 0.6,
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE),
                                  child: TextField(
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(8),
                                      CurrencyTextInputFormatter(
                                        locale: Get.find<SplashController>().configModel.currencyPosition == 'left' ? 'en' : 'fr',
                                        decimalDigits: 0,
                                        symbol: '${Get.find<SplashController>().configModel.currencySymbol}',
                                      )
                                    ],
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    controller: _inputAmountController,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    style: rubikMedium.copyWith(fontSize: 34, color: ColorResources.getPrimaryTextColor()),
                                    decoration: InputDecoration(
                                        isCollapsed : true,
                                        hintText:'${PriceConverter.balanceInputHint()}',
                                        border : InputBorder.none, focusedBorder: UnderlineInputBorder(),
                                        hintStyle: rubikMedium.copyWith(fontSize: 34, color: ColorResources.getPrimaryTextColor().withOpacity(0.7)),

                                    ),

                                  ),
                                ),
                                Center( child: GetBuilder<ProfileController>( builder: (profController) {
                                      return profController.isLoading ? Center(child: CircularProgressIndicator(color: ColorResources.getPrimaryTextColor()))
                                          : Text('${'available_balance'.tr} ${PriceConverter.availableBalance()}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getGreyColor()));
                                    }
                                  ),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),


                              ],
                            ),
                          ),

                          widget.transactionType !='cash_out' && widget.transactionType !='add_money'? localizationController.isLtr ?
                          Positioned(
                            left: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                            child: CustomImage(image:'${splashController.configModel.baseUrls.purposeImageUrl}/${controller.purposeList.isEmpty ? Purpose().logo : controller.purposeList[controller.selectedItem].logo}',
                              height: 50, width: 50, fit: BoxFit.cover),
                          ) : Positioned(
                            right: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                            child:
                            CustomImage(image:'${splashController.configModel.baseUrls.purposeImageUrl}/${controller.purposeList.isEmpty ? Purpose().logo : controller.purposeList[controller.selectedItem].logo}',
                              height: 50, width: 50, fit: BoxFit.cover),
                          ) : SizedBox(),


                          widget.transactionType !='cash_out' && widget.transactionType !='add_money'? localizationController.isLtr ?
                          Positioned( right: 10 ,  bottom: 5, child: Image.asset(Images.input_stack_desing, width: 150.0)) :
                          Positioned(left: 10,  bottom: 5, child: Transform( transform: Matrix4.rotationY(math.pi), alignment: Alignment.center,
                            child:  Image.asset(Images.input_stack_desing, width: 150.0))) : SizedBox(),
                        ],
                      ),

                      Container(height: Dimensions.DIVIDER_SIZE_MEDIUM, color: ColorResources.backgroundColor,),

                    ],
                  );
                }
              ),

           widget.transactionType !='add_money' ? widget.transactionType =='cash_out'?
              Padding( padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical:Dimensions.PADDING_SIZE_DEFAULT ),
                child: Row( children: [
                  Text('save_future_cash_out'.tr, style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  Spacer(),

                  GetBuilder<TransactionMoneyController>(
                    builder: (switchController) {
                      return Padding( padding: EdgeInsets.zero, child: CupertinoSwitch(value: switchController.isFutureSave, onChanged: switchController.cupertinoSwitchOnChange));
                    }
                  )
                ],
                ),
              ): SizedBox() : SizedBox(),
              widget.transactionType !='cash_out' && widget.transactionType !='add_money' && Get.find<TransactionMoneyController>().purposeList.isNotEmpty ?
           MediaQuery.of(context).viewInsets.bottom > 10 ?
           Container(
             color: ColorResources.whiteColor.withOpacity(0.92),
             padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
             child: Row(children: [
               GetBuilder<TransactionMoneyController>(
                   builder: (controller) {
                     if(controller.purposeList.isEmpty){
                       return Center(child: CircularProgressIndicator(color: ColorResources.getPrimaryTextColor()));
                     }
                     return SizedBox();
                   }
               ),
               SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

               Text('change_purpose'.tr, style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),)
             ],),
           ): PurposeWidget(): SizedBox(),

            ],
          ),
        ),

        floatingActionButton: GetBuilder<TransactionMoneyController>(
          builder: (controller) {
            return  FloatingActionButton(

              onPressed:() {
                double amount;
                if(_inputAmountController.text.isEmpty){
                  showCustomSnackBar('please_input_amount'.tr,isError: true);
                }else{
                  String balance =  _inputAmountController.text;
                  if(balance.contains('${splashController.configModel.currencySymbol}')) {
                    balance = balance.replaceAll('${splashController.configModel.currencySymbol}', '');
                  }
                  if(balance.contains(',')){
                    balance = balance.replaceAll(',', '');
                  }
                  if(balance.contains(' ')){
                    balance = balance.replaceAll(' ', '');
                  }
                   amount = double.parse(balance);
                  if(amount == 0) {
                    showCustomSnackBar('transaction_amount_must_be'.tr,isError: true);
                  }else {
                    if((widget.transactionType == 'send_money' && PriceConverter.withSendMoneyCharge(amount) > profileController.userInfo.balance) ||
                        (widget.transactionType == 'cash_out' && PriceConverter.withCashOutCharge(amount) > profileController.userInfo.balance)
                    ) {
                      showCustomSnackBar('insufficient_balance'.tr, isError: true);

                    }else {
                      if(widget.transactionType == 'add_money'){
                        Get.find<AddMoneyController>().addMoney(context, amount.toString());
                      }else{
                        Get.to(()=> TransactionMoneyConfirmation(
                          inputBalance: amount, transactionType:widget.transactionType, purpose: controller.purposeList.isEmpty ? Purpose().title : controller.purposeList[controller.selectedItem].title,contactModel: widget.contactModel,));
                      }
                    }
                  }

                }
              },
              child: NextButton(isSubmittable: true),
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            );
          }
        )

      ),
    );
  }
}




