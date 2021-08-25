import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:simple_markdown_editor/src/image_network.dart';

typedef ZMarkdownTapTagCallback = void Function(
  String name,
  String fullText,
);

class ZMarkdownParse extends StatelessWidget {
  const ZMarkdownParse({
    Key? key,
    required String data,
    MarkdownTapLinkCallback? onTapLink,
    ZMarkdownTapTagCallback? onTapHastag,
    ZMarkdownTapTagCallback? onTapMention,
  })  : this._data = data,
        this._onTapLink = onTapLink,
        this._onTapHastag = onTapHastag,
        this._onTapMention = onTapMention,
        super(key: key);

  final String _data;
  final MarkdownTapLinkCallback? _onTapLink;
  final ZMarkdownTapTagCallback? _onTapHastag;
  final ZMarkdownTapTagCallback? _onTapMention;

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: _data,
      selectable: true,
      padding: EdgeInsets.all(10),
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [
          md.EmojiSyntax(),
          md.AutolinkExtensionSyntax(),
          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
        ],
      ),
      blockSyntaxes: [
        md.FencedCodeBlockSyntax(),
      ],
      inlineSyntaxes: [
        ColoredHastagSyntax(),
        ColoredMentionSyntax(),
      ],
      builders: {
        "hastag": ColoredHastagElementBuilder(_onTapHastag),
        "mention": ColoredMentionElementBuilder(_onTapMention),
      },
      styleSheet: MarkdownStyleSheet(
        code: TextStyle(
          color: Colors.purple,
        ),
      ),
      onTapLink: _onTapLink,
      imageBuilder: (Uri uri, String? title, String? alt) {
        return ImageNetworkMarkdown(
          uri: uri.toString(),
          title: title,
        );
      },
    );
  }
}

// Colored hastag syntax
class ColoredHastagSyntax extends md.InlineSyntax {
  ColoredHastagSyntax({String pattern = r'#[^\s#]+'}) : super(pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final tag = match.group(0).toString();
    md.Element hastagElement = md.Element.text("hastag", tag);
    parser.addNode(hastagElement);
    return true;
  }
}

// hastag element builder
class ColoredHastagElementBuilder extends MarkdownElementBuilder {
  final ZMarkdownTapTagCallback? onTapHastag;

  ColoredHastagElementBuilder(this.onTapHastag);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return GestureDetector(
      onTap: () {
        onTapHastag?.call(
          element.textContent.replaceFirst("#", ""),
          element.textContent,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.blue.withOpacity(0.1),
        ),
        child: Text(
          element.textContent,
          style: TextStyle(
            color: Colors.blue[700],
          ),
        ),
      ),
    );
  }
}

// Colored mention syntax
class ColoredMentionSyntax extends md.InlineSyntax {
  ColoredMentionSyntax({String pattern = r'\@[^\s@]+'}) : super(pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final tag = match.group(0).toString();
    md.Element hastagElement = md.Element.text("mention", tag);
    parser.addNode(hastagElement);
    return true;
  }
}

// mention element builder
class ColoredMentionElementBuilder extends MarkdownElementBuilder {
  final ZMarkdownTapTagCallback? onTapHastag;

  ColoredMentionElementBuilder(this.onTapHastag);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return GestureDetector(
      onTap: () {
        onTapHastag?.call(
          element.textContent.replaceFirst("@", ""),
          element.textContent,
        );
      },
      child: Text(
        element.textContent + " ",
        style: TextStyle(
          color: Colors.blue[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
