import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:package_chatbot/core/config/local_variable.dart';
import 'package:path/path.dart' as paths;

class HttpRequest {
  static HttpRequest instance = HttpRequest._();
  final int _timeOut = 30000; //30 s
  late Dio _dio;

  void reReg() {
    instance = HttpRequest._();
  }

  HttpRequest._() {
    final BaseOptions options = BaseOptions(
        connectTimeout: _timeOut,
        receiveTimeout: _timeOut,
        baseUrl: LocalVariable.urlAPI,
        contentType: ContentType.json.value,
        responseType: ResponseType.plain);

    _dio = Dio(options);
  }

  Future<String?> getAsync(String url, {Map<String, dynamic>? headers}) async {
    try {
      final Response response = await _dio.get(url,
          options: (headers != null) ? Options(headers: headers) : null);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e);
//      AppCenter.trackEventAsync(
//          'getAsync', <String, String>{'url': url, 'catch': e.toString()});
//       Crashlytics.instance.log(e.message + ' - $url');
      return null;
    }
  }

  Future<String?> postAsync(String url, Map<String, dynamic> param,
      {Map<String, dynamic>? headers}) async {
    try {
      final String jso = jsonEncode(param);
      final Response response = await _dio.post(url,
          data: jso,
          options: (headers != null) ? Options(headers: headers) : null);
      if (response.statusCode == 200) {
        //      String json = Utf8Decoder().convert(response.bodyBytes);
        print(response.data);
        return response.data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e);
      return null;
    }
  }



  Future<String?> download1(String url, savePath, {Function? callBack}) async {
    final CancelToken cancelToken = CancelToken();
    try {
      await _dio.download(url, savePath,
          // onReceiveProgress: callBack,
          cancelToken: cancelToken);
      return savePath;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Another way to downloading small file
  //dowload ftp
  Future<File?> download2(String url,
      {Map<String, dynamic>? param,
      String? filePath,
      Function? callBack}) async {
    try {
      final String jso = jsonEncode(param);
      final Response response = await _dio.post(
        url, data: jso,
        // onReceiveProgress: callBack,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0),
      );
      final File file = File(filePath!);
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<String?> postUploadFile(String url, {List<File>? files}) async {
    try {
      final List<MapEntry<String, MultipartFile>> _uploadData = files!
          .map((e) => MapEntry(
              'files',
              MultipartFile.fromFileSync(e.path,
                  filename: paths.basename(e.path))))
          .toList();
      final Response response = await _dio.post(
        url,
        data: FormData()..files.addAll(_uploadData),
        onSendProgress: (int sent, int total) {
          print('$sent $total');
        },
      );
      if (response.statusCode == 200) return response.data;
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> postUploadFileByte(String url,
      {String? fileName, Uint8List? file}) async {
    try {
      final MapEntry<String, MultipartFile> _uploadData =
          MapEntry('files', MultipartFile.fromBytes(file!, filename: fileName));
      final Response response = await _dio.post(
        url,
        data: FormData()..files.add(_uploadData),
        onSendProgress: (int sent, int total) {
          print('$sent $total');
        },
      );
      if (response.statusCode == 200) return response.data;
      return null;
    } catch (e) {
      return null;
    }
  }
}
