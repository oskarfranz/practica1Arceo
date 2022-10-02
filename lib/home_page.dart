import 'dart:convert';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import './fav_songs.dart';
import './proveedor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'match_song.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final recorder = FlutterSoundRecorder();
  
  @override
  void initState(){
    super.initState();
    initRecorder();
  }

  Future record() async{
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async{
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    print(audioFile);
    return audioFile;
  }

  Future initRecorder() async{
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw 'No se dio acceso al micrófono';
    }
    await recorder.openRecorder();
  }

  void startlisten() async{
    if(recorder.isRecording){
      await stop();
    }else{
      await record();
    }

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Text("Toque para escuchar", style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 100,),
          Center(
            child: AvatarGlow(
              child:IconButton(
                iconSize: 180,
                icon: CircleAvatar(
                  radius: 90,
                  backgroundImage: NetworkImage("https://img.freepik.com/psd-gratis/representacion-3d-icono-nota-musical-dia-san-valentin_23-2149290321.jpg?w=2000"),
                ),
                onPressed: () async {
                  // context.read<Proveedor>().startlisten();
                  if(recorder.isRecording){
                    File audio = await stop();
                    context.read<Proveedor>().stoplisten();
                    postAudio(audio);
                  }
                  else {
                    context.read<Proveedor>().startlisten();
                    await record();
                    
                    
                  }
                  // await postAudio();
                },
              ),
              endRadius: 160,
              glowColor: Colors.grey,
              animate: context.watch<Proveedor>().listening
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(icon: Icon(Icons.favorite), onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FavSongs(song: {})));
                  },),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(icon: Icon(Icons.power_settings_new), onPressed: (){
                  context.read<Proveedor>().stoplisten();
                },),
              ),
            ],
          )
      ],)
    );
  }

  postAudio(File audio) async {
    var audioBytes = audio.readAsBytesSync();
    var B64 = base64.encode(audioBytes); 
    Object body = {
      'api_token': 'your_token',
      'audio': B64,
      // 'url': 'https://audd.tech/example.mp3',
      'return': 'apple_music,spotify',
    };

    final response = await http.post(Uri.parse('https://api.audd.io/'), body: body);

    if (response.statusCode == 200) {
      print(response.body);
      Map complete_music = jsonDecode(response.body);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MatchSong(response: complete_music)));
    } else {
      throw Exception('Failed on post');
    }
  }
}
