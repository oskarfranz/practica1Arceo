import 'package:flutter/material.dart';
import './fav_songs.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchSong extends StatelessWidget {
  MatchSong({super.key, required this.response});
  final Map response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Here you go'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                showAlertDialog(context);
              },
              child: Icon(Icons.favorite,size: 26.0,),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image(image: NetworkImage("${response["result"]["spotify"]["album"]["images"][0]["url"]}")),
            ),
            SizedBox(height: 20,),
            Text("${response["result"]["title"]}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            Text("${response["result"]["album"]}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            Text("${response["result"]["artist"]}"),
            Text("${response["result"]["release_date"]}"),
            SizedBox(height: 20,),
            Divider(color: Colors.grey),
            SizedBox(height: 20,),
            Text("Abrir con: "),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: Icon(Icons.apple), iconSize: 70, onPressed: () {
                  print(response["result"]["artist"]);
                  _launchUrl(Uri.parse("${response["result"]["apple_music"]["previews"][0]["url"]}"));
                }),
                IconButton(icon: Image.asset('assets/images/spotifyIcon.png'), iconSize: 50, onPressed: () {
                  _launchUrl(Uri.parse("${response["result"]["spotify"]["album"]["external_urls"]["spotify"]}"));
                },),
              ],
            )
          ],
        )
      );
  }
}

Future<void> _launchUrl(_url) async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

showAlertDialog(BuildContext context) {
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed:  () {
      final Map<String, String> song = {
        "autor": "Dua lipa",
        "title": "Be the one",
        "image": "https://lastfm.freetls.fastly.net/i/u/770x0/25a98b82acd36cb3e4769119d511f29a.jpg",
      };
      Navigator.push(context, MaterialPageRoute(builder: (context) => FavSongs(song: song)));
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Agregar a favoritos"),
    content: Text("La canción se añadirá a favoritos, ¿Quieres continuar?"),
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