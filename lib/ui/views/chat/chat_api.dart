part of 'chat_bloc.dart';

@protected
Future<List<DanhMucChucNangModels>?> _getAllDSChuNangAPI() async {
  final String _url = LocalVariable.urlAPI + '/api/home/GetAllDanhMucChucNang';

  final String? json = await HttpRequest.instance.getAsync(_url);
  if (json == null) {
    return null;
  }

  final data = jsonDecode(json);
  List<DanhMucChucNangModels> _listData = <DanhMucChucNangModels>[];
  if (data['result'] != null) {
    final result = data['result'] as List;
    _listData = result
        .map((tagJson) => DanhMucChucNangModels.fromJson(tagJson))
        .toList();
    return _listData;
  }
  return null;
}

@protected
Future<List<TraCuuDiaDiemModels>?> _traCuuDiaDiemAPI(
    {String? maCoQuan,
    String? tenCoQuan,
    double? lat,
    double? long,
    int? banKinh,
    int? pageNum,
    String? maLoaiDanhMuc}) async {
  final String _url = LocalVariable.urlAPI + '/api/Home/TraCuuDiaDiem';

  final Map<String, dynamic> parms = {
    'maCoQuan': maCoQuan,
    'tenCoQuan': tenCoQuan,
    'lat': lat,
    'long': long,
    'banKinh': banKinh,
    'maLoaiDanhMuc': maLoaiDanhMuc,
    'pageNum': pageNum,
    'pageSize': 10
  };

  final String? json = await HttpRequest.instance.postAsync(_url, parms);
  if (json == null) return null;
  final data = jsonDecode(json);
  List<TraCuuDiaDiemModels> _listData = <TraCuuDiaDiemModels>[];
  if (data['result'] != null) {
    final result = data['result'] as List;
    _listData =
        result.map((tagJson) => TraCuuDiaDiemModels.fromJson(tagJson)).toList();
    return _listData;
  }

  return null;
}

@protected
Future<List<BotMessage>> _sendChatBot(String tinNhan) async {
  final String _url = LocalVariable.urlChatBot + '/webhooks/rest/webhook';

  final Map<String, dynamic> parms = {
    'sender': 'Nhanahihi',
    'message': tinNhan,
  };

  final String? json = await HttpRequest.instance.postAsync(_url, parms);
  List<BotMessage> _temp = <BotMessage>[];
  if (json != null) {
    final data = jsonDecode(json) as List;
    _temp = data.map((tagJson) => BotMessage.fromJson(tagJson)).toList();
  }
  return _temp;
}

@protected
Future<List<TraCuuTTHCmodel>?> _getLinhVucTucHanhChinhAPI() async {
  final String _url = LocalVariable.urlAPI + '/api/Home/GetLinhVucTucHanhChinh';

  final String? json = await HttpRequest.instance.getAsync(_url);
  if (json == null) {
    return null;
  }
  final data = jsonDecode(json);
  List<TraCuuTTHCmodel> _listData = <TraCuuTTHCmodel>[];

  if (data['result'] != null) {
    final result = data['result'] as List;
    _listData =
        result.map((tagJson) => TraCuuTTHCmodel.fromJson(tagJson)).toList();

    return _listData;
  }

  return null;
}

@protected
Future<List<TraCuuTTHCmodel>?> _getDanhSachThuTucHanhChinhTheoAPI(
    int linhVucID) async {
  final String _url = LocalVariable.urlAPI +
      '/api/Home/GetDanhSachThuTucHanhChinhTheoLinhVucID/$linhVucID';

  final String? json = await HttpRequest.instance.getAsync(_url);
  if (json == null) {
    return null;
  }
  final data = jsonDecode(json);
  List<TraCuuTTHCmodel> _listData = <TraCuuTTHCmodel>[];

  if (data['result'] != null) {
    final result = data['result'] as List;
    _listData =
        result.map((tagJson) => TraCuuTTHCmodel.fromJson(tagJson)).toList();

    return _listData;
  }

  return null;
}

@protected
Future<List<TraCuuBienNhanModel>?> _getTraCuuSoBienNhanAPI(
    String soBienNhan) async {
  final String _url =
      LocalVariable.urlAPI + '/api/Home/GetTraCuuSoBienNhan/$soBienNhan';

  final String? json = await HttpRequest.instance.getAsync(_url);
  if (json == null) {
    return null;
  }
  final data = jsonDecode(json);
  List<TraCuuBienNhanModel> _listData = <TraCuuBienNhanModel>[];

  if (data['result'] != null) {
    final result = data['result'] as List;
    _listData =
        result.map((tagJson) => TraCuuBienNhanModel.fromJson(tagJson)).toList();

    return _listData;
  }

  return null;
}

@protected
Future<List<PhuongXaModel>?> _getAllPhuongXaAPI() async {
  final String _url = LocalVariable.urlAPI + '/api/Home/Bot_GetAllPhuongXa';

  final String? json = await HttpRequest.instance.getAsync(_url);
  if (json == null) {
    return null;
  }
  final data = jsonDecode(json);
  List<PhuongXaModel> _listData = <PhuongXaModel>[];

  if (data['result'] != null) {
    final result = data['result'] as List;
    _listData =
        result.map((tagJson) => PhuongXaModel.fromJson(tagJson)).toList();
    return _listData;
  }

  return null;
}

@protected
Future<ChiTietQuyHoachModel?> _getUrlTraCuuQuyHoachAPI(String thongTin) async {
  final String _url = LocalVariable.urlAPI + '/api/Home/Bot_GetTraCuuQuyHoach';

  final String? json =
      await HttpRequest.instance.postAsync(_url, {'thongTin': thongTin});
  if (json == null) {
    return null;
  }

  final data = jsonDecode(json);
  if (data['result'] != null) {
    final ChiTietQuyHoachModel _result =
        ChiTietQuyHoachModel.fromJson(data['result']);
    return _result;
  }
  return null;
}
