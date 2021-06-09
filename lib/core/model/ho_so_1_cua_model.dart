class HoSo1CuaModel{
  String? diaChiDangKy;
  int? donViNhanID;
  int? dungOrTre;
  bool? goiDonViNgoaiHeThong;
  int? hoSoID;
  int? hoSoOnlineID;
  int? linhVucID;
  int? loaiID;
  String? maTraCuu;
  String? ngayBaoCao;
  String? ngayHenTra;
  String? ngayHoanTatHoSo;
  String? ngayHoanTatHoSoExcel;
  String? ngayNhan;
  String? ngayThucTra;
  String? nguoiDungTenHoSo;
  String? noiDungKhac;
  int? stt;
  String? soBienNhan;
  String? soVanBan;
  String? tenDonVi;
  String? tenDonViNgay;
  String? tenDuongDi;
  String? tenLinhVuc;
  String? tenThuTuc;
  String? thongTinLienLac;
  String? tinhTrangHoSo;
  String? trichYeu;

  HoSo1CuaModel(
      {

        //------tra cuu bien nhan
        this.diaChiDangKy,
        this.donViNhanID,
        this.dungOrTre,
        this.goiDonViNgoaiHeThong,
        this.hoSoID,
        this.hoSoOnlineID,
        this.linhVucID,
        this.loaiID,
        this.maTraCuu,
        this.ngayBaoCao,
        this.ngayHenTra,
        this.ngayHoanTatHoSo,
        this.ngayHoanTatHoSoExcel,
        this.ngayNhan,
        this.ngayThucTra,
        this.nguoiDungTenHoSo,
        this.noiDungKhac,
        this.stt,
        this.soBienNhan,
        this.soVanBan,
        this.tenDonVi,
        this.tenDonViNgay,
        this.tenDuongDi,
        this.tenLinhVuc,
        this.tenThuTuc,
        this.thongTinLienLac,
        this.tinhTrangHoSo,
        this.trichYeu,
        //-----------------


      });


  HoSo1CuaModel.fromJson(Map<String, dynamic> json) {


    //------tra cuu bien nhan
    diaChiDangKy = json['diaChiDangKy'];
    donViNhanID = json['donViNhanID'];
    dungOrTre = json['dungOrTre'];
    goiDonViNgoaiHeThong = json['goiDonViNgoaiHeThong'];
    hoSoID = json['hoSoID'];
    hoSoOnlineID = json['hoSoOnlineID'];
    linhVucID = json['linhVucID'];
    loaiID = json['loaiID'];
    maTraCuu = json['maTraCuu'];
    ngayBaoCao = json['ngayBaoCao'];
    ngayHenTra = json['ngayHenTra'];
    ngayHoanTatHoSo = json['ngayHoanTatHoSo'];
    ngayHoanTatHoSoExcel = json['ngayHoanTatHoSoExcel'];
    ngayNhan = json['ngayNhan'];
    ngayThucTra = json['ngayThucTra'];
    nguoiDungTenHoSo = json['nguoiDungTenHoSo'];
    noiDungKhac = json['noiDungKhac'];
    stt = json['stt'];
    soBienNhan = json['soBienNhan'];
    soVanBan = json['soVanBan'];
    tenDonVi = json['tenDonVi'];
    tenDonViNgay = json['tenDonVi_Ngay'];
    tenDuongDi = json['tenDuongDi'];
    tenLinhVuc = json['tenLinhVuc'];
    tenThuTuc = json['tenThuTuc'];
    thongTinLienLac = json['thongTinLienLac'];
    tinhTrangHoSo = json['tinhTrangHoSo'];
    trichYeu = json['trichYeu'];
    //-----------------


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //------tra cuu bien nhan
    data['diaChiDangKy'] = diaChiDangKy;
    data['donViNhanID'] = donViNhanID;
    data['dungOrTre'] = dungOrTre;
    data['goiDonViNgoaiHeThong'] = goiDonViNgoaiHeThong;
    data['hoSoID'] = hoSoID;
    data['hoSoOnlineID'] = hoSoOnlineID;
    data['linhVucID'] = linhVucID;
    data['loaiID'] = loaiID;
    data['maTraCuu'] = maTraCuu;
    data['ngayBaoCao'] = ngayBaoCao;
    data['ngayHenTra'] = ngayHenTra;
    data['ngayHoanTatHoSo'] = ngayHoanTatHoSo;
    data['ngayHoanTatHoSoExcel'] = ngayHoanTatHoSoExcel;
    data['ngayNhan'] = ngayNhan;
    data['ngayThucTra'] = ngayThucTra;
    data['nguoiDungTenHoSo'] = nguoiDungTenHoSo;
    data['noiDungKhac'] = noiDungKhac;
    data['stt'] = stt;
    data['soBienNhan'] = soBienNhan;
    data['soVanBan'] = soVanBan;
    data['tenDonVi'] = tenDonVi;
    data['tenDonVi_Ngay'] = tenDonViNgay;
    data['tenDuongDi'] = tenDuongDi;
    data['tenLinhVuc'] = tenLinhVuc;
    data['tenThuTuc'] = tenThuTuc;
    data['thongTinLienLac'] = thongTinLienLac;
    data['tinhTrangHoSo'] = tinhTrangHoSo;
    data['trichYeu'] = trichYeu;
    //-----------------

    return data;
  }

}