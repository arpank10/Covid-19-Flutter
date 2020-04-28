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
