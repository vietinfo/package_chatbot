import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/config/local_variable.dart';
import 'package:package_chatbot/core/model/chitietthutucmodel.dart';
import 'package:package_chatbot/core/services/http_request.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
part 'chitietthutuc_api.dart';

class ChiTietThuTucBloc extends BaseBloc {

  final BehaviorSubject<ChiTietThuTucModel> chiTietThuTuc =
      BehaviorSubject<ChiTietThuTucModel>();

  void getChiTietThuTuc(int thuTucID) {
    _chiTietThuTucAPI(thuTucID: thuTucID).then((value) {
      chiTietThuTuc.sink.add(value!);
    });
  }

  Future downloadFile(String url) async{
    final sysPath = await path_provider.getTemporaryDirectory();
    final _direct = join('${sysPath.path}/HocMon/${path.basename(url)}');
    if (!await File(_direct).exists())

    final String data = await downLoadFile(url, _direct);

    await OpenFile.open(_direct);
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chiTietThuTuc.close();
  }
}
