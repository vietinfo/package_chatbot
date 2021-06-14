part of 'chat_bloc.dart';

@protected
Future<List<DanhMucChucNangModels>?> _getAllDSChuNangAPI() async {

  try {
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
  } catch (e) {
    print(e);
  }

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

  try {
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
  } catch (e) {
    print(e);
  }


}

@protected
Future<List<BotMessage>?> _sendChatBot({String? tinNhan, String? userName}) async {

  try {
    final String _url = LocalVariable.urlChatBot + '/webhooks/rest/webhook';
    final Map<String, dynamic> parms = {
      'sender': userName,
      'message': tinNhan,
    };

    final String? json = await HttpRequest.instance.postAsync(_url, parms);
    List<BotMessage> _temp = <BotMessage>[];
    if (json != null) {
      final data = jsonDecode(json) as List;
      _temp = data.map((tagJson) => BotMessage.fromJson(tagJson)).toList();
    }
    return _temp;
  } catch (e) {
    print(e);
  }


}

@protected
Future<List<TraCuuTTHCmodel>?> _getLinhVucTucHanhChinhAPI() async {

  try {
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
  } catch (e) {
    print(e);
  }


}

@protected
Future<List<TraCuuTTHCmodel>?> _getDanhSachThuTucHanhChinhTheoAPI(
    int linhVucID) async {
  try {
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
  } catch (e) {
    print(e);
  }


}

@protected
Future<HoSo1CuaModel?> _traCuuHoSo1CuaAPI(String soBienNhan) async {


  try {
    final String _url =
        LocalVariable.urlAPI + '/api/Home/TraCuuHoSo1Cua/$soBienNhan';

    final String? json = await HttpRequest.instance.getAsync(_url);
    if (json == null) {
      return null;
    }
    final data = jsonDecode(json);

    if (data['result'] != null) {
      final HoSo1CuaModel _result = HoSo1CuaModel.fromJson(data['result']);

      return _result;
    }

    return null;
  } catch (e) {
    print(e);
  }


}

@protected
Future<HoSoDatDaiModel?> _traCuuHoSoDatDaiAPI(String maHoSo) async {


  try {
    final String _url =
        LocalVariable.urlAPI + '/api/Home/TraCuuHoSoDatDai/$maHoSo';

    final String? json = await HttpRequest.instance.getAsync(_url);
    if (json == null) {
      return null;
    }
    final data = jsonDecode(json);

    if (data['result'] != null) {
      final HoSoDatDaiModel _result = HoSoDatDaiModel.fromJson(data['result']);

      return _result;
    }

    return null;
  } catch (e) {
    print(e);
  }

}

@protected
Future<List<PhuongXaModel>?> _getAllPhuongXaAPI() async {

  try {
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
  } catch (e) {
    print(e);
  }


}

@protected
Future<ChiTietQuyHoachModel?> _getUrlTraCuuQuyHoachAPI(String thongTin) async {

  try {
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
  } catch (e) {
    print(e);
  }

}

@protected
Future<List<ChatModel>?> _getAllHistoryChat(
    String userName, int pageNum) async {

  try {
    final String _url = LocalVariable.urlAPI + '/api/Home/GetAllHistoryChat';

    final Map<String, dynamic> parms = {
      'userName': userName,
      'pageIndex': pageNum,
    };

    final String? json = await HttpRequest.instance.postAsync(_url, parms);
    if (json == null) {
      return null;
    }

    final data = jsonDecode(json);
    List<ChatModel> _listData = <ChatModel>[];
    if (data['result'] != null) {
      final result = data['result'] as List;
      _listData = result.map((tagJson) => ChatModel.fromJson(tagJson)).toList();
      return _listData;
    }
    return null;
  } catch (e) {
    print(e);
  }


}

@protected
Future<bool?> _insertHistoryChat(var param) async {

  try {
    final String _url = LocalVariable.urlAPI + '/api/Home/InsertHistoryChat';

    final String? json = await HttpRequest.instance.postAsync(_url, param);
    if (json == null) {
      return false;
    }

    final data = jsonDecode(json);
    if (data['result'] != null) {
      return true;
    }
    return false;
  } catch (e) {
    print(e);
  }


}
