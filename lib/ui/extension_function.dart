import 'package:get/get.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/config/local_variable.dart';
import 'package:package_chatbot/ui/views/chat/chat_bloc.dart';
import 'package:package_chatbot/ui/views/chat/chat_ui.dart';

class ExtensionFunction {
  ExtensionFunction._();
  static final ExtensionFunction instance = ExtensionFunction._();

  void goChatBot(
      {required String userName,
        int? userId,
      required String fullName,
      required String soDienThoai,
      String urlChatBotAPI = '',
      String urlChatBot = '',
      int quanHuyenID = 0,
      String tenQuanHuyen = ''}) {
    LocalVariable.userName = userName;
    //LocalVariable.userId = userId!;
    LocalVariable.fullName = fullName;
    LocalVariable.soDienThoai = soDienThoai;
    if (urlChatBotAPI.isNotEmpty) LocalVariable.urlAPI = urlChatBotAPI;
    if (urlChatBot.isNotEmpty) LocalVariable.urlChatBot = urlChatBot;
    if (quanHuyenID > 0) LocalVariable.quanHuyenID = quanHuyenID;
    if (tenQuanHuyen.isNotEmpty) LocalVariable.tenQuanHuyen = tenQuanHuyen;

    Get.to(() => BlocProvider(child: ChatUI(), bloc: ChatBloc()));
  }
}
