import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/config/palettes.dart';
import 'package:package_chatbot/core/model/botmessasge.dart';
import 'package:package_chatbot/core/model/tracuudiadiemmodel.dart';
import 'package:package_chatbot/ui/views/tracuudiadiem/tracuudiadiem_bloc.dart';
import 'package:package_chatbot/ui/widgets/listview_loadmore.dart';
import 'package:url_launcher/url_launcher.dart';

class TraCuuDiaDiemUI extends StatefulWidget {
  @override
  _TraCuuDiaDiemUIState createState() => _TraCuuDiaDiemUIState();
}

class _TraCuuDiaDiemUIState extends State<TraCuuDiaDiemUI> {
  late TraCuuDiaDiemBloc _traCuuDiaDiemBloc;
  late List<TraCuuDiaDiemModels> _traCuuDiaDiem;
  late List<BotMessage> _botMess;
  late String _tenDM;
  late int _banKinh;
  late String _maLoaiDanhMuc;
  late int _checkDD;
  late double _lat;
  late double _long;
  int _pageNum = 1;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    _traCuuDiaDiemBloc = BlocProvider.of<TraCuuDiaDiemBloc>(context);
    final Map data = Map.from(Get.arguments);
    _traCuuDiaDiem = data['result'];
    _botMess = data['results'];
    _tenDM = data['tenDM'];
    _banKinh = data['banKinh'];
    _maLoaiDanhMuc = data['maLoaiDanhMuc'];
    _checkDD = data['checkDD'];
    _lat = data['lat'];
    _long = data['long'];
    if (_checkDD != 1) {
      _traCuuDiaDiemBloc.traCuuDD(
          lat: _lat,
          long: _long,
          banKinh: _banKinh,
          maLoaiDanhMuc: _maLoaiDanhMuc,
          pageNum: _pageNum);
    } else {
      _traCuuDiaDiemBloc.traCuuDD1(
          lat: _lat,
          long: _long,
          banKinh: _botMess.first.custom!.data!.banKinh,
          maLoaiDanhMuc: _botMess.first.custom!.data!.maLoaiDanhMuc,
          tenCoQuan: _botMess.first.custom!.data!.tenCoQuan,
          maCoQuan: _botMess.first.custom!.data!.maCoQuan,
          pageNum: _pageNum);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tra cứu địa điểm $_tenDM'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: _traCuuDiaDiemBloc.traCuuDiaDiem.stream,
            builder:
                (context, AsyncSnapshot<List<TraCuuDiaDiemModels>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    _traCuuDiaDiem = snapshot.data!;
                    return ListViewLoadMore(
                      funcLoadMore: _loadMore,
                      isLoadMore: _traCuuDiaDiemBloc.isLoadMore,
                      showLoading: _traCuuDiaDiemBloc.showLoading,
                      itemCount: _traCuuDiaDiem.length,
                      itemBuilder: (context, index) {
                        final TraCuuDiaDiemModels traCuuDiaDiem =
                            _traCuuDiaDiem[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 8.0, top: 5),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxHeight: double.infinity,
                            ),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 5,
                                      color: Colors.grey)
                                ],
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
                                          '${traCuuDiaDiem.tenCoQuan ?? ' '} ',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Điện thoại:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 15.0),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => launch(
                                              'tel://${traCuuDiaDiem.soDienThoai}'),
                                          child: Text(
                                            ' ${traCuuDiaDiem.soDienThoai ?? 'Số điện thoại hiện tại chưa được cập nhập'}',
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.bold,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          onTap: () => _launchURL(
                                              traCuuDiaDiem.website!),
                                          child: Text(
                                            traCuuDiaDiem.website ??
                                                ' Website hiện tại chưa được cập nhập',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          onTap: () => openMapsSheet(
                                              traCuuDiaDiem.viDo!,
                                              traCuuDiaDiem.kinhDo!,
                                              traCuuDiaDiem.tenCoQuan!),
                                          child: Text(
                                            traCuuDiaDiem.diaChi ??
                                                ' Địa chỉ hiện tại chưa được cập nhập',
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
                                if (_traCuuDiaDiem[index].distance != 0)
                                  const Divider(),
                                if (traCuuDiaDiem.distance != 0)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        right: 10,
                                        left: 10,
                                        bottom: 15),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Vị trí này cách bạn ',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.0),
                                        ),
                                        Text(
                                          '${NumberFormat("###", "en_US").format(traCuuDiaDiem.distance)}m ',
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('Không có dữ liệu');
                  }
                default:
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                    ),
                  );
              }
            }));
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future openMapsSheet(double viDo, double kinhDo, String name) async {
    final latitude = viDo;
    final longitude = kinhDo;
    final availableMaps = await MapLauncher.installedMaps;
    print(
        availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
    await availableMaps.last.showDirections(
        destination: Coords(latitude, longitude), destinationTitle: name);
  }

  void _loadMore() {
    if (_pageNum == 0) return;
    if (_checkDD != 1) {
      _traCuuDiaDiemBloc.traCuuDD(
          lat: _lat,
          long: _long,
          banKinh: _banKinh,
          maLoaiDanhMuc: _maLoaiDanhMuc,
          pageNum: _pageNum++);
    } else {
      _traCuuDiaDiemBloc.traCuuDD1(
          lat: _lat,
          long: _long,
          banKinh: _botMess.first.custom!.data!.banKinh,
          maLoaiDanhMuc: _botMess.first.custom!.data!.maLoaiDanhMuc,
          tenCoQuan: _botMess.first.custom!.data!.tenCoQuan,
          maCoQuan: _botMess.first.custom!.data!.maCoQuan,
          pageNum: _pageNum++);
    }
  }
}
