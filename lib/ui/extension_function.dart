import 'package:get/get.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/services/shared_pref.dart';
import 'package:package_chatbot/ui/views/chat/chat_bloc.dart';
import 'package:package_chatbot/ui/views/chat/chat_ui.dart';
import 'views/thuthapthongtin/thu_thap_thong_tin_ui.dart';

class ExtensionFunction {
  ExtensionFunction._();
  static final ExtensionFunction instance = ExtensionFunction._();

  void goChat() {
    Get.to(()=> BlocProvider(child: ChatUI(), bloc: ChatBloc()));
  }

  void goThuThapData() {
    Get.to(()=> ThuThapThongTinUI());
  }

  Future init() async {
    await SharedPref.getInstance();
  }
}
