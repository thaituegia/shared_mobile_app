import 'package:user_app/controller/auth_controller.dart';
import 'package:user_app/controller/create_account_controller.dart';
import 'package:user_app/controller/varification_controller.dart';
import 'package:user_app/util/color_resources.dart';
import 'package:user_app/util/dimensions.dart';
import 'package:user_app/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerSection extends StatelessWidget {
  const TimerSection({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VarificationController>(builder: (controller){
      return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: controller.visibility == true ? true : false,
          child: InkWell(
            onTap: (){
              controller.startTimer();
              controller.setVisibility(false);
              Get.find<AuthController>().resendOtp(phoneNumber: Get.find<CreateAccountController>().phoneNumber);
            },
            child: Text('resend'.tr, style: rubikMedium.copyWith(color: ColorResources.getBlackColor(), fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE), textAlign: TextAlign.center,
            ),
          ),
        ),
        Visibility(
          visible: controller.visibility == true ? false : true,
          child: Text('resend_OTP_in'.tr + '${controller.maxSecond}' +" " + 'seconds'.tr, style: rubikRegular.copyWith(color: ColorResources.getOnboardGreyColor(), fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE), textAlign: TextAlign.center,
          ),
        ),
      ],
    );
    });
  }
}
