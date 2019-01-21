import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../actions/actions.dart';

class HomePage extends StatelessWidget {
  static final _bodyKey = GlobalKey<_BodyState>();

  HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
            postsFollowing: store.state.post.postsFollowing
                .map<PostEntity>((v) => store.state.post.posts[v.toString()])
                .toList(),
          ),
      builder: (context, vm) => Scaffold(
            appBar: AppBar(
              title: Text('首页'),
            ),
            body: _Body(
              key: _bodyKey,
              store: StoreProvider.of<AppState>(context),
              vm: vm,
            ),
            bottomNavigationBar: WgTabBar(tabIndex: 0),
          ),
    );
  }
}

class _ViewModel {
  final List<PostEntity> postsFollowing;

  _ViewModel({
    @required this.postsFollowing,
  });
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;

  _Body({
    Key key,
    @required this.store,
    @required this.vm,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _scrollController = ScrollController();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);

    _loadPostsFollowing(recent: true, more: false);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadPostsFollowing();
    }
  }

  void _loadPostsFollowing({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    Completer<Null> completer,
  }) {
    if (_isLoading) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoading = true;
      });
    }

    int beforeId;
    if (more && widget.vm.postsFollowing.isNotEmpty) {
      beforeId = widget.vm.postsFollowing.last.id;
    }
    int afterId;
    if (recent && widget.vm.postsFollowing.isNotEmpty) {
      afterId = widget.vm.postsFollowing.first.id;
    }
    widget.store.dispatch(postsFollowingAction(
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (posts) {
        if (!refresh) {
          setState(() {
            _isLoading = false;
          });
        }

        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoading = false;
          });
        }

        completer?.complete();

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  Future<Null> _refresh() {
    final completer = Completer<Null>();
    _loadPostsFollowing(
      more: false,
      refresh: true,
      completer: completer,
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.vm.postsFollowing.length,
            itemBuilder: (context, index) => Post(
                  key: Key(widget.vm.postsFollowing[index].id.toString()),
                  post: widget.vm.postsFollowing[index],
                ),
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
