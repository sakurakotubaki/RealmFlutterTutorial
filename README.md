# FlutterでRealmを使う
**やること**
1. パッケージを追加する
```
flutter pub add realm
```

2. モデルクラスを作る。今回はPersonというクラスを作ります。 

```dart:perons.dart
import 'package:realm/realm.dart';

part 'person.g.dart';// person.g.dartは、RealmObjectを継承するクラスから自動生成されます。

@RealmModel()// @RealmModelは、RealmObjectを継承するクラスに付与するアノテーションです。
class _Person {
  late String name;// lateをつけるのは、RealmObjectはデフォルトコンストラクタを持たないためです。
}
```
3. Personというクラスを作ったら、Realmを使うのに、必要なファイルを自動生成します

ファイルを自動生成するコマンド
```
dart run realm generate
```

```dart:dart:person.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Person extends _Person with RealmEntity, RealmObjectBase, RealmObject {
  Person(
    String name,
  ) {
    RealmObjectBase.set(this, 'name', name);
  }

  Person._();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<Person>> get changes =>
      RealmObjectBase.getChanges<Person>(this);

  @override
  Person freeze() => RealmObjectBase.freezeObject<Person>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Person._);
    return const SchemaObject(ObjectType.realmObject, Person, 'Person', [
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}
```