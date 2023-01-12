import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final statuses = [
      Permission.storage,
    ].request();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      title: 'Primeiro_App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Primeiro App em Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final pages = PageView(
      controller: _controller,
      children: [
        HomeWidget(),
        PhotosWidget(),
      ],
    );
    return pages;
  }
}


class HomeWidget extends StatelessWidget{

  Widget build(BuildContext context){
    final children = new Scaffold(
    body: new Image.asset(
      "images/home1.jpeg",
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    ),
    );
  return new GestureDetector(
    onTapDown: _onTapDown,
    child: children,
  );
}

_onTapDown(TapDownDetails details){

  var x = details.globalPosition.dx;
  var y = details.globalPosition.dy;

  print(details.localPosition);

  int dx = (x / 80).floor();
  int dy = ((y - 180) / 100).floor();
  int posicao = dy * 5 + dx;
  print("Resultados: x=$x y=$y $dx $dy $posicao");
  _save(posicao);
}

_save(int posicao) async{
  var appDocDir = await getTemporaryDirectory();
  String savePath = appDocDir.path + "efeito-$posicao.jpeg";
  print(savePath);
  await Dio().download(
    "https://raw.githubusercontent.com/atn337/flutter-magic/main/efeito-$posicao.jpg",
    savePath);
  print("Salvo!");
  final resultado = await ImageGallerySaver.saveFile(savePath);
  print(resultado);
  }
}


class PhotosWidget extends StatelessWidget{

  Widget build(BuildContext context){
    final children = new Scaffold(
      body: new Image.asset(
        "images/home2.jpeg",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
    return new GestureDetector(
      onTap: openGallery,
      child: children,
    );
  }

  Future<void> openGallery() async {
    final ImagePicker picker = ImagePicker();
    final PickedFile? image = await picker.getImage(source: ImageSource.gallery);
  }
}



