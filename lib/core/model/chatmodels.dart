import 'package:package_chatbot/core/model/ho_so_1_cua.dart';
import 'package:package_chatbot/core/model/tracuubiennhanmodel.dart';
import 'package:package_chatbot/core/model/tracuudiadiemmodel.dart';
import 'package:package_chatbot/core/model/tracuutthcmodel.dart';

import 'botmessasge.dart';
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
    this.line = false
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
  TraCuuBienNhanModel? traCuuBienNhan;
  HoSo1Cua? traCuuHoSo1Cua;
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
      this.maLoaiDanhMuc,
      this.traCuuHoSo1Cua
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
    traCuuBienNhan = json['traCuuBienNhan'] != null
        ? TraCuuBienNhanModel.fromJson(json['traCuuBienNhan'])
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
    traCuuHoSo1Cua = json['traCuuHoSo1Cua'] != null
        ? HoSo1Cua.fromJson(json['traCuuHoSo1Cua'])
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

    if (traCuuBienNhan != null) {
      data['traCuuBienNhan'] = traCuuBienNhan!.toJson();
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

    if (traCuuHoSo1Cua != null) {
      data['traCuuHoSo1Cua'] = traCuuHoSo1Cua!.toJson();
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
