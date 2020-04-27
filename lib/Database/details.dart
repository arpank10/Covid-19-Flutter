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
