

import 'package:flutter/material.dart';
import 'package:composition_md/data/drama_data.dart';
import 'package:composition_md/models/drama.dart';

// Tepat 200 karakter. Untuk tes "Long text".
const String kLongTitle =
    'Crash Landing on You: The Extended Director Cut With Alternate Endings, '
    'Behind The Scenes Commentary, Deleted Scenes, Cast Interviews, Bloopers, '
    'Soundtrack Special, and Fan Voted Epilogue Episodes Pt2';

final List<Drama> kLongTitleDramas = [
  const Drama(
    id: 'long-title',
    title: kLongTitle,
    genre: 'Romance Comedy Fantasy Thriller Historical Melodrama',
    status: WatchStatus.watching,
    totalEpisodes: 16,
    watchedEpisodes: 3,
    minutesPerEpisode: 60,
    seasonRatings: [9.9],
  ),
  ...kDefaultDramas,
];

// Untuk tes "Long list".
final List<Drama> kBigDramas = List.generate(
  500,
      (i) => Drama(
    id: 'big-$i',
    title: 'Drama ${i + 1}',
    genre: 'Romance',
    status: WatchStatus.values[i % WatchStatus.values.length],
    totalEpisodes: 16,
    watchedEpisodes: i % 17,
    minutesPerEpisode: 60,
    seasonRatings: [5.0 + (i % 50) / 10],
  ),
);

// Harness
enum HarnessDevice {
  small('Small phone', Size(320, 568)),
  large('Large phone', Size(430, 932)),
  tablet('Tablet', Size(800, 1280));

  const HarnessDevice(this.label, this.size);

  final String label;
  final Size size;
}

enum HarnessData {
  normal('Normal'),
  longTitle('200-char title'),
  empty('Zero items'),
  big('500 items');

  const HarnessData(this.label);

  final String label;

  List<Drama> get dramas => switch (this) {
    HarnessData.normal => kDefaultDramas,
    HarnessData.longTitle => kLongTitleDramas,
    HarnessData.empty => const <Drama>[],
    HarnessData.big => kBigDramas,
  };
}