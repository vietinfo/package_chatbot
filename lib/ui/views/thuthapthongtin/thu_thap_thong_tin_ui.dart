import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:package_chatbot/core/config/local_variable.dart';
import 'package:package_chatbot/core/model/ds_chu_nang_model.dart';
import 'package:package_chatbot/core/model/tracuudiadiemmodel.dart';
import 'package:package_chatbot/core/services/http_request.dart';
import 'package:package_chatbot/core/services/shared_pref.dart';

class ThuThapThongTinUI extends StatefulWidget {
  @override
  _ThuThapThongTinUIState createState() => _ThuThapThongTinUIState();
}

class _ThuThapThongTinUIState extends State<ThuThapThongTinUI> {
  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textGhiChuEditingController =
      TextEditingController();
  bool _isShowList = true;
  DetailsResult? detailsResult;
  Uint8List? images;

  bool _isloadImage = false;
  ListDanhMuc? _danhMuc;
  List<ListDanhMuc> _lstDanhMuc = [];

  @override
  void initState() {
    googlePlace = GooglePlace(
        SharedPref.instance!.getString(LocalVariable.instance.apikey));
    getlistDanhMuc();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textGhiChuEditingController.dispose();
    super.dispose();
  }

  void autoCompleteSearch(String value) async {
    final result = await googlePlace!.autocomplete.get(value, language: 'vi');
    if (result != null && result.predictions != null && mounted) {
      print(result);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getDetils(String placeId) async {
    final result =
        await googlePlace!.details.get(placeId, language: 'vi', region: 'VN');
    if (result != null && result.result != null && mounted) {
      if (!result.result!.formattedAddress!.toLowerCase().contains('hóc môn')) {
        Get.snackbar(
            'Xin lỗi chúng tôi hiện tại chỉ hỗ trợ khu vực Huyện Hóc Môn', '');

        return;
      }
      setState(() {
        detailsResult = result.result;
        _isShowList = false;
        images = null;
      });

      if (result.result!.photos != null) {
        // for (var photo in result.result.photos) {
        //   getPhoto(photo.photoReference);
        // }
        getPhoto(result.result!.photos!.first.photoReference!);
      }
    }
  }

  void getPhoto(String photoReference) async {
    final result = await googlePlace!.photos.get(photoReference, 0, 400);
    if (result != null && mounted) {
      setState(() {
        images = result;
        _isloadImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thu thu thập tư liệu'),
        actions: [
          if (!_isShowList)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => _sentData(),
            )
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: [
                  TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      labelText: 'tìm kiếm',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
                          width: 2.0,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && value.length > 10) {
                        autoCompleteSearch(value);
                      } else {
                        if (predictions.isNotEmpty && mounted) {
                          setState(() {
                            predictions = [];
                          });
                        }
                      }
                    },
                  ),
                  Positioned(
                      right: 5,
                      top: 5,
                      child: IconButton(
                        onPressed: () {
                          _textEditingController.text = '';
                          predictions = [];
                          _isShowList = true;
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (_isShowList)
                Expanded(
                  child: ListView.builder(
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(predictions[index].description!),
                        onTap: () {
                          debugPrint(predictions[index].placeId);
                          getDetils(predictions[index].placeId!);

                          // Navigator.push(
                          //   context,-
                          //   MaterialPageRoute(
                          //     builder: (context) => DetailsPage(
                          //       placeId: predictions[index].placeId,
                          //       googlePlace: googlePlace,
                          //     ),
                          //   ),
                          // );
                        },
                      );
                    },
                  ),
                )
              else
                Expanded(
                    child: ListView(
                  children: [
                    if (images != null)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ExtendedImage.memory(
                            images!,
                            fit: BoxFit.fill,
                          ),
                          if (_isloadImage)
                            const Center(
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.redAccent,
                                minHeight: 5,
                              ),
                            ),
                          if (detailsResult!.photos!.length > 1)
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.autorenew),
                                  highlightColor: Colors.green,
                                  iconSize: 50,
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      _isloadImage = true;
                                    });
                                    final int _index = Random().nextInt(
                                        detailsResult!.photos!.length - 1);
                                    getPhoto(detailsResult!
                                        .photos![_index].photoReference!);
                                  },
                                ))
                        ],
                      ),
                    const SizedBox(height: 10),
                    Text(
                      detailsResult != null &&
                              detailsResult!.formattedAddress != null
                          ? 'Địa chỉ: ${detailsResult!.formattedAddress}'
                          : 'Address: ',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      detailsResult != null &&
                              detailsResult!.geometry != null &&
                              detailsResult!.geometry!.location != null
                          ? 'Geometry: ${detailsResult!.geometry!.location!.lat.toString()},${detailsResult!.geometry!.location!.lng.toString()}'
                          : 'Geometry: ',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      detailsResult != null && detailsResult!.name != null
                          ? 'Tên: ${detailsResult!.name}'
                          : 'Tên: ',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      detailsResult != null && detailsResult!.website != null
                          ? 'website: ${detailsResult!.website}'
                          : 'website: ',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      detailsResult != null &&
                              detailsResult!.internationalPhoneNumber != null
                          ? 'Số điện thoại: ${detailsResult!.internationalPhoneNumber!.replaceAll(' ', '')}'
                          : 'Số điện thoại: ',
                    ),
                    DropdownButton(
                        value: _danhMuc,
                        hint: const Text(
                            'Vui lòng chọn danh mục cho địa điểm này'),
                        items: _lstDanhMuc
                            .map((e) => DropdownMenuItem(
                                  child: Text(e.tenLoaiDanhMuc!),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (ListDanhMuc? value) {
                          setState(() {
                            _danhMuc = value!;
                          });
                        }),
                    const SizedBox(height: 10),
                    const Text(
                      'ghi chú cho địa điểm này để tăng khả năng tìm kiếm chính xác cho địa điểm này, vd: vui chơi, giải trí, ăn uống',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextField(
                      controller: _textGhiChuEditingController,
                      decoration: const InputDecoration(
                        labelText: 'Ghi chú cho địa điểm này',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black54,
                            width: 2.0,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
              // Container(
              //   margin: EdgeInsets.only(top: 10, bottom: 10),
              //   child: Image.asset("assets/powered_by_google.png"),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _upload() async {
    final String _url =
        '${LocalVariable.instance.urlAPI}/api/Common/FileUpload/hocmonimage';
    final String? _data = await HttpRequest.instance.postUploadFileByte(_url,
        file: images, fileName: detailsResult!.placeId! + '.jpg');
    if (_data != null) {
      final List _item = jsonDecode(_data);
      return _item.first['linkFile'];
    }
    return null;
  }

  Future _sentData() async {
    if (_danhMuc == null) {
      Get.snackbar('Vui lòng chọn loại Danh mục địa điểm', '');
      return;
    } else if (_textGhiChuEditingController.text.isEmpty) {
      Get.snackbar('Vui lòng chọn ghi chú cho địa điểm', '');
      return;
    }

    final String _imageUrl = (await _upload())!;
    final String _url =
        '${LocalVariable.instance.urlAPI}/api/Home/ThuThapDataChatBot';

    final TraCuuDiaDiemModels _params = TraCuuDiaDiemModels()
      ..tenCoQuan = detailsResult!.name
      ..website = detailsResult!.website
      ..diaChi = detailsResult!.formattedAddress
      ..viDo = detailsResult!.geometry!.location!.lat
      ..kinhDo = detailsResult!.geometry!.location!.lng
      ..maLoaiDanhMuc = _danhMuc!.maLoaiDanhMuc
      ..maCoQuan = detailsResult!.placeId
      ..soDienThoai = detailsResult!.internationalPhoneNumber
      ..ghiChu = _textGhiChuEditingController.text
      ..imageURL = _imageUrl
      ..quanHuyenID = LocalVariable.instance.quanHuyenID
      ..tenQuanHuyen = LocalVariable.instance.tenQuanHuyen;

    final String _json =
        (await HttpRequest.instance.postAsync(_url, _params.toJson()))!;
    final _item = jsonDecode(_json);
    if (_item['result'] == -1)
      Get.snackbar('Địa điểm này đã có trong cơ sở dữ liệu', '');
    else {
      _isShowList = true;
      detailsResult = null;
      images = null;
      predictions = [];
      _textGhiChuEditingController.text = '';
      _textEditingController.text = '';
      _danhMuc = ListDanhMuc();
      Get.snackbar('Đã thêm thành công', '');

      setState(() {});
    }
  }

  void getlistDanhMuc() {
    final String _url =
        '${LocalVariable.instance.urlAPI}/api/Home/Bot_GetAllDanhMuc';
    HttpRequest.instance.getAsync(_url).then((value) {
      if (value != null) {
        final data = jsonDecode(value);
        if (data['result'] != null && data['result'] is List) {
          _lstDanhMuc = List.from(
              data['result'].map((e) => ListDanhMuc.fromJson(e)).toList());
        }
      }
    });
  }
}
