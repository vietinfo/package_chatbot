class PhuongXaModel {
  int? id;
  int? phuongID;
  String? tenPhuong;
  String? maPhuongXa;
  String? maPhuong;

  PhuongXaModel(
      {this.id, this.phuongID, this.tenPhuong, this.maPhuongXa, this.maPhuong});

  PhuongXaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phuongID = json['phuongID'];
    tenPhuong = json['tenPhuong'];
    maPhuongXa = json['maPhuongXa'];
    maPhuong = json['maPhuong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phuongID'] = phuongID;
    data['tenPhuong'] = tenPhuong;
    data['maPhuongXa'] = maPhuongXa;
    data['maPhuong'] = maPhuong;
    return data;
  }
}