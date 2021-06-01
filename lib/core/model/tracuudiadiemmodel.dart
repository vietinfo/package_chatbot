class TraCuuDiaDiemModels {
  int? id;
  String? maCoQuan;
  String? tenCoQuan;
  String? soDienThoai;
  String? email;
  String? website;
  String? diaChi;
  double? viDo;
  double? kinhDo;
  double? distance;
  String? maLoaiDanhMuc;
  int? quanHuyenID;
  String? tenQuanHuyen;
  String? ghiChu;
  String? imageURL;

  TraCuuDiaDiemModels(
      {this.id,
      this.maCoQuan,
      this.tenCoQuan,
      this.soDienThoai,
      this.email,
      this.website,
      this.diaChi,
      this.viDo,
      this.kinhDo,
      this.distance,
      this.maLoaiDanhMuc,
      this.quanHuyenID,
      this.tenQuanHuyen,
      this.ghiChu,
      this.imageURL});

  TraCuuDiaDiemModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maCoQuan = json['maCoQuan'];
    tenCoQuan = json['tenCoQuan'];
    soDienThoai = json['soDienThoai'];
    email = json['email'];
    website = json['website'];
    diaChi = json['diaChi'];
    viDo = (json['viDo'] != null) ? json['viDo'] + 0.0 : null;
    kinhDo = (json['kinhDo'] != null) ? json['kinhDo'] + 0.0 : null;
    distance = (json['distance'] != null) ? json['distance'] + 0.0 : null;
    maLoaiDanhMuc = json['maLoaiDanhMuc'];
    quanHuyenID = json['quanHuyenID'];
    tenQuanHuyen = json['tenQuanHuyen'];
    ghiChu = json['ghiChu'];
    imageURL = json['imageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['maCoQuan'] = maCoQuan;
    data['tenCoQuan'] = tenCoQuan;
    data['soDienThoai'] = soDienThoai;
    data['email'] = email;
    data['website'] = website;
    data['diaChi'] = diaChi;
    data['viDo'] = viDo;
    data['kinhDo'] = kinhDo;
    data['distance'] = distance;
    data['maLoaiDanhMuc'] = maLoaiDanhMuc;
    data['quanHuyenID'] = quanHuyenID;
    data['tenQuanHuyen'] = tenQuanHuyen;
    data['ghiChu'] = ghiChu;
    data['imageURL'] = imageURL;
    return data;
  }
}
