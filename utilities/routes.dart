import 'package:get/get.dart';
import 'package:project/pages/home.dart';
import 'package:project/pages/memo_page.dart';

class Routes {
  static const homepage = '/home';
  static const memopage = '/memo';
}

final getPages =
  [
    GetPage(
      name: Routes.homepage,
      page: () => const Homepage(),
    ),
    GetPage(
      name: Routes.memopage,
      page: () => const MemoPage(),
    ),
  ];