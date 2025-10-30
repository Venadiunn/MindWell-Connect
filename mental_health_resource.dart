class MentalHealthResource {
  final String name;
  final String description;
  final String url;
  final List<String> tags;
  final String category;
  final String type;
  final String urgency;
  bool isFavorite;
  int rating;

  MentalHealthResource({
    required this.name,
    required this.description,
    required this.url,
    required this.tags,
    this.category = '',
    this.type = '',
    this.urgency = '',
    this.isFavorite = false,
    this.rating = 0,
  });
}