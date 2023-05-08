class Bill {
  Bill(this.noi_dung, this.tien, this.ghi_chu, this.ngay, this.id);

  final String noi_dung;
  final int tien;
  final String ghi_chu;
  final String ngay;
  final String id;

  String get date => ngay;

  String get loai => noi_dung;
  Map<String, dynamic> toMap() {
    return {
      'noi_dung': noi_dung,
      'tien': tien,
      'ghi_chu': ghi_chu,
      'ngay': ngay,
      'id': id,
    };
  }
}
