import 'package:package_chatbot/core/model/tracuubiennhanmodel.dart';
import 'package:package_chatbot/core/model/tracuudiadiemmodel.dart';
import 'package:package_chatbot/core/model/tracuutthcmodel.dart';

import 'ds_chu_nang_model.dart';

class ChatModel {
  String? iD;
  String? messLeft;
  String? messRight;
  bool isHeader;
  bool isInfo;
  bool isListDM;
  bool isListDM1;
  bool isTTHC;
  bool isTTQH;
  bool isTTQHEnd;
  bool isTTHS;
  int isTTHSEnd;
  List<ListDanhMuc>? listDanhMuc;
  List<TraCuuTTHCmodel>? listTTHC;
  TraCuu? traCuu;

  ChatModel({
    this.isHeader = false,
    this.isListDM = false,
    this.isListDM1 = false,
    this.isInfo = false,
    this.isTTHC = false,
    this.isTTQH = false,
    this.isTTQHEnd = false,
    this.isTTHS = false,
    this.isTTHSEnd = 0,
    this.iD,
    this.messLeft,
    this.messRight,
    this.listDanhMuc,
    this.traCuu,
    this.listTTHC,
  });
}

class TraCuu {
  List<TraCuuDiaDiemModels>? data;
  TraCuuDiaDiemModels? data1;
  TraCuuBienNhanModel? traCuuBienNhan;
  List<TraCuuTTHCmodel>? traCuuTTHCmodel;
  ChiTietQuyHoachModel? chiTietQuyHoachModel;

  String? type;
  TraCuu(
      {this.data,
      this.type,
      this.data1,
      this.traCuuBienNhan,
      this.traCuuTTHCmodel,
      this.chiTietQuyHoachModel});
}

class ChiTietQuyHoachModel {
  ChiTietQuyHoachModel({
    this.thuaDatId = 0,
    this.tenXa,
    this.soHieuToBanDo,
    this.soThuTuThua,
    this.dienTich = 0.0,
    this.tenLoaiDat,
    this.thongTin,
    this.gisUrl,
  });

  int thuaDatId;
  String? tenXa;
  String? soHieuToBanDo;
  String? soThuTuThua;
  double dienTich;
  String? tenLoaiDat;
  String? thongTin;
  String? gisUrl;

  factory ChiTietQuyHoachModel.fromJson(Map<String, dynamic> json) =>
      ChiTietQuyHoachModel(
        thuaDatId: json['thuaDatID'],
        tenXa: json['tenXa'],
        soHieuToBanDo: json['soHieuToBanDo'],
        soThuTuThua: json['soThuTuThua'],
        dienTich: json['dienTich'].toDouble(),
        tenLoaiDat: json['tenLoaiDat'],
        thongTin: json['thongTin'],
        gisUrl: json['gisUrl'],
      );

  Map<String, dynamic> toJson() => {
        'thuaDatID': thuaDatId,
        'tenXa': tenXa,
        'soHieuToBanDo': soHieuToBanDo,
        'soThuTuThua': soThuTuThua,
        'dienTich': dienTich,
        'tenLoaiDat': tenLoaiDat,
        'thongTin': thongTin,
        'gisUrl': gisUrl,
      };
}
