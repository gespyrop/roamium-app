class Review {
  final int? id;
  final int stars;
  final String text;

  Review(this.stars, this.text, {this.id});

  Review.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        stars = json['stars'],
        text = json['text'];

  Map<String, dynamic> toJSON() => {'stars': stars, 'text': text};
}
