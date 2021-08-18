import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../chitietthutuc_bloc.dart';
import 'package:path/path.dart';

class DownLoadFile extends StatefulWidget {
  final String? linkFile;

  const DownLoadFile(this.linkFile);

  @override
  _DownLoadFileState createState() => _DownLoadFileState();
}

class _DownLoadFileState extends State<DownLoadFile> {
  final PublishSubject<Map<String, dynamic>> downloadFile =
  PublishSubject<Map<String, dynamic>>();

  final PublishSubject<double> _progress = PublishSubject<double>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: downloadFile.stream,
        builder: (context,
            AsyncSnapshot<Map<String, dynamic>>
            snapshot) {
          if (snapshot.hasData && snapshot.data!['linkFile'] != null)
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(
                          5.0) //                 <--- border radius here
                  ),
                  color: Colors.green),
              //             <--- BoxDecoration here
              child: GestureDetector(
                onTap: () async {
                  await OpenFile.open(
                      snapshot.data!['linkFile']);
                },
                child: Padding(
                  padding:
                  const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Text(
                        'Mở',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.open_in_new,
                        size: 10,
                      )
                    ],
                  ),
                ),
              ),
            ).paddingOnly(right: 20);
          else
            return GestureDetector(
              onTap: () {
                if (widget.linkFile !=
                    null) {
                  _downloadFile();
                } else {
                  // Navigator.pop(context);
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message:
                      'File lỗi hoặc File không tồn tại!!',
                    ),
                  );
                }
              },
              child: Icon(
                Icons.file_download,
              ),
            ).paddingOnly(right: 20);
        });
  }

  Future _downloadFile() async {
    final sysPath = await path_provider.getTemporaryDirectory();
    if (widget.linkFile != null) {
      final _direct = join(
          '${sysPath.path}/HocMon/${path.basename(widget.linkFile!)}');
      final String? data = await downLoadFile(widget.linkFile!, _direct);
      if (data != null) {
        downloadFile.sink.add({'linkFile': _direct,});
      } else {
        downloadFile.sink.add({});
      }
    } else {
      downloadFile.sink.add({});
    }
  }

  Future checkDowloadFile() async {
    final sysPath = await path_provider.getTemporaryDirectory();
    if (widget.linkFile != null) {
      final _direct = join(
          '${sysPath.path}/HocMon/${path.basename(widget.linkFile!)}');
      if (!await File(_direct).exists()) {
        downloadFile.sink.add({});
      } else {
        downloadFile.sink.add({'linkFile': _direct});
      }
    } else {
      downloadFile.sink.add({});
    }
  }

  @override
  void initState() {
    checkDowloadFile();
    super.initState();
  }

  @override
  void dispose() {
    downloadFile.close();
    _progress.close();
    super.dispose();
  }
}
