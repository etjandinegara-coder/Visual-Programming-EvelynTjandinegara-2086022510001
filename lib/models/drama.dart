enum WatchStatus {
  watching('Watching'),
  finished('Finished'),
  backlog('Backlog');

  const WatchStatus(this.label);

  final String label;
}

class Drama {
  const Drama({
    required this.id,
    required this.title,
    required this.genre,
    required this.status,
    required this.totalEpisodes,
    required this.watchedEpisodes,
    required this.minutesPerEpisode,
    this.tropes = const [],
    this.seasonRatings = const [],
  });

  final String id;
  final String title;
  final String genre;
  final WatchStatus status;
  final int totalEpisodes;
  final int watchedEpisodes;
  final int minutesPerEpisode;
  final List<String> tropes;
  final List<double> seasonRatings;

  int get episodesLeft => totalEpisodes - watchedEpisodes;

  int get watchedMinutes => watchedEpisodes * minutesPerEpisode;

  double get progress =>
      totalEpisodes == 0 ? 0 : watchedEpisodes / totalEpisodes;

  double get averageRating {
    if (seasonRatings.isEmpty) return 0;
    final sum = seasonRatings.reduce((a, b) => a + b);
    return sum / seasonRatings.length;
  }

  Drama copyWith({
    String? title,
    String? genre,
    WatchStatus? status,
    int? totalEpisodes,
    int? watchedEpisodes,
    int? minutesPerEpisode,
    List<String>? tropes,
    List<double>? seasonRatings,
  }) {
    return Drama(
      id: id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      status: status ?? this.status,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      watchedEpisodes: watchedEpisodes ?? this.watchedEpisodes,
      minutesPerEpisode: minutesPerEpisode ?? this.minutesPerEpisode,
      tropes: tropes ?? this.tropes,
      seasonRatings: seasonRatings ?? this.seasonRatings,
    );
  }
}