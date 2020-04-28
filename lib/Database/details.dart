class Link{
  String text;
  String url;

  Link(String text, String url){
    this.text = text;
    this.url = url;
  }

  factory Link.fromJson(dynamic json) {
    String text = json['text'];
    String url = json['url'];
    Link link = new Link(text, url);
    return link;
  }
}

class Precaution{
  String text;
  String image;
  String description;

  Precaution(String text, String image, String description){
    this.text = text;
    this.image = image;
    this.description = description;
  }

  factory Precaution.fromJson(dynamic json) {
    String text = json['title'];
    String image = json['image'];
    String description = json['description'];
    Precaution precaution = new Precaution(text, image, description);
    return precaution;
  }
}

class Helpline {
  String title;
  String number;
  String cc;

  Helpline(String title, String number, String cc){
    this.title = title;
    this.number = number;
    this.cc = cc;
  }

  factory Helpline.fromJson(dynamic json) {
    String title = json['title'];
    String number = json['number'];
    String cc = json['cc'];
    Helpline helpline = new Helpline(title, number, cc);
    return helpline;
  }
}
