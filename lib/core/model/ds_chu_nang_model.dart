class DanhMucChucNangModels {
  int? id;
  String? tenChucNang;
  String? maChucNang;
  String?  imageURL;
  List<ListDanhMuc>? listDanhMuc;

  DanhMucChucNangModels({this.id, this.tenChucNang, this.maChucNang,this.imageURL,this.listDanhMuc});

  DanhMucChucNangModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenChucNang = json['tenChucNang'];
    maChucNang = json['maChucNang'];
    imageURL = json['imageURL'];
    if (json['listDanhMuc'] != null) {
      listDanhMuc = <ListDanhMuc>[];
      json['listDanhMuc'].forEach((v) {
        listDanhMuc!.add(ListDanhMuc.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tenChucNang'] = tenChucNang;
    data['maChucNang'] = maChucNang;
    data['imageURL'] = imageURL;
    if (listDanhMuc != null) {
      data['listDanhMuc'] = listDanhMuc!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListDanhMuc {
  String? maLoaiDanhMuc;
  String? tenLoaiDanhMuc;
  String? maChucNang;
  int? nhom;

  ListDanhMuc(
      {this.maLoaiDanhMuc, this.tenLoaiDanhMuc, this.maChucNang, this.nhom});

  ListDanhMuc.fromJson(Map<String, dynamic> json) {
    maLoaiDanhMuc = json['maLoaiDanhMuc'];
    tenLoaiDanhMuc = json['tenLoaiDanhMuc'];
    maChucNang = json['maChucNang'];
    nhom = json['nhom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maLoaiDanhMuc'] = maLoaiDanhMuc;
    data['tenLoaiDanhMuc'] = tenLoaiDanhMuc;
    data['maChucNang'] = maChucNang;
    data['nhom'] = nhom;
    return data;
  }
}