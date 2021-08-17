part of 'chitietthutuc_bloc.dart';

Future<ChiTietThuTucModel?> _chiTietThuTucAPI({int? thuTucID}) async {
  final String _url =
      LocalVariable.urlAPI + '/api/Home/ChiTietThuTuc/$thuTucID';

  final String? json = await HttpRequest.instance.getAsync(_url);
  if (json == null) return null;
  final data = jsonDecode(json);
  ChiTietThuTucModel _data = ChiTietThuTucModel();
  if (data['result'] != null) {
    _data = ChiTietThuTucModel.fromJson(data['result']);
    return _data;
  }
  return null;
}

@protected
Future<String?> downLoadFile(String url, String filePath) async {
  try {
    return await HttpRequest.instance.download1(url, filePath);
  } catch (e) {
    print(e);
    return 'Lỗi';
  }
}
