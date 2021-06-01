import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final BehaviorSubject<bool> isLoadMoreController =
      BehaviorSubject<bool>.seeded(true);
  Stream<bool> get isLoadMore => isLoadMoreController.stream;

  final BehaviorSubject<bool> showLoadingController =
      BehaviorSubject<bool>.seeded(false);
  Stream<bool> get showLoading => showLoadingController.stream;

  @mustCallSuper
  void dispose() {
    isLoadMoreController.close();
    showLoadingController.close();
  }
}

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  const BlocProvider({
    required this.child,
    required this.bloc,
  });

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BaseBloc>(BuildContext context) {
    final BlocProvider<T> provider =
        context.findAncestorWidgetOfExactType<BlocProvider<T>>()!;
    return provider.bloc;
  }
}

class _BlocProviderState<T> extends State<BlocProvider<BaseBloc>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
