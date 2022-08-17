import 'package:user_app/controller/auth_controller.dart';
import 'package:user_app/util/color_resources.dart';
import 'package:user_app/util/dimensions.dart';
import 'package:user_app/view/base/custom_app_bar.dart';
import 'package:user_app/view/base/demo_otp_hint.dart';
import 'package:user_app/view/screens/forget_password/widget/infornation_section.dart';
import 'package:user_app/view/screens/forget_password/widget/otp_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class FvarificationScreen extends StatefulWidget {
  final String phoneNumber;
  const FvarificationScreen({Key key, this.phoneNumber}) : super(key: key);

  @override
  _FvarificationScreenState createState() => _FvarificationScreenState();
}

class _FvarificationScreenState extends State<FvarificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.getWhiteAndBlack(),
        appBar: CustomAppbar(
          title: 'phone_verification'.tr,
        ),
        body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                      ),
                      FinformationSection(phoneNumber: widget.phoneNumber),
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_OVER_LARGE,
                      ),
                      OtpFieldSection(phoneNumber: widget.phoneNumber,),
                      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),

                      DemoOtpHint(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 100,
                child:  GetBuilder<AuthController>(builder: (controller){
                  return controller.isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)) : SizedBox();
                },),
              )

            ],
          ),


    );
  }
}
