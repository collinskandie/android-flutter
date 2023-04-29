class Blog {
  final String title;
  final String description;
  final String image;
  final String date;

  Blog({
    required this.title,
    required this.description,
    required this.image,
    required this.date,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      date: json['date'],
    );
  }
}
