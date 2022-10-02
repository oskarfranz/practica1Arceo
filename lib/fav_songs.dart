import 'package:flutter/material.dart';
// import './item_fav.dart';
// import './match_song.dart';
// import './proveedor.dart';
// import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


final List<Map<String, String>> _favSongs = [
    {
      "autor": "Dua lipa",
      "title": "Be the one",
      "image": "https://lastfm.freetls.fastly.net/i/u/770x0/25a98b82acd36cb3e4769119d511f29a.jpg",
      "url": ""
    },
    {
      "autor": "The Weekend",
      "title": "call me by your name",
      "image": "https://m.media-amazon.com/images/I/51UVW34rJTL._AC_SX425_.jpg",
      "url": ""
    },
    {
      "autor": "Danny ocean",
      "title": "Volare",
      "image": "https://i.scdn.co/image/ab67616d0000b273d8243a13e6f41310a5fa7b96",
      "url": ""
    },
  ];

class FavSongs extends StatefulWidget {
  FavSongs({super.key, required this.song});
  final Map<String, String> song;

  @override
  State<FavSongs> createState() => _FavSongsState();
}

class _FavSongsState extends State<FavSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your favorite songs'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _favSongs.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 25, bottom: 25),
                  child: GestureDetector(
                    onTap: (){
                      showAlertDialogRedirect(context, _favSongs[index]["url"]);
                      setState(() {});
                    },
                    child: Container(
                      height: 270,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Image.network(
                                "${_favSongs[index]["image"]}",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              top: 10, left: 5, //give the values according to your requirement
                              child: IconButton(icon: Icon(Icons.favorite), onPressed: () {
                                print(_favSongs[index]["autor"]);
                                showAlertDialog(context, index);
                                print('aios');
                                setState(() {});
                              },),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xef4169D8),
                                  borderRadius:
                                      BorderRadius.only(topRight: Radius.circular(15)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${_favSongs[index]["autor"]}",
                                      style: TextStyle(color: Colors.grey[200], fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    Text(
                                      "${_favSongs[index]["title"]}",
                                      style: TextStyle(color: Colors.grey[200], fontSize: 15),
                                    ),
                                    Text(
                                      "${this.widget.song}",
                                      style: TextStyle(color: Colors.grey[200], fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                                  ),
                  ),
              );
            }
          ),
        ),
      ],
    ));
  }
  showAlertDialog(BuildContext context, index) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        print(index);
        _favSongs.removeAt(index);
        setState(() {});
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar de favoritos"),
      content: Text("El elemento será eliminado de favoritos, ¿Quieres continuar?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}


showAlertDialogRedirect(BuildContext context, url) {
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed:  () {
      _launchUrl(Uri.parse(url));
      
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Abrir cancion"),
    content: Text("Sera redirigido a ver opciones para abrir la canción, ¿Quiere continuar?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<void> _launchUrl(_url) async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}