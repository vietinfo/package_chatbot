import 'package:package_chatbot/core/model/ho_so_1_cua_model.dart';
import 'package:package_chatbot/core/model/ho_so_dat_dai_model.dart';
import 'package:package_chatbot/core/model/tra_cuu_dia_diem_model.dart';
import 'package:package_chatbot/core/model/tra_cuu_tthc_model.dart';

class BotMessage {
  String? recipientId;
  String? text;
  Custom? custom;

  BotMessage({this.recipientId, this.text, this.custom});

  BotMessage.fromJson(Map<String, dynamic> json) {
    recipientId = json['recipient_id'];
    text = json['text'];
    custom =
    json['custom'] != null ? Custom.fromJson(json['custom']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recipient_id'] = recipientId;
    data['text'] = text;
    if (custom != null) {
      data['custom'] = custom!.toJson();
    }
    return data;
  }
}

class Custom {
  Data? data;
  String? type;

  Custom({this.data, this.type});

  Custom.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['type'] = type;
    return data;
  }
}

class Data {
  String? maCoQuan;
  String? tenCoQuan;
  int? lat;
  int? long;
  int? banKinh;
  String? maLoaiDanhMuc;
  List<TraCuuDiaDiemModels>? traCuuDiaDiem;
  HoSo1CuaModel? hoSo1Cua;
  HoSoDatDaiModel? hoSoDatDai;
  List<TraCuuTTHCmodel>? traCuuTTHC;

  Data({ this.traCuuDiaDiem,this.maCoQuan,
    this.hoSo1Cua,
    this.traCuuTTHC,
    this.tenCoQuan,
    this.lat,
    this.long,
    this.banKinh,
    this.maLoaiDanhMuc,
    this.hoSoDatDai
  });

  Data.fromJson(Map<String, dynamic> json) {
    maCoQuan = json['maCoQuan'];
    tenCoQuan = json['tenCoQuan'];
    lat = json['lat'];
    long = json['long'];
    banKinh = json['banKinh'];
    maLoaiDanhMuc = json['maLoaiDanhMuc'];

    //------------------------//
    if (json['result'] is List) {

      traCuuDiaDiem = <TraCuuDiaDiemModels>[];
      json['result'].forEach((v) {
        traCuuDiaDiem!.add(TraCuuDiaDiemModels.fromJson(v));
      });



      traCuuTTHC = <TraCuuTTHCmodel>[];
      json['result'].forEach((v) {
        traCuuTTHC!.add(TraCuuTTHCmodel.fromJson(v));
      });

    }else{

      hoSo1Cua = json['result'] != null
          ? HoSo1CuaModel.fromJson(json['result'])
          : null;

      hoSoDatDai = json['result'] != null
          ? HoSoDatDaiModel.fromJson(json['result'])
          : null;

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maCoQuan'] = maCoQuan;
    data['tenCoQuan'] = tenCoQuan;
    data['lat'] = lat;
    data['long'] = long;
    data['banKinh'] = banKinh;
    data['maLoaiDanhMuc'] = maLoaiDanhMuc;
    if (traCuuDiaDiem != null) {
      data['result'] = traCuuDiaDiem!.map((v) => v.toJson()).toList();
    }

    if(hoSo1Cua != null){
      data['result'] = hoSo1Cua!.toJson();
    }

    if(hoSoDatDai != null){
      data['result'] = hoSoDatDai!.toJson();
    }

    if(traCuuTTHC != null){
      data['result'] = traCuuTTHC!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

