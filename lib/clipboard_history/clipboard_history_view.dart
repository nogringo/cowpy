import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:cowpy/clipboard_history/clipboard_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class ClipboardHistoryView extends StatefulWidget {
  const ClipboardHistoryView({super.key});

  @override
  State<ClipboardHistoryView> createState() => _ClipboardHistoryViewState();
}

class _ClipboardHistoryViewState extends State<ClipboardHistoryView>
    with ClipboardListener {
  @override
  void initState() {
    clipboardWatcher.addListener(this);
    // start watch
    clipboardWatcher.start();
    super.initState();
  }

  @override
  void dispose() {
    clipboardWatcher.removeListener(this);
    // stop watch
    clipboardWatcher.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ClipboardHistoryController());
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DragHandleView(),
          Expanded(
            child:
                GetBuilder<ClipboardHistoryController>(builder: (controller) {
              return ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return ListTile(
                    title: Text(item.text),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  void onClipboardChanged() async {
    ClipboardHistoryController.to.onClipboardChanged();
  }
}

class DragHandleView extends StatelessWidget {
  const DragHandleView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        windowManager.startDragging();
      },
      child: ColoredBox(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 100,
            height: 8,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
