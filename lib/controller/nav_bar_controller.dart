import "package:get/get.dart";


class NavigationBarController extends GetxController {
  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    update();
    switch (selectedIndex) {
      case 0:
        Get.offAllNamed('/');
        break;
      case 1:
        Get.offAllNamed('/buddies');
        break;
      case 2:
        Get.offAllNamed('/discover');
        break;
      case 3:
        Get.offAllNamed('/settings');
        break;
    }
  }
}