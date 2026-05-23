class OmdbMovie {
  const OmdbMovie({
    required this.title,
    required this.poster,
  });

  final String title;
  final String poster;

  factory OmdbMovie.fromJson(Map<String, dynamic> json) {
    return OmdbMovie(
      title: json['Title'] as String? ?? 'Sin titulo',
      poster: json['Poster'] as String? ?? '',
    );
  }
}
