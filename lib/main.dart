import 'package:flutter/material.dart';
import 'Tasks/tasks.dart';
import 'api.dart';
import 'dart:convert';

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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 2, 18, 126)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Découverte Flutter'),
      routes: {
        '/tasks': (context) => PageTasks(),
      },
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
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    PageTasks(),
    FutureBuilder(
      future: fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Parsez le JSON en une liste de maps.
          var data = json.decode(snapshot.data);
          List<dynamic> countriesData = data['countries'];
          List<Country> countries =
              countriesData.map((item) => Country.fromJson(item)).toList();

          // Retourne une ListView avec un ListTile pour chaque pays.
          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Pays: ${countries[index].name}'),
                subtitle: Text('Nom Français: ${countries[index].nameFr}\n'
                    'Population: ${countries[index].population}\n'
                    'Code: ${countries[index].continent['code']}\n'
                    'Latitude: ${countries[index].continent['latitude']}\n'
                    'Longitude: ${countries[index].continent['longitude']}'),
              );
            },
          );
        }
      },
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Country API',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 12, 0, 0),
        onTap: _onItemTapped,
      ),
    );
  }
}
