// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rt_db_univercity_app/service/storege_service.dart';
import 'package:rt_db_univercity_app/service/util_service.dart';

class VedioPage extends StatefulWidget {
  const VedioPage({super.key});

  @override
  State<VedioPage> createState() => _VedioPageState();
}

class _VedioPageState extends State<VedioPage> {
  File? file;
  List<String> linkList = [];
  (List<String>, List<String>) allList = ([], []);
  List<String> nameList = [];
  bool isLoading = false;

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
      if (file!.path.endsWith(".mp4")) {
        String link = await StorageService.upload(path: "vedio", file: file!);
        log(link);
        Utils.fireSnackBar("Successfully Uploaded", context);
      } else {
        Utils.fireSnackBar("Eror creat .mp4", context);
      }
    }
    await getItems();
  }

  Future<void> getItems() async {
    isLoading = false;
    allList = await StorageService.getData("vedio");
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

  @override
  void initState() {
    getItems();
    super.initState();
  }

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
                                  content: nameList[index].endsWith(".mp4")
                                      ? Image.network(linkList[index])
                                      : Image.network(
                                          "https://www.pixsector.com/cache/517d8be6/av5c8336583e291842624.png",fit: BoxFit.cover,),
                                );
                              });
                        },
                        leading: nameList[index].endsWith(".png") ||
                                nameList[index].endsWith(".jpg")
                            ? Image.network(linkList[index])
                            : Image.network(
                                "https://cdn0.iconfinder.com/data/icons/ui-for-commercial/32/vedio_call_live_direct-512.png"),
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
        child: const Icon(
          Icons.video_call_outlined,
          size: 35,
        ),
      ),
    );
  }
}
