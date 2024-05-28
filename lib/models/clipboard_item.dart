import 'package:isar/isar.dart';

part 'clipboard_item.g.dart';

@collection
class ClipboardItem {
  Id id = Isar.autoIncrement;

  String text;

  ClipboardItem(this.text);
}