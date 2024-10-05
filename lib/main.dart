import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_nation_example/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Title"),
          centerTitle: true,
        ),
        body: const App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var collercton = FirebaseFirestore.instance.collection('main');

  List<DocumentSnapshot> items = [];

  DocumentSnapshot? lastDoc;

  bool isLoad = false;
  bool isGetting = false;
  bool hasData = true;

  ScrollController scrollController = ScrollController();

  getItems() async {
    if (isLoad) return;
    setState(() {
      isLoad = true;
    });
    Query query = collercton.limit(10);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      items = querySnapshot.docs;
      lastDoc = querySnapshot.docs.last;
    }

    setState(() {
      isLoad = false;
    });
  }

  getMoreData() async {
    if (isGetting || !hasData || isLoad) return;

    setState(() {
      isGetting = true;
    });

    Query query = collercton.startAfterDocument(lastDoc!).limit(10);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      items.addAll(querySnapshot.docs);
      lastDoc = querySnapshot.docs.last;
    } else {
      setState(() {
        hasData = false;
      });
    }
    setState(() {
      isGetting = false;
    });
  }

  @override
  void initState() {
    getItems();
    super.initState();

    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;

      if (maxScroll == scrollController.offset) {
        getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: hasData ? items.length + 1 : items.length,
            itemBuilder: (ctx, index) {
              if (index == items.length) {
                return const ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text("Just a second"),
                    ],
                  ),
                );
              }
              var data = items[index].get('name');
              return Card(
                child: ListTile(
                  title: Text("${index + 1}. $data"),
                ),
              );
            },
          );
  }
}
