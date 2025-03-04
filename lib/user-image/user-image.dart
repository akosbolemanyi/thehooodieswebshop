import 'dart:io';
import 'package:android_studio_projects/provider/theme.provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../provider/theme-changer.provider.dart';
import 'image-rounder.dart';

class UserImage extends StatefulWidget {
  final Function(String imageUrl) onFileChanged;

  UserImage({
    required this.onFileChanged,
  });

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  final ImagePicker _picker = ImagePicker();

  String? _uid = FirebaseAuth.instance.currentUser?.uid;

  String? imageUrl = null;

  // Ez segédlet, megjeleníti az összes collection adatot.
  Future _getDataFromDatabase() async {
    FirebaseFirestore.instance.collection('users').get().then((value) => {
          value.docs.forEach((result) {
            String? email = result.data()['email'];
            print(email);
          })
        });
  }

  void getData() async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    setState(() {
      imageUrl = userDoc.get('imageUrl');
      print("Ez a FireStore: ${imageUrl}");
      print(
          "Ez a FireBaseAuth: ${FirebaseAuth.instance.currentUser?.photoURL}");
    });
  }

  @override
  void initState() {
    // TODO: Check if database is used or the FireBase module.
    super.initState();
    //_getDataFromDatabase();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Stack(
      children: [
        if (imageUrl == '' || imageUrl == null)
          CircleAvatar(
            radius: 70.0,
            backgroundImage: AssetImage('assets/img/default_profile.png'),
          ),
        if (imageUrl != null && imageUrl != '')
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _selectPhoto(),
            child: AppRoundImage.url(
              imageUrl!,
              width: 150,
              height: 150,
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: themeChanger.themeMode == ThemeMode.dark
                  ? Colors.yellow
                  : Colors.blue,
            ),
            child: Center(
              child: IconButton(
                onPressed: () => _selectPhoto(),
                icon: Icon(Icons.change_circle_outlined,
                    color: Colors.black, size: 30),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const LocaleText('camera'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.filter),
                    title: const LocaleText('pick_a_file'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              onClosing: () {},
            ));
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) {
      return;
    }

    var file = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
    if (file == null) {
      return;
    }

    File compressedFile = await compressImage(file.path, 35);

    await _uploadFile(compressedFile.path);
  }

  Future<File> convertXFileToFile(XFile xFile) async {
    return File(xFile.path);
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      newPath,
      quality: quality,
    );
    return convertXFileToFile(result!);
  }

  Future _uploadFile(String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('profile-pictures')
        .child('${DateTime.now().toIso8601String() + p.basename(path)}');

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrl = fileUrl;
    });

    widget.onFileChanged(fileUrl);
  }
}
