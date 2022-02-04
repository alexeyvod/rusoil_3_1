import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3.1',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: '3.1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int Counter1 = -1;
  int Counter2 = -1;
  SharedPreferences? _prefs;

  @override
  void initState() {
    // TODO: implement initState
    load();
    super.initState();
  }

  void load() async {
    _prefs = await SharedPreferences.getInstance();
    Counter1 = _prefs?.getInt("Counter1") ?? 0;
    Counter2 = await readIntFromFile();
    setState(() {
    });
  }

  Future<int> readIntFromFile() async{
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = await File(directory.path + '/counter.txt');
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return -1;
    }
  }

  void setIntToFile(int value) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String path = directory.path + '/counter.txt';
      final file = await File(path);
      file.writeAsString('$value');
    } catch (e) {
      print('Error in setIntToFile');
    }
  }

  void addCounter1(){
    Counter1 += 1;
    _prefs?.setInt("Counter1", Counter1);
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Значение1: $Counter1',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 5,),
              ElevatedButton(
                  onPressed: (){
                    addCounter1();
                  },
                  child: Text('Увеличить'),
              ),
              SizedBox(height: 30,),
              Text(
                'Значение2: $Counter2',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 5,),
              ElevatedButton(
                onPressed: (){
                  Counter2 += 1;
                  setIntToFile(Counter2);
                  setState(() {
                  });
                },
                child: Text('Увеличить'),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
