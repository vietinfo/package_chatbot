import 'package:package_chatbot/core/model/tracuubiennhanmodel.dart';
import 'package:package_chatbot/core/model/tracuudiadiemmodel.dart';
import 'package:package_chatbot/core/model/tracuutthcmodel.dart';

import 'botmessasge.dart';
import 'ds_chu_nang_model.dart';

class ChatModel {
  int? userId;
  String? userName;
  String? messRight;
  String? messLeft;
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
  DateTime? createDate;
  bool isReadMore;

  ChatModel({
    this.isHeader = false,
    this.isListDM = false,
    this.isListDM1 = false,
    this.isInfo = false,
    this.isTTHC = false,
    this.isTTQH = false,
    this.isTTQHEnd = false,
    this.isTTHS = false,
    this.isReadMore = false,
    this.isTTHSEnd = 0,
    this.userId,
    this.userName,
    this.messRight,
    this.messLeft,
    this.listDanhMuc,
    this.traCuu,
    this.listTTHC,
    this.createDate,
  });
}

class TraCuu {
  List<TraCuuDiaDiemModels>? data;
  TraCuuDiaDiemModels? data1;
  TraCuuBienNhanModel? traCuuBienNhan;
  List<TraCuuTTHCmodel>? traCuuTTHCmodel;
  ChiTietQuyHoachModel? chiTietQuyHoachModel;
  String? type;

  List<BotMessage>? dataBot;
  int? banKinh;
  String? maLoaiDanhMuc;
  String? tenDM;

  TraCuu(
      {this.data,
      this.type,
      this.data1,
      this.traCuuBienNhan,
      this.traCuuTTHCmodel,
      this.chiTietQuyHoachModel,
      this.dataBot,
      this.banKinh,
      this.tenDM,
      this.maLoaiDanhMuc});
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
