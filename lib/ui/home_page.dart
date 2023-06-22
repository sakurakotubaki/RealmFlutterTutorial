import 'dart:async';

import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:realm_app/person.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Realm realm;// Realmインスタンスを保持するための変数
  final _nameController = TextEditingController();
  final _personsController = StreamController<List<Person>>.broadcast();

  @override
  void initState() {
    super.initState();
    final config = Configuration.local([Person.schema]);
    realm = Realm(config);
    _fetchPersons();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _personsController.close();
    super.dispose();
  }

  // _fetchPersonsは、RealmからPersonのリストを取得し、_personsControllerに追加するメソッド
  void _fetchPersons() {
    final persons = realm.all<Person>().toList();
    _personsController.add(persons);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realm Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '名前'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  if (_nameController.text.isEmpty) {
                    throw ('名前が入力されてません!');
                  }

                  var person = Person(_nameController.text);
                  realm.write(() {
                    realm.add(person);
                  });
                  _nameController.clear();
                  _fetchPersons();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              child: const Text('Add Person'),
            ),
            Expanded(
              child: StreamBuilder<List<Person>>(
                stream: _personsController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final person = snapshot.data![index];
                          return ListTile(
                            title: Text(person.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                realm.write(() {
                                  realm.delete(person);
                                });
                                _fetchPersons();
                              },
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(
                      child: Text('データがありません'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
