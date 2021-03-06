import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/config/palettes.dart';
import 'package:package_chatbot/core/model/bot_messasge.dart';
import 'package:package_chatbot/core/model/tra_cuu_dia_diem_model.dart';
import 'package:package_chatbot/ui/views/tracuudiadiem/tracuudiadiem_bloc.dart';
import 'package:package_chatbot/ui/widgets/listview_loadmore.dart';
import 'package:url_launcher/url_launcher.dart';

class TraCuuDiaDiemUI extends StatefulWidget {
  @override
  _TraCuuDiaDiemUIState createState() => _TraCuuDiaDiemUIState();
}

class _TraCuuDiaDiemUIState extends State<TraCuuDiaDiemUI> {
  late TraCuuDiaDiemBloc _traCuuDiaDiemBloc;
   List<TraCuuDiaDiemModels>? _traCuuDiaDiem;
  List<BotMessage>? _botMess;
  String? _tenDM;
  int? _banKinh;
  String? _maLoaiDanhMuc;
  int? _checkDD;
  double? _lat;
  double? _long;
  int _pageNum = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _traCuuDiaDiemBloc = BlocProvider.of<TraCuuDiaDiemBloc>(context);
    Future.delayed(Duration.zero, () {
      if(ModalRoute.of(context)!.settings.arguments is List<TraCuuDiaDiemModels>){
        _traCuuDiaDiem = ModalRoute.of(context)!.settings.arguments as List<TraCuuDiaDiemModels>;
        setState(() {});
      }else{
        final data = ModalRoute.of(context)!.settings.arguments as ObjectData;
        _traCuuDiaDiem = data.traCuuDiaDiem;
        _botMess = data.botMess;
        _tenDM = data.tenDM;
        _banKinh = data.banKinh;
        _maLoaiDanhMuc = data.maLoaiDanhMuc;
        _checkDD = data.checkDD;
        _lat = data.lat;
        _long = data.long;
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
              banKinh: _botMess!.first.custom!.data!.banKinh,
              maLoaiDanhMuc: _botMess!.first.custom!.data!.maLoaiDanhMuc,
              tenCoQuan: _botMess!.first.custom!.data!.tenCoQuan,
              maCoQuan: _botMess!.first.custom!.data!.maCoQuan,
              pageNum: _pageNum);
        }
      }

    });
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
          title: Text('Tra c???u ?????a ??i???m'),
          centerTitle: true,
        ),
        body: (_traCuuDiaDiem != null)?ListView.builder(
            itemCount: _traCuuDiaDiem!.length,
            itemBuilder: (context, index) {
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
                                '${_traCuuDiaDiem![index].tenCoQuan ?? ' '} ',
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
                              '??i???n tho???i:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.0),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => launch(
                                    'tel://${_traCuuDiaDiem![index].soDienThoai}'),
                                child: Text(
                                  ' ${_traCuuDiaDiem![index].soDienThoai ?? 'S??? ??i???n tho???i hi???n t???i ch??a ???????c c???p nh???p'}',
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
                                    _traCuuDiaDiem![index].website!),
                                child: Text(
                                  _traCuuDiaDiem![index].website ??
                                      ' Website hi???n t???i ch??a ???????c c???p nh???p',
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
                              '?????a ch???: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.0),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => openMapsSheet(
                                    _traCuuDiaDiem![index].viDo!,
                                    _traCuuDiaDiem![index].kinhDo!,
                                    _traCuuDiaDiem![index].tenCoQuan!),
                                child: Text(
                                  _traCuuDiaDiem![index].diaChi ??
                                      ' ?????a ch??? hi???n t???i ch??a ???????c c???p nh???p',
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
                      if (_traCuuDiaDiem![index].distance != 0)
                        const Divider(),
                      if (_traCuuDiaDiem![index].distance != 0)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10,
                              right: 10,
                              left: 10,
                              bottom: 15),
                          child: Row(
                            children: [
                              const Text(
                                'V??? tr?? n??y c??ch b???n ',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.0),
                              ),
                              Text(
                                '${NumberFormat("###", "en_US").format(_traCuuDiaDiem![index].distance)}m ',
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
            })
            :StreamBuilder(
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
                      itemCount: _traCuuDiaDiem!.length,
                      itemBuilder: (context, index) {
                        final TraCuuDiaDiemModels traCuuDiaDiem =
                            _traCuuDiaDiem![index];
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
                                        '??i???n tho???i:',
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
                                            ' ${traCuuDiaDiem.soDienThoai ?? 'S??? ??i???n tho???i hi???n t???i ch??a ???????c c???p nh???p'}',
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
                                                ' Website hi???n t???i ch??a ???????c c???p nh???p',
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
                                        '?????a ch???: ',
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
                                                ' ?????a ch??? hi???n t???i ch??a ???????c c???p nh???p',
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
                                if (_traCuuDiaDiem![index].distance != 0)
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
                                          'V??? tr?? n??y c??ch b???n ',
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
                    return const Text('Kh??ng c?? d??? li???u');
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
          banKinh: _botMess!.first.custom!.data!.banKinh,
          maLoaiDanhMuc: _botMess!.first.custom!.data!.maLoaiDanhMuc,
          tenCoQuan: _botMess!.first.custom!.data!.tenCoQuan,
          maCoQuan: _botMess!.first.custom!.data!.maCoQuan,
          pageNum: _pageNum++);
    }
  }
}

class ObjectData {
  TraCuuDiaDiemBloc? traCuuDiaDiemBloc;
  List<TraCuuDiaDiemModels>? traCuuDiaDiem;
  List<BotMessage>? botMess;
  String? tenDM;
  int? banKinh;
  String? maLoaiDanhMuc;
  int? checkDD;
  double? lat;
  double? long;

  ObjectData(
      {this.traCuuDiaDiemBloc,
      this.traCuuDiaDiem,
      this.botMess,
      this.tenDM,
      this.banKinh,
      this.maLoaiDanhMuc,
      this.checkDD,
      this.lat,
      this.long});
}
