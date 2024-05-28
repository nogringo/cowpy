import 'package:cowpy/app.dart';
import 'package:cowpy/models/clipboard_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // window
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(300, 500),
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // await windowManager.setResizable(false);
    await windowManager.setAsFrameless();
    await windowManager.hide();
  });

  // hot keys
  if (kDebugMode) {
    await hotKeyManager.unregisterAll();
  }

  await hotKeyManager.register(
    HotKey(
      key: PhysicalKeyboardKey.keyV,
      modifiers: [
        HotKeyModifier.control,
        HotKeyModifier.alt,
      ],
    ),
    keyDownHandler: (_) async {
      await windowManager.show();
      windowManager.focus();
    },
  );
  await hotKeyManager.register(
    HotKey(
      key: PhysicalKeyboardKey.escape,
    ),
    keyDownHandler: (_) => windowManager.hide(),
  );

  // database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ClipboardItemSchema],
    directory: dir.path,
  );
  Get.put(isar);
  await isar.writeTxn(() async {
    await isar.clipboardItems.clear();
  });

  runApp(const App());
}
