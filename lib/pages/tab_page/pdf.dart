// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rt_db_univercity_app/service/storege_service.dart';
import 'package:rt_db_univercity_app/service/util_service.dart';
import 'package:video_player/video_player.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  late VideoPlayerController videoPlay;
  (List<String>, List<String>) allList = ([], []);
  List<String> linkList = [];
  List<String> nameList = [];
  bool isLoading = false;
  File? file;

  Future<File?> takeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  }

  Future<void> upload() async {
    file = await takeFile();
    if (file != null) {
      if (file!.path.endsWith(".txt")) {
        String link = await StorageService.upload(path: "Pdf", file: file!);
        log(link);
        Utils.fireSnackBar("Successfully Uploaded", context);
      } else {
        Utils.fireSnackBar("Eror creat .Pdf", context);
      }
    }
    await getItems();
  }

  Future<void> getItems() async {
    isLoading = false;
    allList = await StorageService.getData("Pdf");
    linkList = allList.$1;
    nameList = allList.$2;
    log(linkList.toString());
    isLoading = true;
    setState(() {});
  }

  Future<void> delete(String url) async {
    isLoading = false;
    setState(() {});
    await StorageService.delete(url);
    await getItems();
  }

  // @override
  // void initState() {
  //   videoPlay = VideoPlayerController.networkUrl(url)
  //   getItems();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: ListView.builder(
                  itemCount: linkList.length,
                  itemBuilder: (_, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (contex) {
                                return AlertDialog(
                                  content: nameList[index].endsWith(".pdf")
                                      ? Image.network(linkList[index])
                                      : Image.network(
                                          "https://www.pixsector.com/cache/517d8be6/av5c8336583e291842624.png"),
                                );
                              });
                        },
                        leading: nameList[index].endsWith(".png") ||
                                nameList[index].endsWith(".jpg")
                            ? Image.network(linkList[index])
                            : Image.network(
                                "https://i.pinimg.com/474x/3a/0d/51/3a0d510e8aff0312920ce1bcb5b022ac.jpg"),
                        title: Text(nameList[index]),
                        trailing: IconButton(
                          onPressed: () async {
                            log(linkList[index]);
                          },
                          icon: const Icon(Icons.download),
                        ),
                        onLongPress: () async {
                          await delete(linkList[index]);
                        },
                      ),
                    );
                  }),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await upload();
        },
        child: const Icon(Icons.picture_as_pdf_outlined),
      ),
    );
  }
}
