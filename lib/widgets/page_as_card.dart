import 'package:flutter/material.dart';

/// A page with transparency
/// 
/// - On page header, we can see previous page
/// - Scroll on top, pop to previous page
/// 
class PageAsCard extends StatefulWidget {
  final Widget content;

  PageAsCard({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  _PageAsCardState createState() => _PageAsCardState();
}

class _PageAsCardState extends State<PageAsCard> {
  bool canPop = true;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        // Android
        if (notification is OverscrollNotification &&
            notification.dragDetails != null &&
            notification.overscroll < -5) {
          Navigator.of(context).pop();
          return false;
          // iOS
        } else if (notification.metrics.pixels <
                notification.metrics.minScrollExtent - 25 &&
            canPop) {
          canPop = false;
          Navigator.of(context).pop();
          return false;
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 170,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              flexibleSpace: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: FlexibleSpaceBar(),
              ),
            ),
            SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: widget.content,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
