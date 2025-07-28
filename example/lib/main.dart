import 'package:flutter/material.dart';
import 'package:tooltip_view/tooltip_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final _ct = TooltipController();
  TooltipAlignment alignment = TooltipAlignment.top;
  double dx = 40.0;
  double dy = 0.0;
  double borderRadius = 10.0;
  double triangleSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Text("Alignment"),
            title: Row(
              children: [
                const Text('top'),
                Radio(
                  value: TooltipAlignment.top,
                  groupValue: alignment,
                  onChanged: (TooltipAlignment? value) {
                    setState(() {
                      alignment = value!;
                    });
                  },
                ),
                const Text('left'),
                Radio(
                  value: TooltipAlignment.left,
                  groupValue: alignment,
                  onChanged: (TooltipAlignment? value) {
                    setState(() {
                      alignment = value!;
                    });
                  },
                ),
                const Text('bottom'),
                Radio(
                  value: TooltipAlignment.bottom,
                  groupValue: alignment,
                  onChanged: (TooltipAlignment? value) {
                    setState(() {
                      alignment = value!;
                    });
                  },
                ),
                const Text('right'),
                Radio(
                  value: TooltipAlignment.right,
                  groupValue: alignment,
                  onChanged: (TooltipAlignment? value) {
                    setState(() {
                      alignment = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Text("dx"),
            title: Slider(
              value: dx,
              min: -50,
              max: 50,
              divisions: 100,
              label: "dx $dx",
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  dx = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Text("dy"),
            title: Slider(
              value: dy,
              min: -50,
              max: 50,
              divisions: 100,
              label: "dy $dy",
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  dy = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Text("borderRadius"),
            title: Slider(
              value: borderRadius,
              min: 5,
              max: 50,
              divisions: 45,
              label: "borderRadius $borderRadius",
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  borderRadius = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Text("triangleSize"),
            title: Slider(
              value: triangleSize,
              min: 5,
              max: 50,
              divisions: 45,
              label: "triangleSize $triangleSize",
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  triangleSize = value;
                });
              },
            ),
          ),
          SizedBox(height: 150),
          const Text('You have pushed the button this many times:'),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TooltipView(
            controller: _ct,
            alignment: alignment,
            offset: Offset(dx, dy),
            borderRadius: borderRadius,
            triangleSize: triangleSize,
            tooltipBuilder: (BuildContext context, TooltipController c) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 38, 16, 38),
                    child: Text("Please click here add counter"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        c.show = false;
                      },
                      child: Icon(Icons.close_outlined),
                    ),
                  )
                ],
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.blue,
              ),
              child: IconButton(
                color: Colors.white,
                onPressed: _incrementCounter,
                icon: const Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ct.show = true;
        },
        tooltip: 'Show',
        child: Text("Show"),
      ),
    );
  }
}
