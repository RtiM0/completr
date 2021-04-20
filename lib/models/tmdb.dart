class TMDB {
  final String backdropPath,
      posterPath,
      name,
      genre,
      rating,
      overview,
      airDate,
      creator,
      trailer;
  final List<Credits> cast;
  final List<Similar> similar;
  final int numSeasons, numEpisodes, episodeRuntime;

  TMDB(
      {this.overview,
      this.backdropPath,
      this.posterPath,
      this.name,
      this.genre,
      this.rating,
      this.episodeRuntime,
      this.airDate,
      this.creator,
      this.numSeasons,
      this.numEpisodes,
      this.trailer,
      this.cast,
      this.similar});

  factory TMDB.fromJson(Map<String, dynamic> json) {
    return TMDB(
        backdropPath:
            "https://image.tmdb.org/t/p/original${json['backdrop_path']}",
        posterPath: "https://image.tmdb.org/t/p/w154${json['poster_path']}",
        name: json['name'],
        overview: json['overview'],
        genre: json['genres'][0]['name'],
        rating: json['vote_average'].toString(),
        episodeRuntime: json['episode_run_time'][0],
        airDate: (json['in_production'])
            ? "${json['first_air_date'].substring(0, 4)}-"
            : "${json['first_air_date'].substring(0, 4)}-${json['last_air_date'].substring(0, 4)}",
        creator: json['created_by'][0]['name'],
        trailer: json['videos']['results'][0]['key'],
        cast: json['credits']['cast'].map<Credits>((creditJson) {
          return Credits.fromJson(creditJson);
        }).toList(),
        similar: json['similar']['results'].map<Similar>((similarJson) {
          return Similar.fromJson(similarJson);
        }).toList(),
        numSeasons: json['number_of_seasons'],
        numEpisodes: json['number_of_episodes']);
  }
}

class Credits {
  final String name, character, profilePath;

  Credits({this.name, this.character, this.profilePath});

  factory Credits.fromJson(Map<String, dynamic> json) {
    return Credits(
        name: json['name'],
        character: json['character'],
        profilePath: "https://image.tmdb.org/t/p/w185${json['profile_path']}");
  }
}

class Similar {
  final String name, overview, rating, posterPath;

  Similar({this.name, this.overview, this.rating, this.posterPath});

  factory Similar.fromJson(Map<String, dynamic> json) {
    return Similar(
        name: json['name'],
        overview: json['overview'],
        rating: json['vote_average'].toString(),
        posterPath: "https://image.tmdb.org/t/p/w154${json['poster_path']}");
  }
}
