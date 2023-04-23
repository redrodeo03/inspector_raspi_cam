import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> captureImage(BuildContext context) async  {
  final ImagePicker picker = ImagePicker();
  XFile? imageFile;
  return showModalBottomSheet<XFile?>(
      context: context,
      isDismissible: true,
      builder: (context) {
        return Wrap(children: [
          ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () async {
                
                imageFile = await picker.pickImage(
                  source: ImageSource.camera,
                );    
                Navigator.pop(context,imageFile);
              }),
          ListTile(
            leading: const Icon(Icons.browse_gallery_outlined),
            title: const Text('Gallery'),
            onTap: () async {
              //todo
              imageFile = await picker.pickImage(
                source: ImageSource.gallery,
              );
              Navigator.pop(context,imageFile);
            },
          )
        ]);
      });
 // return imageFile;
}
