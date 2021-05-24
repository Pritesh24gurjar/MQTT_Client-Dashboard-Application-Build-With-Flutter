class Devices {
  final int id;
  final String title;
  // final String image;
  final String sub;
  final int qos;
  final String retain;
  final String style;
  final String savetext;
  final double min;
  final double max;
  final String saveweb;
  final String savewebclick;
  final String saveRadio;
  Devices({this.id, this.title, this.qos, this.retain, this.sub , this.style,this.savetext,this.min,this.max,this.saveweb,this.savewebclick,this.saveRadio});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'sub': sub,
      'qos': qos,
      'retain': retain,
      'style' : style,
      'savetext' : savetext,
      'min' : min,
      'max' : max,
      'saveweb' : saveweb,
      'savewebclick' : savewebclick,
      'saveRadio' : saveRadio
    };
  }
}
