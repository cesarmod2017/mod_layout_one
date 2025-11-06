import 'package:get/get.dart';

import 'textcopy_controller.dart';

class TextCopyBinding extends Bindings {
  @override
  void dependencies() {
    print(
        '[TextCopyBinding] ${DateTime.now()} - dependencies - Creating TextCopyController');
    Get.put<TextCopyController>(TextCopyController());
  }
}
