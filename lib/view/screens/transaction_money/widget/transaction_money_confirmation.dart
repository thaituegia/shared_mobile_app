import 'package:flutter/services.dart';
import 'package:user_app/controller/auth_controller.dart';
import 'package:user_app/controller/bootom_slider_controller.dart';
import 'package:user_app/controller/profile_screen_controller.dart';
import 'package:user_app/controller/transaction_controller.dart';
import 'package:user_app/controller/splash_controller.dart';
import 'package:user_app/data/model/response/contact_model.dart';
import 'package:user_app/util/color_resources.dart';
import 'package:user_app/util/dimensions.dart';
import 'package:user_app/util/styles.dart';
import 'package:user_app/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:user_app/view/base/custom_pin_code_field.dart';
import 'package:user_app/view/base/custom_snackbar.dart';
import 'package:user_app/view/base/demo_otp_hint.dart';
import 'package:user_app/view/screens/transaction_money/widget/show_amount_view.dart';

import 'bottom_sheet_with_slider.dart';
import 'for_person_widget.dart';




class TransactionMoneyConfirmation extends StatelessWidget {
  final double inputBalance;
  final String transactionType;
  final String purpose;
  final ContactModel contactModel;
  TransactionMoneyConfirmation({@required this.inputBalance,@required this.transactionType, this.purpose, this.contactModel});
  final _pinCodeFieldController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final bottomSliderController = Get.find<BottomSliderController>();
    if(bottomSliderController.isPinCompleted != null) { bottomSliderController.setIsPinCompleted(isCompleted: false, isNotify: false);}
    return Scaffold(
      appBar: CustomAppbar(title: transactionType =='send_money'? 'send_money'.tr : transactionType =='cash_out' ? 'cash_out'.tr : 'request_money'.tr,
        onTap: (){
        Get.back();
      },),
      body:  SingleChildScrollView(
          child: Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ForPersonWidget(contactModel: contactModel,),
              ShowAmountView(amountText:  inputBalance.toString(), onTap: ()=> Get.back()),
              Divider(height: Dimensions.DIVIDER_SIZE_MEDIUM, color: ColorResources.backgroundColor),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE, bottom:Dimensions.PADDING_SIZE_DEFAULT),
                      child: Text('4digit_pin'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(alignment: Alignment.center, height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(27.0), color: ColorResources.getGreyBaseGray6()),
                            child: PinCodeTextField(
                              controller: _pinCodeFieldController,
                              length: 4, appContext:  context, onChanged: (value){bottomSliderController.changePinComleted(value);},
                              keyboardType: TextInputType.number, inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                              obscureText: true, hintCharacter: '•', hintStyle: rubikMedium.copyWith(color: ColorResources.getGreyBaseGray4()),
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly, cursorColor: ColorResources.getGreyBaseGray6(),
                              pinTheme: PinTheme.defaults(shape: PinCodeFieldShape.circle, activeColor: ColorResources.getGreyBaseGray6(),
                                  activeFillColor: Colors.red,selectedColor: ColorResources.getGreyBaseGray6(), borderWidth: 0, inactiveColor: ColorResources.getGreyBaseGray6()),
                            ),

                          ),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                        GestureDetector(
                          onTap: (){
                            if(!Get.find<BottomSliderController>().isPinCompleted) {
                              showCustomSnackBar('please_input_4_digit_pin'.tr);
                            }else {
                              Get.find<TransactionMoneyController>().pinVerify(pin: Get.find<BottomSliderController>().pin).then((value){
                                if(value.isOk){
                                  if(Get.find<SplashController>().configModel.twoFactor  && Get.find<ProfileController>().userInfo.twoFactor){
                                    Get.find<AuthController>().checkOtp().then((value) {
                                      if(value.isOk){
                                        Get.defaultDialog(
                                          barrierDismissible: false,
                                          title: 'otp_verification'.tr,
                                          content: Column(
                                            children: [
                                              CustomPinCodeField( onCompleted: (pin){
                                                Get.find<AuthController>().verifyOtp(pin).then((value) {
                                                  if(value.isOk){
                                                    showModalBottomSheet(isScrollControlled: true, context: Get.context, isDismissible: false, enableDrag: false,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SIZE_LARGE))),
                                                        builder: (context) {
                                                          return BottomSheetWithSlider(amountCharge: Get.find<SplashController>().configModel.sendMoneyChargeFlat,
                                                            amount: inputBalance.toString(),contactModel: contactModel,pinCode: Get.find<BottomSliderController>().pin, transactionType: transactionType,
                                                            purpose: purpose,
                                                          );
                                                        }
                                                    );
                                                  }
                                                });
                                              }),
                                              DemoOtpHint(),
                                              GetBuilder<AuthController>(builder: (verifyController){
                                                return verifyController.isVerifying ? CircularProgressIndicator(color: ColorResources.getPrimaryTextColor()) : SizedBox.shrink();
                                              })
                                            ],
                                          ),
                                        );
                                      }
                                    });
                                  }else{
                                    showModalBottomSheet(isScrollControlled: true, context: Get.context, isDismissible: false, enableDrag: false,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SIZE_LARGE))),
                                        builder: (context) {
                                          return BottomSheetWithSlider(amountCharge: Get.find<SplashController>().configModel.sendMoneyChargeFlat,
                                            amount: inputBalance.toString(),contactModel: contactModel,pinCode: Get.find<BottomSliderController>().pin,transactionType: transactionType,
                                            purpose: purpose,
                                          );
                                        }
                                    );
                                  }
                                }
                              });
                            }
                          },
                          child: GetBuilder<AuthController>(
                            builder: (otpCheckController) {
                              return GetBuilder<TransactionMoneyController>(
                                    builder: (pinVerify) {
                                      return pinVerify.isLoading|| otpCheckController.isLoading ? SizedBox(width: Dimensions.RADIUS_SIZE_OVER_LARGE,height:  Dimensions.RADIUS_SIZE_OVER_LARGE,
                                          child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)))
                                          : Container(width: Dimensions.RADIUS_SIZE_OVER_LARGE,height:  Dimensions.RADIUS_SIZE_OVER_LARGE,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Theme.of(context).secondaryHeaderColor),
                                          child: Icon(Icons.arrow_forward, color: ColorResources.blackColor));
                                    }
                                  );
                            }
                          )
                        )

                      ],
                    )

                  ],
                ),
              )


            ],
          ),
        ),
      );
  }
}





