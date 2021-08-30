import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.syntaxHighlighter,
    this.bulletBuilder,
    this.styleSheetTheme,
    this.styleSheet,
    this.imageBuilder,
    this.checkboxBuilder,
    this.builders = const <String, MarkdownElementBuilder>{},
    this.inlineSyntaxes,
    this.blockSyntaxes,
  }) : super(key: key);

  /// The string markdown to display.
  final String data;

  /// Called when the user taps a link.
  final MarkdownTapLinkCallback? onTapLink;

  /// Called when the user taps a hashtag.
  final ZMarkdownTapTagCallback? onTapHastag;

  /// Called when the user taps a mention.
  final ZMarkdownTapTagCallback? onTapMention;

  /// How the scroll view should respond to user input.
  ///
  /// See also: [ScrollView.physics]
  final ScrollPhysics? physics;

  /// n object that can be used to control the position to which this scroll view is scrolled.
  ///
  /// See also: [ScrollView.controller]
  final ScrollController? controller;

  /// Whether the extent of the scroll view in the scroll direction should be determined by the contents being viewed.
  ///
  /// See also: [ScrollView.shrinkWrap]
  final bool shrinkWrap;

  /// Creates a format [TextSpan] given a string.
  ///
  /// Used by [MarkdownWidget] to highlight the contents of `pre` elements.
  final SyntaxHighlighter? syntaxHighlighter;

  /// Signature for custom bullet widget.
  ///
  /// Used by [MarkdownWidget.bulletBuilder]
  final MarkdownBulletBuilder? bulletBuilder;

  /// Enum to specify which theme being used when creating [MarkdownStyleSheet]
  ///
  /// [material] - create MarkdownStyleSheet based on MaterialTheme
  /// [cupertino] - create MarkdownStyleSheet based on CupertinoTheme
  /// [platform] - create MarkdownStyleSheet based on the Platform where the
  /// is running on. Material on Android and Cupertino on iOS
  final MarkdownStyleSheetBaseTheme? styleSheetTheme;

  /// Defines which [TextStyle] objects to use for which Markdown elements.
  final MarkdownStyleSheet? styleSheet;

  /// Signature for custom image widget.
  ///
  /// Used by [MarkdownWidget.imageBuilder]
  final MarkdownImageBuilder? imageBuilder;

  /// Signature for custom checkbox widget.
  ///
  /// Used by [MarkdownWidget.checkboxBuilder]
  final MarkdownCheckboxBuilder? checkboxBuilder;

  final Map<String, MarkdownElementBuilder> builders;
  final List<md.InlineSyntax>? inlineSyntaxes;
  final List<md.BlockSyntax>? blockSyntaxes;

  @override
  Widget build(BuildContext context) {
    return Markdown(
      key: Key("defaultmarkdownformatter"),
      data: data,
      selectable: true,
      padding: EdgeInsets.all(10),
      physics: physics,
      controller: controller,
      shrinkWrap: shrinkWrap,
      syntaxHighlighter: syntaxHighlighter,
      bulletBuilder: bulletBuilder,
      styleSheetTheme: styleSheetTheme,
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
        if (blockSyntaxes != null) ...blockSyntaxes!
      ],
      inlineSyntaxes: [
        ColoredHastagSyntax(),
        ColoredMentionSyntax(),
        if (inlineSyntaxes != null) ...inlineSyntaxes!
      ],
      builders: {
        "hastag": ColoredHastagElementBuilder(onTapHastag),
        "mention": ColoredMentionElementBuilder(onTapMention),
        ...builders
      },
      styleSheet: styleSheet != null
          ? styleSheet
          : MarkdownStyleSheet(
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
              blockquotePadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            ),
      onTapLink: onTapLink,
      imageBuilder: imageBuilder != null
          ? imageBuilder
          : (Uri uri, String? title, String? alt) {
              return ImageNetworkMarkdown(
                uri: uri.toString(),
                title: title,
              );
            },
      checkboxBuilder: checkboxBuilder != null
          ? checkboxBuilder
          : (bool value) {
              return Icon(
                value
                    ? FontAwesomeIcons.solidCheckSquare
                    : FontAwesomeIcons.square,
                size: 14,
                color: value ? Colors.green : Colors.grey,
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
