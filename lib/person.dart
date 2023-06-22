import 'package:realm/realm.dart';

part 'person.g.dart';// person.g.dartは、RealmObjectを継承するクラスから自動生成されます。

@RealmModel()// @RealmModelは、RealmObjectを継承するクラスに付与するアノテーションです。
class _Person {
  late String name;// lateをつけるのは、RealmObjectはデフォルトコンストラクタを持たないためです。
}
