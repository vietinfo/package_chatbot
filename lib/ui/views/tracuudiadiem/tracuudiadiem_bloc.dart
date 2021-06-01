import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/config/local_variable.dart';
import 'package:package_chatbot/core/model/tracuudiadiemmodel.dart';
import 'package:package_chatbot/core/services/http_request.dart';
import 'package:rxdart/rxdart.dart';
part 'tracuudiadiem_api.dart';

class TraCuuDiaDiemBloc extends BaseBloc{

  final BehaviorSubject<List<TraCuuDiaDiemModels>> traCuuDiaDiem = BehaviorSubject<List<TraCuuDiaDiemModels>>();
  List<TraCuuDiaDiemModels>? _tempList ;


  //
  void traCuuDD1({double? lat, double? long, int? banKinh, String? maLoaiDanhMuc, int? pageNum, String? tenCoQuan, String? maCoQuan}){

    showLoadingController.sink.add(true);
    _traCuuDiaDiemAPI(banKinh: banKinh, maLoaiDanhMuc: maLoaiDanhMuc,pageNum: pageNum, maCoQuan: maCoQuan,tenCoQuan: tenCoQuan, lat: lat, long: long).then((value) {

      if (value == null || traCuuDiaDiem.isClosed) {
        showLoadingController.sink.add(false);
        return;
      }
      if (pageNum == 1) {
        isLoadMoreController.sink.add(true);
        _tempList = <TraCuuDiaDiemModels>[];
      }
      if (value.isEmpty) {
        isLoadMoreController.sink.add(false);
        showLoadingController.sink.add(false);
        if (_tempList == null || _tempList!.isEmpty)
          traCuuDiaDiem.sink.add(<TraCuuDiaDiemModels>[]);
        return;
      }

      _tempList!.addAll(value);
      traCuuDiaDiem.sink.add(_tempList!);
      showLoadingController.sink.add(false);

    });

  }


  //
  void traCuuDD({double? lat, double? long, int? banKinh, String? maLoaiDanhMuc, int? pageNum}){

    showLoadingController.sink.add(true);
    _traCuuDiaDiemAPI(banKinh: banKinh, maLoaiDanhMuc: maLoaiDanhMuc,pageNum: pageNum, lat: lat, long: long).then((value) {

      if (value == null || traCuuDiaDiem.isClosed) {
        showLoadingController.sink.add(false);
        return;
      }
      if (pageNum == 1) {
        isLoadMoreController.sink.add(true);
        _tempList = <TraCuuDiaDiemModels>[];
      }
      if (value.isEmpty) {
        isLoadMoreController.sink.add(false);
        showLoadingController.sink.add(false);
        if (_tempList == null || _tempList!.isEmpty)
          traCuuDiaDiem.sink.add(<TraCuuDiaDiemModels>[]);
        return;
      }

      _tempList!.addAll(value);
      traCuuDiaDiem.sink.add(_tempList!);
      showLoadingController.sink.add(false);

    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    traCuuDiaDiem.close();
  }

}