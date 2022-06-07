class tmdbItem {
  final String posterPath, backdropPath, name, overview, type;
  final int tmdbid;

  tmdbItem({
    required this.posterPath,
    required this.backdropPath,
    required this.name,
    required this.overview,
    required this.type,
    required this.tmdbid,
  });

  factory tmdbItem.fromJson(
    Map<String, dynamic> json,
    String type,
    int tmdbid,
  ) {
    return tmdbItem(
      posterPath: "https://image.tmdb.org/t/p/w154${json['poster_path']}",
      backdropPath: "https://image.tmdb.org/t/p/w300${json['backdrop_path']}",
      name: (type == "tv") ? json['name'] : json['title'],
      overview: json['overview'],
      type: type,
      tmdbid: tmdbid,
    );
  }
}

class TMDB {
  final String? backdropPath,
      posterPath,
      name,
      genre,
      rating,
      overview,
      airDate,
      creator,
      trailer,
      imdbid,
      numSeasons,
      numEpisodes,
      episodeRuntime;
  final List<Credits>? cast;
  final List<Similar>? similar;
  final List<String>? watchProviders;

  TMDB(
      {this.overview: "",
      this.backdropPath: "",
      this.posterPath: "",
      this.name: "COMPLETR",
      this.genre: "Media",
      this.rating: "∞",
      this.episodeRuntime: "",
      this.airDate: "2021-",
      this.creator: "Potato",
      this.numSeasons: "",
      this.numEpisodes: "",
      this.trailer: "",
      this.imdbid: "",
      this.cast,
      this.similar,
      this.watchProviders});

  factory TMDB.fromJson(Map<String, dynamic> json, String? type,
      {String? countryCode: "GB"}) {
    var watchProvider = json['watch/providers']['results'];
    var providers = [];
    if (watchProvider[countryCode] != null) {
      if (watchProvider[countryCode]['flatrate'] != null) {
        providers.addAll(watchProvider[countryCode]['flatrate']);
      }
      if (watchProvider[countryCode]['buy'] != null) {
        providers.addAll(watchProvider[countryCode]['buy']);
      }
    }
    return TMDB(
        backdropPath:
            "https://image.tmdb.org/t/p/original${json['backdrop_path']}",
        posterPath: "https://image.tmdb.org/t/p/w154${json['poster_path']}",
        name: (type == "tv") ? json['name'] : json['title'],
        overview: json['overview'],
        genre: json['genres'].isEmpty ? "" : json['genres'][0]['name'],
        rating: json['vote_average'].toString(),
        episodeRuntime: (type == "tv")
            ? "${json['episode_run_time'][0]}M AVG"
            : "RUNTIME:${json['runtime']}",
        airDate: (type == "tv")
            ? (json['in_production'])
                ? "${json['first_air_date'].substring(0, 4)}-"
                : "${json['first_air_date'].substring(0, 4)}-${json['last_air_date'].substring(0, 4)}"
            : json['release_date'].substring(0, 4),
        creator: (type == "tv")
            ? json['created_by'].isEmpty
                ? ""
                : json['created_by'][0]['name']
            : json['credits']['crew'].firstWhere(
                (crew) => crew['job'] == "Director",
                orElse: () => {"name": ""})['name'],
        trailer: json['videos']['results'].isEmpty
            ? ""
            : json['videos']['results'][0]['key'],
        cast: json['credits']['cast'].map<Credits>((creditJson) {
          return Credits.fromJson(creditJson);
        }).toList(),
        similar: json['recommendations']['results'].map<Similar>((similarJson) {
          return Similar.fromJson(similarJson, type);
        }).toList(),
        imdbid: json['external_ids']['imdb_id'],
        numSeasons:
            (type == "tv") ? "${json['number_of_seasons']} SEASONS" : "",
        numEpisodes:
            (type == "tv") ? "${json['number_of_episodes']} EPISODES" : "",
        watchProviders: providers.map<String>((provider) {
          return provider['provider_name'].toString();
        }).toList());
  }
}

class Credits {
  final String? name, character, profilePath;

  Credits({this.name, this.character, this.profilePath});

  factory Credits.fromJson(Map<String, dynamic> json) {
    return Credits(
        name: json['name'],
        character: json['character'],
        profilePath: "https://image.tmdb.org/t/p/w185${json['profile_path']}");
  }
}

class Similar {
  final String? name, overview, rating, posterPath;
  final int? tmdbid;

  Similar(
      {this.tmdbid, this.name, this.overview, this.rating, this.posterPath});

  factory Similar.fromJson(Map<String, dynamic> json, String? type) {
    return Similar(
        tmdbid: json['id'],
        name: (type == "tv") ? json['name'] : json['title'],
        overview: json['overview'],
        rating: json['vote_average'].toString(),
        posterPath: "https://image.tmdb.org/t/p/w154${json['poster_path']}");
  }
}

class Ratings {
  final String? source, value;

  Ratings({this.source, this.value});

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(source: json['Source'], value: json['Value']);
  }
}

class SearchResult {
  final String? name, type, overview;
  final int? tmdbid;

  SearchResult({this.name, this.type, this.overview, this.tmdbid});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    String? type = json['media_type'];
    return SearchResult(
        name: (type == "tv") ? json['name'] : json['title'],
        type: type,
        overview: json['overview'],
        tmdbid: json['id']);
  }
}
