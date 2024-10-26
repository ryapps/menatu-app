import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Theme.of(context).primaryColor,
          iconColor: Colors.white,
          title: Text(
            'Pilih Gambar melalui',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromWidth(120),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        width: 2,
                        style: BorderStyle.none,
                      )),
                  padding: EdgeInsets.all(20)),
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Column(
                children: [
                  Icon(
                    Icons.photo,
                    color: Theme.of(context).primaryColor,
                    size: 40,
                  ),
                  Text(
                    'Gallery',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromWidth(120),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        width: 2,
                        style: BorderStyle.none,
                      )),
                  padding: EdgeInsets.all(20)),
              onHover: (value) => false,
              onPressed: () => _pickImage(ImageSource.camera),
              child: Column(
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).primaryColor,
                    size: 40,
                  ),
                  Text(
                    'Camera',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _image != null
                    ? CircleAvatar(maxRadius: 40, child: Image.file(_image!))
                    : CircleAvatar(
                        backgroundImage: AssetImage('assets/img/avatarrr.png'),
                        maxRadius: 40,
                      ),
                SizedBox(height: 5),
                TextButton(
                    onPressed: () {
                      _showAlertDialog();
                    },
                    child: Text('Ubah Gambar',
                        style: TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            color: Colors.white))),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
