
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_url.dart';

class AuthController extends GetxController {
  final createAccountUrl = Uri.parse('${baseUrl}create');
  final loginUrl = Uri.parse('${baseUrl}login');
  final deleteUrl = Uri.parse('${baseUrl}deletememo');
  final addUrl = Uri.parse('${baseUrl}addmemo');
  final signOutUrl = Uri.parse('${baseUrl}signout');

  RxBool isLoading = false.obs;
  RxBool isSignedIn = false.obs;
  RxString token = ''.obs;
  RxList memos = [].obs;
  RxString signInEmail = ''.obs;

  Future<String> createAccount(
    String firstname,
    String lastname,
    String email,
    String password,
  ) async {
    try {
      var createAccountData = await http.post(
        createAccountUrl,
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (createAccountData.statusCode == 200) {
        return 'Account created successfully';
      } else {
        var response = jsonDecode(createAccountData.body);
        return response['message']; // Return error message from server
        //change something here
      }
    } catch (e) {
      return '$e';
    }
  }

  Future<String> signIn(String email, String password) async {
    try {
      var signIndata = await http.post(
        loginUrl,
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      if (signIndata.statusCode == 200) {
        final response = jsonDecode(signIndata.body);
        isSignedIn.value = true;
        token.value = response['token'];
        signInEmail.value = response['email'];
        memos.value = response['memos'];
        memos.clear();
        memos.addAll(response['memos']);
        return 'Login successful';
      } else {
        var response = jsonDecode(signIndata.body);
        return response['message']; // Return error message from server
      }
    } catch (e) {
      return '$e';
    }
  }

  Future<String> addMemo(String content)async{
    try{
      var addMemoData = await http.post(
        addUrl,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token.value,
      }, 
      body: jsonEncode({'content': content}),
      ); 
      if (addMemoData.statusCode == 200) {
        final response = jsonDecode(addMemoData.body);
        memos.clear();
        memos.addAll( response);

        return 'Memo added successfully';
      } else {
        final response = jsonDecode(addMemoData.body);
        return response['message']; // Return error message from server
      }
    } catch (e) {
      return '$e';
    }
  }

  Future<String> deleteMemo(String id)async{
    try{
      var deleteMemoData = await http.post(
        deleteUrl,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token.value,
      }, 
      body: jsonEncode({'id': id}),
      ); 
      if (deleteMemoData.statusCode == 200) {
        final response = jsonDecode(deleteMemoData.body);
        memos.clear();
        if(response.isNotEmpty){
         memos.addAll( response);
        }

        return 'Memo deleted successfully';
      } else {
        final response = jsonDecode(deleteMemoData.body);
        return response['message']; // Return error message from server
      }
    } catch (e) {
      return '$e';
    }
  }
 
  void signout(){
    Get.offNamed('/signin');
    isSignedIn.value = false;
    token.value = '';
    memos.clear();
  }

}

 class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}
