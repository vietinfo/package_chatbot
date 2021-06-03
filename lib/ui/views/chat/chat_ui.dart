import 'dart:convert';
import 'dart:math' as math;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/config/palettes.dart';
import 'package:package_chatbot/core/model/botmessasge.dart';
import 'package:package_chatbot/core/model/chatmodels.dart';
import 'package:package_chatbot/core/model/ds_chu_nang_model.dart';
import 'package:package_chatbot/core/model/phuongxamodel.dart';
import 'package:package_chatbot/core/model/tracuutthcmodel.dart';
import 'package:package_chatbot/ui/views/chat/chat_bloc.dart';
import 'package:package_chatbot/ui/views/chitietthutuc/chitietthutuc_bloc.dart';
import 'package:package_chatbot/ui/views/chitietthutuc/chitietthutuc_ui.dart';
import 'package:package_chatbot/ui/widgets/disable_glow_listview.dart';
import 'package:package_chatbot/ui/widgets/web_view_widget.dart';
import 'package:popover/popover.dart';
import 'package:speech_to_text_vi/speech_to_text_vi.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/listitems.dart';
import 'components/messtype.dart';

class ChatUI extends StatefulWidget {
  @override
  _ChatUIState createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  final TextEditingController _mess = TextEditingController();
  late ChatBloc _chatBloc;
  List<ChatModel>? _chatModel;
  List<DanhMucChucNangModels>? _danhMucChucNangModels;
  int bk500 = 500;
  int bk1000 = 1000;
  bool checkViTri = false;
  Location location = Location();
  LocationData? _location;
  String? _error;
  String? tenDM;
  bool _checkTTHS = false;
  bool _checkTTQH = false;
  bool _checkTTQH1 = false;
  final int _pageNum = 1;
  bool _checkKB = false;
  int _checkPX = 0;
  int _checkHS = 0;
  int _isCheckTTHS = 0;
  double? lat;
  double? long;
  late String userName;

  String? maLoaiDM;
  List<PhuongXaModel> _listPhuongXa = <PhuongXaModel>[];

  late ScrollController listScrollController;

  Future<void> _getLocation() async {
    setState(() {
      _error = null;
    });
    try {
      final LocationData _locationResult = await location.getLocation();
      lat = _locationResult.latitude;
      long = _locationResult.longitude;
      print(_locationResult.latitude);
      print(_locationResult.longitude);
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mess.dispose();
    listScrollController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listScrollController = ScrollController();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    userName = '....';
    _getLocation();
    _chatBloc.getAllHistoryChat(tinNhan: 'null', userName: userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
            child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xff205072),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: ExtendedImage.network(
                      'https://i.tribune.com.pk/media/images/1253791-bot-1480922017/1253791-bot-1480922017.jpg',
                      fit: BoxFit.cover,
                      cache: true,
                      enableMemoryCache: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const[
                     Text(
                      'UBND huyện Hóc Môn',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:  TextStyle(
                          fontSize: 13,
                          // fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: Color(0xff205072)),
                    ),
                  ],
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     _chatBloc.restart();
              //     _mess.clear();
              //     _checkTTQH = false;
              //     _checkTTHS = false;
              //     _chatBloc.dsPhuongXa.sink.add([]);
              //     _chatBloc.sendController.sink.add(false);
              //     _chatBloc.checkHuy.sink.add(false);
              //   },
              //   child: const Icon(
              //     Icons.refresh,
              //     size: 25,
              //   ),
              // )
            ],
          ),
        )),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildListMessage(),
              StreamBuilder(
                  stream: _chatBloc.isCheckLocation.stream,
                  builder:
                      (context, AsyncSnapshot<Map<bool, String>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.keys.first) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 5),
                            child: Text(
                              'Để tra cứu thông tin $tenDM bạn vui lòng chọn bán kính',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (snapshot.data!.values.first != '1') {
                                    _chatBloc.traCuuDD(
                                        userName: userName,
                                      lat: lat,
                                        long: long,
                                        banKinh: bk500,
                                        maLoaiDanhMuc:
                                            snapshot.data!.values.first,
                                        tenDM: tenDM,
                                        pageNum: _pageNum);
                                  } else {
                                    _chatBloc.traCuuDD(
                                      userName: userName,
                                        lat: lat,
                                        long: long,
                                        banKinh: bk500,
                                        maLoaiDanhMuc: maLoaiDM,
                                        tenDM: tenDM,
                                        pageNum: _pageNum);
                                  }
                                  _scrollEndScreen();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Container(
                                    width: 80,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Palettes.allColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$bk500 m',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (snapshot.data!.values.first != '1') {
                                    _chatBloc.traCuuDD(
                                        lat: lat,
                                        long: long,
                                        banKinh: bk1000,
                                        maLoaiDanhMuc:
                                            snapshot.data!.values.first,
                                        tenDM: tenDM,
                                        pageNum: _pageNum);
                                  } else {
                                    _chatBloc.traCuuDD(
                                        lat: lat,
                                        long: long,
                                        banKinh: bk1000,
                                        maLoaiDanhMuc: maLoaiDM,
                                        tenDM: tenDM,
                                        pageNum: _pageNum);
                                  }
                                  _scrollEndScreen();
                                },
                                child: Container(
                                  width: 80,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Palettes.allColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$bk1000 m',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {

                                  if (snapshot.data!.values.first != '1') {
                                    _chatBloc.traCuuDD(
                                        lat: lat,
                                        long: long,
                                        banKinh: 0,
                                        maLoaiDanhMuc:
                                            snapshot.data!.values.first,
                                        tenDM: tenDM,
                                        pageNum: _pageNum);
                                  } else {
                                    _chatBloc.traCuuDD(
                                        lat: lat,
                                        long: long,
                                        banKinh: 0,
                                        maLoaiDanhMuc: maLoaiDM,
                                        tenDM: tenDM,
                                        pageNum: _pageNum);
                                  }
                                  _scrollEndScreen();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                    width: 80,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Palettes.allColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Tất cả',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  _chatBloc.checkLocation();
                                  _scrollEndScreen();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 15,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: 60,
                              color: Palettes.backGroundColor,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow:const [
                                           BoxShadow(
                                              offset: Offset(0, 3),
                                              blurRadius: 5,
                                              color: Colors.grey)
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            child: (_keyboardIsVisible())
                                                ? const Padding(
                                                    padding:
                                                         EdgeInsets.only(
                                                            left: 5),
                                                    child: Icon(
                                                      Icons.keyboard,
                                                      size: 25,
                                                    ),
                                                  )
                                                : const Padding(
                                                    padding:
                                                         EdgeInsets.only(
                                                            left: 5),
                                                    child: Icon(
                                                      Icons.menu,
                                                      size: 25,
                                                    ),
                                                  ),
                                            onTap: () {
                                              (_keyboardIsVisible())
                                                  ? FocusScope.of(context)
                                                      .unfocus()
                                                  : showPopover(
                                                      context: context,
                                                      bodyBuilder: (context) =>
                                                          ListItems(
                                                            userName,
                                                        _danhMucChucNangModels,
                                                        _chatBloc,
                                                        _scrollEndScreen,
                                                        checkTTHS: (value) {
                                                          _checkTTHS = value;
                                                        },
                                                        checkTTQH: (value) {
                                                          _checkTTQH = value;
                                                          if (!value)
                                                            _checkPX = 0;
                                                        },
                                                      ),
                                                      width: 250,
                                                      height: 400,
                                                      arrowHeight: 15,
                                                      onPop: () {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                      },
                                                      transitionDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  200),
                                                      arrowDxOffset: -150,
                                                    );
                                            },
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: TextFormField(
                                                controller: _mess,
                                                decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                  hintText:
                                                      'Hoặc nhập bán kính, đơn vị (m)',
                                                  hintStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14),
                                                  border: InputBorder.none,
                                                ),
                                                keyboardType:
                                                    TextInputType.number),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (_mess.text.isNotEmpty) {
                                                _chatBloc.traCuuDD(
                                                    lat: lat,
                                                    long: long,
                                                    banKinh:
                                                        int.parse(_mess.text),
                                                    maLoaiDanhMuc: maLoaiDM,
                                                    pageNum: _pageNum);

                                                _mess.clear();
                                              }
                                            },
                                            child: const Padding(
                                              padding:  EdgeInsets.only(
                                                  right: 5),
                                              child: Icon(
                                                Icons.send,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Align(
                          alignment: Alignment.bottomLeft,
                          child: StreamBuilder(
                              initialData: false,
                              stream: _chatBloc.sendController.stream,
                              builder: (context, AsyncSnapshot<bool> snapshot) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      color: const Color(0xffF1F1F1),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                boxShadow:const [
                                                  BoxShadow(
                                                      offset: Offset(0, 3),
                                                      blurRadius: 5,
                                                      color: Colors.grey)
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    child:
                                                        (_keyboardIsVisible())
                                                            ? const Padding(
                                                                padding:
                                                                     EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                child: Icon(
                                                                  Icons
                                                                      .keyboard,
                                                                  size: 25,
                                                                ),
                                                              )
                                                            : const Padding(
                                                                padding:
                                                                     EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                child: Icon(
                                                                  Icons.menu,
                                                                  size: 25,
                                                                ),
                                                              ),
                                                    onTap: () {
                                                      (_keyboardIsVisible())
                                                          ? FocusScope.of(
                                                                  context)
                                                              .unfocus()
                                                          : showPopover(
                                                              context: context,
                                                              bodyBuilder:
                                                                  (context) =>
                                                                      ListItems(
                                                                        userName,
                                                                _danhMucChucNangModels,
                                                                _chatBloc,
                                                                _scrollEndScreen,
                                                                checkTTHS:
                                                                    (value) {
                                                                  _checkTTHS =
                                                                      value;
                                                                },
                                                                checkTTQH:
                                                                    (value) {
                                                                  _checkTTQH =
                                                                      value;
                                                                  if (!value)
                                                                    _checkPX =
                                                                        0;
                                                                },
                                                              ),
                                                              width: 250,
                                                              height: 400,
                                                              onPop: () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                              },
                                                              arrowHeight: 15,
                                                              transitionDuration:
                                                              const Duration(
                                                                      milliseconds:
                                                                          200),
                                                              arrowDxOffset:
                                                                  -150,
                                                            );
                                                    },
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller: _mess,
                                                      textInputAction:
                                                          TextInputAction
                                                              .newline,
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                    horizontal:
                                                                        10.0),
                                                        hintText:
                                                            'Nhập tại đây .......',
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 14),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .sentences,
                                                      onChanged: (value) {
                                                        _soanTinNhan(value);

                                                        ///aaaaaa
                                                        if (_checkTTQH) {
                                                          _checkThongTinQuyHoach(
                                                              value);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  if (snapshot.data!)
                                                    InkWell(
                                                      onTap: () {
                                                        if (_checkTTQH1)
                                                          _checkTTQH = false;
                                                        if (_checkTTQH) {
                                                          _sendThongTinQuyHoach(
                                                              _mess.text);
                                                        }
                                                        if (_checkTTHS) {
                                                          _sendThongTinHoSo(
                                                              _mess.text);
                                                        }
                                                        _sendBot();
                                                      },
                                                      child: const Padding(
                                                        padding:
                                                             EdgeInsets
                                                                    .only(
                                                                right: 10),
                                                        child: Icon(
                                                          Icons.send,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: (snapshot.data!)
                                                ? const SizedBox.shrink()
                                                : InkWell(
                                                    onTap: () => showMicSheet(
                                                        homeContext:
                                                            this.context,
                                                        resultSpeech:
                                                            _voiceCheck),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      decoration: const BoxDecoration(
                                                          color: Colors.blue,
                                                          shape:
                                                              BoxShape.circle),
                                                      child: const Padding(
                                                        padding:
                                                             EdgeInsets
                                                                    .only(
                                                                top: 2,
                                                                bottom: 2),
                                                        child: Icon(
                                                          Icons.keyboard_voice,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }));
                    }
                  }),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: StreamBuilder(
                  stream: _chatBloc.dsPhuongXa.stream,
                  builder:
                      (context, AsyncSnapshot<List<PhuongXaModel>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          _listPhuongXa = snapshot.data!;
                          return ScrollConfiguration(
                            behavior: DisableGlowListViewCustom(),
                            child: CupertinoScrollbar(
                              controller: listScrollController,
                              isAlwaysShown: true,
                              child: Container(
                                color: Colors.white,
                                constraints: BoxConstraints(
                                    maxHeight: Get.height / 5,
                                    minWidth: Get.width),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: listWidget(_listPhuongXa),
                                  ),
                                ),
                                // child: ListView.builder(
                                //     itemCount: _listPhuongXa.length,
                                //     itemBuilder: (context, index) {
                                //       PhuongXaModel phuongXaModel =
                                //           _listPhuongXa[index];
                                //       return InkWell(
                                //         onTap: () {
                                //           _getTenPhuongXa(
                                //               phuongXaModel.tenPhuong!);
                                //         },
                                //         child: Padding(
                                //           padding: const EdgeInsets.all(10.0),
                                //           child: Text(
                                //             phuongXaModel.tenPhuong!,
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.bold),
                                //           ),
                                //         ),
                                //       );
                                //     }),
                              ),
                            ),
                          );
                        } else
                          return const SizedBox.shrink();
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> listWidget(List<PhuongXaModel> data) {
    final List<Widget> listWidget = [];
    for (final item in data) {
      listWidget.add(itemWidget(item));
    }
    return listWidget;
  }

  Widget itemWidget(PhuongXaModel phuongXaModel) {
    return InkWell(
      onTap: () {
        _getTenPhuongXa(phuongXaModel.tenPhuong!);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          phuongXaModel.tenPhuong!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildListMessage() {
    return Expanded(
      child: Container(
        color: Palettes.backGroundColor,
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: DisableGlowListViewCustom(),
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {
                    if (scrollNotification.metrics.pixels != 0) {
                      _chatBloc.showBottomScroll(true);
                    } else {
                      _chatBloc.showBottomScroll(false);
                    }
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  controller: listScrollController,
                  padding: EdgeInsets.zero,
                  reverse: true,
                  child: StreamBuilder(
                      stream: _chatBloc.mess.stream,
                      builder:
                          (context, AsyncSnapshot<List<ChatModel>> snapshot) {
                        if (snapshot.hasData) {
                          _chatModel = snapshot.data;

                          // kiem tra thong tin quy hoach tu bot tra ra
                          if (_chatModel!.first.isTTQH!) {
                            _checkTTQH = _chatModel!.first.isTTQH!;
                          }

                          if (_chatModel!.first.isTTQHEnd!) {
                            _checkTTQH = false;
                            _checkTTQH1 = _chatModel!.first.isTTQHEnd!;
                          } else {
                            _checkTTQH1 = false;
                          }
                          //--------------------------------------//

                          // kiem tra sô bien nhan tu bot tra ra
                          if (_chatModel!.first.isTTHS!) {
                            _checkTTHS = _chatModel!.first.isTTHS!;
                          }
                          //  = 1 dang nhap sai ma bien nhan
                          if (_chatModel!.first.isTTHSEnd == 1) {
                            _checkHS = 0;
                          }
                          //  = 2 dang nhap dung ma bien nhan
                          if (_chatModel!.first.isTTHSEnd == 2) {
                            _isCheckTTHS = 0;
                            _checkTTHS = false;
                            _checkHS = 0;
                          }
                          //--------------------------------------//
                          return Column(
                            children: _chatModel!.reversed.map((e) {
                              tenDM = e.messRight;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (e.isInfo == true) _info(),
                                  if (e.messRight != null)
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: MessageTile(
                                            message: e.messRight!,
                                            sendByMe: true,
                                          ),
                                        )),
                                  if (e.messLeft != null)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: MessageTile(
                                          message: e.messLeft!,
                                          sendByMe: false,
                                        ),
                                      ),
                                    ),
                                  if (e.isListDM == true)
                                    _buildColumnDM(e.listDanhMuc!),
                                  if (e.isTTHC == true)
                                    _buildColumnTTHC(e.listTTHC!),
                                  if (e.isHeader == true)
                                    Column(
                                      children: [
                                        StreamBuilder(
                                            stream:
                                                _chatBloc.dsChucNang.stream,
                                            builder: (context,
                                                AsyncSnapshot<
                                                        List<
                                                            DanhMucChucNangModels>>
                                                    snapshot) {
                                              _danhMucChucNangModels =
                                                  snapshot.data;
                                              if (snapshot.hasData) {
                                                return _buildColumnDSChuNang();
                                              } else {
                                                return const SizedBox.shrink();
                                              }
                                            })
                                      ],
                                    ),
                                  if (e.traCuu != null)
                                    _data(e.traCuu!, e.isReadMore!)

                                ],
                              );
                            }).toList(),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 0,
              child: StreamBuilder(
                  stream: _chatBloc.typing.stream,
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData && snapshot.data!) {
                      return Row(
                        children:const [
                           SpinKitWanderingCubes(
                            color: Colors.cyan,
                            shape: BoxShape.circle,
                            size: 10,
                          ),
                           SizedBox(
                            width: 3,
                          ),
                           Text(
                            'Đang soạn tin',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                color: Colors.cyan),
                          ),
                        ],
                      );
                    } else
                      return const SizedBox.shrink();
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: StreamBuilder(
                    stream: _chatBloc.scroll.stream,
                    builder: (context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!) {
                          return GestureDetector(
                            onTap: () {
                              _scrollEndScreen();
                              _chatBloc.showBottomScroll(false);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Palettes.allColor),
                                  child: Center(
                                    child: Transform.rotate(
                                        angle: math.pi / 2,
                                        child: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 25,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 10,
              child: StreamBuilder(
                  stream: _chatBloc.checkHuy.stream,
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!) {
                        return GestureDetector(
                          onTap: () {
                            _chatBloc.sendHuyTraCuu(userName,value: 'Hủy');
                            _mess.clear();
                            _chatBloc.sendController.sink.add(false);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(  Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: const Text('Hủy',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _info() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: Get.width * 0.3,
          width: Get.width * 0.3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(360),
            child: ExtendedImage.network(
              'https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/e6/97/ab/e697abc1-d5fe-f3d5-b86c-80d852b65955/source/512x512bb.jpg',
              fit: BoxFit.cover,
              cache: true,
              enableMemoryCache: true,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'UBND huyện Hóc Môn xin kính chào!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Chào mừng bạn đến với UBND huyện Hóc Môn! Tôi là BOT tự động, Mời Anh/Chị bấm bắt đầu để chọn dịch vụ cần hổ trợ hoặc muốn tra cứu thông tin :).',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildColumnDSChuNang() {
    return SizedBox(
      height: Get.width * 0.6,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          // if(scrollNotification.metrics.pixels != 0){
          //   _chatBloc!.showBottomScroll(false);
          // }
          return true;
        },
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _danhMucChucNangModels!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (_danhMucChucNangModels![index].maChucNang! == 'TCTTHS') {
                    _checkTTHS = true;
                  } else {
                    _checkTTHS = false;
                    _chatBloc.checkHuy.sink.add(false);
                  }

                  if (_danhMucChucNangModels![index].maChucNang! == 'TCTTQH') {
                    _checkTTQH = true;
                    _chatBloc.getAllPhuongXa();
                  } else {
                    _checkPX = 0;
                    _chatBloc.dsPhuongXa.sink.add([]);
                    _checkTTQH = false;
                    _mess.clear();
                    _chatBloc.checkHuy.sink.add(false);
                  }

                  _chatBloc.sendMessAPI(
                    userName: userName,
                      tinNhan: _danhMucChucNangModels![index].tenChucNang!,
                      maChucNang: _danhMucChucNangModels![index].maChucNang!,
                      listDanhMuc: _danhMucChucNangModels![index].listDanhMuc);
                  _scrollEndScreen();
                  _chatBloc.checkLocation();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(10),
                  width: Get.width * 0.5,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: Get.width * 0.35,
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: ExtendedImage.network(
                            _danhMucChucNangModels![index].imageURL!,
                            fit: BoxFit.cover,
                            cache: true,
                            enableMemoryCache: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: Get.width * 0.5,
                                height: Get.height * 0.05,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: Text(
                                    _danhMucChucNangModels![index].tenChucNang!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Palettes.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildColumnDM(String listDanhMucs) {
    var listDanhMuc = jsonDecode(listDanhMucs);
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          width: Get.width * 0.5,
          constraints: const BoxConstraints(maxHeight: double.infinity),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listDanhMuc.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _chatBloc.messDanhMuc(userName: userName,tenDanhMuc: listDanhMuc[index]['tenLoaiDanhMuc']);
                        maLoaiDM = listDanhMuc[index]['maLoaiDanhMuc'];
                        tenDM = listDanhMuc[index]['tenLoaiDanhMuc'];
                        _checkTTQH = false;
                        _chatBloc.checkHuy.sink.add(false);
                        _scrollEndScreen();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: Get.width * 0.5,
                          height: Get.height * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(
                            child: Text(
                              listDanhMuc[index]['tenLoaiDanhMuc'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Palettes.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _buildColumnTTHC(String listTTHCs) {
    var listTTHC = jsonDecode(listTTHCs);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        width: Get.width * 0.6,
        constraints: const BoxConstraints(maxHeight: double.infinity),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listTTHC.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _chatBloc.getDSTTHC(userName,listTTHC[index]['linhVucID'],
                          tinNhan: listTTHC[index]['tenLinhVuc']);
                      _checkTTQH = false;
                      _scrollEndScreen();
                      _chatBloc.checkHuy.sink.add(false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: Get.width * 0.6,
                        constraints:
                            const BoxConstraints(maxHeight: double.infinity),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            listTTHC[index]['tenLinhVuc'],
                            style: const TextStyle(
                                color: Color(0xff364761),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _data(String customs, bool readMore, ) {
    var custom = jsonDecode(customs);
    print(custom);
    switch (custom['type']) {
      case 'action_tra_cuu_dia_diem':
        var data = jsonDecode(custom['data1']);
        return Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 5),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: double.infinity,
                ),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    color: Color(0xffffffff)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on),
                          Expanded(
                            child: Text(
                              '${data['tenCoQuan'] ?? ' '} ',
                              style: const TextStyle(
                                  color: Palettes.textColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Text(
                            'Điện thoại:',
                            style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 15.0),
                          ),
                          GestureDetector(
                            onTap: () =>
                                launch('tel://${data['soDienThoai']}'),
                            child: Text(
                              ' ${data['soDienThoai'] ?? 'Số điện thoại hiện tại chưa được cập nhập'}',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Website: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 15.0),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _launchURL(data['website']),
                              child: Text(
                                data['website'] ?? ' Website hiện tại chưa được cập nhập',
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Địa chỉ: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 15.0),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _openMapsSheet(data['viDo'],
                                  data['kinhDo'], data['tenCoQuan']),
                              child: Text(
                                data['diaChi'],
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (data['distance'] != 0)
                      const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Divider(),
                      ),
                    if (data['distance'] != 0)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Text(
                              'Vị trí này cách bạn ',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal, fontSize: 15.0),
                            ),
                            Text(
                              '${NumberFormat("###", "en_US").format(data['distance'])}m ',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.0),
                            ),
                          ],
                        ),
                      ),

                  ],
                ),
              ),
            ),
            if(readMore) GestureDetector(
              onTap: (){
                _checkTTQH = false;
                _checkTTHS = false;
                _chatBloc.dsPhuongXa.sink.add([]);
                _chatBloc.sendController.sink.add(false);
                _chatBloc.checkHuy.sink.add(false);
                _chatBloc.readMoreDD(userName,custom,_mess.text, 1, lat, long);
              },
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 20),
                    child: Text(
                      "Xem tất cả",
                      style: const TextStyle(
                          color:  const Color(0xff47b0f0),
                          fontStyle:  FontStyle.italic,
                          fontSize: 17.0
                      ),
                    ),
                  )),
            )

          ],
        );
      case 'action_tra_cuu_so_bien_nhan':
        var dataTraCuuBienNhan = jsonDecode(custom['traCuuBienNhan']);
        return Padding(
          padding:
              const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 5),
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: double.infinity,
            ),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: Color(0xffffffff)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text('Thông tin hồ sơ',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tên hồ sơ/thủ tục: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0),
                      ),
                      Expanded(
                        child: Text(
                          ' ${dataTraCuuBienNhan['tenThuTuc']}',
                          style: const TextStyle(
                              color: Colors.blue,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Số biên nhận:',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0),
                      ),
                      Expanded(
                        child: Text(
                          ' ${dataTraCuuBienNhan['soBienNhan']}',
                          style: const TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Người nộp hồ sơ:',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0),
                      ),
                      Expanded(
                        child: Text(
                          ' ${dataTraCuuBienNhan['nguoiDungTenHoSo']}',
                          style: const TextStyle(
                              fontStyle: FontStyle.normal, fontSize: 15.0),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ngày tiếp nhận: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0),
                      ),
                      Expanded(
                        child: Text(
                          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(dataTraCuuBienNhan['ngayNhan']))} ',
                          style: const TextStyle(
                              fontStyle: FontStyle.normal, fontSize: 15.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ngày hẹn trả: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0),
                      ),
                      Expanded(
                        child: Text(
                          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(dataTraCuuBienNhan['ngayHenTra']))} ',
                          style: const TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trạng thái: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0),
                      ),
                      Expanded(
                        child: Text(
                          '${dataTraCuuBienNhan['tinhTrangHoSo']} ',
                          style: const TextStyle(
                              color: Colors.green,
                              fontStyle: FontStyle.normal,
                              fontSize: 13.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case 'action_tra_cuu_thu_tuc_hanh_chinh':
        var data = jsonDecode(custom['traCuuTTHCmodel']);
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _chatBloc.checkHuy.sink.add(false);
                  Get.to(
                      BlocProvider(
                          child: ChiTietThuTucUI(), bloc: ChiTietThuTucBloc()),
                      arguments: {
                        'result': data[index]['thuTucID']
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0, top: 5),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: double.infinity,
                    ),
                    width: Get.width,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color(0xffffffff)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data[index]['tenThuTuc'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8, bottom: 8),
                        //   child: Text('${custom.traCuuTTHCmodel![index].tenLinhVuc}', style: TextStyle(color: Colors.grey),),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            });
      case 'action_tra_cuu_thong_tin_quy_hoach':
        var dataTraCuuTTQH = jsonDecode(custom['chiTietQuyHoachModel']);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration:
            BoxDecoration(border: Border.all(color: Colors.black12)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    color: Colors.grey.shade300,
                    child: const Center(
                        child: Text(
                          'Thông tin thửa đất',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                      text: 'Địa chỉ: ',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    TextSpan(
                      text: dataTraCuuTTQH['tenXa'] ?? '',
                      style: const TextStyle(color: Colors.redAccent, fontSize: 15),
                    )
                  ])),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                      text: 'Số hiệu tờ bản đồ: ',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    TextSpan(
                      text: dataTraCuuTTQH['soHieuToBanDo'],
                      style: const TextStyle(color: Colors.redAccent, fontSize: 15),
                    )
                  ])),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                      text: 'Số thứ tự thửa: ',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    TextSpan(
                      text: dataTraCuuTTQH['soThuTuThua'],
                      style: const TextStyle(color: Colors.redAccent, fontSize: 15),
                    )
                  ])),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                      text: 'Diện tích: ',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    TextSpan(
                      text:  dataTraCuuTTQH['dienTich'].toString(),
                      style: const TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    const TextSpan(
                      text: ' m²',
                      style: TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                  ])),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(TextSpan(children: [
                        const TextSpan(
                          text: 'Loại đất: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        TextSpan(
                          text: dataTraCuuTTQH['tenLoaiDat'] ??
                              'Đang cập nhật',
                          style:
                          const TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                      ])),
                      InkWell(
                        onTap: () => Get.to(WebViewWidget(
                            dataTraCuuTTQH['gisUrl'])),
                        child: const Text(
                          'Xem chi tiết',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _checkThongTinQuyHoach(String value) {
    if (_checkPX == 0) {
      _chatBloc.searchPhuongXa(keySearch: value);
    }
  }

  void _sendThongTinQuyHoach(String value) {
    if (value.trim().isEmpty) {
      Get.snackbar('Thông báo', 'Vui lòng nhập giá trị');
      return;
    }

    _mess.clear();
    _checkPX++;

    if (value.trim().isNotEmpty) {
      _chatBloc.sendThongTinPhuongXa(userName,tinNhan: value, isCheck: _checkPX);
    }
    if (_checkPX == 3) {
      _checkPX = 0;
      _checkTTQH = false;
    }
  }

  void _sendThongTinHoSo(String value) {
    _mess.clear();

    if (_isCheckTTHS == 0) {
      _checkHS++;
      if (value.trim().isNotEmpty) {
        _chatBloc.sendThongTinHoSo(userName,tinNhan: value, isCheckTTHS: _checkHS);
      }
    }
  }

  void _getTenPhuongXa(String tenPhuongXa) {
    _mess.text = tenPhuongXa;
    _mess.selection =
        TextSelection.fromPosition(TextPosition(offset: _mess.text.length));
    _chatBloc.dsPhuongXa.sink.add([]);
  }

  void _voiceCheck(String text) {
    if (text.trim().isNotEmpty) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _mess.text = text;
        _mess.selection =
            TextSelection.fromPosition(TextPosition(offset: _mess.text.length));
      });
      _chatBloc.sendController.sink.add(true);
    } else {
      _chatBloc.sendController.sink.add(false);
    }
  }

  void _sendBot() {
    if (_mess.text.trim().isNotEmpty) {
      _chatBloc
          .sendMessBot(userName,_mess.text, danhMucChucNang: _danhMucChucNangModels,lat: lat, long: long);

      _chatBloc.sendController.sink.add(false);
      _mess.clear();

      _scrollEndScreen();
    }
  }

  bool _keyboardIsVisible() {
    _checkKB = true;
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  void _soanTinNhan(String value) {
    if (value.trim().isNotEmpty) {
      _chatBloc.sendController.sink.add(true);
    } else {
      _chatBloc.sendController.sink.add(false);
    }
    // if(_checkTTQH){
    //   FocusScope.of(context).unfocus();
    // }
  }

  // ignore: avoid_void_async
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _openMapsSheet(double viDo, double kinhDo, String name) async {
    final latitude = viDo;
    final longitude = kinhDo;
    final availableMaps = await MapLauncher.installedMaps;
    print(
        availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
    await availableMaps.last.showDirections(
        destination: Coords(latitude, longitude), destinationTitle: name);
  }

  void _scrollEndScreen() {
    listScrollController.animateTo(
        listScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut);
  }
}
