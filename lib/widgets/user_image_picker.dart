import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// I need this package for File _pickedImageFile
import 'dart:io';

// I use statefull Widget
// I need to manage some state for picking the image
// and showing a preview of image before we uppload it
class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

// I need this for manage selected image in authentication form
  final void Function(File pickedImage) onPickImage;

  @override
  State<StatefulWidget> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  // I use the "?" bellow to make it clear that this is not necessairly set. (= oxi orismeno aparaitita)
  File? _pickedImageFile;

  void _pickImage() async {
    // borw na xrisimopoihsw kai to gallery san pigh eikonas
    ////final pickedImageGalerry = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70, maxHeight: 200);
    //
    // orizw apo poy pernw ti fwto, ti diastaseis tha exei
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    //
    // ean o xrhsths den epileksei kapoi fwto den xalase o kosmos
    // to app sinexizei kanonika.
    if (pickedImage == null) {
      return;
    }

    // edw paw otan to image picker den einai null
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // gia na exw kukliko to avatar ths fwto pou traviksa
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.green,
          // edw thelw na fenetai h miniatoura ts fwto pou trabikse o xristis
          //
          // only if is not null make it visible, Otherwise, make the space empty(null)
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
          // When I touch the button I wil trigger the camera to open
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        )
      ],
    );
  }
}
