import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_digit/animated_digit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int number = 0;
  double books = 0;
  double movies = 0;
  double km = 0;

  deleteSuperListEl(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("dikaiologies").doc(item);

    documentReference.delete().whenComplete(() {
      print("Deleted");
    });
  }

  void funFacts() {
    books = 0.0027521132298015 * number;
    movies = 0.0095247456167448 * number;
    km = 0.0666685388525373 * number;
  }

  @override
  void initState() {
    super.initState();

    // listen to changes in the database and update the number variable
    final docTime = FirebaseFirestore.instance
        .collection('totalTime')
        .doc('wastedTime')
        .snapshots();
    docTime.listen((doc) {
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          setState(() {
            number = data['time'];
          });
        }
        funFacts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Wasted On Waiting Vasilis'),
        elevation: 0,
      ),
      body: SizedBox(
        height: height,
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 60),
              child: Expanded(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Total time wasted",
                      style:
                          TextStyle(fontSize: 40),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 50),
              child: Align(
                alignment: Alignment.center,
                child: AnimatedDigitWidget(
                  value: number,
                  textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  fractionDigits: 2,
                  enableSeparator: true,
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    "The equivalent of",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                )),
            Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedDigitWidget(
                        value: books,
                        fractionDigits: 2,
                        enableSeparator: true,
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "books read",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        )),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedDigitWidget(
                        value: movies,
                        fractionDigits: 2,
                        enableSeparator: true,
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "movies watched",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        )),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedDigitWidget(
                        value: km,
                        fractionDigits: 2,
                        enableSeparator: true,
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "km walked",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        )),
                  ],
                )),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 45,bottom: 20),
                child: Text('Recent Dikaiologies',style: TextStyle(fontSize: 20),)),
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("dikaiologies")
                  .snapshots(),
              builder: (context, snapshots) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: (snapshots.data)?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        (snapshots.data!).docs[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        title: Text(documentSnapshot["Itemtitle"],style: TextStyle(fontStyle: FontStyle.italic),),
                      ),
                    );
                  },
                );
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final docTime = FirebaseFirestore.instance
              .collection('totalTime')
              .doc('wastedTime');

          docTime.update({
            'time': 234234,
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
