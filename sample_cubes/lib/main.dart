import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cube',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Cube Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _count = 75;
  late Scene _scene;
  Object? _cubes;

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.position.z = 50;
    _cubes = Object(scale: Vector3(2.0, 2.0, 2.0), backfaceCulling: false, fileName: 'assets/1/cube.obj');
    double scale = 2.0;

    for (var i = 0; i < _count; i++) {
      Random r = Random();
      final x = r.nextDouble() * 20 - 10;
      final y = r.nextDouble() * 20 - 10;
      final z = r.nextDouble() * 20 - 10;
      final Object cube = Object(
        position: Vector3(x, y, z)..scale(scale),
        fileName: 'assets/${r.nextInt(3) + 1}/cube.obj',
      );
      _cubes!.add(cube);
    }
    scene.world.add(_cubes!);
  }


  void _onSceneChanged(Scene scene) {
    _scene = scene;
    scene.camera.position.z = 50;
    scene.world = Object(scale: Vector3(2.0, 2.0, 2.0), backfaceCulling: false, fileName: 'assets/1/cube.obj');
    double scale = 2.0;

    for (var i = 0; i < _count; i++) {
      Random r = Random();
      final x = r.nextDouble() * 20 - 10;
      final y = r.nextDouble() * 20 - 10;
      final z = r.nextDouble() * 20 - 10;
      final Object cube = Object(
        position: Vector3(x, y, z)..scale(scale),
        fileName: 'assets/${r.nextInt(3) + 1}/cube.obj',
      );
      scene.world.add(cube);
    }
    // scene.world = _cubes!;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Cube(
              onSceneCreated: _onSceneCreated,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Slider(
                  value: _count.toDouble(),
                  min: 1,
                  max: 150,
                  divisions: 150,
                  onChanged: (value) {
                    setState(
                      (){
                        _count = value.toInt();
                      }
                    );
                  },
                  onChangeEnd: (value) {
                    _onSceneChanged(_scene);
                  },
                ),
              ]
            )
          ]
        ),
      )
    );
  }
}