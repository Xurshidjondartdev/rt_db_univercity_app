import 'package:flutter/material.dart';
import 'package:rt_db_univercity_app/model/post_model.dart';
import 'package:rt_db_univercity_app/service/rtdb_service.dart';

class RTPage extends StatefulWidget {
  const RTPage({super.key});

  @override
  State<RTPage> createState() => _RTPageState();
}

class _RTPageState extends State<RTPage> {
  bool isLoading = false;
  List<Post> postList = [];

  ///add post
  Future<void> addNewPost() async {
    isLoading = false;
    setState(() {});
    Post post = Post(
        userId: "posts",
        firstname: "firstname",
        lastname: "lastname",
        date: "date",
        content: "content");
    await RTDBService.create(path: "posts", post: post);
    await loadPost();
    isLoading = true;
    setState(() {});
  }

  ///load post
  Future<void> loadPost() async {
    isLoading = false;
    setState(() {});
    postList = await RTDBService.read(path: "posts");
    setState(() {});
  }

  ///update post
  Future<void> updatePost(Post post) async {
    isLoading = false;
    setState(() {});
    await RTDBService.update(path: 'posts', post: post);
    await loadPost();
    isLoading = true;
    setState(() {});
  }

  // remove
  Future<void> remove(String key) async {
    isLoading = false;
    setState(() {});
    await RTDBService.delete(path: "posts", postKey: key);
    await loadPost();
    isLoading = true;
    setState(() {});
  }

  @override
  void initState() {
    loadPost().then((value) {
      isLoading = true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: ListView.builder(
                  itemCount: postList.length,
                  itemBuilder: (_, __) {
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          Post post = Post(
                              postKey: postList[__].postKey,
                              userId: 'xurshid',
                              firstname: 'umarov',
                              lastname: 'axsa',
                              date: 'date',
                              content: 'content');
                          await updatePost(post);
                        },
                        onLongPress: () async {
                          await remove(postList[__].postKey!);
                        },
                        title: Text(postList[__].firstname),
                        subtitle: Text(postList[__].content),
                        leading: Text(postList[__].userId),
                        trailing: Text(postList[__].date),
                      ),
                    );
                  }),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addNewPost();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
