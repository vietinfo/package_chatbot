import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/config/local_variable.dart';
import 'package:package_chatbot/core/model/chi_tiet_thu_tuc_model.dart';
import 'package:package_chatbot/core/services/http_request.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
part 'chitietthutuc_api.dart';

class ChiTietThuTucBloc extends BaseBloc {

  final BehaviorSubject<ChiTietThuTucModel> chiTietThuTuc =
      BehaviorSubject<ChiTietThuTucModel>();
  final PublishSubject<Map<String, dynamic>> checkDowLoad =
  PublishSubject<Map<String, dynamic>>();

  final PublishSubject<double> progress = PublishSubject<double>();


  void getChiTietThuTuc(int thuTucID) {
    _chiTietThuTucAPI(thuTucID: thuTucID).then((value) {
      chiTietThuTuc.sink.add(value!);
    });
  }


  Future checkDowloadFile(List<Files> file) async {
    final sysPath = await path_provider.getTemporaryDirectory();
    for(var a in file){
      if(a.templateTrong != null){
        final _direct = join('${sysPath.path}/HocMon/${path.basename(a.templateTrong!)}');
        if (!await File(_direct).exists()) {
          checkDowLoad.sink.add({'check' : a.isCheck});
        } else {
          a.isCheck = true;
          checkDowLoad.sink.add({'linkFile': _direct,'check' : a.isCheck});
        }
      }else{
        a.isCheck = false;
        checkDowLoad.sink.add({'check' : a.isCheck});
      }
    }

  }


  Future downloadFile(String url, Files index, int p) async{
    final sysPath = await path_provider.getTemporaryDirectory();
    final _direct = join('${sysPath.path}/HocMon/${path.basename(url)}');
    final String? data = await downLoadFile(url, _direct);
    if(data != null){
      index.isCheck = true;
      checkDowLoad.sink.add({'linkFile': _direct, 'check' : index.isCheck});
    }else{
      index.isCheck = true;
      checkDowLoad.sink.add({'check' : index.isCheck});
    }



  }

  void showDownloadProgress(received, total) {
    if (total > 0) {
      final double calPercent = (received / total * 100);
      if (!progress.isClosed) progress.sink.add(calPercent);
    } else if (!progress.isClosed) progress.sink.add(100.0);
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chiTietThuTuc.close();
    checkDowLoad.close();
    progress.close();
  }

}
