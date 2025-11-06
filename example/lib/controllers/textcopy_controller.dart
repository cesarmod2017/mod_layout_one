import 'package:get/get.dart';

class TextCopyController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print(
        '[TextCopyBinding] ${DateTime.now()} - onInit - Controller initialized');
  }

  @override
  void onReady() {
    super.onReady();
    print(
        '[TextCopyBinding] ${DateTime.now()} - onReady - Controller ready for use');
  }

  @override
  void onClose() {
    print(
        '[TextCopyBinding] ${DateTime.now()} - onClose - Controller being disposed');
    super.onClose();
  }
}
