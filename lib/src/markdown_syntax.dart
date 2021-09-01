import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:simple_markdown_editor/widgets/markdown_parse.dart';
import 'package:markdown/markdown.dart' as md;

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
  final MarkdownTapTagCallback? onTapHastag;

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
  final MarkdownTapTagCallback? onTapHastag;

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
