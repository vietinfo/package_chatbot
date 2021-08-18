import 'package:package_chatbot/core/model/ho_so_dat_dai_model.dart';
import 'package:package_chatbot/core/model/ho_so_1_cua_model.dart';
import 'package:package_chatbot/core/model/tra_cuu_dia_diem_model.dart';
import 'package:package_chatbot/core/model/tra_cuu_tthc_model.dart';

import 'bot_messasge.dart';
import 'ds_chu_nang_model.dart';

class ChatModel {
  int? id;
  String? userName;
  String? messRight;
  String? messLeft;
  bool? isHeader = false;
  bool? isInfo = false;
  bool? isListDM = false;
  bool? isListDM1 = false;
  bool? isTTHC = false;
  bool? isTTQH = false;
  bool? isTTQHEnd = false;
  bool? isTTHS = false;
  int? isTTHSEnd = 0;

  // List<ListDanhMuc>? listDanhMuc;
  String? listDanhMuc;

  // List<TraCuuTTHCmodel>? listTTHC;
  String? listTTHC;
  String? traCuu;
  bool? isReadMore = false;
  DateTime? createDate;

  bool? line = false;
  String? checkTTHS;
  // check tra cuu quy hoach
  int? isTCQH = 0;

  ChatModel({
    this.id,
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
    this.userName,
    this.messRight,
    this.messLeft,
    this.listDanhMuc,
    this.traCuu,
    this.listTTHC,
    this.createDate,
    this.line = false,
    this.checkTTHS,
    this.isTCQH = 0
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    messLeft = json['messLeft'];
    messRight = json['messRight'];
    isHeader = json['isHeader'];
    isInfo = json['isInfo'];
    isListDM = json['isListDM'];
    isListDM1 = json['isListDM1'];
    isTTHC = json['isTTHC'];
    isTTQH = json['isTTQH'];
    isTTQHEnd = json['isTTQHEnd'];
    isTTHS = json['isTTHS'];
    isTTHSEnd = json['isTTHSEnd'];
    listDanhMuc = json['listDanhMuc'];
    listTTHC = json['listTTHC'];
    traCuu = json['traCuu'];
    isReadMore = json['isReadMore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['messLeft'] = this.messLeft;
    data['messRight'] = this.messRight;
    data['isHeader'] = this.isHeader;
    data['isInfo'] = this.isInfo;
    data['isListDM'] = this.isListDM;
    data['isListDM1'] = this.isListDM1;
    data['isTTHC'] = this.isTTHC;
    data['isTTQH'] = this.isTTQH;
    data['isTTQHEnd'] = this.isTTQHEnd;
    data['isTTHS'] = this.isTTHS;
    data['isTTHSEnd'] = this.isTTHSEnd;
    data['listDanhMuc'] = this.listDanhMuc;
    data['listTTHC'] = this.listTTHC;
    data['traCuu'] = this.traCuu;
    data['isReadMore'] = this.isReadMore;
    data['createDate'] = this.createDate;
    return data;
  }
}

class TraCuu {
  List<TraCuuDiaDiemModels>? data;
  TraCuuDiaDiemModels? data1;
  HoSo1CuaModel? traCuuHS1Cua;
  HoSoDatDaiModel? traCuuHSDatDai;
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
      this.traCuuHS1Cua,
      this.traCuuTTHCmodel,
      this.chiTietQuyHoachModel,
      this.dataBot,
      this.banKinh,
      this.tenDM,
      this.maLoaiDanhMuc,
      this.traCuuHSDatDai
      });

  TraCuu.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TraCuuDiaDiemModels>[];
      json['data'].forEach((v) {
        data!.add(TraCuuDiaDiemModels.fromJson(v));
      });
    }

    data1 = json['data1'] != null
        ? TraCuuDiaDiemModels.fromJson(json['data1'])
        : null;
    traCuuHS1Cua = json['traCuuBienNhan'] != null
        ? HoSo1CuaModel.fromJson(json['traCuuBienNhan'])
        : null;

    if (json['traCuuTTHCmodel'] != null) {
      traCuuTTHCmodel = <TraCuuTTHCmodel>[];
      json['traCuuTTHCmodel'].forEach((v) {
        traCuuTTHCmodel!.add(TraCuuTTHCmodel.fromJson(v));
      });
    }

    chiTietQuyHoachModel = json['chiTietQuyHoachModel'] != null
        ? ChiTietQuyHoachModel.fromJson(json['chiTietQuyHoachModel'])
        : null;
    type = json['type'];

    if (json['dataBot'] != null) {
      dataBot = <BotMessage>[];
      json['dataBot'].forEach((v) {
        dataBot!.add(BotMessage.fromJson(v));
      });
    }

    banKinh = json['banKinh'];
    maLoaiDanhMuc = json['maLoaiDanhMuc'];
    tenDM = json['tenDM'];
    traCuuHSDatDai = json['traCuuHoSo1Cua'] != null
        ? HoSoDatDaiModel.fromJson(json['traCuuHoSo1Cua'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    if (data1 != null) {
      data['data1'] = data1!.toJson();
    }

    if (traCuuHS1Cua != null) {
      data['traCuuBienNhan'] = traCuuHS1Cua!.toJson();
    }

    if (traCuuTTHCmodel != null) {
      data['traCuuTTHCmodel'] =
          traCuuTTHCmodel!.map((v) => v.toJson()).toList();
    }

    if (chiTietQuyHoachModel != null) {
      data['chiTietQuyHoachModel'] = chiTietQuyHoachModel!.toJson();
    }
    data['type'] = this.type;
    if (dataBot != null) {
      data['dataBot'] = dataBot!.map((v) => v.toJson()).toList();
    }
    data['banKinh'] = this.banKinh;
    data['maLoaiDanhMuc'] = this.maLoaiDanhMuc;
    data['tenDM'] = this.tenDM;

    if (traCuuHSDatDai != null) {
      data['traCuuHoSo1Cua'] = traCuuHSDatDai!.toJson();
    }
    return data;
  }
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
