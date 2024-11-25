class Article {
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String summary;
  final String publishedAt;

  Article({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.summary,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      imageUrl: json['image_url'],
      summary: json['summary'],
      publishedAt: json['published_at'],
    );
  }
}