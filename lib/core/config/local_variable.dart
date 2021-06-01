class LocalVariable {
  factory LocalVariable() {
    return instance;
  }
   const LocalVariable._();

  static const LocalVariable instance =  LocalVariable._();


  String get apikey => 'APIKey';
  int get quanHuyenID => 11243;
  String get tenQuanHuyen => 'Huyện Hóc Môn';

  ///link local
  String get urlAPI => 'http://demo.vietinfo.tech:8090';
  // final String urlAPI = 'http://192.168.1.125:7412';
  String get urlChatBot => 'http://chatbot.vietinfo.tech:8088';
}
