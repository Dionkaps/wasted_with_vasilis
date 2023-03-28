import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Wasted On Vasilis'),
      ),
      body: SizedBox(
        height: 400,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 60),
              child: const Expanded(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Total time wasted",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            const Expanded(
              child: Align(alignment: Alignment.center, child: Text("XXXX")),
            ),
            const Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "The equivalent of",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )),
            ),
            Expanded(
                child: Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: const [
                    Expanded(
                      child: Align(
                          alignment: Alignment.center, child: Text("XXXX")),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "books read",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: const [
                    Expanded(
                      child: Align(
                          alignment: Alignment.center, child: Text("XXXX")),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "movies watched",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: const [
                    Expanded(
                      child: Align(
                          alignment: Alignment.center, child: Text("XXXX")),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "km walked",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                )),
              ],
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final docTime = FirebaseFirestore.instance
              .collection('totalTime')
              .doc('wastedTime');

              docTime.update({
                'time': 2,
              });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
