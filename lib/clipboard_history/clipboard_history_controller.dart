import 'package:cowpy/models/clipboard_item.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

class ClipboardHistoryController extends GetxController {
  static ClipboardHistoryController get to => Get.find();

  Isar get isar => Get.find<Isar>();
  List<ClipboardItem> items = [];

  QueryBuilder<ClipboardItem, ClipboardItem, QWhere> get querySnapshot =>
      isar.clipboardItems.where();

  ClipboardHistoryController() {
    getItems();

    querySnapshot.watch().listen((clipboardItems) {
      items = clipboardItems.reversed.toList();
      update();
    });
  }

  void getItems() async {
    items = (await querySnapshot.findAll()).reversed.toList();
    update();
  }

  void onClipboardChanged() async {
    ClipboardData? newClipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    String clipboardText = newClipboardData?.text ?? "";

    if (items.isNotEmpty) {
      if (items.first.text == clipboardText) return;
    }
    print("add item");
    final newClipboardItem = ClipboardItem(clipboardText);

    await isar.writeTxn(() async {
      await isar.clipboardItems.put(newClipboardItem);
    });
  }
}
