import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:google_fonts/google_fonts.dart';

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
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.oswaldTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      home: const MyHomePage(),
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
  String input = "";
  String mininput = "";
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _mintextFieldController = TextEditingController();

  createSuperListEl() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("dikaiologies").doc(input);

    Map<String, String> superList = {"Itemtitle": input};

    documentReference.set(superList).whenComplete(() {
      print("$input Created");
    });

    final docTime =
        FirebaseFirestore.instance.collection('totalTime').doc('wastedTime');

    docTime.update({
      'time': number + int.parse(mininput),
    });
    MotionToast.success(
      title: const Text("EPITIXIA"),
      description: const Text("OLA KALA ANEVIKAN"),
    ).show(context);
  }

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
      backgroundColor:const Color.fromARGB(255, 232, 239, 245),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Wasted On Waiting Vasilis',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Total minutes wasted",
                        style: TextStyle(fontSize: 36),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 45),
              child: Align(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      number.toString(),
                      style: const TextStyle(
                          fontSize: 90, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            const Align(
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
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            books.toStringAsFixed(2),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        )),
                    const Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "books read📚",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            movies.toStringAsFixed(2),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        )),
                    const Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "movies watched🎥",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            km.toStringAsFixed(2),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        )),
                    const Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "km walked🚶",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                )),
              ],
            ),
            const Padding(
                padding: EdgeInsets.only(top: 45, bottom: 20),
                child: Text(
                  '⭐Recent Dikaiologies⭐',
                  style: TextStyle(fontSize: 20),
                )),
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("dikaiologies")
                  .snapshots(),
              builder: (context, snapshots) {
                return Scrollbar(
                  thumbVisibility: true,
                  thickness: 5,
                  radius: const Radius.circular(20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: (snapshots.data)?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          (snapshots.data!).docs[index];
                      return Card(
                        elevation: 3,
                        color: const Color.fromARGB(255, 244, 245, 246),
                        margin: const EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(
                            documentSnapshot["Itemtitle"],
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ))
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15, right: 15),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    elevation: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text('Add'),
                    content: SizedBox(
                      height: 160,
                      child: Column(children: [
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'POSO ARGISE PALI(SE LEPTA)',
                            border: InputBorder.none,
                          ),
                          controller: _mintextFieldController,
                          onChanged: (String value) {
                            mininput = value;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'TI DIKAIOLOGIA EIPE PALI',
                              border: InputBorder.none,
                            ),
                            controller: _textFieldController,
                            onChanged: (String value) {
                              input = value;
                            },
                          ),
                        ),
                      ]),
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: TextButton(
                            onPressed: () {
                              if (input == '' || mininput == '') {
                                MotionToast.warning(
                                        title: const Text("WARNING"),
                                        description: const Text(
                                            "EXEIS AFISEI KAPOIO PEDIO KENO STOKE"))
                                    .show(context);
                              } else if (int.parse(mininput) < 0) {
                                MotionToast.warning(
                                        title: const Text("WARNING"),
                                        description: const Text(
                                            "GIATI VAZEIS ARNITIKOUS?🤡🤡"))
                                    .show(context);
                              } else {
                                createSuperListEl();
                              }
                              _textFieldController.clear();
                              _mintextFieldController.clear();
                              input = '';
                              mininput = '';
                              FocusScope.of(context).unfocus();
                            },
                            child: const Text("Add")),
                      )
                    ],
                  );
                });
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
