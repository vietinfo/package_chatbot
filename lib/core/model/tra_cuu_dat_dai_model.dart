/// receiveDate : 1620887400000
/// statusName : "Hoàn thành"
/// attachedDocuments : [{"id":119705426,"numberOfOriginals":1,"numberOfCopies":0,"name":"Giấy chứng nhận","numberOfPhotos":0},{"id":119705427,"numberOfOriginals":1,"numberOfCopies":0,"name":"Trang bổ sung GCN","numberOfPhotos":0},{"id":119705428,"numberOfOriginals":1,"numberOfCopies":0,"name":"Hợp đồng thế chấp","numberOfPhotos":0},{"id":119705429,"numberOfOriginals":1,"numberOfCopies":0,"name":"Giấy ủy quyền","numberOfPhotos":0},{"id":119705430,"numberOfOriginals":1,"numberOfCopies":0,"name":"Đơn yêu cầu đăng ký thế chấp","numberOfPhotos":0}]
/// finishDate : "14/05/2021"
/// fieldCode : "CN03"
/// addressDetail : {"numberNo":"","wardCode":"27577","districtName":"Huyện Hóc Môn","districtCode":"784","wardName":"Xã Xuân Thới Sơn","streetName":"","streetCode":"","quarter":""}
/// agencyName : ""
/// appointDate : 1620979245265
/// content : ""
/// address : "Xã Xuân Thới Sơn, Huyện Hóc Môn, TP Hồ Chí Minh"
/// recordTypeCode : "CN0304"
/// treeJobCycle : {"processer":"BP.TNHS H Hóc Môn","receiveDate":"13/05/2021 13:32","processContent":"N/A","children":[{"processer":"Chi nhánh VPĐKSDĐ VPĐK Huyện Hóc Môn","receiveDate":"13/05/2021 17:40","processContent":"N/A","children":[{"processer":"Cán bộ trả kết quả Huyện Hóc Môn","receiveDate":"14/05/2021 16:42","processContent":"N/A","processOrg":"UBND H.Hóc Môn - Văn phòng đăng ký Huyện Hóc Môn","roleName":"Bộ Phận Trả Hồ Sơ","processDate":"14/05/2021 16:50"}],"processOrg":"UBND H.Hóc Môn - Văn phòng đăng ký Huyện Hóc Môn","roleName":"Chuyên viên","processDate":"14/05/2021 16:42"}],"processOrg":"UBND H.Hóc Môn - Văn phòng đăng ký Huyện Hóc Môn","roleName":"Bộ phận tiếp nhận hồ sơ","processDate":"13/05/2021 17:40"}
/// unitName : "Huyện Hóc Môn"
/// fullName : "NGUYỄN HẢI KHANH"
/// fieldName : "Giao dịch đảm bảo (Cá nhân)"
/// receiptNumber : "27577.120.21.012715"
/// recordTypeName : "Thế chấp"

class TraCuuDatDaiModel {
  int? _receiveDate;
  String? _statusName;
  List<AttachedDocuments>? _attachedDocuments;
  String? _finishDate;
  String? _fieldCode;
  AddressDetail? _addressDetail;
  String? _agencyName;
  int? _appointDate;
  String? _content;
  String? _address;
  String? _recordTypeCode;
  TreeJobCycle? _treeJobCycle;
  String? _unitName;
  String? _fullName;
  String? _fieldName;
  String? _receiptNumber;
  String? _recordTypeName;

  int? get receiveDate => _receiveDate;
  String? get statusName => _statusName;
  List<AttachedDocuments>? get attachedDocuments => _attachedDocuments;
  String? get finishDate => _finishDate;
  String? get fieldCode => _fieldCode;
  AddressDetail? get addressDetail => _addressDetail;
  String? get agencyName => _agencyName;
  int? get appointDate => _appointDate;
  String? get content => _content;
  String? get address => _address;
  String? get recordTypeCode => _recordTypeCode;
  TreeJobCycle? get treeJobCycle => _treeJobCycle;
  String? get unitName => _unitName;
  String? get fullName => _fullName;
  String? get fieldName => _fieldName;
  String? get receiptNumber => _receiptNumber;
  String? get recordTypeName => _recordTypeName;

  TraCuuDatDaiModel(
      {int? receiveDate,
      String? statusName,
      List<AttachedDocuments>? attachedDocuments,
      String? finishDate,
      String? fieldCode,
      AddressDetail? addressDetail,
      String? agencyName,
      int? appointDate,
      String? content,
      String? address,
      String? recordTypeCode,
      TreeJobCycle? treeJobCycle,
      String? unitName,
      String? fullName,
      String? fieldName,
      String? receiptNumber,
      String? recordTypeName}) {
    _receiveDate = receiveDate;
    _statusName = statusName;
    _attachedDocuments = attachedDocuments;
    _finishDate = finishDate;
    _fieldCode = fieldCode;
    _addressDetail = addressDetail;
    _agencyName = agencyName;
    _appointDate = appointDate;
    _content = content;
    _address = address;
    _recordTypeCode = recordTypeCode;
    _treeJobCycle = treeJobCycle;
    _unitName = unitName;
    _fullName = fullName;
    _fieldName = fieldName;
    _receiptNumber = receiptNumber;
    _recordTypeName = recordTypeName;
  }

  TraCuuDatDaiModel.fromJson(dynamic json) {
    _receiveDate = json["receiveDate"];
    _statusName = json["statusName"];
    if (json["attachedDocuments"] != null) {
      _attachedDocuments = [];
      json["attachedDocuments"].forEach((v) {
        _attachedDocuments?.add(AttachedDocuments.fromJson(v));
      });
    }
    _finishDate = json["finishDate"];
    _fieldCode = json["fieldCode"];
    _addressDetail = json["addressDetail"] != null
        ? AddressDetail.fromJson(json["addressDetail"])
        : null;
    _agencyName = json["agencyName"];
    _appointDate = json["appointDate"];
    _content = json["content"];
    _address = json["address"];
    _recordTypeCode = json["recordTypeCode"];
    _treeJobCycle = json["treeJobCycle"] != null
        ? TreeJobCycle.fromJson(json["treeJobCycle"])
        : null;
    _unitName = json["unitName"];
    _fullName = json["fullName"];
    _fieldName = json["fieldName"];
    _receiptNumber = json["receiptNumber"];
    _recordTypeName = json["recordTypeName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["receiveDate"] = _receiveDate;
    map["statusName"] = _statusName;
    if (_attachedDocuments != null) {
      map["attachedDocuments"] =
          _attachedDocuments?.map((v) => v.toJson()).toList();
    }
    map["finishDate"] = _finishDate;
    map["fieldCode"] = _fieldCode;
    if (_addressDetail != null) {
      map["addressDetail"] = _addressDetail?.toJson();
    }
    map["agencyName"] = _agencyName;
    map["appointDate"] = _appointDate;
    map["content"] = _content;
    map["address"] = _address;
    map["recordTypeCode"] = _recordTypeCode;
    if (_treeJobCycle != null) {
      map["treeJobCycle"] = _treeJobCycle?.toJson();
    }
    map["unitName"] = _unitName;
    map["fullName"] = _fullName;
    map["fieldName"] = _fieldName;
    map["receiptNumber"] = _receiptNumber;
    map["recordTypeName"] = _recordTypeName;
    return map;
  }
}

/// processer : "BP.TNHS H Hóc Môn"
/// receiveDate : "13/05/2021 13:32"
/// processContent : "N/A"
/// children : [{"processer":"Chi nhánh VPĐKSDĐ VPĐK Huyện Hóc Môn","receiveDate":"13/05/2021 17:40","processContent":"N/A","children":[{"processer":"Cán bộ trả kết quả Huyện Hóc Môn","receiveDate":"14/05/2021 16:42","processContent":"N/A","processOrg":"UBND H.Hóc Môn - Văn phòng đăng ký Huyện Hóc Môn","roleName":"Bộ Phận Trả Hồ Sơ","processDate":"14/05/2021 16:50"}],"processOrg":"UBND H.Hóc Môn - Văn phòng đăng ký Huyện Hóc Môn","roleName":"Chuyên viên","processDate":"14/05/2021 16:42"}]
/// processOrg : "UBND H.Hóc Môn - Văn phòng đăng ký Huyện Hóc Môn"
/// roleName : "Bộ phận tiếp nhận hồ sơ"
/// processDate : "13/05/2021 17:40"

class TreeJobCycle {
  String? _processer;
  String? _receiveDate;
  String? _processContent;
  List<Children>? _children;
  String? _processOrg;
  String? _roleName;
  String? _processDate;

  String? get processer => _processer;
  String? get receiveDate => _receiveDate;
  String? get processContent => _processContent;
  List<Children>? get children => _children;
  String? get processOrg => _processOrg;
  String? get roleName => _roleName;
  String? get processDate => _processDate;

  TreeJobCycle(
      {String? processer,
      String? receiveDate,
      String? processContent,
      List<Children>? children,
      String? processOrg,
      String? roleName,
      String? processDate}) {
    _processer = processer;
    _receiveDate = receiveDate;
    _processContent = processContent;
    _children = children;
    _processOrg = processOrg;
    _roleName = roleName;
    _processDate = processDate;
  }

  TreeJobCycle.fromJson(dynamic json) {
    _processer = json["processer"];
    _receiveDate = json["receiveDate"];
    _processContent = json["processContent"];
    if (json["children"] != null) {
      _children = [];
      json["children"].forEach((v) {
        _children?.add(Children.fromJson(v));
      });
    }
    _processOrg = json["processOrg"];
    _roleName = json["roleName"];
    _processDate = json["processDate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["processer"] = _processer;
    map["receiveDate"] = _receiveDate;
    map["processContent"] = _processContent;
    if (_children != null) {
      map["children"] = _children?.map((v) => v.toJson()).toList();
    }
    map["processOrg"] = _processOrg;
    map["roleName"] = _roleName;
    map["processDate"] = _processDate;
    return map;
  }
}

/// processer : "Chi nhánh VPĐKSDĐ VPĐK Huyện Hóc Môn"
/// receiveDate : "13/05/2021 17:40"
/// processContent : "N/A"
/// children : [{"processer":"Cán bộ trả kết quả Huyện Hóc Môn","receiveDate":"14/05/2021 16:42","processContent":"N/A","processOrg":"UBND H.Hóc Môn - Văn phòng đăng ký Huyện Hóc Môn","roleName":"Bộ Phận Trả Hồ Sơ","processDate":"14/05/2021 16:50"}]
/// processOrg : "UBND H.Hóc Môn - Văn phòng đăng ký Huyện Hóc Môn"
/// roleName : "Chuyên viên"
/// processDate : "14/05/2021 16:42"

class Children {
  String? _processer;
  String? _receiveDate;
  String? _processContent;
  List<Children>? _children;
  String? _processOrg;
  String? _roleName;
  String? _processDate;

  String? get processer => _processer;
  String? get receiveDate => _receiveDate;
  String? get processContent => _processContent;
  List<Children>? get children => _children;
  String? get processOrg => _processOrg;
  String? get roleName => _roleName;
  String? get processDate => _processDate;

  Children(
      {String? processer,
      String? receiveDate,
      String? processContent,
      List<Children>? children,
      String? processOrg,
      String? roleName,
      String? processDate}) {
    _processer = processer;
    _receiveDate = receiveDate;
    _processContent = processContent;
    _children = children;
    _processOrg = processOrg;
    _roleName = roleName;
    _processDate = processDate;
  }

  Children.fromJson(dynamic json) {
    _processer = json["processer"];
    _receiveDate = json["receiveDate"];
    _processContent = json["processContent"];
    if (json["children"] != null) {
      _children = [];
      json["children"].forEach((v) {
        _children?.add(Children.fromJson(v));
      });
    }
    _processOrg = json["processOrg"];
    _roleName = json["roleName"];
    _processDate = json["processDate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["processer"] = _processer;
    map["receiveDate"] = _receiveDate;
    map["processContent"] = _processContent;
    if (_children != null) {
      map["children"] = _children?.map((v) => v.toJson()).toList();
    }
    map["processOrg"] = _processOrg;
    map["roleName"] = _roleName;
    map["processDate"] = _processDate;
    return map;
  }
}

/// processer : "Cán bộ trả kết quả Huyện Hóc Môn"
/// receiveDate : "14/05/2021 16:42"
/// processContent : "N/A"
/// processOrg : "UBND H.Hóc Môn - Văn phòng đăng ký Huyện Hóc Môn"
/// roleName : "Bộ Phận Trả Hồ Sơ"
/// processDate : "14/05/2021 16:50"

/// numberNo : ""
/// wardCode : "27577"
/// districtName : "Huyện Hóc Môn"
/// districtCode : "784"
/// wardName : "Xã Xuân Thới Sơn"
/// streetName : ""
/// streetCode : ""
/// quarter : ""

class AddressDetail {
  String? _numberNo;
  String? _wardCode;
  String? _districtName;
  String? _districtCode;
  String? _wardName;
  String? _streetName;
  String? _streetCode;
  String? _quarter;

  String? get numberNo => _numberNo;
  String? get wardCode => _wardCode;
  String? get districtName => _districtName;
  String? get districtCode => _districtCode;
  String? get wardName => _wardName;
  String? get streetName => _streetName;
  String? get streetCode => _streetCode;
  String? get quarter => _quarter;

  AddressDetail(
      {String? numberNo,
      String? wardCode,
      String? districtName,
      String? districtCode,
      String? wardName,
      String? streetName,
      String? streetCode,
      String? quarter}) {
    _numberNo = numberNo;
    _wardCode = wardCode;
    _districtName = districtName;
    _districtCode = districtCode;
    _wardName = wardName;
    _streetName = streetName;
    _streetCode = streetCode;
    _quarter = quarter;
  }

  AddressDetail.fromJson(dynamic json) {
    _numberNo = json["numberNo"];
    _wardCode = json["wardCode"];
    _districtName = json["districtName"];
    _districtCode = json["districtCode"];
    _wardName = json["wardName"];
    _streetName = json["streetName"];
    _streetCode = json["streetCode"];
    _quarter = json["quarter"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["numberNo"] = _numberNo;
    map["wardCode"] = _wardCode;
    map["districtName"] = _districtName;
    map["districtCode"] = _districtCode;
    map["wardName"] = _wardName;
    map["streetName"] = _streetName;
    map["streetCode"] = _streetCode;
    map["quarter"] = _quarter;
    return map;
  }
}

/// id : 119705426
/// numberOfOriginals : 1
/// numberOfCopies : 0
/// name : "Giấy chứng nhận"
/// numberOfPhotos : 0

class AttachedDocuments {
  int? _id;
  int? _numberOfOriginals;
  int? _numberOfCopies;
  String? _name;
  int? _numberOfPhotos;

  int? get id => _id;
  int? get numberOfOriginals => _numberOfOriginals;
  int? get numberOfCopies => _numberOfCopies;
  String? get name => _name;
  int? get numberOfPhotos => _numberOfPhotos;

  AttachedDocuments(
      {int? id,
      int? numberOfOriginals,
      int? numberOfCopies,
      String? name,
      int? numberOfPhotos}) {
    _id = id;
    _numberOfOriginals = numberOfOriginals;
    _numberOfCopies = numberOfCopies;
    _name = name;
    _numberOfPhotos = numberOfPhotos;
  }

  AttachedDocuments.fromJson(dynamic json) {
    _id = json["id"];
    _numberOfOriginals = json["numberOfOriginals"];
    _numberOfCopies = json["numberOfCopies"];
    _name = json["name"];
    _numberOfPhotos = json["numberOfPhotos"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["numberOfOriginals"] = _numberOfOriginals;
    map["numberOfCopies"] = _numberOfCopies;
    map["name"] = _name;
    map["numberOfPhotos"] = _numberOfPhotos;
    return map;
  }
}
