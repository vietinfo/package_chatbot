class HoSoDatDaiModel {
  int? receiveDate;
  String? statusName;
  List<AttachedDocuments>? attachedDocuments;
  String? finishDate;
  String? fieldCode;
  AddressDetail? addressDetail;
  String? agencyName;
  int? appointDate;
  String? content;
  String? address;
  String? recordTypeCode;
  TreeJobCycle? treeJobCycle;
  String? unitName;
  String? fullName;
  String? fieldName;
  String? receiptNumber;
  String? recordTypeName;

  HoSoDatDaiModel(
      {this.receiveDate,
        this.statusName,
        this.attachedDocuments,
        this.finishDate,
        this.fieldCode,
        this.addressDetail,
        this.agencyName,
        this.appointDate,
        this.content,
        this.address,
        this.recordTypeCode,
        this.treeJobCycle,
        this.unitName,
        this.fullName,
        this.fieldName,
        this.receiptNumber,
        this.recordTypeName});

  HoSoDatDaiModel.fromJson(Map<String, dynamic> json) {
    receiveDate = json['receiveDate'];
    statusName = json['statusName'];
    if (json['attachedDocuments'] != null) {
      attachedDocuments = <AttachedDocuments>[];
      json['attachedDocuments'].forEach((v) {
        attachedDocuments!.add(new AttachedDocuments.fromJson(v));
      });
    }
    finishDate = json['finishDate'];
    fieldCode = json['fieldCode'];
    addressDetail = json['addressDetail'] != null
        ? new AddressDetail.fromJson(json['addressDetail'])
        : null;
    agencyName = json['agencyName'];
    appointDate = json['appointDate'];
    content = json['content'];
    address = json['address'];
    recordTypeCode = json['recordTypeCode'];
    treeJobCycle = json['treeJobCycle'] != null
        ? new TreeJobCycle.fromJson(json['treeJobCycle'])
        : null;
    unitName = json['unitName'];
    fullName = json['fullName'];
    fieldName = json['fieldName'];
    receiptNumber = json['receiptNumber'];
    recordTypeName = json['recordTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiveDate'] = this.receiveDate;
    data['statusName'] = this.statusName;
    if (this.attachedDocuments != null) {
      data['attachedDocuments'] =
          this.attachedDocuments!.map((v) => v.toJson()).toList();
    }
    data['finishDate'] = this.finishDate;
    data['fieldCode'] = this.fieldCode;
    if (this.addressDetail != null) {
      data['addressDetail'] = this.addressDetail!.toJson();
    }
    data['agencyName'] = this.agencyName;
    data['appointDate'] = this.appointDate;
    data['content'] = this.content;
    data['address'] = this.address;
    data['recordTypeCode'] = this.recordTypeCode;
    if (this.treeJobCycle != null) {
      data['treeJobCycle'] = this.treeJobCycle!.toJson();
    }
    data['unitName'] = this.unitName;
    data['fullName'] = this.fullName;
    data['fieldName'] = this.fieldName;
    data['receiptNumber'] = this.receiptNumber;
    data['recordTypeName'] = this.recordTypeName;
    return data;
  }
}

class AttachedDocuments {
  int? id;
  int? numberOfOriginals;
  int? numberOfCopies;
  String? name;
  int? numberOfPhotos;

  AttachedDocuments(
      {this.id,
        this.numberOfOriginals,
        this.numberOfCopies,
        this.name,
        this.numberOfPhotos});

  AttachedDocuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numberOfOriginals = json['numberOfOriginals'];
    numberOfCopies = json['numberOfCopies'];
    name = json['name'];
    numberOfPhotos = json['numberOfPhotos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['numberOfOriginals'] = this.numberOfOriginals;
    data['numberOfCopies'] = this.numberOfCopies;
    data['name'] = this.name;
    data['numberOfPhotos'] = this.numberOfPhotos;
    return data;
  }
}

class AddressDetail {
  String? numberNo;
  int? wardCode;
  String? districtName;
  int? districtCode;
  String? wardName;
  String? streetName;
  String? streetCode;
  String? quarter;

  AddressDetail(
      {this.numberNo,
        this.wardCode,
        this.districtName,
        this.districtCode,
        this.wardName,
        this.streetName,
        this.streetCode,
        this.quarter});

  AddressDetail.fromJson(Map<String, dynamic> json) {
    numberNo = json['numberNo'];
    wardCode = json['wardCode'];
    districtName = json['districtName'];
    districtCode = json['districtCode'];
    wardName = json['wardName'];
    streetName = json['streetName'];
    streetCode = json['streetCode'];
    quarter = json['quarter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numberNo'] = this.numberNo;
    data['wardCode'] = this.wardCode;
    data['districtName'] = this.districtName;
    data['districtCode'] = this.districtCode;
    data['wardName'] = this.wardName;
    data['streetName'] = this.streetName;
    data['streetCode'] = this.streetCode;
    data['quarter'] = this.quarter;
    return data;
  }
}

class TreeJobCycle {
  String? processer;
  String? receiveDate;
  String? processContent;
  List<Children>? children;
  String? processOrg;
  String? roleName;
  String? processDate;

  TreeJobCycle(
      {this.processer,
        this.receiveDate,
        this.processContent,
        this.children,
        this.processOrg,
        this.roleName,
        this.processDate});

  TreeJobCycle.fromJson(Map<String, dynamic> json) {
    processer = json['processer'];
    receiveDate = json['receiveDate'];
    processContent = json['processContent'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(new Children.fromJson(v));
      });
    }
    processOrg = json['processOrg'];
    roleName = json['roleName'];
    processDate = json['processDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['processer'] = this.processer;
    data['receiveDate'] = this.receiveDate;
    data['processContent'] = this.processContent;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    data['processOrg'] = this.processOrg;
    data['roleName'] = this.roleName;
    data['processDate'] = this.processDate;
    return data;
  }
}

class Children {
  String? processer;
  String? receiveDate;
  String? processContent;
  List<Children>? children;
  String? processOrg;
  String? roleName;
  String? processDate;

  Children(
      {this.processer,
        this.receiveDate,
        this.processContent,
        this.children,
        this.processOrg,
        this.roleName,
        this.processDate});

  Children.fromJson(Map<String, dynamic> json) {
    processer = json['processer'];
    receiveDate = json['receiveDate'];
    processContent = json['processContent'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(new Children.fromJson(v));
      });
    }
    processOrg = json['processOrg'];
    roleName = json['roleName'];
    processDate = json['processDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['processer'] = this.processer;
    data['receiveDate'] = this.receiveDate;
    data['processContent'] = this.processContent;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    data['processOrg'] = this.processOrg;
    data['roleName'] = this.roleName;
    data['processDate'] = this.processDate;
    return data;
  }
}
