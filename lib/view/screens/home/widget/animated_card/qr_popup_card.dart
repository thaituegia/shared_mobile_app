import 'package:user_app/controller/home_controller.dart';
import 'package:user_app/controller/profile_screen_controller.dart';
import 'package:user_app/util/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'custom_rect_tween.dart';

class QrPopupCard extends StatelessWidget {
  const QrPopupCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: Get.find<HomeController>().heroShowQr,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: ColorResources.whiteColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GetBuilder<ProfileController>(
                  builder: (controller) {
                    return SizedBox(
                      //  height: MediaQuery.of(context).size.height*0.4,
                      // width: MediaQuery.of(context).size.width*0.8,
                      // child: Image.asset( Images.qrImage,
                      //   fit: BoxFit.contain,),
                      child: SvgPicture.string(
                        controller.userInfo.qrCode,
                        fit: BoxFit.contain,
                        width: size.width * 0.8,
                        // height: size.width * 0.8,
                      ),
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}
