class TraCuuTTHCmodel {
  int? thuTucID;
  int? linhVucID;
  String? maLinhVuc;
  String? tenLinhVuc;
  String? maThuTuc;
  String? tenThuTuc;
  String? imageURL;
  String? moTaNgan;
  int? thuTuThuTuc;
  int? thuTuLinhVuc;
  bool? isBanVe;
  int? phanLoai;

  TraCuuTTHCmodel(
      {this.thuTucID,
        this.linhVucID,
        this.maLinhVuc,
        this.tenLinhVuc,
        this.maThuTuc,
        this.tenThuTuc,
        this.imageURL,
        this.moTaNgan,
        this.thuTuThuTuc,
        this.thuTuLinhVuc,
        this.isBanVe,
        this.phanLoai});

  TraCuuTTHCmodel.fromJson(Map<String, dynamic> json) {
    thuTucID = json['thuTucID'];
    linhVucID = json['linhVucID'];
    maLinhVuc = json['maLinhVuc'];
    tenLinhVuc = json['tenLinhVuc'];
    maThuTuc = json['maThuTuc'];
    tenThuTuc = json['tenThuTuc'];
    imageURL = json['imageURL'];
    moTaNgan = json['moTaNgan'];
    thuTuThuTuc = json['thuTu_ThuTuc'];
    thuTuLinhVuc = json['thuTu_LinhVuc'];
    isBanVe = json['isBanVe'];
    phanLoai = json['phanLoai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thuTucID'] = thuTucID;
    data['linhVucID'] = linhVucID;
    data['maLinhVuc'] = maLinhVuc;
    data['tenLinhVuc'] = tenLinhVuc;
    data['maThuTuc'] = maThuTuc;
    data['tenThuTuc'] = tenThuTuc;
    data['imageURL'] = imageURL;
    data['moTaNgan'] = moTaNgan;
    data['thuTu_ThuTuc'] = thuTuThuTuc;
    data['thuTu_LinhVuc'] = thuTuLinhVuc;
    data['isBanVe'] = isBanVe;
    data['phanLoai'] = phanLoai;
    return data;
  }
}
