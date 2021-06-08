import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/config/local_variable.dart';
import 'package:package_chatbot/core/model/botmessasge.dart';
import 'package:package_chatbot/core/model/chatmodels.dart';
import 'package:package_chatbot/core/model/ds_chu_nang_model.dart';
import 'package:package_chatbot/core/model/ho_so_1_cua.dart';
import 'package:package_chatbot/core/model/phuongxamodel.dart';
import 'package:package_chatbot/core/model/tracuubiennhanmodel.dart';
import 'package:package_chatbot/core/model/tracuudiadiemmodel.dart';
import 'package:package_chatbot/core/model/tracuutthcmodel.dart';
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
                  messLeft: 'Hướng dẫn tra cứu'));
          _listMess.insert(
              0,
              ChatModel(
                  userName: userName,
                  isHeader: true,
                  messLeft:
                      'Để tra cứu thông tin bạn vui lòng bấm chọn các nút hoặc nhập để tra cứu (ví dụ: Tra cứu thủ tục hành chính)'));
        }
      } else {
        if (tinNhan == 'null') {
          _listMess.insert(
              0,
              ChatModel(
                  userName: userName,
                  isInfo: true,
                  messLeft: 'Hướng dẫn tra cứu'));
          _listMess.insert(
              0,
              ChatModel(
                  userName: userName,
                  isHeader: true,
                  messLeft:
                      'Để tra cứu thông tin bạn vui lòng bấm chọn các nút hoặc nhập để tra cứu (ví dụ: Tra cứu thủ tục hành chính)'));

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
                      messLeft: 'Hướng dẫn tra cứu')
                  .toJson(),
              ChatModel(
                      userName: userName,
                      isHeader: true,
                      messLeft:
                          'Để tra cứu thông tin bạn vui lòng bấm chọn các nút hoặc nhập để tra cứu (ví dụ: Tra cứu thủ tục hành chính)')
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
              userName: userName, isInfo: true, messLeft: 'Hướng dẫn tra cứu'));
      _listMess.insert(
          0,
          ChatModel(
              userName: userName,
              isHeader: true,
              messLeft:
                  'Để tra cứu thông tin bạn vui lòng bấm chọn các nút hoặc nhập để tra cứu (ví dụ: Tra cứu thủ tục hành chính)'));

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
                  messLeft: 'Hướng dẫn tra cứu')
              .toJson(),
          ChatModel(
                  userName: userName,
                  isHeader: true,
                  messLeft:
                      'Để tra cứu thông tin bạn vui lòng bấm chọn các nút hoặc nhập để tra cứu (ví dụ: Tra cứu thủ tục hành chính)')
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

    var params = {
      'param': [
        ChatModel(userName: userName, messRight: tinNhan).toJson(),
      ]
    };
    _insertHistoryChat(params);

    _sendChatBot(tinNhan).then((value) {
      if (value.isNotEmpty) {
        if (value.first.text == 'TCTTQH') {
          _isCheckTTQH = true;
          getAllPhuongXa();
        } else {
          _isCheckTTQH = false;
        }
        if (value.first.text == 'TCTTHS') {
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
            case 'action_tra_cuu_so_bien_nhan':
              keyTraCuuBienNhan(userName, value);
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
                  'Xin lỗi dự liệu này hiện tại của tôi chưa được cập nhập',
            ));
        mess.sink.add(_listMess);
        typing.sink.add(false);
        var params = {
          'param': [
            ChatModel(
              userName: userName,
              messLeft:
                  'Xin lỗi dự liệu này hiện tại của tôi chưa được cập nhập',
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
            _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
            _listMess.insert(
                0,
                ChatModel(
                    isTTHC: true,
                    messLeft:
                        'Để ${tinNhan.toLowerCase()} bạn vui lòng bấm nút hoặc nhập để tra cứu (vd: ${value.first.tenLinhVuc!.toLowerCase()})',
                    listTTHC: jsonEncode(value)));

            mess.sink.add(_listMess);
            var params = {
              'param': [
                ChatModel(userName: userName, messLeft: 'Hướng dẫn tra cứu')
                    .toJson(),
                ChatModel(
                        userName: userName,
                        isTTHC: true,
                        messLeft:
                            'Để ${tinNhan.toLowerCase()} bạn vui lòng bấm nút hoặc nhập để tra cứu (vd: ${value.first.tenLinhVuc!.toLowerCase()})',
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
      case 'TCTTHS':
        sendThongTinHoSoDatDai(userName, isCheckTTHS: 0);

        break;

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
    _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
    _listMess.insert(
        0,
        ChatModel(
            isListDM: true,
            messLeft:
                'Để ${tinNhan.toLowerCase()} bạn vui lòng bấm nút hoặc nhập để tra cứu (vd: ${listDanhMuc!.first.tenLoaiDanhMuc})',
            listDanhMuc: jsonEncode(listDanhMuc)));
    mess.sink.add(_listMess);
    typing.sink.add(false);
    isCheckLocation.sink.add({false: '1'});
    var params = {
      'param': [
        ChatModel(userName: userName, messLeft: 'Hướng dẫn tra cứu').toJson(),
        ChatModel(
                userName: userName,
                isListDM: true,
                messLeft:
                    'Để ${tinNhan.toLowerCase()} bạn vui lòng bấm nút hoặc nhập để tra cứu (vd: ${listDanhMuc.first.tenLoaiDanhMuc})',
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
          _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
          TraCuu data = TraCuu(
              traCuuTTHCmodel: value,
              type: 'action_tra_cuu_thu_tuc_hanh_chinh');
          _listMess.insert(
              0,
              ChatModel(
                  messLeft:
                      'Để tra cứu thông tin thủ tục ${tinNhan.toUpperCase()} bạn vui lòng chọn mục bạn muốn tra cứu',
                  traCuu: jsonEncode(data.toJson())));
          mess.sink.add(_listMess);
          var params = {
            'param': [
              ChatModel(userName: userName, messLeft: 'Hướng dẫn tra cứu')
                  .toJson(),
              ChatModel(
                      userName: userName,
                      messLeft:
                          'Để tra cứu thông tin thủ tục ${tinNhan.toUpperCase()} bạn vui lòng chọn mục bạn muốn tra cứu',
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
          _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));

          TraCuu data = TraCuu(
              traCuuTTHCmodel: value,
              type: 'action_tra_cuu_thu_tuc_hanh_chinh');

          _listMess.insert(
              0,
              ChatModel(
                  messLeft:
                      'Để tra cứu thông tin thủ tục ${value.first.tenLinhVuc!.toUpperCase()} bạn vui lòng chọn mục bạn muốn tra cứu',
                  traCuu: jsonEncode(data.toJson())));
          mess.sink.add(_listMess);

          var params = {
            'param': [
              ChatModel(userName: userName, messLeft: 'Hướng dẫn tra cứu')
                  .toJson(),
              ChatModel(
                      messLeft:
                          'Để tra cứu thông tin thủ tục ${value.first.tenLinhVuc!.toUpperCase()} bạn vui lòng chọn mục bạn muốn tra cứu',
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
                    'Xin lỗi dự liệu này hiện tại của tôi chưa được cập nhập, bạn vui lòng thử lại sau',
              ));

          mess.sink.add(_listMess);
          var params = {
            'param': [
              ChatModel(
                      userName: userName,
                      messLeft:
                          'Xin lỗi dự liệu này hiện tại của tôi chưa được cập nhập, bạn vui lòng thử lại sau')
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

        // if (value.first.custom!.data!.traCuuDiaDiem!.length > 1) {
        //   Get.to(()=>
        //       BlocProvider(
        //           child: TraCuuDiaDiemUI(), bloc: TraCuuDiaDiemBloc()),
        //       arguments: {'result': _traCuuDiaDiem, 'tenDM': tinNhan, 'checkDD': 1});
        // } else {
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
              messLeft: 'Thông tin địa điểm $tinNhan',
            ));

        TraCuu data = TraCuu(data1: diaDiem, type: value.first.custom!.type);

        _listMess.insert(0, ChatModel(traCuu: jsonEncode(data.toJson())));
        mess.sink.add(_listMess);

        var params = {
          'param': [
            ChatModel(
              userName: userName,
              messLeft: 'Thông tin địa điểm $tinNhan',
            ).toJson(),
            ChatModel(userName: userName, traCuu: jsonEncode(data.toJson()))
                .toJson()
          ]
        };
        _insertHistoryChat(params);

        // }
      } else {
        _listMess.insert(
            0,
            ChatModel(
                messLeft:
                    'Xin lỗi dự liệu này hiện tại của tôi chưa được cập nhập'));
        mess.sink.add(_listMess);

        var params = {
          'param': [
            ChatModel(
                    userName: userName,
                    messLeft:
                        'Xin lỗi dự liệu này hiện tại của tôi chưa được cập nhập')
                .toJson(),
          ]
        };
        _insertHistoryChat(params);
      }
    }
  }

  void keyTraCuuBienNhan(String userName, List<BotMessage> value) {
    if (value.first.custom!.data!.traCuuBienNhan != null) {
      if (value.first.custom!.data!.traCuuBienNhan!.isNotEmpty) {
        TraCuu data = TraCuu(
            traCuuBienNhan: value.first.custom!.data!.traCuuBienNhan!.first,
            type: 'action_tra_cuu_so_bien_nhan');

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
  }

  void keyTraCuuTTHC(String userName, List<BotMessage> value, String tinNhan) {
    if (value.first.custom!.data!.traCuuTTHC != null) {
      if (value.first.custom!.data!.traCuuTTHC!.isNotEmpty) {
        _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));

        TraCuu data = TraCuu(
            traCuuTTHCmodel: value.first.custom!.data!.traCuuTTHC!,
            type: 'action_tra_cuu_thu_tuc_hanh_chinh');

        _listMess.insert(
            0,
            ChatModel(
                messLeft:
                    'Để tra cứu thông tin thủ tục ${tinNhan.toUpperCase()} bạn vui lòng chọn mục bạn muốn tra cứu',
                traCuu: jsonEncode(data.toJson())));
        mess.sink.add(_listMess);

        var params = {
          'param': [
            ChatModel(userName: userName, messLeft: 'Hướng dẫn tra cứu')
                .toJson(),
            ChatModel(
                    userName: userName,
                    messLeft:
                        'Để tra cứu thông tin thủ tục ${tinNhan.toUpperCase()} bạn vui lòng chọn mục bạn muốn tra cứu',
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
                    'Xin lỗi dự liệu này hiện tại của tôi chưa được cập nhập',
              ));
          mess.sink.add(_listMess);
          isCheckLocation.sink.add({false: '1'});

          var params = {
            'param': [
              ChatModel(
                      userName: userName,
                      messLeft:
                          'Xin lỗi dự liệu này hiện tại của tôi chưa được cập nhập')
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
    _listMess.insert(0, ChatModel(isInfo: true, messLeft: 'Hướng dẫn tra cứu'));
    _listMess.insert(
        0,
        ChatModel(
            isHeader: true,
            messLeft:
                'Để tra cứu thông tin bạn vui lòng bấm chọn các nút hoặc nhập để tra cứu (ví dụ: Tra cứu thủ tục hành chính)'));
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
      case 'AnUong':
      case 'DoanhNghiep':
      case 'KhachSan':
      case 'TinNguong':
        troGiup(userName);
        break;

      /// Phải xem lại
      case 'HoSo1Cua':
        sendThongTinHoSoDatDai(userName, tinNhan: tinNhan, isCheckTTHS: 0);

        break;
      case 'HoSoDatDai':
        sendThongTinHoSo1Cua(userName, tinNhan: tinNhan, isCheckTTHS: 0);
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
              'Xin lỗi dữ liệu của tôi chưa đủ khả năng để hiểu ý của bạn.',
        ));
    mess.sink.add(_listMess);
    typing.sink.add(false);
    var params = {
      'param': [
        ChatModel(
          userName: userName,
          messLeft:
              'Xin lỗi dữ liệu của tôi chưa đủ khả năng để hiểu ý của bạn.',
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
      _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
      _listMess.insert(
          0,
          ChatModel(
            messLeft:
                'Để tra cứu thông tin quy hoạch bạn vui lòng nhập theo hướng dẫn',
          ));
      _listMess.insert(
          0,
          ChatModel(
            messLeft: 'Bạn vui lòng nhập Phường(xã)',
          ));
      _listMess.insert(0,
          ChatModel(isTTQH: (_isCheckTTQH) ? true : false, messRight: tinNhan));

      var params = {
        'param': [
          ChatModel(userName: userName, messLeft: 'Hướng dẫn tra cứu').toJson(),
          ChatModel(
            userName: userName,
            messLeft:
                'Để tra cứu thông tin quy hoạch bạn vui lòng nhập theo hướng dẫn',
          ).toJson(),
          ChatModel(
            userName: userName,
            messLeft: 'Bạn vui lòng nhập Phường(xã)',
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
          ChatModel(messRight: tinNhan, messLeft: 'Bạn vui lòng nhập số tờ'));

      var params = {
        'param': [
          ChatModel(
                  userName: userName,
                  messRight: tinNhan,
                  messLeft: 'Bạn vui lòng nhập số tờ')
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
          ChatModel(messRight: tinNhan, messLeft: 'Bạn vui lòng nhập số thửa'));

      var params = {
        'param': [
          ChatModel(
                  userName: userName,
                  messRight: tinNhan,
                  messLeft: 'Bạn vui lòng nhập số thửa')
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
      // _listMess.insert(0, ChatModel(messRight: 'Bạn vui lòng chờ kết quả'));
      checkHuy.sink.add(false);

      sendController.sink.add(false);

      /// Thằng này để check khi bot trả data ra
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
        TraCuu data = TraCuu(
            chiTietQuyHoachModel: value,
            type: 'action_tra_cuu_thong_tin_quy_hoach');

        _listMess.insert(0, ChatModel(traCuu: jsonEncode(data.toJson())));
        mess.sink.add(_listMess);
        typing.sink.add(false);

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
        typing.sink.add(true);
        _listMess.insert(0, ChatModel(messLeft: 'không tìm thấy thông tin'));
        mess.sink.add(_listMess);
        typing.sink.add(false);
        var params = {
          'param': [
            ChatModel(userName: userName, messLeft: 'không tìm thấy thông tin')
                .toJson(),
          ]
        };
        _insertHistoryChat(params);
      }
    });
  }

  void sendThongTinHoSo1Cua(String userName,
      {String? tinNhan, int? isCheckTTHS}) {
    checkHuy.sink.add(true);
    if (isCheckTTHS == 0) {
      //checkHuy.sink.add(true);
      _listMess.insert(0, ChatModel(messRight: tinNhan));
      _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
      _listMess.insert(
          0,
          ChatModel(
            isTTHS: (_isCheckTTHS) ? true : false,
            messLeft:
                'Để tra cứu tình trạng hồ sơ vui lòng nhập số biên nhận được ghi trên hồ sơ (vd: 123456ABCD)',
          ));
      mess.sink.add(_listMess);

      typing.sink.add(false);

      var params = {
        'param': [
          ChatModel(userName: userName, messRight: tinNhan).toJson(),
          ChatModel(userName: userName, messLeft: 'Hướng dẫn tra cứu').toJson(),
          ChatModel(
            userName: userName,
            isTTHS: (_isCheckTTHS) ? true : false,
            messLeft:
                'Để tra cứu tình trạng hồ sơ vui lòng nhập số biên nhận được ghi trên hồ sơ (vd: 123456ABCD)',
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
          TraCuu data = TraCuu(
              traCuuBienNhan: value, type: 'action_tra_cuu_so_bien_nhan');

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
                    'Mã hồ sơ này không tồn tại. Quý khách vui lòng kiểm tra lại.',
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
                    'Mã hồ sơ này không tồn tại. Quý khách vui lòng kiểm tra lại.',
              ).toJson(),
            ]
          };
          _insertHistoryChat(params);
        }
      });
    }
  }

  void sendThongTinHoSoDatDai(String userName,
      {String? tinNhan, int? isCheckTTHS}) {
    checkHuy.sink.add(true);
    if (isCheckTTHS == 0) {
      _listMess.insert(0, ChatModel(messRight: tinNhan));
      _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
      _listMess.insert(
          0,
          ChatModel(
            isTTHS: (_isCheckTTHS) ? true : false,
            messLeft:
                'Để tra cứu tình trạng hồ sơ vui lòng nhập số biên nhận được ghi trên hồ sơ (vd: 123456ABCD)',
          ));
      mess.sink.add(_listMess);
      typing.sink.add(false);

      var params = {
        'param': [
          ChatModel(userName: userName, messRight: tinNhan).toJson(),
          ChatModel(userName: userName, messLeft: 'Hướng dẫn tra cứu').toJson(),
          ChatModel(
            userName: userName,
            isTTHS: (_isCheckTTHS) ? true : false,
            messLeft:
                'Để tra cứu tình trạng hồ sơ vui lòng nhập số biên nhận được ghi trên hồ sơ (vd: 123456ABCD)',
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
              traCuuHoSo1Cua: value, type: 'action_tra_cuu_so_ho_so_1_cua');

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
                    'Mã hồ sơ này không tồn tại. Quý khách vui lòng kiểm tra lại.',
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
                    'Mã hồ sơ này không tồn tại. Quý khách vui lòng kiểm tra lại.',
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
    _listMess.insert(0, ChatModel(messRight: 'Hủy'));
    mess.sink.add(_listMess);
    typing.sink.add(true);

    var params = {
      'param': [
        ChatModel(userName: userName, messRight: 'Hủy').toJson(),
      ]
    };
    _insertHistoryChat(params);

    await Future.delayed(const Duration(seconds: 1), () {
      _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
      _listMess.insert(
          0,
          ChatModel(
              isTTHSEnd: 2,
              isTTQHEnd: true,
              isHeader: true,
              messLeft:
                  'Để tra cứu thông tin bạn vui lòng bấm chọn các nút hoặc nhập để tra cứu (ví dụ: Tra cứu thủ tục hành chính)'));
      typing.sink.add(false);
      mess.sink.add(_listMess);

      var params = {
        'param': [
          ChatModel(userName: userName, messLeft: 'Hướng dẫn tra cứu').toJson(),
          ChatModel(
                  userName: userName,
                  isTTHSEnd: 2,
                  isTTQHEnd: true,
                  isHeader: true,
                  messLeft:
                      'Để tra cứu thông tin bạn vui lòng bấm chọn các nút hoặc nhập để tra cứu (ví dụ: Tra cứu thủ tục hành chính)')
              .toJson()
        ]
      };
      _insertHistoryChat(params);
    });
  }

  void readMoreDD(String userName, TraCuu values, String? tinNhan, int? pageNum,
      double? lat, double? long) {
    if (values.dataBot != null) {
      var data = values.dataBot;
      // List<BotMessage> data = result.map((e) => BotMessage.fromJson(e)).toList();

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
              Get.to(
                  BlocProvider(
                      child: TraCuuDiaDiemUI(), bloc: TraCuuDiaDiemBloc()),
                  arguments: {
                    'banKinh': data.first.custom!.data!.banKinh,
                    'tenDM': tinNhan,
                    'result': value,
                    'results': data,
                    'checkDD': 1
                  });
            }
          } else {
            _listMess.insert(
                0,
                ChatModel(
                  messRight:
                      'Xin lỗi dự liệu này hiện tại của tôi chưa được cập nhập, bạn vui lòng thử lại sau',
                ));
            mess.sink.add(_listMess);
          }
        } else {
          troGiup(userName);
        }
      });
    } else {
      Get.to(BlocProvider(child: TraCuuDiaDiemUI(), bloc: TraCuuDiaDiemBloc()),
          arguments: {
            'lat': lat,
            'long': long,
            'banKinh': values.banKinh,
            'tenDM': values.tenDM,
            'maLoaiDanhMuc': values.maLoaiDanhMuc,
            'checkDD': 0
          });
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
