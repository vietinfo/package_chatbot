import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/config/local_variable.dart';
import 'package:package_chatbot/core/model/botmessasge.dart';
import 'package:package_chatbot/core/model/chatmodels.dart';
import 'package:package_chatbot/core/model/ds_chu_nang_model.dart';
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
  final List<ChatModel> _listMess = <ChatModel>[];
  final List<TraCuuDiaDiemModels> _traCuuDiaDiem = <TraCuuDiaDiemModels>[];
  List<ListDanhMuc> _listDanhMuc = <ListDanhMuc>[];
  List<PhuongXaModel> _listAllPX = <PhuongXaModel>[];
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

  void sendMessAPI(
    String tinNhan, {
    List<ListDanhMuc>? listDanhMuc,
    String? maChucNang,
  }) {
    if (tinNhan == 'null') {
      _listMess.insert(
          0, ChatModel(isInfo: true, messLeft: 'Hướng dẫn tra cứu'));
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
    } else {
      _listMess.insert(0, ChatModel(messRight: tinNhan));
      mess.sink.add(_listMess);

      typing.sink.add(true);

      if (listDanhMuc == null) {
        traCuuAPI(tinNhan, maChucNang!);
      } else {
        traCuuDM(tinNhan, listDanhMuc);
      }
    }
  }

  void sendMessBot(String tinNhan,
      {List<DanhMucChucNangModels>? danhMucChucNang,
      bool? checkTTHS,
      double? lat,
      double? long,
      int? isCheckTTHS}) {
    _listMess.insert(0, ChatModel(messRight: tinNhan));
    mess.sink.add(_listMess);
    typing.sink.add(true);

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
          checkKeyChucNangVaDanhMuc(value,
              tinNhan: tinNhan, listDanhMuc: _listDanhMuc);
        } else {
          checkKeyChucNangVaDanhMuc(value, tinNhan: tinNhan);
        }

        if (value.first.custom != null) {
          switch (value.first.custom!.type) {
            case 'action_tra_cuu_dia_diem_theo_ban_kinh':
              keyTraCuuDiaDiemTheoBanKinh(value,
                  tinNhan: tinNhan, lat: lat, long: long);
              break;
            case 'action_tra_cuu_dia_diem':
              keyTraCuuDiaDiem(value, tinNhan: tinNhan);
              break;
            case 'action_tra_cuu_so_bien_nhan':
              keyTraCuuBienNhan(value);
              break;
            case 'action_tra_cuu_thu_tuc_hanh_chinh':
              keyTraCuuTTHC(value, tinNhan);
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
      }
    });
  }

  void traCuuAPI(String tinNhan, String maCN) {
    switch (maCN) {
      case 'TCTTHC':
        _getLinhVucTucHanhChinhAPI().then((value) {
          if (value != null) {
            _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
            _listMess.insert(
                0,
                ChatModel(
                    isTTHC: true,
                    messLeft:
                        'Để ${tinNhan.toLowerCase()} bạn vui lòng bấm nút hoặc nhập để tra cứu (vd: ${value.first.tenLinhVuc!.toLowerCase()})',
                    listTTHC: value));

            mess.sink.add(_listMess);
            typing.sink.add(false);
          } else {
            troGiup();
          }
        });
        break;
      case 'TCTTHS':
        sendThongTinHoSo(isCheckTTHS: 0);

        break;

      case 'TCTTQH':
        sendThongTinPhuongXa(isCheck: 0);
        break;

      default:
        troGiup();
        break;
    }
  }

  void traCuuDM(String tinNhan, List<ListDanhMuc>? listDanhMuc) {
    _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
    _listMess.insert(
        0,
        ChatModel(
            isListDM: true,
            messLeft:
                'Để ${tinNhan.toLowerCase()} bạn vui lòng bấm nút hoặc nhập để tra cứu (vd: ${listDanhMuc!.first.tenLoaiDanhMuc})',
            listDanhMuc: listDanhMuc));
    mess.sink.add(_listMess);
    typing.sink.add(false);

    isCheckLocation.sink.add({false: '1'});
  }

  void getDSTTHC(int linhVucID, {String? tinNhan}) {
    if (tinNhan != null) {
      _listMess.insert(0, ChatModel(messRight: tinNhan));
      _getDanhSachThuTucHanhChinhTheoAPI(linhVucID).then((value) {
        if (value != null) {
          _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
          _listMess.insert(
              0,
              ChatModel(
                  messLeft:
                      'Để tra cứu thông tin thủ tục ${tinNhan.toUpperCase()} bạn vui lòng chọn mục bạn muốn tra cứu',
                  traCuu: TraCuu(
                      traCuuTTHCmodel: value,
                      type: 'action_tra_cuu_thu_tuc_hanh_chinh')));
          mess.sink.add(_listMess);
        }
      });
    } else {
      _getDanhSachThuTucHanhChinhTheoAPI(linhVucID).then((value) {
        if (value != null) {
          _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
          _listMess.insert(
              0,
              ChatModel(
                  messLeft:
                      'Để tra cứu thông tin thủ tục ${value.first.tenLinhVuc!.toUpperCase()} bạn vui lòng chọn mục bạn muốn tra cứu',
                  traCuu: TraCuu(
                      traCuuTTHCmodel: value,
                      type: 'action_tra_cuu_thu_tuc_hanh_chinh')));
          mess.sink.add(_listMess);
        }
      });
    }
  }

  void keyTraCuuDiaDiemTheoBanKinh(
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
            Get.to(
                BlocProvider(
                    child: TraCuuDiaDiemUI(), bloc: TraCuuDiaDiemBloc()),
                arguments: {
                  'lat': lat,
                  'long': long,
                  'banKinh': values.first.custom!.data!.banKinh,
                  'tenDM': tinNhan,
                  'result': value,
                  'results': values,
                  'checkDD': 1
                });
          } else {
            _listMess.insert(
                0,
                ChatModel(
                    traCuu: TraCuu(
                        data1: value.first, type: 'action_tra_cuu_dia_diem')));
            mess.sink.add(_listMess);
          }
        } else {
          _listMess.insert(
              0,
              ChatModel(
                messLeft:
                    'Xin lỗi dự liệu này hiện tại của tôi chưa được cập nhập, bạn vui lòng thử lại sau',
              ));
          mess.sink.add(_listMess);
        }
      } else {
        troGiup();
      }
    });
  }

  void keyTraCuuDiaDiem(List<BotMessage> value, {String? tinNhan}) {
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

        _listMess.insert(
            0,
            ChatModel(
                traCuu:
                    TraCuu(data1: diaDiem, type: value.first.custom!.type)));
        mess.sink.add(_listMess);
        // }
      } else {
        _listMess.insert(
            0,
            ChatModel(
                messLeft:
                    'Xin lỗi dự liệu này hiện tại của tôi chưa được cập nhập'));
        mess.sink.add(_listMess);
      }
    }
  }

  void keyTraCuuBienNhan(List<BotMessage> value) {
    if (value.first.custom!.data!.traCuuBienNhan != null) {
      if (value.first.custom!.data!.traCuuBienNhan!.isNotEmpty) {
        _listMess.insert(
            0,
            ChatModel(
                traCuu: TraCuu(
                    traCuuBienNhan:
                        value.first.custom!.data!.traCuuBienNhan!.first,
                    type: 'action_tra_cuu_so_bien_nhan')));
        mess.sink.add(_listMess);
      } else {
        troGiup();
      }
    }
  }

  void keyTraCuuTTHC(List<BotMessage> value, String tinNhan) {
    if (value.first.custom!.data!.traCuuTTHC != null) {
      if (value.first.custom!.data!.traCuuTTHC!.isNotEmpty) {
        _listMess.insert(0, ChatModel(messLeft: 'Hướng dẫn tra cứu'));
        _listMess.insert(
            0,
            ChatModel(
                messLeft:
                    'Để tra cứu thông tin thủ tục ${tinNhan.toUpperCase()} bạn vui lòng chọn mục bạn muốn tra cứu',
                traCuu: TraCuu(
                    traCuuTTHCmodel: value.first.custom!.data!.traCuuTTHC!,
                    type: 'action_tra_cuu_thu_tuc_hanh_chinh')));
        mess.sink.add(_listMess);
      } else {
        troGiup();
      }
    }
  }

  void messDanhMuc({ListDanhMuc? listDanhMuc, int? banKinh}) {
    _listMess.insert(0, ChatModel(messRight: listDanhMuc!.tenLoaiDanhMuc));
    mess.sink.add(_listMess);
    isCheckLocation.sink.add({true: '1'});
  }

  void traCuuDD(
      {double? lat,
      double? long,
      int? banKinh,
      String? maLoaiDanhMuc,
      String? tenDM,
      int? pageNum}) {
    // _listMess.insert(0, ChatModel(isCheckTraCuuDiaDiem: true));
    _traCuuDiaDiemAPI(
            lat: lat,
            long: long,
            banKinh: banKinh,
            maLoaiDanhMuc: maLoaiDanhMuc,
            pageNum: pageNum)
        .then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          Get.to(
              BlocProvider(child: TraCuuDiaDiemUI(), bloc: TraCuuDiaDiemBloc()),
              arguments: {
                'lat': lat,
                'long': long,
                'banKinh': banKinh,
                'tenDM': tenDM,
                'maLoaiDanhMuc': maLoaiDanhMuc,
                'checkDD': 0
              });
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
        }
      } else {
        troGiup();
        isCheckLocation.sink.add({false: '1'});
      }
    });
  }

  void restart() {
    _listMess.clear();
    _listMess.insert(
        0, ChatModel(isInfo: true, messLeft: 'Hướng dẫn tra cứu'));
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

  void sendMessRight(List<BotMessage> value) {
    _listMess.insert(0, ChatModel(messLeft: value.first.text));
    mess.sink.add(_listMess);
    typing.sink.add(false);
  }

  void checkKeyChucNangVaDanhMuc(List<BotMessage> value,
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
      case 'TCTTHS':
        traCuuAPI(tinNhan!, value.first.text!);
        break;

      case 'TCCQCQ':
      case 'TCCSGD':
      case 'TCCSYT':
      case 'TCKVCGT':
      case 'TCDDDL':
      case 'TCCSTTTTM':
      case 'TCTTDN':
        traCuuDM(tinNhan!, listDanhMuc);
        break;

      case 'QH-40':
      case 'LD-37':
      case 'KT-35':
      case 'CPXD-8':
        getDSTTHC(int.parse(value.first.text!.split('-').last));
        break;

      case 'TCLTD':
      case 'TCCAN':
      case 'KhoiKhac':
      case 'VuiChoiGiaiTri':
        troGiup();
        break;

      case 'TCTTQH':
        sendThongTinPhuongXa(isCheck: 0);
        break;

      case 'TTHDDTTHS':
      case 'AnUong':
      case 'DoanhNghiep':
      case 'KhachSan':
      case 'TinNguong':
        troGiup();
        break;

      default:
        sendMessRight(value);
        break;
    }
  }

  void troGiup() {
    checkHuy.sink.add(false);
    _listMess.insert(
        0,
        ChatModel(
          messLeft:
              'Xin lỗi dữ liệu của tôi chưa đủ khả năng để hiểu ý của bạn.',
        ));
    mess.sink.add(_listMess);
    typing.sink.add(false);
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

  void sendThongTinPhuongXa({String? tinNhan, int? isCheck}) {
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
    }

    if (isCheck == 1) {
      dsPhuongXa.sink.add([]);
      _tenPhuong = tinNhan!;
      typing.sink.add(true);
      _listMess.insert(0,
          ChatModel(messRight: tinNhan, messLeft: 'Bạn vui lòng nhập số tờ'));
    }

    if (isCheck == 2) {
      dsPhuongXa.sink.add([]);
      _soTo = tinNhan!;
      typing.sink.add(true);
      _listMess.insert(0,
          ChatModel(messRight: tinNhan, messLeft: 'Bạn vui lòng nhập số thửa'));
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
      } else {
        _listMess.insert(0, ChatModel(isTTQH: false, isTTQHEnd: false));
      }

      _callAPIGetTCQuyHoach('$_tenPhuong/$_soTo/$_soThua');
    }

    mess.sink.add(_listMess);
    typing.sink.add(false);
  }

  void _callAPIGetTCQuyHoach(String thongTin) {
    _getUrlTraCuuQuyHoachAPI(thongTin).then((value) {
      if (value != null) {
        _listMess.insert(
            0,
            ChatModel(
                traCuu: TraCuu(
                    chiTietQuyHoachModel: value,
                    type: 'action_tra_cuu_thong_tin_quy_hoach')));
        mess.sink.add(_listMess);
      }
      // Get.to(WebViewWidget(value));
      else {
        _listMess.insert(0, ChatModel(messLeft: 'không tìm thấy thông tin'));
        mess.sink.add(_listMess);
      }
    });
  }

  void sendThongTinHoSo({String? tinNhan, int? isCheckTTHS}) {
    if (isCheckTTHS == 0) {
      checkHuy.sink.add(true);
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
    }
    if (isCheckTTHS == 1) {
      _getTraCuuSoBienNhanAPI(tinNhan!).then((value) {
        if (value != null) {
          if (value.isNotEmpty) {
            _listMess.insert(
                0,
                ChatModel(
                  messRight: tinNhan,
                ));

            _listMess.insert(
                0,
                ChatModel(
                    isTTHSEnd: 2,
                    isTTQH: false,
                    traCuu: TraCuu(
                        traCuuBienNhan: value.first,
                        type: 'action_tra_cuu_so_bien_nhan')));
            checkHuy.sink.add(false);
            sendController.sink.add(false);
            mess.sink.add(_listMess);
            typing.sink.add(false);
          } else {
            _listMess.insert(
                0,
                ChatModel(
                  isTTHSEnd: 1,
                  messRight: tinNhan,
                  messLeft:
                      'Mã hồ sơ này không tồn tại. Quý khách vui lòng kiểm tra lại.',
                ));
            mess.sink.add(_listMess);
            typing.sink.add(false);
          }
        } else {
          _listMess.insert(
              0,
              ChatModel(
                isTTHSEnd: 1,
                messRight: tinNhan,
                messLeft:
                    'Mã hồ sơ này không tồn tại. Quý khách vui lòng kiểm tra lại.',
              ));
          mess.sink.add(_listMess);
          typing.sink.add(false);
        }
      });
    }
  }

  Future sendHuyTraCuu({String? value}) async {
    checkHuy.sink.add(false);
    _listMess.insert(0, ChatModel(messRight: 'Hủy'));
    mess.sink.add(_listMess);
    typing.sink.add(true);
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




      
    });
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
