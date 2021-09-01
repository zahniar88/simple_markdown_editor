# simple_markdown_editor


[![Support Me](https://img.shields.io/badge/Donate-Paypal-blue.svg)](https://paypal.me/zahniaradirahman?locale.x=en_US)
[![Support Me](https://img.shields.io/badge/Donate-Saweria-orange.svg)](https://saweria.co/zahniar88)
[![GitHub stars](https://img.shields.io/github/stars/zahniar88/simple_markdown_editor?color=green)](https://github.com/zahniar88/simple_markdown_editor)
[![undo](https://img.shields.io/pub/v/simple_markdown_editor.svg?color=teal)](https://pub.dev/packages/simple_markdown_editor)
![GitHub](https://img.shields.io/github/license/zahniar88/simple_markdown_editor?color=red)
![GitHub repo size](https://img.shields.io/github/repo-size/zahniar88/simple_markdown_editor?label=size&color=brightgreen)


Simple markdown editor library For flutter. 
For demo video, you can see it at this url [Demo](https://youtu.be/aYBeXXDoNPo)

## Features
- [x] Convert to Bold, Italic, Strikethrough
- [x] Convert to Code, Quote, Links
- [x] Convert to Heading (H1, H2, H3).
- [x] Convert to unorder list and checkbox list
- [x] Support multiline convert
- [x] Support auto convert emoji

## Usage

Add dependencies to your `pubspec.yaml`

```yaml
dependencies:
    simple_markdown_editor: ^version
```
> **Recomended Version:** >= ^0.1.4+1

Run `flutter pub get` to install.

## How it works

Import library

```dart
import 'package:simple_markdown_editor/simple_markdown_editor.dart';
```

Initialize controller and focus node. These controllers and focus nodes are optional because if you don't create them, the editor will create them themselves

```dart
TextEditingController _controller = TextEditingController();
FocusNode _focusNode = FocusNode();
```

Show widget for editor

```dart
// editable text with toolbar
MarkdownFormField(
    controller: _controller,
    enableToolBar: true,
    emojiConvert: true,
    autoCloseAfterSelectEmoji: false,
)

// editable text without toolbar
MarkdownField(
    controller: _controller,
    emojiConvert: true,
)
```

if you want to parse text into markdown you can use the following widget:

```dart
String data = '''
**bold**
*italic*

#hashtag
@mention
'''

MarkdownParse(
    data: data,
    onTapHastag: (String name, String match) {
        // name => hashtag
        // match => #hashtag
    },
    onTapMention: (String name, String match) {
        // name => mention
        // match => #mention
    },
)
```

Result Editor:

<img src="https://i.ibb.co/3FPFxCM/Simulator-Screen-Recording-i-Phone-12-Pro-Max-2021-09-01-at-22-53-01.gif" alt="screenshoot" width="300" />

___
