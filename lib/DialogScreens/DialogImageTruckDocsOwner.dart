import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ownerapp/DialogScreens/DialogFailed.dart';
import 'package:ownerapp/DialogScreens/DialogProcessing.dart';
import 'package:ownerapp/DialogScreens/DialogSuccess.dart';
import 'package:ownerapp/HttpHandler.dart';

class DialogImageTruckDocs {
  static DialogImageTruckDocs _instance = new DialogImageTruckDocs.internal();
  BuildContext context;
  String title;
  String truckId;
  String fileName;
  File imageFile;
  bool imageDone;
  String srcURL;

  void postUpdateImageRequest() async {
    DialogProcessing().showCustomDialog(context,
        title: "Updating Docs", text: "Processing, Please Wait!");
    HTTPHandler().editTruckImage(
        [truckId, fileName, imageFile.path.toString()]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Updating Docs");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Updating Docs", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      print(error);
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Updating Docs", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  Future<void> getNewFile() async {
    imageFile = await FilePicker.getFile();
    if (imageFile.existsSync()) {
      imageDone = true;
    }
  }

  DialogImageTruckDocs.internal();

  factory DialogImageTruckDocs() => _instance;

  void showCustomDialog(BuildContext context,
      {String title, String truckId, String fileName, String srcURL}) {
    this.context = context;
    this.title = title;
    this.truckId = truckId;
    this.fileName = fileName;
    this.srcURL = srcURL;

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                this.title,
                style: TextStyle(fontSize: 30.0),
              ),
              Container(
                child: Image.network(
                  srcURL,
                  fit: BoxFit.fill,
                  height: 400.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      getNewFile();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.6),
                      radius: 30.0,
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      postUpdateImageRequest();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.6),
                      radius: 30.0,
                      child: Icon(
                        Icons.save,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
