import 'package:user_app/controller/profile_screen_controller.dart';
import 'package:user_app/util/color_resources.dart';
import 'package:user_app/util/dimensions.dart';
import 'package:user_app/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/view/base/custom_text_field.dart';

class InputSection extends StatefulWidget {
  final TextEditingController occupationController, fNameController,lNameController,emailController;
  final bool fromEditProfile;
   InputSection({Key key, this.occupationController, this.fNameController, this.lNameController, this.emailController, this.fromEditProfile = false}) : super(key: key);

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  final FocusNode occupationFocus = FocusNode();

  final FocusNode firstNameFocus = FocusNode();

  final FocusNode lastNameFocus = FocusNode();

  final FocusNode emailNameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller){
      return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_LARGE,
          vertical: Dimensions.PADDING_SIZE_LARGE),
      child: Column(
        children: [
          CustomTextField(
            fillColor: Theme.of(context).cardColor,
            hintText: 'occupation'.tr,
            isShowBorder: true,
            controller: widget.occupationController,
            focusNode: occupationFocus,
            nextFocus: firstNameFocus,
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_LARGE,
          ),

          CustomTextField(
            fillColor: Theme.of(context).cardColor,
            hintText: 'first_name'.tr,
            isShowBorder: true,
            controller: widget.fNameController,
            focusNode: firstNameFocus,
            nextFocus: lastNameFocus,
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_LARGE,
          ),

          CustomTextField(
            fillColor: Theme.of(context).cardColor,
            hintText: 'last_name'.tr,
            isShowBorder: true,
            controller: widget.lNameController,
            focusNode: lastNameFocus,
            nextFocus: emailNameFocus,
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE,
          ),

        widget.fromEditProfile ? SizedBox():  Column(
            children: [

              Row(
                children: [
                  Text('email_address'.tr, style: rubikMedium.copyWith(
                      color: ColorResources.getBlackColor(),
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    ),
                  ),

                  Text('optional'.tr, style: rubikRegular.copyWith(
                      color: ColorResources.getPrimaryTextColor(),
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE,
              ),

              CustomTextField(
                fillColor: Theme.of(context).cardColor,
                hintText: 'type_email_address'.tr,
                isShowBorder: true,
                controller: widget.emailController,
                focusNode: emailNameFocus,
                inputType: TextInputType.emailAddress,
              ),
            ],
          ) ,

        ],
      ),
    );
    });
  }
}
