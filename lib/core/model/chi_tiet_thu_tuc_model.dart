class ChiTietThuTucModel {
  int? thuTucID;
  String? tenThuTuc;
  String? maThuTuc;
  String? moTa;
  List<Files>? files;

  ChiTietThuTucModel({this.thuTucID, this.tenThuTuc, this.maThuTuc, this.moTa, this.files});

  ChiTietThuTucModel.fromJson(Map<String, dynamic> json) {
    thuTucID = json['thuTucID'];
    tenThuTuc = json['tenThuTuc'];
    maThuTuc = json['maThuTuc'];
    moTa = json['moTa'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thuTucID'] = thuTucID;
    data['tenThuTuc'] = tenThuTuc;
    data['maThuTuc'] = maThuTuc;
    data['moTa'] = moTa;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Files {
  int? id;
  String? maThuTuc;
  int? fileID;
  String? tenFile;
  String? gioiThieu;
  String? templateMau;
  String? templateTrong;
  String? moTaNgan;
  bool? isBanVe;

  Files(
      {this.id,
        this.maThuTuc,
        this.fileID,
        this.tenFile,
        this.gioiThieu,
        this.templateMau,
        this.templateTrong,
        this.moTaNgan,
        this.isBanVe});

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maThuTuc = json['maThuTuc'];
    fileID = json['fileID'];
    tenFile = json['tenFile'];
    gioiThieu = json['gioiThieu'];
    templateMau = json['template_Mau'];
    templateTrong = json['template_Trong'];
    moTaNgan = json['moTaNgan'];
    isBanVe = json['isBanVe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['maThuTuc'] = maThuTuc;
    data['fileID'] = fileID;
    data['tenFile'] = tenFile;
    data['gioiThieu'] = gioiThieu;
    data['template_Mau'] = templateMau;
    data['template_Trong'] = templateTrong;
    data['moTaNgan'] = moTaNgan;
    data['isBanVe'] = isBanVe;
    return data;
  }
}