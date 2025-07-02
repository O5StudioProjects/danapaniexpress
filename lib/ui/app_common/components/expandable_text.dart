import 'package:danapaniexpress/core/common_imports.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;
  final TextStyle? linkStyle;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 2,
    this.style,
    this.linkStyle,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  bool _hasOverflow = false;

  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final lineHeight = widget.style?.height ?? 1.2;
        final fontSize = widget.style?.fontSize ?? 16.0;
        final maxHeight = widget.trimLines * lineHeight * fontSize;

        final didOverflow = renderBox.size.height > maxHeight;
        if (didOverflow != _hasOverflow) {
          print(didOverflow);
          setState(() => _hasOverflow = didOverflow);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = const TextStyle(fontSize: 16, height: 1.2, color: Colors.black);
    final defaultLinkStyle = const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500);

    return Column(
      crossAxisAlignment: appLanguage == URDU_LANGUAGE ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          key: _textKey,
          style: widget.style ?? defaultTextStyle,
          maxLines: _expanded ? null : widget.trimLines,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          textDirection: setTextDirection(appLanguage),
          textAlign: setTextAlignment(appLanguage),
        ),
       if (_hasOverflow)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _expanded ? 'See less' : 'See more',
                style: widget.linkStyle ?? defaultLinkStyle,
                textDirection: setTextDirection(appLanguage),
                textAlign: setTextAlignment(appLanguage),
              ),
            ),
          ),
      ],
    );
  }
}
