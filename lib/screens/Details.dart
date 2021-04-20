import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:completr/models/tmdb.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

Future<List<PaletteColor>> fetchColors(ImageProvider imageProvider) async {
  final PaletteGenerator generator =
      await PaletteGenerator.fromImageProvider(imageProvider);
  List<PaletteColor> paletteColors = [];
  paletteColors.addAll([generator.darkVibrantColor, generator.darkMutedColor]);
  return generator.paletteColors;
}

Future<TMDB> fetchShow(int id) async {
  final response = await http.get(Uri.https("api.themoviedb.org", "/3/tv/$id", {
    "api_key": "aa83b59842709a91c2855a4dbf200f79",
    "append_to_response": "credits,videos,similar"
  }));
  if (response.statusCode == 200) {
    return TMDB.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Couldn't Load");
  }
}

class Details extends StatefulWidget {
  final int tmdbid;

  const Details({Key key, this.tmdbid}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  Future<TMDB> tmdb;

  _detailsPage(
      Size size, List<PaletteColor> colors, Image backdrop, TMDB tmdb) {
    return Scaffold(
      appBar: AppBar(
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
            icon: Icon(Icons.search),
            color: colors.last.color,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.list),
            color: colors.last.color,
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
        child: ListView(children: [
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
                          color: Colors.yellow[600],
                        ),
                        Text(
                          tmdb.rating + "/10",
                          style:
                              TextStyle(color: Colors.white, letterSpacing: 1),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                  borderSide: BorderSide(color: colors.last.color, width: 2.0)),
              controller: TabController(
                length: 2,
                vsync: this,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    height: 75,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white.withOpacity(.1))),
                    child: Icon(Icons.favorite_border, size: 48),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    height: 75,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                        border: Border(
                            top:
                                BorderSide(color: Colors.white.withOpacity(.1)),
                            bottom: BorderSide(
                                color: Colors.white.withOpacity(.1)))),
                    child: Icon(Icons.add, size: 48),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    height: 75,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white.withOpacity(.1))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("62/62"), Text("Episodes Watched")],
                    ),
                  )),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  tmdb.name.toUpperCase(),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.barlowSemiCondensed(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                )),
          ),
          Row(
            children: [
              Text(tmdb.airDate),
              Text(tmdb.genre),
              Text("${tmdb.numSeasons} SEASONS"),
              Text("${tmdb.numEpisodes} EPISODES"),
              Text("${tmdb.episodeRuntime}M AVG")
            ],
          ),
          Container(
              height: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tmdb.cast.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Image.network(
                          tmdb.cast[index].profilePath,
                          errorBuilder: (context, exception, stackTrack) =>
                              Icon(Icons.error),
                          fit: BoxFit.fitHeight,
                          height: 200,
                        )
                      ],
                    );
                  })),
          Image.network(
            "https://img.youtube.com/vi/${tmdb.trailer}/0.jpg",
            height: 200,
            fit: BoxFit.cover,
          ),
          Container(
              height: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tmdb.similar.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Image.network(
                          tmdb.similar[index].posterPath,
                          errorBuilder: (context, exception, stackTrack) =>
                              Icon(Icons.error),
                          fit: BoxFit.fitHeight,
                          height: 200,
                        )
                      ],
                    );
                  })),
          ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                      "$index COLOR BRO",
                      style: TextStyle(color: Colors.white),
                    ),
                    tileColor: colors[index].color);
              })
        ]),
      ),
      backgroundColor: colors[0].color,
    );
  }

  @override
  void initState() {
    super.initState();
    tmdb = fetchShow(widget.tmdbid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<TMDB>(
      future: tmdb,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Image backdrop = Image.network(snapshot.data.backdropPath,
              fit: BoxFit.cover, height: size.height * 0.6, width: size.width);
          return FutureBuilder<List<PaletteColor>>(
            future: fetchColors(backdrop.image),
            builder: (context, paletteColorlist) {
              List<PaletteColor> colors =
                  paletteColorlist.hasData && paletteColorlist.data[0] != null
                      ? paletteColorlist.data
                      : <PaletteColor>[
                          PaletteColor(Colors.black, 200),
                          PaletteColor(Colors.white, 200)
                        ];
              return _detailsPage(size, colors, backdrop, snapshot.data);
            },
          );
        }
        return Scaffold();
      },
    );
  }
}
