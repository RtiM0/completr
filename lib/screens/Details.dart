import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:completr/models/tmdb.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:url_launcher/url_launcher.dart';

Future<List<PaletteColor>> fetchColors(ImageProvider imageProvider) async {
  final PaletteGenerator generator =
      await PaletteGenerator.fromImageProvider(imageProvider);
  List<PaletteColor> paletteColors = [];
  paletteColors.addAll([generator.darkVibrantColor, generator.darkMutedColor]);
  return generator.paletteColors;
}

Future<TMDB> fetchShow(int id, String type) async {
  String countryCode;
  try {
    final ipapi = await http.get(Uri.http("ip-api.com", "/json"));
    countryCode = jsonDecode(ipapi.body)['countryCode'];
  } catch (e) {
    countryCode = "GB";
  }
  final response =
      await http.get(Uri.https("api.themoviedb.org", "/3/$type/$id", {
    "api_key": "aa83b59842709a91c2855a4dbf200f79",
    "append_to_response":
        "external_ids,credits,videos,recommendations,watch/providers"
  }));
  if (response.statusCode == 200) {
    return TMDB.fromJson(jsonDecode(response.body), type,
        countryCode: countryCode);
  } else {
    throw Exception("Couldn't Load");
  }
}

Future<List<Ratings>> fetchRatings(String imdbid) async {
  final response = await http
      .get(Uri.http("omdbapi.com", "/", {"i": imdbid, "apikey": "5928a79e"}));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['Ratings'].map<Ratings>((rating) {
      return Ratings.fromJson(rating);
    }).toList();
  } else {
    return <Ratings>[];
  }
}

Widget _subTitle(BuildContext context, String text, Color color) {
  return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Text(text,
          style: GoogleFonts.barlowSemiCondensed(
            textStyle: Theme.of(context).textTheme.bodyText2,
            color: color,
          )));
}

Widget _detailsPage(
    BuildContext context,
    Size size,
    List<PaletteColor> colors,
    Widget backdrop,
    TMDB tmdb,
    TabController _controller,
    int _tabIndex,
    Future<List<Ratings>> ratings,
    String type) {
  const _kFontFam = 'Completr';
  const String _kFontPkg = null;

  const IconData favourite =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  const IconData add_to_watchlist =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  const IconData check =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  const IconData search =
      IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  const IconData back =
      IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  const IconData menu =
      IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  Color primary = colors.first.color.darken(10);
  Color accent = colors.last.color.lighten(10);
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(back, color: accent),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        tmdb.name.toUpperCase(),
        style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 16),
      ),
      actions: [
        IconButton(
          icon: Icon(search),
          color: accent,
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(menu),
          color: accent,
          onPressed: () {},
        )
      ],
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colors[0].color, Colors.transparent])),
      ),
      toolbarHeight: 75,
    ),
    extendBodyBehindAppBar: true,
    body: MediaQuery.removePadding(
      context: context,
      child: ListView(physics: BouncingScrollPhysics(), children: [
        Stack(
          children: <Widget>[
            backdrop,
            Positioned(
                bottom: 0,
                child: Container(
                  height: 100,
                  width: size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black])),
                )),
            Positioned(
              bottom: 0,
              child: Container(
                height: 100,
                width: size.width,
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: accent,
                      ),
                      Text(
                        tmdb.rating + "/10",
                        style: TextStyle(color: Colors.white, letterSpacing: 1),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (type == "tv")
          TabBar(
              tabs: [
                Tab(
                  child: Text("ABOUT"),
                ),
                Tab(
                  child: Text("EPISODE LIST"),
                )
              ],
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: accent, width: 2.0)),
              controller: _controller),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 75,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(.1))),
                        child: Icon(favourite, color: accent, size: 24),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 75,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.white.withOpacity(.1)),
                                bottom: BorderSide(
                                    color: Colors.white.withOpacity(.1)))),
                        child: Icon(add_to_watchlist, color: accent, size: 24),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 75,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(.1))),
                        child: (type == "tv")
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "0/${tmdb.numEpisodes}\nEpisodes Watched",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.barlowSemiCondensed(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          color: accent)),
                                ],
                              )
                            : Icon(check, color: accent, size: 24),
                      )),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 0, 0),
                    child: Text(
                      tmdb.name.toUpperCase(),
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlowSemiCondensed(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    )),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Row(
                    children: [
                      _subTitle(context, tmdb.airDate, accent),
                      _subTitle(context, tmdb.genre.toUpperCase(), accent),
                      if (type == "tv")
                        _subTitle(context, "${tmdb.numSeasons}", accent),
                      if (type == "tv")
                        _subTitle(context, "${tmdb.numEpisodes}", accent),
                      _subTitle(context, "${tmdb.episodeRuntime}", accent)
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24, top: 16),
                child: Text(tmdb.overview,
                    style: GoogleFonts.barlowSemiCondensed(
                        textStyle: Theme.of(context).textTheme.bodyText2,
                        color: Colors.white)),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 24, top: 16),
                  child: RichText(
                      text: TextSpan(
                          text: 'Creator: ',
                          style: GoogleFonts.barlowSemiCondensed(color: accent),
                          children: <TextSpan>[
                        TextSpan(
                            text: tmdb.creator,
                            style: GoogleFonts.barlowSemiCondensed(
                                color: Colors.white))
                      ]))),
              Container(
                  height: 200,
                  margin: EdgeInsets.only(top: 16),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: (tmdb.cast != null) ? tmdb.cast.length : 0,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.all(8),
                            child: SizedBox(
                                width: 100,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: FadeInImage.assetNetwork(
                                        image: tmdb.cast[index].profilePath,
                                        placeholder:
                                            'assets/profile_placeholder.jpg',
                                        fit: BoxFit.fitHeight,
                                        height: 150,
                                      ),
                                    ),
                                    Text(tmdb.cast[index].name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.barlowSemiCondensed(
                                            color: Colors.white)),
                                    Text(tmdb.cast[index].character,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.barlowSemiCondensed(
                                            color:
                                                Colors.white.withOpacity(.5))),
                                  ],
                                )));
                      })),
              Padding(
                  padding: EdgeInsets.only(left: 24, top: 16),
                  child: Text(
                    "Reviews",
                    style: GoogleFonts.barlowSemiCondensed(color: Colors.white),
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Expanded(
                  flex: 1,
                  child: FutureBuilder<List<Ratings>>(
                    future: ratings,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.only(left: 24),
                                child: RichText(
                                    text: TextSpan(
                                        text:
                                            '${snapshot.data[index].source}: ',
                                        style: GoogleFonts.barlowSemiCondensed(
                                            color: accent),
                                        children: <TextSpan>[
                                      TextSpan(
                                          text: snapshot.data[index].value,
                                          style:
                                              GoogleFonts.barlowSemiCondensed(
                                                  color: Colors.white))
                                    ])));
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FadeInImage.assetNetwork(
                        image: (tmdb.trailer != "")
                            ? "https://img.youtube.com/vi/${tmdb.trailer}/maxresdefault.jpg"
                            : "assets/profile_placeholder.jpg",
                        placeholder: "assets/profile_placeholder.jpg",
                        imageErrorBuilder: (context, exception, stackTrack) =>
                            Icon(Icons.error),
                        fit: BoxFit.fill,
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(24),
                    ),
                    onTap: () async {
                      await launch("http://youtu.be/${tmdb.trailer}");
                    },
                  ),
                )
              ]),
              Padding(
                  padding: EdgeInsets.only(left: 24, top: 16),
                  child: Text(
                    "Where to watch",
                    style: GoogleFonts.barlowSemiCondensed(color: Colors.white),
                  )),
              Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: tmdb.watchProviders != null
                        ? tmdb.watchProviders.length
                        : 0,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                          child: Card(
                            color: primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: BorderSide(color: accent)),
                            child: Container(
                                alignment: Alignment.center,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 4, right: 4),
                                    child: Text(tmdb.watchProviders[index],
                                        style: GoogleFonts.barlowSemiCondensed(
                                            color: Colors.white)))),
                          ));
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 24, top: 16),
                  child: Text(
                    "You may also like...",
                    style: GoogleFonts.barlowSemiCondensed(color: Colors.white),
                  )),
              Container(
                  height: 400,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount:
                          (tmdb.similar != null) ? tmdb.similar.length : 0,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.all(8),
                            child: InkWell(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: FadeInImage.assetNetwork(
                                        image: tmdb.similar[index].posterPath,
                                        placeholder:
                                            'assets/profile_placeholder.jpg',
                                        fit: BoxFit.fitHeight,
                                        height: 231,
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(tmdb.similar[index].name,
                                          style:
                                              GoogleFonts.barlowSemiCondensed(
                                                  color: Colors.white)),
                                    ),
                                    SizedBox(
                                        width: 154,
                                        child: Text(
                                            tmdb.similar[index].overview,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                            style:
                                                GoogleFonts.barlowSemiCondensed(
                                                    color: Colors.white
                                                        .withOpacity(.5)))),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Details(
                                              tmdbid:
                                                  tmdb.similar[index].tmdbid,
                                              type: type)));
                                }));
                      })),
            ],
            [
              Center(
                child: Text("YOOO"),
              )
            ]
          ][_tabIndex],
        )
        // ListView.builder(
        //     shrinkWrap: true,
        //     physics: ScrollPhysics(),
        //     itemCount: colors.length,
        //     itemBuilder: (context, index) {
        //       return ListTile(
        //           title: Text(
        //             "$index COLOR BRO",
        //             style: TextStyle(color: Colors.white),
        //           ),
        //           tileColor: colors[index].color);
        //     })
      ]),
    ),
    backgroundColor: primary,
  );
}

class Details extends StatefulWidget {
  final int tmdbid;
  final String type;

  const Details({Key key, this.tmdbid, this.type}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  Future<TMDB> tmdb;
  Future<List<PaletteColor>> paletteColors;
  Future<List<Ratings>> ratings;
  TabController _controller;
  int _tabIndex = 0;

  @override
  void initState() {
    _controller = TabController(
      length: 2,
      vsync: this,
    );
    _controller.addListener(() {
      if (_controller.indexIsChanging) {
        setState(() {
          _tabIndex = _controller.index;
        });
      }
    });
    super.initState();
    tmdb = fetchShow(widget.tmdbid, widget.type);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<PaletteColor> def = <PaletteColor>[
      PaletteColor(Colors.black, 200),
      PaletteColor(Colors.white, 200),
    ];
    return FutureBuilder<TMDB>(
      future: tmdb,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FadeInImage backdrop = FadeInImage.assetNetwork(
              image: snapshot.data.backdropPath,
              placeholder: 'assets/profile_placeholder.jpg',
              fit: BoxFit.cover,
              height: size.height * 0.6,
              width: size.width);
          if (paletteColors == null && backdrop.image != null) {
            paletteColors = fetchColors(backdrop.image);
          }
          ratings = fetchRatings(snapshot.data.imdbid);
          return FutureBuilder<List<PaletteColor>>(
            future: paletteColors,
            builder: (context, paletteColorlist) {
              List<PaletteColor> colors =
                  paletteColorlist.hasData && paletteColorlist.data[0] != null
                      ? paletteColorlist.data
                      : def;
              return _detailsPage(context, size, colors, backdrop,
                  snapshot.data, _controller, _tabIndex, ratings, widget.type);
            },
          );
        }
        return _detailsPage(
            context,
            size,
            def,
            SizedBox(
              height: size.height * 0.6,
            ),
            TMDB(),
            _controller,
            _tabIndex,
            ratings,
            widget.type);
      },
    );
  }
}
