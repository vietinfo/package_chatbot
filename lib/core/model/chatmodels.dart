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

  ChatModel(
      {
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
  // List<TraCuuDiaDiemModels>? data;
  String? data;
  // TraCuuDiaDiemModels? data1;
  String? data1;
  // TraCuuBienNhanModel? traCuuBienNhan;
  String? traCuuBienNhan;
  // List<TraCuuTTHCmodel>? traCuuTTHCmodel;
  String? traCuuTTHCmodel;
  // ChiTietQuyHoachModel? chiTietQuyHoachModel;
  String? chiTietQuyHoachModel;
  String? type;
  // List<BotMessage>? dataBot;
  String? dataBot;
  int? banKinh;
  String? maLoaiDanhMuc;
  String? tenDM;


  TraCuu({this.data,
    this.type,
    this.data1,
    this.traCuuBienNhan,
    this.traCuuTTHCmodel,
    this.chiTietQuyHoachModel,
    this.dataBot,
    this.banKinh,
    this.tenDM,
    this.maLoaiDanhMuc});

  TraCuu.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    data1 = json['data1'];
    traCuuBienNhan = json['traCuuBienNhan'];
    traCuuTTHCmodel = json['traCuuTTHCmodel'];
    chiTietQuyHoachModel = json['chiTietQuyHoachModel'];
    type = json['type'];
    dataBot = json['dataBot'];
    banKinh = json['banKinh'];
    maLoaiDanhMuc = json['maLoaiDanhMuc'];
    tenDM = json['tenDM'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['data1'] = this.data1;
    data['traCuuBienNhan'] = this.traCuuBienNhan;
    data['traCuuTTHCmodel'] = this.traCuuTTHCmodel;
    data['chiTietQuyHoachModel'] = this.chiTietQuyHoachModel;
    data['type'] = this.type;
    data['dataBot'] = this.dataBot;
    data['banKinh'] = this.banKinh;
    data['maLoaiDanhMuc'] = this.maLoaiDanhMuc;
    data['tenDM'] = this.tenDM;
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
