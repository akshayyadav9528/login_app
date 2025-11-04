import 'package:flutter/material.dart';

import 'package:project/utilities/dependencies.dart' as dependencies;
import 'package:get/get.dart';

class DeleteMemoDialog extends StatefulWidget {
  final int index;
  final Function scrollTobottom;
  const DeleteMemoDialog({
    super.key,
    required this.index,
    required this.scrollTobottom,
  });

  @override
  State<DeleteMemoDialog> createState() => _DeleteMemoDialogState();
}

class _DeleteMemoDialogState extends State<DeleteMemoDialog> {
  RxString status = 'delete-memo'.obs;
  var memoController = TextEditingController();

  Widget deletememowidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('delete this memo?'),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  status.value = 'deleting memo...';
                },
                child: Text('delete'.toUpperCase()),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('cancel'.toUpperCase()),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget deletingMemo() {
    return FutureBuilder(
      future: Get.find<dependencies.AuthController>().deleteMemo(
        widget.index.toString(),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Memo deleting successfully'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          );
        } else if (snapshot.data == 'success') {
          Future.delayed(const Duration(seconds: 2), () {
            if (Get.find<dependencies.AuthController>().memos.isEmpty) {
              widget.scrollTobottom();
            }
            Navigator.of(context).pop();
          });
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: Colors.green),
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
                SizedBox(height: 10),
                Text('Memo deleted successfully!'),
              ],
            ),
          );
        } else{
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(height: 10),
                Text(snapshot.data!),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => status.value == 'delete-memo' ? deletememowidget()
       : status.value == 'deleting-memo' ? deletingMemo() : Container()),
    );
  }
}