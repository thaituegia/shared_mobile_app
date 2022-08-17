import 'package:get/get.dart';
import 'package:user_app/controller/auth_controller.dart';
import 'package:user_app/data/model/body/error_body.dart';
import 'package:user_app/helper/route_helper.dart';
import 'package:user_app/view/base/custom_snackbar.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 401) {
      Get.find<AuthController>().removeCustomerToken();
      Get.offAllNamed(RouteHelper.getLoginRoute(countryCode: Get.find<AuthController>().getCustomerCountryCode(),phoneNumber: Get.find<AuthController>().getCustomerNumber()));
      showCustomSnackBar(response.statusText, isIcon: true);

    } else if(response.statusCode == 400) {
      showCustomSnackBar('to_money_login_attempts'.tr);

    }
    else {
      showCustomSnackBar(response.body['message'] ?? ErrorBody.fromJson(response.body).errors.first.message, isError: true);
    }
  }
}
