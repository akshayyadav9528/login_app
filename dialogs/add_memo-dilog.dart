import 'package:flutter/material.dart';
import 'package:project/utilities/dependencies.dart' as dependencies;
import 'package:get/get.dart';

class AddMemoDialog extends StatefulWidget {
  final Function scrollTobottom;
  const AddMemoDialog({super.key, required this.scrollTobottom});

  @override
  State<AddMemoDialog> createState() => _AddMemoDialogState();
}

class _AddMemoDialogState extends State<AddMemoDialog> {
  RxString status = 'type-memo'.obs;
  final TextEditingController _memoController = TextEditingController();
  

  @override
  Widget typeMemowidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: _memoController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'type something',
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    status.value = 'adding memo...';
                  },
                  child: Text('save'.toUpperCase()),
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
          ),
        ],
      ),
    );
  }


  Widget addingMemo() {
    return FutureBuilder(
      future: Get.find<dependencies.AuthController>().addMemo(_memoController.text),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data == 'success') {
          Future.delayed(const Duration(milliseconds: 500), () {
            widget.scrollTobottom();
            Navigator.of(context).pop();
          });
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: Colors.green),
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
                SizedBox(height: 10),
                Text('Memo added successfully!'),
              ],
            ),
          );
        }else{
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
                  child: Text('close'.toUpperCase()),
                ),
              ],
            ),
          );
        }
      },
    );
  }


@override
  Widget build(BuildContext context){
    return Scaffold(
      body: Obx(() => status.value == 'type-memo' ? 
     typeMemowidget() : status.value == 'adding memo...' ? addingMemo() : 
      const SizedBox(),
      )
    );
  }


}
