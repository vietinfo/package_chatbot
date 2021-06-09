import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_chatbot/core/model/ds_chu_nang_model.dart';
import 'package:package_chatbot/ui/views/chat/chat_bloc.dart';
import 'package:package_chatbot/ui/widgets/disable_glow_listview.dart';

class ListItems extends StatelessWidget {
  final String userName;
  final List<DanhMucChucNangModels>? _danhMucChucNangModels;
  final ChatBloc _chatBloc;
  final Function(bool isCheckTTHS)? checkTTHS;
  final Function(bool isCheckTTQH)? checkTTQH;
  final Function()? scoll;


  const ListItems(this.userName,this._danhMucChucNangModels, this._chatBloc, this.scoll,{this.checkTTHS, this.checkTTQH});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: DisableGlowListViewCustom(),
      child: (_danhMucChucNangModels != null)
          ? ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _danhMucChucNangModels!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                          FocusScope.of(context).unfocus();
                          if( _danhMucChucNangModels![index].maChucNang! == 'TCTTHS' ){
                            checkTTHS!(true);
                          }else{
                            checkTTHS!(false);
                            _chatBloc.checkHuy.sink.add(false);
                          }
                          if(_danhMucChucNangModels![index].maChucNang! == 'TCTTQH'){
                            checkTTQH!(true);
                            _chatBloc.getAllPhuongXa();
                          }else{
                            checkTTQH!(false);
                            _chatBloc.dsPhuongXa.sink.add([]);
                            _chatBloc.checkHuy.sink.add(false);

                          }
                          scoll!();
                          _chatBloc.sendMessAPI(
                              userName: userName,
                             tinNhan:  _danhMucChucNangModels![index].tenChucNang!,
                              maChucNang:
                                  _danhMucChucNangModels![index].maChucNang!,
                              listDanhMuc:
                                  _danhMucChucNangModels![index].listDanhMuc);

                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: Get.width * 0.125,
                              width: Get.width * 0.125,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(360),
                                child: ExtendedImage.network(
                                  _danhMucChucNangModels![index].imageURL!,
                                  fit: BoxFit.cover,
                                  cache: true,
                                  enableMemoryCache: true,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                  _danhMucChucNangModels![index].tenChucNang!),
                            )),
                          ],
                        ),
                      ),
                      const Divider()
                    ],
                  ),
                );
              })
          : const SizedBox.shrink(),
    );
  }
}
