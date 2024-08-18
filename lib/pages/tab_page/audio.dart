// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rt_db_univercity_app/service/storege_service.dart';
import 'package:rt_db_univercity_app/service/util_service.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  late AudioPlayer player;

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
      if (file!.path.endsWith(".mp3")) {
        String link = await StorageService.upload(path: "audio", file: file!);
        log(link);
        Utils.fireSnackBar("Successfully Uploaded", context);
      } else {
        Utils.fireSnackBar("Error: Please upload a .mp3 file", context);
      }
    }
    await getItems();
  }

  Future<void> getItems() async {
    isLoading = false;
    allList = await StorageService.getData("audio");
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
    player = AudioPlayer();
    getItems();
    super.initState();
  }

  void showDeleteConfirmationDialog(String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tasdiqlash"),
          content: const Text("Siz ushbu faylni o'chirmoqchimisiz?"),
          actions: [
            TextButton(
              child: const Text("Bekor qilish"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("O'chirish"),
              onPressed: () async {
                await delete(url);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                        onTap: () async {
                          player.setSourceUrl(linkList[index]);
                          await player.play(UrlSource(linkList[index]));
                        },
                        leading: Image.network(
                          "https://cdn1.iconfinder.com/data/icons/social-messaging-ui-color-shapes/128/volume-circle-blue-512.png",
                        ),
                        title: Text(nameList[index]),
                        trailing: IconButton(
                          onPressed: () async {
                            showDeleteConfirmationDialog(linkList[index]);

                            log(linkList[index]);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        onLongPress: () async {
                          await player.pause();
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
        child: const Icon(Icons.audiotrack_outlined),
      ),
    );
  }
}
