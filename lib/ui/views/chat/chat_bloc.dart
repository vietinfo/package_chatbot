import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/config/local_variable.dart';
import 'package:package_chatbot/core/model/bot_messasge.dart';
import 'package:package_chatbot/core/model/chat_models.dart';
import 'package:package_chatbot/core/model/ds_chu_nang_model.dart';
import 'package:package_chatbot/core/model/ho_so_dat_dai_model.dart';
import 'package:package_chatbot/core/model/phuong_xa_model.dart';
import 'package:package_chatbot/core/model/ho_so_1_cua_model.dart';
import 'package:package_chatbot/core/model/tra_cuu_dia_diem_model.dart';
import 'package:package_chatbot/core/model/tra_cuu_tthc_model.dart';
import 'package:package_chatbot/core/services/http_request.dart';
import 'package:package_chatbot/core/utils/utilities.dart';
import 'package:package_chatbot/ui/views/tracuudiadiem/tracuudiadiem_bloc.dart';
import 'package:package_chatbot/ui/views/tracuudiadiem/tracuudiadiem_ui.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

part 'chat_api.dart';

class ChatBloc extends BaseBloc {
  List<ChatModel> _listMess = <ChatModel>[];
  final List<TraCuuDiaDiemModels> _traCuuDiaDiem = <TraCuuDiaDiemModels>[];
  List<ListDanhMuc> _listDanhMuc = <ListDanhMuc>[];
  List<PhuongXaModel> _listAllPX = <PhuongXaModel>[];
  List<BotMessage> listBotMess = <BotMessage>[];
  bool _isCheckTTQH = false;
  String _tenPhuong = '';
  String _soTo = '';
  String _soThua = '';
  bool _isCheckTTHS = false;

  final BehaviorSubject<bool> sendController = BehaviorSubject<bool>();

  final BehaviorSubject<bool> scroll = BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<bool> checkHuy = BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<List<ChatModel>> mess =
      BehaviorSubject<List<ChatModel>>();
  final BehaviorSubject<bool> typing = BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<List<DanhMucChucNangModels>> dsChucNang =
      BehaviorSubject<List<DanhMucChucNangModels>>();

  final BehaviorSubject<List<ListDanhMuc>> lDanhMuc =
      BehaviorSubject<List<ListDanhMuc>>();
  final BehaviorSubject<Map<bool, String>> isCheckLocation =
      BehaviorSubject<Map<bool, String>>.seeded({false: '1'});

  final BehaviorSubject<TraCuuDiaDiemModels> traCuuDiaDiem =
      BehaviorSubject<TraCuuDiaDiemModels>();

  final BehaviorSubject<List<PhuongXaModel>> dsPhuongXa =
      BehaviorSubject<List<PhuongXaModel>>();



  /// Get lich su chat
  void getAllHistoryChat({
    String? userName,
    String? tinNhan,
    List<ListDanhMuc>? listDanhMuc,
    String? maChucNang,
    int? pageNum,
  }) {
    _getAllHistoryChat(userName!, pageNum!).then((value) {
      if (value!.length > 0) {
        _listMess = value;
        mess.sink.add(value);

        _getAllDSChuNangAPI().then((value) {
          dsChucNang.sink.add(value!);
          typing.sink.add(false);
          isCheckLocation.sink.add({false: '1'});
        });
        if (value.length != 2) {
          _listMess.insert(
              0,
              ChatModel(
                  line: true,
                  userName: userName,
                  messLeft: 'H?????ng d???n tra c???u'));
          _listMess.insert(
              0,
              ChatModel(
                  userName: userName,
                  isHeader: true,
                  messLeft:
                      '????? tra c???u th??ng tin b???n vui l??ng b???m ch???n c??c n??t ho???c nh???p ????? tra c???u (v?? d???: Tra c???u th??? t???c h??nh ch??nh)'));
        }
      } else {
        if (tinNhan == 'null') {
          _listMess.insert(
              0,
              ChatModel(
                  userName: userName,
                  isInfo: true,
                  messLeft: 'H?????ng d???n tra c???u'));
          _listMess.insert(
              0,
              ChatModel(
                  userName: userName,
                  isHeader: true,
                  messLeft:
                      '????? tra c???u th??ng tin b???n vui l??ng b???m ch???n c??c n??t ho???c nh???p ????? tra c???u (v?? d???: Tra c???u th??? t???c h??nh ch??nh)'));

          mess.sink.add(_listMess);
          typing.sink.add(true);
          _getAllDSChuNangAPI().then((value) {
            dsChucNang.sink.add(value!);
            typing.sink.add(false);
            isCheckLocation.sink.add({false: '1'});
          });
          // inset data vao db
          var params = {
            'param': [
              ChatModel(
                      userName: userName,
                      isInfo: true,
                      messLeft: 'H?????ng d???n tra c???u')
                  .toJson(),
              ChatModel(
                      userName: userName,
                      isHeader: true,
                      messLeft:
                          '????? tra c???u th??ng tin b???n vui l??ng b???m ch???n c??c n??t ho???c nh???p ????? tra c???u (v?? d???: Tra c???u th??? t???c h??nh ch??nh)')
                  .toJson(),
            ]
          };
          _insertHistoryChat(params);
        } else {
          _listMess.insert(0, ChatModel(messRight: tinNhan));
          mess.sink.add(_listMess);

          typing.sink.add(true);
          var params = {
            'param': [
              ChatModel(userName: userName, messRight: tinNhan).toJson()
            ]
          };
          _insertHistoryChat(params);

          if (listDanhMuc == null) {
            traCuuAPI(userName, tinNhan!, maChucNang!);
          } else {
            traCuuDM(userName, tinNhan!, listDanhMuc);
          }
        }
      }
    });
  }

  /// Gui tin nhan qua api
  void sendMessAPI({
    String? userName,
    String? tinNhan,
    List<ListDanhMuc>? listDanhMuc,
    String? maChucNang,
  }) {
    if (tinNhan == 'null') {
      _listMess.insert(
          0,
          ChatModel(
              userName: userName, isInfo: true, messLeft: 'H?????ng d???n tra c???u'));
      _listMess.insert(
          0,
          ChatModel(
              userName: userName,
              isHeader: true,
              messLeft:
                  '????? tra c???u th??ng tin b???n vui l??ng b???m ch???n c??c n??t ho???c nh???p ????? tra c???u (v?? d???: Tra c???u th??? t???c h??nh ch??nh)'));

      mess.sink.add(_listMess);
      typing.sink.add(true);
      _getAllDSChuNangAPI().then((value) {
        dsChucNang.sink.add(value!);
        typing.sink.add(false);
        isCheckLocation.sink.add({false: '1'});
      });
      // inset data vao db
      var params = {
        'param': [
          ChatModel(
                  userName: userName,
                  isInfo: true,
                  messLeft: 'H?????ng d???n tra c???u')
              .toJson(),
          ChatModel(
                  userName: userName,
                  isHeader: true,
                  messLeft:
                      '????? tra c???u th??ng tin b???n vui l??ng b???m ch???n c??c n??t ho???c nh???p ????? tra c???u (v?? d???: Tra c???u th??? t???c h??nh ch??nh)')
              .toJson(),
        ]
      };
      _insertHistoryChat(params);
    } else {
      //_listMess.addAll(_listMessT);
      _listMess.insert(0, ChatModel(messRight: tinNhan));
      mess.sink.add(_listMess);

      typing.sink.add(true);
      var params = {
        'param': [ChatModel(userName: userName, messRight: tinNhan).toJson()]
      };
      _insertHistoryChat(params);

      if (listDanhMuc == null) {
        traCuuAPI(userName!, tinNhan!, maChucNang!);
      } else {
        traCuuDM(userName!, tinNhan!, listDanhMuc);
      }
    }
  }

  /// Gui tin nhan qua bot
  void sendMessBot(String userName, String tinNhan,
      {List<DanhMucChucNangModels>? danhMucChucNang,
      bool? checkTTHS,
      double? lat,
      double? long,
      int? isCheckTTHS}) {
    //_listMess.addAll(_listMessT);
    _listMess.insert(0, ChatModel(messRight: tinNhan));
    mess.sink.add(_listMess);
    typing.sink.add(true);
    //
    var params = {
      'param': [
        ChatModel(userName: userName, messRight: tinNhan).toJson(),
      ]
    };
    _insertHistoryChat(params);

    _sendChatBot(tinNhan: tinNhan, userName: userName).then((value) {
      if (value!.isNotEmpty) {
        if (value.first.text == 'TCTTQH') {
          _isCheckTTQH = true;
          getAllPhuongXa();
        } else {
          _isCheckTTQH = false;
        }
        if (value.first.text == 'TCTTHS' ||
            value.first.text == 'HoSo1Cua' ||
            value.first.text == 'HoSoDatDai') {
          _isCheckTTHS = true;
        } else {
          _isCheckTTHS = false;
        }
        final DanhMucChucNangModels? checkDMCN =
            danhMucChucNang?.firstWhereOrNull((element) {
          if (element.maChucNang == value.first.text) {
            if (element.listDanhMuc != null) {
              _listDanhMuc = element.listDanhMuc!;
            }
            return true;
          }
          return false;
        });

        if (checkDMCN != null) {
          checkKeyChucNangVaDanhMuc(userName, value,
              tinNhan: tinNhan, listDanhMuc: _listDanhMuc);
        } else {
          checkKeyChucNangVaDanhMuc(userName, value, tinNhan: tinNhan);
        }

        if (value.first.custom != null) {
          switch (value.first.custom!.type) {
            case 'action_tra_cuu_dia_diem_theo_ban_kinh':
              keyTraCuuDiaDiemTheoBanKinh(userName, value,
                  tinNhan: tinNhan, lat: lat, long: long);
              break;
            case 'action_tra_cuu_dia_diem':
              keyTraCuuDiaDiem(userName, value, tinNhan: tinNhan);
              break;
            case 'action_tra_cuu_ho_so_1_cua':
              keyTraCuuHoSo1Cua(userName, value);
              break;
            case 'action_tra_cuu_ho_so_dat_dai':
              keyTraCuuHoSoDatDai(userName, value);
              break;

            case 'action_tra_cuu_thu_tuc_hanh_chinh':
              keyTraCuuTTHC(userName, value, tinNhan);
              break;
          }
        }
        typing.sink.add(false);
      } else {
        checkHuy.sink.add(false);
        _listMess.insert(
            0,
            ChatModel(
              messLeft:
                  'Xin l???i d??? li???u n??y hi???n t???i c???a t??i ch??a ???????c c???p nh???p',
            ));
        mess.sink.add(_listMess);
        typing.sink.add(false);
        var params = {
          'param': [
            ChatModel(
              userName: userName,
              messLeft:
                  'Xin l???i d??? li???u n??y hi???n t???i c???a t??i ch??a ???????c c???p nh???p',
            ).toJson()
          ]
        };
        _insertHistoryChat(params);
      }
    });
  }

  void traCuuAPI(String userName, String tinNhan, String maCN) {
    switch (maCN) {
      case 'TCTTHC':
        _getLinhVucTucHanhChinhAPI().then((value) {
          print(value);
          if (value != null) {
            _listMess.insert(0, ChatModel(messLeft: 'H?????ng d???n tra c???u'));
            _listMess.insert(
                0,
                ChatModel(
                    isTTHC: true,
                    messLeft:
                        '????? ${tinNhan.toLowerCase()} b???n vui l??ng b???m n??t ho???c nh???p ????? tra c???u (vd: ${value.first.tenLinhVuc!.toLowerCase()})',
                    listTTHC: jsonEncode(value)));

            mess.sink.add(_listMess);
            var params = {
              'param': [
                ChatModel(userName: userName, messLeft: 'H?????ng d???n tra c???u')
                    .toJson(),
                ChatModel(
                        userName: userName,
                        isTTHC: true,
                        messLeft:
                            '????? ${tinNhan.toLowerCase()} b???n vui l??ng b???m n??t ho???c nh???p ????? tra c???u (vd: ${value.first.tenLinhVuc!.toLowerCase()})',
                        listTTHC: jsonEncode(value))
                    .toJson()
              ]
            };
            _insertHistoryChat(params);
            typing.sink.add(false);
          } else {
            troGiup(userName);
          }
        });
        break;
      // case 'TCTTHS':
      //   sendThongTinHoSoDatDai(userName, isCheckTTHS: 0);
      //
      //   break;

      case 'TCTTQH':
        sendThongTinPhuongXa(userName, isCheck: 0);
        break;

      default:
        troGiup(userName);
        break;
    }
  }

  void traCuuDM(
      String userName, String tinNhan, List<ListDanhMuc>? listDanhMuc) {
    _listMess.insert(0, ChatModel(messLeft: 'H?????ng d???n tra c???u'));
    _listMess.insert(
        0,
        ChatModel(
            isListDM: true,
            messLeft:
                '????? ${tinNhan.toLowerCase()} b???n vui l??ng b???m n??t ho???c nh???p ????? tra c???u (vd: ${listDanhMuc!.first.tenLoaiDanhMuc})',
            listDanhMuc: jsonEncode(listDanhMuc)));
    mess.sink.add(_listMess);
    typing.sink.add(false);
    isCheckLocation.sink.add({false: '1'});
    var params = {
      'param': [
        ChatModel(userName: userName, messLeft: 'H?????ng d???n tra c???u').toJson(),
        ChatModel(
                userName: userName,
                isListDM: true,
                messLeft:
                    '????? ${tinNhan.toLowerCase()} b???n vui l??ng b???m n??t ho???c nh???p ????? tra c???u (vd: ${listDanhMuc.first.tenLoaiDanhMuc})',
                listDanhMuc: jsonEncode(listDanhMuc))
            .toJson()
      ]
    };
    _insertHistoryChat(params);
  }

  void getDSTTHC(String userName, int linhVucID, {String? tinNhan}) {
    if (tinNhan != null) {
      _listMess.insert(0, ChatModel(messRight: tinNhan));

      var params = {
        'param': [
          ChatModel(userName: userName, messRight: tinNhan).toJson(),
        ]
      };
      _insertHistoryChat(params);

      _getDanhSachThuTucHanhChinhTheoAPI(linhVucID).then((value) {
        if (value != null) {
          //_listMess.addAll(_listMessT);
          _listMess.insert(0, ChatModel(messLeft: 'H?????ng d???n tra c???u'));
          TraCuu data = TraCuu(
              traCuuTTHCmodel: value,
              type: 'action_tra_cuu_thu_tuc_hanh_chinh');
          _listMess.insert(
              0,
              ChatModel(
                  messLeft:
                      '????? tra c???u th??ng tin th??? t???c ${tinNhan.toUpperCase()} b???n vui l??ng ch???n m???c b???n mu???n tra c???u',
                  traCuu: jsonEncode(data.toJson())));
          mess.sink.add(_listMess);
          var params = {
            'param': [
              ChatModel(userName: userName, messLeft: 'H?????ng d???n tra c???u')
                  .toJson(),
              ChatModel(
                      userName: userName,
                      messLeft:
                          '????? tra c???u th??ng tin th??? t???c ${tinNhan.toUpperCase()} b???n vui l??ng ch???n m???c b???n mu???n tra c???u',
                      traCuu: jsonEncode(data.toJson()))
                  .toJson()
            ]
          };
          _insertHistoryChat(params);
        }
      });
    } else {
      _getDanhSachThuTucHanhChinhTheoAPI(linhVucID).then((value) {
        if (value != null) {
          _listMess.insert(0, ChatModel(messLeft: 'H?????ng d???n tra c???u'));

          TraCuu data = TraCuu(
              traCuuTTHCmodel: value,
              type: 'action_tra_cuu_thu_tuc_hanh_chinh');

          _listMess.insert(
              0,
              ChatModel(
                  messLeft:
                      '????? tra c???u th??ng tin th??? t???c ${value.first.tenLinhVuc!.toUpperCase()} b???n vui l??ng ch???n m???c b???n mu???n tra c???u',
                  traCuu: jsonEncode(data.toJson())));
          mess.sink.add(_listMess);

          var params = {
            'param': [
              ChatModel(userName: userName, messLeft: 'H?????ng d???n tra c???u')
                  .toJson(),
              ChatModel(
                      messLeft:
                          '????? tra c???u th??ng tin th??? t???c ${value.first.tenLinhVuc!.toUpperCase()} b???n vui l??ng ch???n m???c b???n mu???n tra c???u',
                      traCuu: jsonEncode(data.toJson()))
                  .toJson()
            ]
          };
          _insertHistoryChat(params);
        }
      });
    }
  }

  void keyTraCuuDiaDiemTheoBanKinh(
    String userName,
    List<BotMessage> values, {
    String? tinNhan,
    int? pageNum,
    double? lat,
    double? long,
  }) {
    _traCuuDiaDiemAPI(
            lat: lat,
            long: long,
            banKinh: values.first.custom!.data!.banKinh,
            maLoaiDanhMuc: values.first.custom!.data!.maLoaiDanhMuc,
            tenCoQuan: values.first.custom!.data!.tenCoQuan,
            maCoQuan: values.first.custom!.data!.maCoQuan,
            pageNum: 1)
        .then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          if (value.length > 1) {
            TraCuu data =
                TraCuu(data1: value[0], type: 'action_tra_cuu_dia_diem');

            _listMess.insert(0, ChatModel(traCuu: jsonEncode(data.toJson())));

            TraCuu data1 = TraCuu(
                dataBot: values,
                data1: value[1],
                type: 'action_tra_cuu_dia_diem');

            _listMess.insert(
                0,
                ChatModel(
                    isReadMore: (value.length == 2) ? false : true,
                    traCuu: jsonEncode(data1.toJson())));

            mess.sink.add(_listMess);

            var params = {
              'param': [
                ChatModel(userName: userName, traCuu: jsonEncode(data.toJson()))
                    .toJson(),
                ChatModel(
                        userName: userName,
                        isReadMore: (value.length == 2) ? false : true,
                        traCuu: jsonEncode(data1.toJson()))
                    .toJson()
              ]
            };
            _insertHistoryChat(params);
          } else {
            TraCuu data =
                TraCuu(data1: value.first, type: 'action_tra_cuu_dia_diem');

            _listMess.insert(0, ChatModel(traCuu: jsonEncode(data.toJson())));
            mess.sink.add(_listMess);

            var params = {
              'param': [
                ChatModel(userName: userName, traCuu: jsonEncode(data.toJson()))
                    .toJson(),
              ]
            };
            _insertHistoryChat(params);
          }
        } else {
          _listMess.insert(
              0,
              ChatModel(
                messLeft:
                    'Xin l???i d??? li???u n??y hi???n t???i c???a t??i ch??a ???????c c???p nh???p, b???n vui l??ng th??? l???i sau',
              ));

          mess.sink.add(_listMess);
          var params = {
            'param': [
              ChatModel(
                      userName: userName,
                      messLeft:
                          'Xin l???i d??? li???u n??y hi???n t???i c???a t??i ch??a ???????c c???p nh???p, b???n vui l??ng th??? l???i sau')
                  .toJson(),
            ]
          };
          _insertHistoryChat(params);
        }
      } else {
        troGiup(userName);
      }
    });
  }

  void keyTraCuuDiaDiem(String userName, List<BotMessage> value,
      {String? tinNhan}) {
    if (value.first.custom!.data!.traCuuDiaDiem != null) {
      if (value.first.custom!.data!.traCuuDiaDiem!.isNotEmpty) {
        _traCuuDiaDiem.clear();
        value.first.custom?.data?.traCuuDiaDiem?.forEach((element) {
          _traCuuDiaDiem.add(TraCuuDiaDiemModels(
              maLoaiDanhMuc: element.maLoaiDanhMuc,
              diaChi: element.diaChi,
              distance: element.distance,
              email: element.email,
              ghiChu: element.ghiChu,
              id: element.id,
              kinhDo: element.kinhDo,
              viDo: element.viDo,
              maCoQuan: element.maCoQuan,
              tenCoQuan: element.tenCoQuan,
              quanHuyenID: element.quanHuyenID,
              soDienThoai: element.soDienThoai,
              tenQuanHuyen: element.tenQuanHuyen,
              website: element.website));
        });

        if (value.first.custom!.data!.traCuuDiaDiem!.length > 1) {
          TraCuu data =
          TraCuu(data1: _traCuuDiaDiem[0], type: value.first.custom!.type);

          _listMess.insert(0, ChatModel(traCuu: jsonEncode(data.toJson())));

          TraCuu data1 = TraCuu(
              data: value.first.custom!.data!.traCuuDiaDiem,
              data1: _traCuuDiaDiem[1],
              type: value.first.custom!.type);

          _listMess.insert(
              0,
              ChatModel(
                  isReadMore: (_traCuuDiaDiem.length == 2) ? false : true,
                  traCuu: jsonEncode(data1.toJson())));

          mess.sink.add(_listMess);

          var params = {
            'param': [
              ChatModel(userName: userName, traCuu: jsonEncode(data.toJson()))
                  .toJson(),
              ChatModel(
                  userName: userName,
                  isReadMore: (_traCuuDiaDiem.length == 2) ? false : true,
                  traCuu: jsonEncode(data1.toJson()))
                  .toJson()
            ]
          };
          _insertHistoryChat(params);
          // _listMess.insert(
          //     0,
          //     ChatModel(
          //       messLeft: 'Th??ng tin ?????a ??i???m $tinNhan',
          //     ));
          //
          // TraCuu data = TraCuu(data: _traCuuDiaDiem, type: value.first.custom!.type);
          //
          // _listMess.insert(0, ChatModel(traCuu: jsonEncode(data.toJson())));
          // mess.sink.add(_listMess);
          //
          // var params = {
          //   'param': [
          //     ChatModel(
          //       userName: userName,
          //       messLeft: 'Th??ng tin ?????a ??i???m $tinNhan',
          //     ).toJson(),
          //     ChatModel(userName: userName, traCuu: jsonEncode(data.toJson()))
          //         .toJson()
          //   ]
          // };
          // _insertHistoryChat(params);

        } else {
        final TraCuuDiaDiemModels diaDiem = TraCuuDiaDiemModels(
            maLoaiDanhMuc:
                value.first.custom!.data!.traCuuDiaDiem!.first.maLoaiDanhMuc,
            diaChi: value.first.custom!.data!.traCuuDiaDiem!.first.diaChi,
            distance: value.first.custom!.data!.traCuuDiaDiem!.first.distance,
            email: value.first.custom!.data!.traCuuDiaDiem!.first.email,
            ghiChu: value.first.custom!.data!.traCuuDiaDiem!.first.ghiChu,
            id: value.first.custom!.data!.traCuuDiaDiem!.first.id,
            kinhDo: value.first.custom!.data!.traCuuDiaDiem!.first.kinhDo,
            viDo: value.first.custom!.data!.traCuuDiaDiem!.first.viDo,
            maCoQuan: value.first.custom!.data!.traCuuDiaDiem!.first.maCoQuan,
            tenCoQuan: value.first.custom!.data!.traCuuDiaDiem!.first.tenCoQuan,
            quanHuyenID:
                value.first.custom!.data!.traCuuDiaDiem!.first.quanHuyenID,
            soDienThoai:
                value.first.custom!.data!.traCuuDiaDiem!.first.soDienThoai,
            tenQuanHuyen:
                value.first.custom!.data!.traCuuDiaDiem!.first.tenQuanHuyen,
            website: value.first.custom!.data!.traCuuDiaDiem!.first.website);
        _listMess.insert(
            0,
            ChatModel(
              messLeft: 'Th??ng tin ?????a ??i???m $tinNhan',
            ));

        TraCuu data = TraCuu(data1: diaDiem, type: value.first.custom!.type);

        _listMess.insert(0, ChatModel(traCuu: jsonEncode(data.toJson())));
        mess.sink.add(_listMess);

        var params = {
          'param': [
            ChatModel(
              userName: userName,
              messLeft: 'Th??ng tin ?????a ??i???m $tinNhan',
            ).toJson(),
            ChatModel(userName: userName, traCuu: jsonEncode(data.toJson()))
                .toJson()
          ]
        };
        _insertHistoryChat(params);

        }
      } else {
        _listMess.insert(
            0,
            ChatModel(
                messLeft:
                    'Xin l???i d??? li???u n??y hi???n t???i c???a t??i ch??a ???????c c???p nh???p'));
        mess.sink.add(_listMess);

        var params = {
          'param': [
            ChatModel(
                    userName: userName,
                    messLeft:
                        'Xin l???i d??? li???u n??y hi???n t???i c???a t??i ch??a ???????c c???p nh???p')
                .toJson(),
          ]
        };
        _insertHistoryChat(params);
      }
    }
  }

  void keyTraCuuHoSo1Cua(String userName, List<BotMessage> value) {
    if (value.first.custom!.data!.hoSo1Cua != null) {
      TraCuu data = TraCuu(
          traCuuHS1Cua: value.first.custom!.data!.hoSo1Cua!,
          type: 'action_tra_cuu_ho_so_1_cua');

      _listMess.insert(0, ChatModel(traCuu: jsonEncode(data.toJson())));
      mess.sink.add(_listMess);

      var params = {
        'param': [
          ChatModel(userName: userName, traCuu: jsonEncode(data.toJson()))
              .toJson(),
        ]
      };
      _insertHistoryChat(params);
    } else {
      troGiup(userName);
    }
  }

  void keyTraCuuHoSoDatDai(String userName, List<BotMessage> value) {
    if (value.first.custom!.data!.hoSoDatDai != null) {
      TraCuu data = TraCuu(
          traCuuHSDatDai: value.first.custom!.data!.hoSoDatDai!,
          type: 'action_tra_cuu_ho_so_dat_dai');

      _listMess.insert(0, ChatModel(traCuu: jsonEncode(data.toJson())));
      mess.sink.add(_listMess);

      var params = {
        'param': [
          ChatModel(userName: userName, traCuu: jsonEncode(data.toJson()))
              .toJson(),
        ]
      };
      _insertHistoryChat(params);
    } else {
      troGiup(userName);
    }
  }

  void keyTraCuuTTHC(String userName, List<BotMessage> value, String tinNhan) {
    if (value.first.custom!.data!.traCuuTTHC != null) {
      if (value.first.custom!.data!.traCuuTTHC!.isNotEmpty) {
        _listMess.insert(0, ChatModel(messLeft: 'H?????ng d???n tra c???u'));

        TraCuu data = TraCuu(
            traCuuTTHCmodel: value.first.custom!.data!.traCuuTTHC!,
            type: 'action_tra_cuu_thu_tuc_hanh_chinh');

        _listMess.insert(
            0,
            ChatModel(
                messLeft:
                    '????? tra c???u th??ng tin th??? t???c ${tinNhan.toUpperCase()} b???n vui l??ng ch???n m???c b???n mu???n tra c???u',
                traCuu: jsonEncode(data.toJson())));
        mess.sink.add(_listMess);

        var params = {
          'param': [
            ChatModel(userName: userName, messLeft: 'H?????ng d???n tra c???u')
                .toJson(),
            ChatModel(
                    userName: userName,
                    messLeft:
                        '????? tra c???u th??ng tin th??? t???c ${tinNhan.toUpperCase()} b???n vui l??ng ch???n m???c b???n mu???n tra c???u',
                    traCuu: jsonEncode(data.toJson()))
                .toJson()
          ]
        };
        _insertHistoryChat(params);
      } else {
        troGiup(userName);
      }
    }
  }

  void messDanhMuc({String? userName, String? tenDanhMuc, int? banKinh}) {
    //_listMess.addAll(_listMessT);

    _listMess.insert(0, ChatModel(messRight: tenDanhMuc));
    mess.sink.add(_listMess);
    isCheckLocation.sink.add({true: '1'});
    var params = {
      'param': [
        ChatModel(userName: userName, messRight: tenDanhMuc).toJson(),
      ]
    };
    _insertHistoryChat(params);
  }

  void traCuuDD(
      {String? userName,
      double? lat,
      double? long,
      int? banKinh,
      String? maLoaiDanhMuc,
      String? tenDM,
      int? pageNum}) {
    _traCuuDiaDiemAPI(
            lat: lat,
            long: long,
            banKinh: banKinh,
            maLoaiDanhMuc: maLoaiDanhMuc,
            pageNum: pageNum)
        .then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          if (value.length > 1) {
            TraCuu data =
                TraCuu(data1: value[0], type: 'action_tra_cuu_dia_diem');

            _listMess.insert(0, ChatModel(traCuu: jsonEncode(data.toJson())));

            TraCuu data1 = TraCuu(
                banKinh: banKinh,
                tenDM: tenDM,
                maLoaiDanhMuc: maLoaiDanhMuc,
                data1: value[1],
                type: 'action_tra_cuu_dia_diem');

            _listMess.insert(
                0,
                ChatModel(
                    isReadMore: (value.length == 2) ? false : true,
                    traCuu: jsonEncode(data1.toJson())));

            mess.sink.add(_listMess);

            var params = {
              'param': [
                ChatModel(userName: userName, traCuu: jsonEncode(data.toJson()))
                    .toJson(),
                ChatModel(
                        userName: userName,
                        isReadMore: (value.length == 2) ? false : true,
                        traCuu: jsonEncode(data1.toJson()))
                    .toJson()
              ]
            };
            _insertHistoryChat(params);
          } else {
            TraCuu data =
                TraCuu(data1: value.first, type: 'action_tra_cuu_dia_diem');

            _listMess.insert(0, ChatModel(traCuu: jsonEncode(data.toJson())));
            mess.sink.add(_listMess);
            var params = {
              'param': [
                ChatModel(userName: userName, traCuu: jsonEncode(data.toJson()))
                    .toJson(),
              ]
            };
            _insertHistoryChat(params);
          }

          isCheckLocation.sink.add({false: '1'});
        } else {
          _listMess.insert(
              0,
              ChatModel(
                messLeft:
                    'Xin l???i d??? li???u n??y hi???n t???i c???a t??i ch??a ???????c c???p nh???p',
              ));
          mess.sink.add(_listMess);
          isCheckLocation.sink.add({false: '1'});

          var params = {
            'param': [
              ChatModel(
                      userName: userName,
                      messLeft:
                          'Xin l???i d??? li???u n??y hi???n t???i c???a t??i ch??a ???????c c???p nh???p')
                  .toJson(),
            ]
          };
          _insertHistoryChat(params);
        }
      } else {
        troGiup(userName!);
        isCheckLocation.sink.add({false: '1'});
      }
    });
  }

  void restart() {
    _listMess.clear();
    _listMess.insert(0, ChatModel(isInfo: true, messLeft: 'H?????ng d???n tra c???u'));
    _listMess.insert(
        0,
        ChatModel(
            isHeader: true,
            messLeft:
                '????? tra c???u th??ng tin b???n vui l??ng b???m ch???n c??c n??t ho???c nh???p ????? tra c???u (v?? d???: Tra c???u th??? t???c h??nh ch??nh)'));
    mess.sink.add(_listMess);
    typing.sink.add(true);
    _getAllDSChuNangAPI().then((value) {
      dsChucNang.sink.add(value!);
      typing.sink.add(false);
      isCheckLocation.sink.add({false: '1'});
    });
  }

  void traCuuDanhMuc(List<BotMessage> value) {
    isCheckLocation.sink.add({true: value.first.text!});
  }

  void sendMessRight(String userName, List<BotMessage> value) {
    //_listMess.addAll(_listMessT);
    _listMess.insert(0, ChatModel(messLeft: value.first.text));
    mess.sink.add(_listMess);
    typing.sink.add(false);

    var params = {
      'param': [
        ChatModel(userName: userName, messLeft: value.first.text).toJson(),
      ]
    };
    _insertHistoryChat(params);
  }

  void checkKeyChucNangVaDanhMuc(String userName, List<BotMessage> value,
      {List<ListDanhMuc>? listDanhMuc, String? tinNhan, bool? checkTTHoSo}) {
    switch (value.first.text) {
      case 'CongAn':
      case 'TAND':
      case 'UBND':
      case 'MamNon':
      case 'PhongGDDT':
      case 'THCS':
      case 'THPT':
      case 'TieuHoc':
      case 'TrungTamDayNghe':
      case 'BenhVien':
      case 'NhaThuoc':
      case 'PhongKham':
      case 'TramYTe':
      case 'TrungTamThuY':
      case 'TTYTe':
      case 'KhuDuLich':
      case 'Cho':
      case 'SieuThi':
      case 'AnUong':
      case 'DoanhNghiep':
      case 'KhachSan':
      case 'TinNguong':
        traCuuDanhMuc(value);
        break;

      case 'TCTTHC':
        traCuuAPI(userName, tinNhan!, value.first.text!);
        break;
      case 'TCTTHS':
        traCuuDM(userName, tinNhan!, listDanhMuc);
        //traCuuAPI(userName, tinNhan!, value.first.text!);
        break;

      case 'TCCQCQ':
      case 'TCCSGD':
      case 'TCCSYT':
      case 'TCKVCGT':
      case 'TCDDDL':
      case 'TCCSTTTTM':
      case 'TCTTDN':
        traCuuDM(userName, tinNhan!, listDanhMuc);
        break;

      case 'QH-40':
      case 'LD-37':
      case 'KT-35':
      case 'CPXD-8':
        getDSTTHC(userName, int.parse(value.first.text!.split('-').last));
        break;

      case 'TCLTD':
      case 'TCCAN':
      case 'KhoiKhac':
      case 'VuiChoiGiaiTri':
        troGiup(userName);
        break;

      case 'TCTTQH':
        sendThongTinPhuongXa(userName, isCheck: 0);
        break;

      case 'TTHDDTTHS':
      // case 'AnUong':
      // case 'DoanhNghiep':
      // case 'KhachSan':
      // case 'TinNguong':
        troGiup(userName);
        break;

      /// Ph???i xem l???i
      case 'HoSo1Cua':
        sendThongTinHoSo1Cua(userName, tinNhan: tinNhan, isCheckTTHS: 0);

        break;
      case 'HoSoDatDai':
        sendThongTinHoSoDatDai(userName, tinNhan: tinNhan, isCheckTTHS: 0);
        break;

      ///------------------------------------///
      default:
        sendMessRight(userName, value);
        break;
    }
  }

  void troGiup(String userName) {
    checkHuy.sink.add(false);
    _listMess.insert(
        0,
        ChatModel(
          messLeft:
              'Xin l???i d??? li???u c???a t??i ch??a ????? kh??? n??ng ????? hi???u ?? c???a b???n.',
        ));
    mess.sink.add(_listMess);
    typing.sink.add(false);
    var params = {
      'param': [
        ChatModel(
          userName: userName,
          messLeft:
              'Xin l???i d??? li???u c???a t??i ch??a ????? kh??? n??ng ????? hi???u ?? c???a b???n.',
        ).toJson(),
      ]
    };
    _insertHistoryChat(params);
  }

  void checkLocation() {
    isCheckLocation.sink.add({false: '1'});
  }

  void showBottomScroll(bool? show) {
    if (!scroll.isClosed) scroll.sink.add(show!);
  }

  void getAllPhuongXa() {
    _getAllPhuongXaAPI().then((value) {
      _listAllPX = value!;
    });
  }

  void searchPhuongXa({String? keySearch}) {
    if (keySearch!.isEmpty) {
      dsPhuongXa.sink.add([]);
      return;
    }
    final String queryKhongDau =
        Utilities.instance.xoaDau(keySearch).toLowerCase();
    final List<PhuongXaModel> result = _listAllPX.where((element) {
      final String xoaDauResult =
          Utilities.instance.xoaDau(element.tenPhuong!).toLowerCase();
      if (xoaDauResult.contains(queryKhongDau)) return true;
      return false;
    }).toList();
    dsPhuongXa.sink.add(result);
  }

  void sendThongTinPhuongXa(String userName, {String? tinNhan, int? isCheck}) {
    if (isCheck == 0) {
      checkHuy.sink.add(true);
      _listMess.insert(0, ChatModel(messLeft: 'H?????ng d???n tra c???u'));
      _listMess.insert(
          0,
          ChatModel(
            messLeft:
                '????? tra c???u th??ng tin quy ho???ch b???n vui l??ng nh???p theo h?????ng d???n',
          ));
      _listMess.insert(
          0,
          ChatModel(
            messLeft: 'B???n vui l??ng nh???p Ph?????ng(x??)',
          ));
      _listMess.insert(0,
          ChatModel(isTTQH: (_isCheckTTQH) ? true : false, messRight: tinNhan));

      var params = {
        'param': [
          ChatModel(userName: userName, messLeft: 'H?????ng d???n tra c???u').toJson(),
          ChatModel(
            userName: userName,
            messLeft:
                '????? tra c???u th??ng tin quy ho???ch b???n vui l??ng nh???p theo h?????ng d???n',
          ).toJson(),
          ChatModel(
            userName: userName,
            messLeft: 'B???n vui l??ng nh???p Ph?????ng(x??)',
          ).toJson(),
          ChatModel(
                  userName: userName,
                  isTTQH: (_isCheckTTQH) ? true : false,
                  messRight: tinNhan)
              .toJson()
        ]
      };
      _insertHistoryChat(params);
    }

    if (isCheck == 1) {
      dsPhuongXa.sink.add([]);
      _tenPhuong = tinNhan!;
      typing.sink.add(true);
      _listMess.insert(0,
          ChatModel(messRight: tinNhan, messLeft: 'B???n vui l??ng nh???p s??? t???'));

      var params = {
        'param': [
          ChatModel(
                  userName: userName,
                  messRight: tinNhan,
                  messLeft: 'B???n vui l??ng nh???p s??? t???')
              .toJson(),
        ]
      };
      _insertHistoryChat(params);
    }

    if (isCheck == 2) {
      dsPhuongXa.sink.add([]);
      _soTo = tinNhan!;
      typing.sink.add(true);

      _listMess.insert(0,
          ChatModel(messRight: tinNhan, messLeft: 'B???n vui l??ng nh???p s??? th???a'));

      var params = {
        'param': [
          ChatModel(
                  userName: userName,
                  messRight: tinNhan,
                  messLeft: 'B???n vui l??ng nh???p s??? th???a')
              .toJson(),
        ]
      };
      _insertHistoryChat(params);
    }

    if (isCheck == 3) {
      _soThua = tinNhan!;

      _listMess.insert(
          0,
          ChatModel(
              messRight: tinNhan, messLeft: '$_tenPhuong/$_soTo/$_soThua'));
      // _listMess.insert(0, ChatModel(messRight: 'B???n vui l??ng ch??? k???t qu???'));
      checkHuy.sink.add(false);

      sendController.sink.add(false);

      /// Th???ng n??y ????? check khi bot tr??? data ra
      if (_isCheckTTQH) {
        _listMess.insert(0, ChatModel(isTTQH: false, isTTQHEnd: true));
        var params = {
          'param': [
            ChatModel(userName: userName, isTTQH: false, isTTQHEnd: true)
                .toJson(),
          ]
        };
        _insertHistoryChat(params);
      } else {
        _listMess.insert(0, ChatModel(isTTQH: false, isTTQHEnd: false));
        var params = {
          'param': [
            ChatModel(userName: userName, isTTQH: false, isTTQHEnd: false)
                .toJson(),
          ]
        };
        _insertHistoryChat(params);
      }

      typing.sink.add(true);
      _callAPIGetTCQuyHoach(userName, '$_tenPhuong/$_soTo/$_soThua');
      var params = {
        'param': [
          ChatModel(
                  userName: userName,
                  messRight: tinNhan,
                  messLeft: '$_tenPhuong/$_soTo/$_soThua')
              .toJson(),
        ]
      };
      _insertHistoryChat(params);
    }

    mess.sink.add(_listMess);
    typing.sink.add(false);
  }

  void _callAPIGetTCQuyHoach(String userName, String thongTin) {
    typing.sink.add(true);
    _getUrlTraCuuQuyHoachAPI(thongTin).then((value) {
      if (value != null) {
        typing.sink.add(false);
        TraCuu data = TraCuu(
            chiTietQuyHoachModel: value,
            type: 'action_tra_cuu_thong_tin_quy_hoach');

        // kiem tra thong tin quy hoach neu isTCQH = 1 => Nhap dung thong tin
        _listMess.insert(0, ChatModel(
             /// de xuat => mo ra khi co yeu cau
            // isTTQH: false, isTTQHEnd: true,  isTCQH: 1,
            traCuu: jsonEncode(data.toJson())));
        mess.sink.add(_listMess);

        var params = {
          'param': [
            ChatModel(userName: userName, traCuu: jsonEncode(data.toJson()))
                .toJson(),
          ]
        };
        _insertHistoryChat(params);
      }
      // Get.to(WebViewWidget(value));
      else {
        //checkHuy.sink.add(true);
        typing.sink.add(true);
        //-------------//
        _listMess.insert(0, ChatModel(messLeft: 'kh??ng t??m th???y th??ng tin'));
        /// de xuat => mo ra khi co yeu cau
        // _listMess.insert(
        //     0,
        //     ChatModel(
        //         messLeft:
        //             'Kh??ng t??m th???y th??ng tin, qu?? kh??ch vui l??ng ki???m tra v?? nh???p l???i th??ng tin theo h?????ng d???n'));
        // // kiem tra thong tin quy hoach neu isTCQH = 2 => Nhap sai thong tin yeu cau nhap lai
        // _listMess.insert(
        //     0,
        //     ChatModel(
        //       isTTQH: true, isTTQHEnd: false,
        //       isTCQH: 2,
        //       messLeft: 'B???n vui l??ng nh???p Ph?????ng(x??)',
        //     ));

        mess.sink.add(_listMess);

        typing.sink.add(false);
        var params = {
          'param': [
            //-------------//
            ChatModel(userName: userName, messLeft: 'kh??ng t??m th???y th??ng tin').toJson()
            /// de xuat => mo ra khi co yeu cau
            // ChatModel(
            //         userName: userName,
            //         messLeft:
            //         'Kh??ng t??m th???y th??ng tin, qu?? kh??ch vui l??ng ki???m tra v?? nh???p l???i th??ng tin theo h?????ng d???n')
            //     .toJson(),
            // ChatModel(
            //     userName: userName,
            //   isTTQH: true, isTTQHEnd: false,
            //   isTCQH: 2,
            //   messLeft: 'B???n vui l??ng nh???p Ph?????ng(x??)',)
            //     .toJson(),
          ]
        };
        _insertHistoryChat(params);
      }
    });
  }

  void sendThongTinHoSo1Cua(String userName,
      {String? tinNhan, int? isCheckTTHS, bool checkClick = false}) {
    checkHuy.sink.add(true);
    if (isCheckTTHS == 0) {
      //checkHuy.sink.add(true);
      if (checkClick) _listMess.insert(0, ChatModel(messRight: tinNhan));
      _listMess.insert(0, ChatModel(messLeft: 'H?????ng d???n tra c???u'));
      _listMess.insert(
          0,
          ChatModel(
            checkTTHS: 'HoSo1Cua',
            isTTHS: (_isCheckTTHS) ? true : false,
            messLeft:
                '????? tra c???u t??nh tr???ng h??? s?? vui l??ng nh???p s??? bi??n nh???n ???????c ghi tr??n h??? s?? (vd: 123456ABCD)',
          ));
      mess.sink.add(_listMess);

      typing.sink.add(false);

      var params = {
        'param': [
          if (checkClick)
            ChatModel(userName: userName, messRight: tinNhan).toJson(),
          ChatModel(userName: userName, messLeft: 'H?????ng d???n tra c???u').toJson(),
          ChatModel(
            userName: userName,
            isTTHS: (_isCheckTTHS) ? true : false,
            messLeft:
                '????? tra c???u t??nh tr???ng h??? s?? vui l??ng nh???p s??? bi??n nh???n ???????c ghi tr??n h??? s?? (vd: 123456ABCD)',
          ).toJson()
        ]
      };
      _insertHistoryChat(params);
    }
    if (isCheckTTHS == 1) {
      _listMess.insert(
          0,
          ChatModel(
            messRight: tinNhan,
          ));
      typing.sink.add(true);
      mess.sink.add(_listMess);

      var params = {
        'param': [
          ChatModel(
            userName: userName,
            messRight: tinNhan,
          ).toJson(),
        ]
      };
      _insertHistoryChat(params);

      _traCuuHoSo1CuaAPI(tinNhan!).then((value) {
        if (value != null) {
          TraCuu data =
              TraCuu(traCuuHS1Cua: value, type: 'action_tra_cuu_ho_so_1_cua');

          _listMess.insert(
              0,
              ChatModel(
                  isTTHSEnd: 2,
                  isTTQH: false,
                  traCuu: jsonEncode(data.toJson())));

          checkHuy.sink.add(false);
          sendController.sink.add(false);
          mess.sink.add(_listMess);
          typing.sink.add(false);

          var params = {
            'param': [
              ChatModel(
                      userName: userName,
                      isTTHSEnd: 2,
                      isTTQH: false,
                      traCuu: jsonEncode(data.toJson()))
                  .toJson()
            ]
          };
          _insertHistoryChat(params);
        } else {
          _listMess.insert(
              0,
              ChatModel(
                isTTHSEnd: 1,
                //messRight: tinNhan,
                messLeft:
                    'M?? h??? s?? n??y kh??ng t???n t???i. Qu?? kh??ch vui l??ng ki???m tra l???i.',
              ));
          mess.sink.add(_listMess);
          typing.sink.add(false);
          var params = {
            'param': [
              ChatModel(
                userName: userName,
                isTTHSEnd: 1,
                //messRight: tinNhan,
                messLeft:
                    'M?? h??? s?? n??y kh??ng t???n t???i. Qu?? kh??ch vui l??ng ki???m tra l???i.',
              ).toJson(),
            ]
          };
          _insertHistoryChat(params);
        }
      });
    }
  }

  void sendThongTinHoSoDatDai(String userName,
      {String? tinNhan, int? isCheckTTHS, bool checkClick = false}) {
    checkHuy.sink.add(true);
    if (isCheckTTHS == 0) {
      if (checkClick) _listMess.insert(0, ChatModel(messRight: tinNhan));
      _listMess.insert(0, ChatModel(messLeft: 'H?????ng d???n tra c???u'));
      _listMess.insert(
          0,
          ChatModel(
            checkTTHS: 'HoSoDatDai',
            isTTHS: (_isCheckTTHS) ? true : false,
            messLeft:
                '????? tra c???u t??nh tr???ng h??? s?? vui l??ng nh???p s??? bi??n nh???n ???????c ghi tr??n h??? s?? (vd: 123456ABCD)',
          ));
      mess.sink.add(_listMess);
      typing.sink.add(false);

      var params = {
        'param': [
          if (checkClick)
            ChatModel(userName: userName, messRight: tinNhan).toJson(),
          ChatModel(userName: userName, messLeft: 'H?????ng d???n tra c???u').toJson(),
          ChatModel(
            userName: userName,
            isTTHS: (_isCheckTTHS) ? true : false,
            messLeft:
                '????? tra c???u t??nh tr???ng h??? s?? vui l??ng nh???p s??? bi??n nh???n ???????c ghi tr??n h??? s?? (vd: 123456ABCD)',
          ).toJson()
        ]
      };
      _insertHistoryChat(params);
    }
    if (isCheckTTHS == 1) {
      _listMess.insert(
          0,
          ChatModel(
            messRight: tinNhan,
          ));
      typing.sink.add(true);
      mess.sink.add(_listMess);

      var params = {
        'param': [
          ChatModel(
            userName: userName,
            messRight: tinNhan,
          ).toJson(),
        ]
      };
      _insertHistoryChat(params);

      _traCuuHoSoDatDaiAPI(tinNhan!).then((value) {
        if (value != null) {
          TraCuu data = TraCuu(
              traCuuHSDatDai: value, type: 'action_tra_cuu_ho_so_dat_dai');

          _listMess.insert(
              0,
              ChatModel(
                  isTTHSEnd: 2,
                  isTTQH: false,
                  traCuu: jsonEncode(data.toJson())));

          checkHuy.sink.add(false);
          sendController.sink.add(false);
          mess.sink.add(_listMess);
          typing.sink.add(false);

          var params = {
            'param': [
              ChatModel(
                      userName: userName,
                      isTTHSEnd: 2,
                      isTTQH: false,
                      traCuu: jsonEncode(data.toJson()))
                  .toJson()
            ]
          };
          _insertHistoryChat(params);
        } else {
          _listMess.insert(
              0,
              ChatModel(
                isTTHSEnd: 1,
                //messRight: tinNhan,
                messLeft:
                    'M?? h??? s?? n??y kh??ng t???n t???i. Qu?? kh??ch vui l??ng ki???m tra l???i.',
              ));
          mess.sink.add(_listMess);
          typing.sink.add(false);
          var params = {
            'param': [
              ChatModel(
                userName: userName,
                isTTHSEnd: 1,
                //messRight: tinNhan,
                messLeft:
                    'M?? h??? s?? n??y kh??ng t???n t???i. Qu?? kh??ch vui l??ng ki???m tra l???i.',
              ).toJson(),
            ]
          };
          _insertHistoryChat(params);
        }
      });
    }
  }

  Future sendHuyTraCuu(String userName, {String? value}) async {
    checkHuy.sink.add(false);
    _listMess.insert(0, ChatModel(messRight: 'H???y'));
    mess.sink.add(_listMess);
    typing.sink.add(true);

    var params = {
      'param': [
        ChatModel(userName: userName, messRight: 'H???y').toJson(),
      ]
    };
    _insertHistoryChat(params);

    await Future.delayed(const Duration(seconds: 1), () {
      _listMess.insert(0, ChatModel(messLeft: 'H?????ng d???n tra c???u'));
      _listMess.insert(
          0,
          ChatModel(
              isTTHSEnd: 2,
              isTTQHEnd: true,
              isHeader: true,
              messLeft:
                  '????? tra c???u th??ng tin b???n vui l??ng b???m ch???n c??c n??t ho???c nh???p ????? tra c???u (v?? d???: Tra c???u th??? t???c h??nh ch??nh)'));
      typing.sink.add(false);
      mess.sink.add(_listMess);

      var params = {
        'param': [
          ChatModel(userName: userName, messLeft: 'H?????ng d???n tra c???u').toJson(),
          ChatModel(
                  userName: userName,
                  isTTHSEnd: 2,
                  isTTQHEnd: true,
                  isHeader: true,
                  messLeft:
                      '????? tra c???u th??ng tin b???n vui l??ng b???m ch???n c??c n??t ho???c nh???p ????? tra c???u (v?? d???: Tra c???u th??? t???c h??nh ch??nh)')
              .toJson()
        ]
      };
      _insertHistoryChat(params);
    });
  }

  void readMoreDD(String userName, TraCuu values, String? tinNhan, int? pageNum,
      double? lat, double? long,
      {required BuildContext context, }) {
    if (values.dataBot != null) {
      var data = values.dataBot;

        _traCuuDiaDiemAPI(
            banKinh: data!.first.custom!.data!.banKinh,
            maLoaiDanhMuc: data.first.custom!.data!.maLoaiDanhMuc,
            tenCoQuan: data.first.custom!.data!.tenCoQuan,
            maCoQuan: data.first.custom!.data!.maCoQuan,
            pageNum: 1)
            .then((value) {
          if (value != null) {
            if (value.isNotEmpty) {
              if (value.length > 1) {
                ObjectData dataTCDD = ObjectData()
                  ..banKinh = data.first.custom!.data!.banKinh
                  ..tenDM = tinNhan
                  ..traCuuDiaDiem = value
                  ..botMess = data
                  ..checkDD = 1;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        child: TraCuuDiaDiemUI(), bloc: TraCuuDiaDiemBloc()),
                    settings: RouteSettings(
                      arguments: dataTCDD,
                    ),
                  ),
                );

              }
            } else {
              _listMess.insert(
                  0,
                  ChatModel(
                    messRight:
                    'Xin l???i d??? li???u n??y hi???n t???i c???a t??i ch??a ???????c c???p nh???p, b???n vui l??ng th??? l???i sau',
                  ));
              mess.sink.add(_listMess);
            }
          } else {
            troGiup(userName);
          }
        });


    } else {
      if(values.data != null){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BlocProvider(child: TraCuuDiaDiemUI(), bloc: TraCuuDiaDiemBloc()),
            settings: RouteSettings(
              arguments: values.data,
            ),
          ),
        );

      }else{
        ObjectData dataTCDD = ObjectData()
          ..banKinh = values.banKinh
          ..tenDM = values.tenDM
          ..maLoaiDanhMuc = values.maLoaiDanhMuc
          ..lat = lat
          ..long = long
          ..checkDD = 0;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BlocProvider(child: TraCuuDiaDiemUI(), bloc: TraCuuDiaDiemBloc()),
            settings: RouteSettings(
              arguments: dataTCDD,
            ),
          ),
        );
      }

    }
  }

  void loadMore({String? userName, int? pageNum}) {
    if (_listMess.length > 0 && _listMess.isNotEmpty) {
      _getAllHistoryChat(userName!, pageNum!).then((value) {
        if (value!.length > 0) {
          _listMess.addAll(value);
          mess.sink.add(_listMess);
        }
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sendController.close();
    scroll.close();
    mess.close();
    typing.close();
    dsChucNang.close();
    lDanhMuc.close();
    isCheckLocation.close();
    traCuuDiaDiem.close();
    dsPhuongXa.close();
    checkHuy.close();
  }
}
