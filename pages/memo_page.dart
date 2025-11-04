import 'package:flutter/material.dart';
import 'package:project/utilities/dependencies.dart' as dependencies;
import 'package:get/get.dart';
import 'package:project/dialogs/add_memo-dilog.dart';
import 'package:project/dialogs/delete_memo_dialog.dart';
import 'package:project/dialogs/sign_out_dialog.dart';
import 'package:intl/intl.dart';

class Memocard extends StatelessWidget {
  final String content;
  final String timeStamp;
  final int index;
  final Function scrollToBottom;

  const Memocard({
    Key? key,
    required this.content,
    required this.timeStamp,
    required this.index,
    required this.scrollToBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      elevation: 5,
      surfaceTintColor: DefaultSelectionStyle.defaultColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMEd().add_jm().format(
                    DateTime.parse(timeStamp).add(const Duration(hours: 3)),
                  ),
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteMemoDialog(
                          index: index,
                          scrollTobottom: scrollToBottom,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(content, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  var memoController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  RxString status = 'type-memo'.obs;
  void scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.find<dependencies.AuthController>().isSignedIn()) {
        Get.toNamed('/home_page');
      }

      if (Get.find<dependencies.AuthController>().memos.isNotEmpty) {
        scrollToBottom();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.find<dependencies.AuthController>().signInEmail.value),//some changes here
        backgroundColor: Colors.white70,
        surfaceTintColor: DefaultSelectionStyle.defaultColor,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const SignOutDialog();
                },
              );
            },
          ),
        ],

      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              var memos = Get.find<dependencies.AuthController>().memos;
              if (memos.isEmpty) {
                return Center(
                  child: Text(
                    status.value,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              } else {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: memos.length,
                  itemBuilder: (context, index) {
                    return Memocard(
                      content: Get.find<dependencies.AuthController>().memos[index]['content'],
                      timeStamp: Get.find<dependencies.AuthController>().memos[index]['timestamp'],
                      index: index,
                      scrollToBottom: scrollToBottom,
                    );
                  },
                );
              }
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: memoController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your memo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (memoController.text.trim().isEmpty) {
                      status.value = 'empty-memo';
                      return;
                    }
                    status.value = 'adding-memo';
                    await Get.find<dependencies.AuthController>()
                        .addMemo(memoController.text.trim());
                    memoController.clear();
                    status.value = 'type-memo';
                    scrollToBottom();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
