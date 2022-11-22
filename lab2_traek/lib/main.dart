import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}


// This is the path that the child will follow. It's a CatmullRomSpline so
// that the coordinates can be specified that it must pass through. If the
// tension is set to 1.0, it will linearly interpolate between those points,
// instead of interpolating smoothly.
final CatmullRomSpline path = CatmullRomSpline(
  const <Offset>[
    Offset(0.05, 0.75),
    Offset(0.18, 0.23),
    Offset(0.32, 0.04),
    Offset(0.73, 0.5),
    Offset(0.42, 0.74),
    Offset(0.73, 0.01),
    Offset(0.93, 0.93),
    Offset(0.05, 0.75),
  ],
  startHandle: const Offset(0.93, 0.93),
  endHandle: const Offset(0.18, 0.23),
);

class FollowCurve2D extends StatefulWidget {
  const FollowCurve2D({
    super.key,
    required this.path,
    this.curve = Curves.easeInOut,
    required this.child,
    this.duration = const Duration(seconds: 1),
  });

  final Curve2D path;
  final Curve curve;
  final Duration duration;
  final Widget child;

  @override
  State<FollowCurve2D> createState() => _FollowCurve2DState();
}

class _FollowCurve2DState extends State<FollowCurve2D>
    with TickerProviderStateMixin {
  // The animation controller for this animation.
  late AnimationController controller;
  // The animation that will be used to apply the widget's animation curve.
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.duration, vsync: this);
    animation = CurvedAnimation(parent: controller, curve: widget.curve);
    // Have the controller repeat indefinitely.  If you want it to "bounce" back
    // and forth, set the reverse parameter to true.
    controller.repeat();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // Always have to dispose of animation controllers when done.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scale the path values to match the -1.0 to 1.0 domain of the Alignment widget.
    final Offset position =
        widget.path.transform(animation.value) * 2.0 - const Offset(1.0, 1.0);
    return Align(
      alignment: Alignment(position.dx, position.dy),
      child: widget.child,
    );
  }
}


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color getColor() {
    if (_selectedIndex == 1) {
      return Colors.greenAccent;
    }
    if (_selectedIndex == 2) {
      return Colors.red;
    }
    if (_selectedIndex == 3) {
      return Colors.blueAccent;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawer Demo'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              onTap: (){_onItemTapped(1);},
              leading: const Icon(Icons.accessible_forward),
              title: const Text('Green'),
            ),
            ListTile(
              onTap: (){_onItemTapped(2);},
              leading: const Icon(Icons.accessible_forward),
              title: const Text('Red'),
            ),
            ListTile(
              onTap: (){_onItemTapped(3);},
              leading: const Icon(Icons.accessible_forward),
              title: const Text('Blue'),
            ),
          ],
        ),
      ),
      body:
        Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: FollowCurve2D(
              path: path,
              duration: const Duration(seconds: 3),
              child: CircleAvatar(
                backgroundColor: getColor(),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline6!,
                  child: const Text('B'), // Buzz, buzz!
                ),
              ),
            ),
          )




    );
  }
}
