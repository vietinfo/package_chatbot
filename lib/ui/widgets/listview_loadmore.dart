import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'disable_glow_listview.dart';

class ListViewLoadMore extends StatefulWidget {
  final Axis? scrollDirection;
  final bool? reverse;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;
  final int? itemCount;
  final DragStartBehavior? dragStartBehavior;
  @required
  final Function? funcLoadMore;
  @required
  final IndexedWidgetBuilder?itemBuilder;
  final Stream<bool>? isLoadMore;
  final Stream<bool>? showLoading;
  const ListViewLoadMore(
      {
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.physics,
      this.shrinkWrap = false,
      this.itemBuilder,
      this.itemCount,
      this.dragStartBehavior = DragStartBehavior.start,
      this.funcLoadMore,
      this.isLoadMore,
      this.showLoading});

  @override
  _ListViewLoadMoreState createState() => _ListViewLoadMoreState();
}

class _ListViewLoadMoreState extends State<ListViewLoadMore> {
  ScrollController? _scrollController;
  final offsetVisibleThreshold = 10.0;
  bool _isload = true;

  @override
  void initState() {
    // TODO: implement initState
    widget.isLoadMore!.listen((event) {
      _isload = event;
    });
    _scrollController = ScrollController()..addListener(funcExcute);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ScrollConfiguration(
            behavior: DisableGlowListViewCustom(),
            child: ListView.builder(
              controller: _scrollController,
              key: widget.key,
              itemBuilder: widget.itemBuilder!,
              itemCount: widget.itemCount,
              shrinkWrap: widget.shrinkWrap!,
              physics: widget.physics,
              reverse: widget.reverse!,
              scrollDirection: widget.scrollDirection!,
              dragStartBehavior: widget.dragStartBehavior!,
            ),
          ),
        ),
        StreamBuilder<bool>(
            stream: widget.showLoading,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!)
                return Container(
                  height: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Color(0xff3eacf0)),
                  child: const Text(
                    'Đang tải dữ liệu',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                );
              else
                return Container();
            })
      ],
    );
  }

  void funcExcute() {
    if (!_isload)
      return;
    if (_scrollController!.offset + offsetVisibleThreshold >=
        _scrollController!.position.maxScrollExtent) {
      widget.funcLoadMore!();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController!.dispose();
    super.dispose();
  }
}
