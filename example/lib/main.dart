import 'package:flutter/material.dart';
import 'package:simple_markdown_editor/simple_markdown_editor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Markdown Editor"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SecondScreen(
                    data: _controller.text,
                  ),
                ),
              );
            },
            icon: Icon(Icons.view_compact),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MarkdownFormField(
                controller: _controller,
                enableToolBar: true,
                emojiConvert: true,
                autoCloseAfterSelectEmoji: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key, required this.data}) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Markdown Parse"),
      ),
      body: MarkdownParse(
        data: data,
        onTapHastag: (String name, String match) {
          // example : #hashtag
          // name => hashtag
          // match => #hashtag
        },
        onTapMention: (String name, String match) {
          // example : @mention
          // name => mention
          // match => #mention
        },
      ),
    );
  }
}
