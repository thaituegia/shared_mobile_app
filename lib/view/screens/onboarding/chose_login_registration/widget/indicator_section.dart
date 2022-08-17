import 'package:user_app/controller/auth_controller.dart';
import 'package:user_app/util/app_constants.dart';
import 'package:user_app/util/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IndicatorSection extends StatelessWidget {
  const IndicatorSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      
      builder: (controller) {
      return AnimatedSmoothIndicator(
        activeIndex: controller.page,
        count: AppConstants.onboardList.length,
        curve: Curves.easeOutSine,
        effect: CustomizableEffect(

          dotDecoration: DotDecoration(
            height: 6,
            width: 6,
            borderRadius: BorderRadius.circular(5),
            color: ColorResources.getPrimaryTextColor().withOpacity(0.2),
          ),
          activeDotDecoration: DotDecoration(
            height: 5,
            width: 16,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: ColorResources.getPrimaryTextColor(),

          ),
        ),
      );
    });
  }
}
