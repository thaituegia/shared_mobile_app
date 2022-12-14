import 'package:flutter/material.dart';
import 'package:user_app/util/color_resources.dart';
import 'package:user_app/util/dimensions.dart';
import 'package:user_app/view/base/custom_ink_well.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String buttonText;
  final Color color;
  CustomButton({this.onTap, @required this.buttonText, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),
      ),
      child: CustomInkWell(
        onTap: onTap,
        radius: Dimensions.RADIUS_SIZE_SMALL,
        child: Padding(

          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(child: Text(buttonText,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: ColorResources.whiteColor),)),

        ),
      ),
    );
  }
}
