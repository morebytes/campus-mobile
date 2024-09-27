// Requirements:
// 1. Only use nullable (?) for data that is optional. Use required params for all others.
// 2. If every field and/or title empty, then throw exception in Model class when analyzing the JSON data

// JSON Data Shape:
// {
//   title: "My Card", // error: must have title or if every field empty, then error: not a valid web card model
//   image_link: "jhasdlkjfdsj", // can be null
//   video_link: "asdfkjlasdjklf", // can be null
//   image_caption: "Accesibility friendly!", // optional, for accessibility
//   regular_links: [
//     { "Caption1" : "dsjflkasdf" }, // captions for accessibility
//     { "Caption2" : "dsjflkasdf" },
//     { "Caption3" : "dsjflkasdf" },
//   ]
// }

// WebCardModel webCardModelFromJson(String str) =>

// TODO: use records instead after we upgrade to Dart 3
class WebCardImageData
{
  String image_link;
  String caption;
  String? video_link; // optional, for static image

  WebCardImageData({
    required this.image_link,
    required this.caption,
    this.video_link
  });
}

// TODO: use records instead after we upgrade to Dart 3
class WebCardLinkPair
{
  String caption;
  String link;

  WebCardLinkPair({
    required this.caption,
    required this.link
  });
}

class WebCardModel
{
  String title;
  WebCardImageData? image_data;
  List<WebCardLinkPair> links;

  WebCardModel({
    required this.title,
    this.image_data,
    required this.links
  });
}

// If we had records!
//
// class WebCardModel
// {
//   String title;
//   (String imgLink, String caption, String vidLink)? image_data;
//   List<(String caption, String link)> links;
//
//   WebCardModel({
//     required this.title,
//     this.image_data,
//     required this.links
//   });
// }