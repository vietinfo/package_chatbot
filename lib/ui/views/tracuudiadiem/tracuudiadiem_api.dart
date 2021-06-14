part of 'tracuudiadiem_bloc.dart';

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
    'lat':lat,
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
