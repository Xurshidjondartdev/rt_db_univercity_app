// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rt_db_univercity_app/pages/tab_page/audio.dart';
import 'package:rt_db_univercity_app/pages/tab_page/image.dart';
import 'package:rt_db_univercity_app/pages/tab_page/pdf.dart';
import 'package:rt_db_univercity_app/pages/tab_page/video.dart';
import 'package:rt_db_univercity_app/service/storege_service.dart';
import 'package:rt_db_univercity_app/service/util_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
      String link = await StorageService.upload(path: "G10", file: file!);
      log(link);
      Utils.fireSnackBar("Successfully Uploaded", context);
    }
  }

  Future<void> getItems() async {
    isLoading = false;
    allList = await StorageService.getData("G10");
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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Storage Application",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 21, 83, 98),
          bottom: const TabBar(
              indicator: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0),
                  width: 5.0,
                ),
              )),
              tabs: <Widget>[
                Tab(
                  icon: Icon(
                    Icons.video_call_rounded,
                    color: Colors.white,
                  ),
                  child: Text(
                    "Vedio",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.audiotrack_outlined,
                    color: Colors.white,
                  ),
                  child: Text(
                    "Audio",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  child: Text(
                    "Pictures",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.picture_as_pdf_outlined,
                    color: Colors.white,
                  ),
                  child: Text(
                    "PDf",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
        ),
        body: const TabBarView(
          children: <Widget>[
            VedioPage(),
            AudioPage(),
            PicturesPage(),
            PdfPage(),
          ],
        ),
      ),
    );
  }
}
