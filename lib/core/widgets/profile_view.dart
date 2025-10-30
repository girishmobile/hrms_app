import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../provider/profile_provider.dart';
import '../constants/color_utils.dart';
import '../constants/image_utils.dart';
import 'component.dart';
import 'image_pick_and_crop_widget.dart';

class ProfileView extends StatelessWidget {
  final String? assetPath;

  const ProfileView({super.key, this.assetPath});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    ImageProvider imageProvider;

    if (provider.pickedFile != null) {
      imageProvider = FileImage(provider.pickedFile!);
    } else if (provider.imageUrl != null && provider.imageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(provider.imageUrl!);
    } else {
      imageProvider = AssetImage(assetPath ?? icDummyUser);
    }

    return Stack(
      children: [
        // Profile Image
        Container(
          width: 120,
          height: 120,
          decoration: commonBoxDecoration(
            borderColor: Colors.black,
            borderWidth: 2,
            shape: BoxShape.circle,

            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Edit Icon
        Positioned(
          right: 0,
          bottom: 0,
          child: commonInkWell(
            onTap: () async {
              final path = await CommonImagePicker.pickImage(
                context: navigatorKey.currentContext!,
              );
              if (path != null) {
                provider.setPickedFile(File(path));
                print('✅ Image updated: $path');
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: commonBoxDecoration(
                shape: BoxShape.circle,
                color: colorProduct,
              ),
              child: Center(
                child: commonPrefixIcon(image: icEdit, colorIcon: Colors.white,width: 20,height: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
