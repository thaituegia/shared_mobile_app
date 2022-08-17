import 'package:user_app/controller/edit_profile_controller.dart';
import 'package:user_app/util/color_resources.dart';
import 'package:user_app/util/dimensions.dart';
import 'package:user_app/util/images.dart';
import 'package:user_app/util/styles.dart';
import 'package:user_app/view/screens/auth/other_info/widget/custom_gender_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class GenderSection extends StatelessWidget {
  const GenderSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<EditProfileController>(builder: (controller){
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: Dimensions.PADDING_SIZE_EXTRA_LARGE,
          left: Dimensions.PADDING_SIZE_SMALL,
          right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          bottom: Dimensions.PADDING_SIZE_DEFAULT,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: ColorResources.getShadowColor().withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 3),
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'gender'.tr,
              style: rubikMedium.copyWith(
                color: ColorResources.getBlackColor(),
                fontSize: Dimensions.FONT_SIZE_LARGE,
              ),
            ),
            const SizedBox(
              height: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            Wrap(
              spacing: Dimensions.PADDING_SIZE_SMALL,
              runSpacing: Dimensions.PADDING_SIZE_SMALL,
              children: [
                CustomGenderCard(
                  icon: Images.male,
                  text: 'Male',
                  color: controller.gender.toLowerCase() == 'male' ? Theme.of(context).secondaryHeaderColor:ColorResources.genderDefaultColor.withOpacity(0.5),
                  onTap: (){
                    controller.setGender('Male');
                  },
                ),
                //const SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                CustomGenderCard(
                  icon: Images.female,
                  text: 'Female',
                  color: controller.gender.toLowerCase() == 'female' ? Theme.of(context).secondaryHeaderColor:ColorResources.genderDefaultColor.withOpacity(0.5),
                  onTap: (){
                    controller.setGender('Female');
                  },
                ),
                //const SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                CustomGenderCard(
                  icon: Images.other,
                  text: 'Other',
                  color: controller.gender.toLowerCase() == 'other' ? Theme.of(context).secondaryHeaderColor:ColorResources.genderDefaultColor.withOpacity(0.5),
                  onTap: (){
                    controller.setGender('Other');
                  },
                ),
              ],
            )
          ],
        ),
      );
    });

  }
}
