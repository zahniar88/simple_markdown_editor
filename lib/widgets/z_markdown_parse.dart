import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:simple_markdown_editor/widgets/image_network.dart';

typedef ZMarkdownTapTagCallback = void Function(
  String name,
  String fullText,
);

class ZMarkdownParse extends StatelessWidget {
  /// Creates a scrolling widget that parses and displays Markdown.
  ZMarkdownParse({
    Key? key,
    required this.data,
    this.onTapLink,
    this.onTapHastag,
    this.onTapMention,
  }) : super(key: key);

  /// The string markdown to display.
  final String data;

  /// Called when the user taps a link.
  final MarkdownTapLinkCallback? onTapLink;

  /// Called when the user taps a hashtag.
  final ZMarkdownTapTagCallback? onTapHastag;

  /// Called when the user taps a mention.
  final ZMarkdownTapTagCallback? onTapMention;

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: data,
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
        "hastag": ColoredHastagElementBuilder(onTapHastag),
        "mention": ColoredMentionElementBuilder(onTapMention),
      },
      styleSheet: MarkdownStyleSheet(
        code: TextStyle(
          color: Colors.purple,
        ),
        blockquoteDecoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(
            left: BorderSide(
              color: Colors.grey,
              width: 5,
            ),
          ),
        ),
        blockquotePadding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      ),
      onTapLink: onTapLink,
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
