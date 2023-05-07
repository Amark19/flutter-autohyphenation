import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Autohyphenation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController descController = TextEditingController();
  String previousText = "", currentText = "";
  dynamic _hyphenate() {
    final value = descController.value;
    final cursorPosition = descController.selection.base.offset;
    final text = value.text;
    final selection = value.selection;
    final textList = text.substring(0, selection.extentOffset).split('\n');
    currentText =
        textList.length <= 1 ? textList[0] : textList[textList.length - 2];
    if (text.substring(0, selection.extentOffset).endsWith("\n")) {
      if (currentText.length > 0 &&
          currentText[0] == "-" &&
          text.length > previousText.length) {
        final newCursorPosition = cursorPosition + 1;
        descController.value = TextEditingValue(
          text: text.substring(0, selection.extentOffset) +
              "-" +
              text.substring(selection.extentOffset, text.length),
          selection: TextSelection.collapsed(offset: newCursorPosition),
        );
      }
    }
    previousText = text;
    return descController.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: TextFormField(
              controller: descController,
              style: TextStyle(color: Colors.grey[800], fontSize: 18),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type something...',
                hintStyle: TextStyle(color: Colors.blue),
              ),
              maxLines: null,
              textInputAction: TextInputAction.newline,
              onChanged: (value) {
                descController.value = _hyphenate();
              },
            ),
          ),
        ),
      ),
    );
  }
}
