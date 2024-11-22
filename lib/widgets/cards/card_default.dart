import 'package:flutter/material.dart';

class ModCard extends StatefulWidget {
  final Widget header;
  final List<Widget>? toolbar;
  final Widget content;
  final Widget? footer;
  final Color headerColor;
  final Color contentColor;
  final Color footerColor;
  final bool isAccordion;
  final bool showFooterWhenCollapsed;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double borderRadius;

  const ModCard({
    super.key,
    required this.header,
    this.toolbar,
    required this.content,
    this.footer,
    this.headerColor = Colors.transparent,
    this.contentColor = Colors.transparent,
    this.footerColor = Colors.transparent,
    this.isAccordion = false,
    this.showFooterWhenCollapsed = false,
    this.margin = const EdgeInsets.all(8.0),
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 8.0,
  });

  @override
  ModCardState createState() => ModCardState();
}

class ModCardState extends State<ModCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 5,
        margin: widget.margin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Column(
          mainAxisSize:
              widget.isAccordion ? MainAxisSize.min : MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: widget.isAccordion
                  ? () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.headerColor,
                  borderRadius: widget.headerColor != Colors.transparent
                      ? BorderRadius.only(
                          topLeft: Radius.circular(widget.borderRadius),
                          topRight: Radius.circular(widget.borderRadius),
                        )
                      : null,
                ),
                padding: widget.padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: widget.header,
                    ),
                    if (widget.toolbar != null || widget.isAccordion)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.toolbar != null) ...widget.toolbar!,
                          if (widget.isAccordion)
                            Icon(_isExpanded
                                ? Icons.expand_less
                                : Icons.expand_more),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: _isExpanded || !widget.isAccordion
                  ? Container(
                      color: widget.contentColor,
                      width: double.infinity,
                      child: Padding(
                        padding: widget.padding,
                        child: widget.content,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            if (widget.footer != null &&
                (!widget.isAccordion ||
                    (widget.isAccordion &&
                        (widget.showFooterWhenCollapsed || _isExpanded))))
              Container(
                decoration: BoxDecoration(
                  color: widget.footerColor,
                  borderRadius: widget.footerColor != Colors.transparent
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(widget.borderRadius),
                          bottomRight: Radius.circular(widget.borderRadius),
                        )
                      : null,
                ),
                width: double.infinity,
                child: Padding(
                  padding: widget.padding,
                  child: widget.footer,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
