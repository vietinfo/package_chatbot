import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:package_chatbot/core/config/base_bloc.dart';
import 'package:package_chatbot/core/model/chitietthutucmodel.dart';
import 'package:package_chatbot/ui/views/chitietthutuc/chitietthutuc_bloc.dart';
import 'package:package_chatbot/ui/widgets/disable_glow_listview.dart';

class ChiTietThuTucUI extends StatefulWidget {
  @override
  _ChiTietThuTucUIState createState() => _ChiTietThuTucUIState();
}

class _ChiTietThuTucUIState extends State<ChiTietThuTucUI> {
  int? _thuTucID;
  late ChiTietThuTucBloc _chiTietThuTucBloc;
  List<Files>? _files;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chiTietThuTucBloc = BlocProvider.of<ChiTietThuTucBloc>(context);
    final Map data = Map.from(Get.arguments);
    _thuTucID = data['result'];
    _chiTietThuTucBloc.getChiTietThuTuc(_thuTucID!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xff205072),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){
              showBotom(_files!);
            },
            child: Row(
              children:const [
                 Text(
                  'Tài liệu',
                  style: TextStyle(color: Colors.black),
                ),
                Padding(
                  padding:  EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.assignment_outlined,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: StreamBuilder(
                stream: _chiTietThuTucBloc.chiTietThuTuc.stream,
                builder: (context, AsyncSnapshot<ChiTietThuTucModel> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        _files = snapshot.data!.files;
                        return ScrollConfiguration(
                          behavior: DisableGlowListViewCustom(),
                          child: SingleChildScrollView(

                            child: Column(
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(snapshot.data!.tenThuTuc!,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    )),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Html(data: snapshot.data!.moTa!)),
                                ),
                                const SizedBox(height: 50,)
                              ],
                            ),
                          ),
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
                }),
          ),
          // Positioned(
          //     bottom: 0,
          //     child: Container(
          //       height: Get.height * 0.08,
          //       width: Get.width,
          //       color: Colors.grey.withOpacity(0.2),
          //       child: Center(child: Container(
          //           width: Get.width * 0.3,
          //           height: Get.height * 0.05,
          //           decoration: const BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.all(Radius.circular(12)),
          //           ),
          //           child:  Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: const[
          //
          //                Padding(
          //                 padding:  EdgeInsets.only(right: 5),
          //                 child: Icon(
          //                   Icons.insert_drive_file_outlined,
          //                   color: Colors.black,
          //                 ),
          //               ),
          //                Text(
          //                 'Nộp hồ sơ',
          //                 style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          //               ),
          //             ],
          //           ))
          //       ),
          //     ))
        ],
      ),
    );
  }

  Future showBotom(List<Files> files) async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      enableDrag: false,
      builder: (context) => AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            height: Get.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
          child: Column(
            children: [
              const  Padding(
                padding:  EdgeInsets.all(8.0),
                child: Text('Tài liệu đính kèm'),
              ),
              ScrollConfiguration(
                behavior: DisableGlowListViewCustom(),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if(files[index].templateTrong != null){
                                  _chiTietThuTucBloc.downloadFile(files[index].templateTrong!);

                                }else{
                                  Get.back();
                                  Get.snackbar('Thông báo', 'Không có file này');
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  files[index].tenFile ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.black),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    }).paddingOnly(left: 10, right: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
