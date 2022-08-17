import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user_app/helper/route_helper.dart';
import 'package:user_app/main.dart';

class SelfieController extends GetxController implements GetxService{

  String selectedImagePath;
  var selectedImageSize = ''.obs;
  final ImagePicker _picker = ImagePicker();
  PermissionStatus permissionStatus;

  void getImage() async{
    final _pickedFile = await _picker.pickImage(source: ImageSource.camera,imageQuality: 50, preferredCameraDevice: CameraDevice.front);
    if(_pickedFile != null){
      selectedImagePath = _pickedFile.path;
      update();
      print(selectedImagePath);
    }
    else{

    }
  }
 
  // camera
  CameraController cameraController ;
  XFile _imageFile;

  XFile get imageFile => _imageFile;


  void initCamera(){
    cameraController = CameraController(cameras[1], ResolutionPreset.medium, enableAudio: false);
    cameraController.initialize();
  }
  void removeImage(){
    _imageFile = null;
    update();
  }
  void capturePicture()async{
    _imageFile = await cameraController.takePicture();
    print(File(imageFile.path));
  }

  // void showAudioDeniedDialog({@required bool fromEditProfile}) {
  //   Get.defaultDialog(
  //     barrierDismissible: false,
  //     title: 'audio_permission'.tr,
  //     middleText: 'you_must_allow_permission_for_further_use'.tr,
  //     confirm: TextButton(onPressed: () async{
  //       Permission.microphone.request().then((value) async{
  //         var status = await Permission.microphone.status;
  //         if (status.isDenied) {
  //           Permission.microphone.request();
  //           Get.back();
  //         }
  //         else if(status.isGranted){
  //           if(fromEditProfile == true){
  //             Get.back();
  //            return Get.toNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
  //           }
  //           else{
  //             Get.back();
  //            return Get.offNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
  //           }
  //         }
  //         else if(status.isPermanentlyDenied){
  //           showPermanentlyDeniedDialog(fromEditProfile: fromEditProfile);
  //         }
  //       });
  //
  //
  //     }, child: Text('allow'.tr)),
  //   );
  //
  // }
  // void showAudioPermanentlyDeniedDialog({@required bool fromEditProfile}) {
  //   Get.defaultDialog(
  //       barrierDismissible: false,
  //       title: 'audio_permission'.tr,
  //       middleText: 'you_must_allow_permission_for_further_use'.tr,
  //       confirm: TextButton(onPressed: () async {
  //         final serviceStatus = await Permission.microphone.status ;
  //         if(serviceStatus.isGranted){
  //           Get.offNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
  //         }
  //         else{
  //           await openAppSettings().then((value)async{
  //             // final serviceStatus = await Permission.camera.status ;
  //             if(serviceStatus.isGranted){
  //               if(fromEditProfile == true){
  //                return Get.toNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
  //               }
  //               else{
  //                return Get.offNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
  //               }
  //             }
  //             else{
  //               showAudioPermanentlyDeniedDialog(fromEditProfile: fromEditProfile);
  //             }
  //           });
  //         }
  //
  //       }, child: Text('go_to_settings'.tr))
  //   );
  // }

  void showDeniedDialog({@required bool fromEditProfile}) {
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'camera_permission'.tr,
      middleText: 'you_must_allow_permission_for_further_use'.tr,
      confirm: TextButton(onPressed: () async{
        Permission.camera.request().then((value) async{
          var status = await Permission.camera.status;
          if (status.isDenied) {
            Get.back();
            Permission.camera.request();

          }
          else if(status.isGranted){
            /*if(fromEditProfile == true){
              Get.back();
             return Get.toNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
            }
            else{
              Get.back();
             return Get.offNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
            }*/
            // Get.back();
            // Get.find<AuthController>().requestMicroPhonePermission(fromEditProfile: fromEditProfile);
          }
          else if(status.isPermanentlyDenied){
           return showPermanentlyDeniedDialog(fromEditProfile: fromEditProfile);
          }
        });


      }, child: Text('allow'.tr)),
    );

  }

  void showPermanentlyDeniedDialog({@required bool fromEditProfile}) {
    Get.defaultDialog(
        barrierDismissible: false,
        title: 'camera_permission'.tr,
        middleText: 'you_must_allow_permission_for_further_use'.tr,
        confirm: TextButton(onPressed: () async {
          final serviceStatus = await Permission.camera.status ;
          if(serviceStatus.isGranted){
            if(fromEditProfile == true){
              Get.back();
              Get.toNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
            }
            else{
              Get.back();
              Get.offNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
            }
          }
          else{
            await openAppSettings().then((value)async{
              // final serviceStatus = await Permission.camera.status ;
              if(serviceStatus.isGranted){
                if(fromEditProfile == true){
                  Get.back();
                 return Get.toNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
                }
                else{
                  Get.back();
                 return Get.offNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
                }
              }
              else{
                Get.back();
                showPermanentlyDeniedDialog(fromEditProfile: fromEditProfile);
              }
            });
          }

        }, child: Text('go_to_settings'.tr))
    );
  }

  //  @override
  // void onInit() {
  //   super.onInit();
  //   // getImage();
  //   controller = CameraController(cameras[1], ResolutionPreset.medium);
  //   controller.initialize();
  //   update();
  // }
  // @override
  // void onClose() {
  //   super.onClose();
  //   controller.dispose();
  // }
}