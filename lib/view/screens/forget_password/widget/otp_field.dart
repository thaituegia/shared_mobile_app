import 'package:user_app/controller/auth_controller.dart';
import 'package:user_app/controller/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/util/dimensions.dart';
import 'package:user_app/view/base/custom_pin_code_field.dart';
class OtpFieldSection extends StatefulWidget {
  final String phoneNumber;
  const OtpFieldSection({Key key,@required this.phoneNumber}) : super(key: key);

  @override
  _OtpFieldSectionState createState() => _OtpFieldSectionState();
}

class _OtpFieldSectionState extends State<OtpFieldSection> {
  @override
  Widget build(BuildContext context) {
    return CustomPinCodeField(
      padding: Dimensions.PADDING_SIZE_OVER_LARGE,
      onCompleted: (pin){
        Get.find<ForgetPassController>().setOtp(pin);
        String _phoneNumber = widget.phoneNumber;
        debugPrint("Completed: $pin");
        debugPrint("phone number : $_phoneNumber");
        Get.find<AuthController>().verificationForForgetPass(_phoneNumber, pin);
      },
    );
  }
}
