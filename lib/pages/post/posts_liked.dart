import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../components/components.dart';

class PostsLikedPage extends StatelessWidget {
  final int userId;

  PostsLikedPage({
    Key key,
    @required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
            userId: userId,
            postsLiked: (store.state.post.postsLiked[userId.toString()] ?? [])
                .map<PostEntity>((v) => store.state.post.posts[v.toString()])
                .toList(),
          ),
      builder: (context, vm) => Scaffold(
            appBar: AppBar(
              title: Text('喜欢'),
            ),
            body: _Body(
              store: StoreProvider.of<AppState>(context),
              vm: vm,
            ),
          ),
    );
  }
}

class _ViewModel {
  final int userId;
  final List<PostEntity> postsLiked;

  _ViewModel({
    @required this.userId,
    @required this.postsLiked,
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

    _loadPostsLiked(recent: true, more: false);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadPostsLiked();
    }
  }

  void _loadPostsLiked({
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
    if (more && widget.vm.postsLiked.isNotEmpty) {
      beforeId = widget.vm.postsLiked.last.id;
    }
    int afterId;
    if (recent && widget.vm.postsLiked.isNotEmpty) {
      afterId = widget.vm.postsLiked.first.id;
    }
    widget.store.dispatch(postsLikedAction(
      userId: widget.vm.userId,
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (posts) {
        setState(() {
          _isLoading = false;
        });

        completer?.complete();
      },
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });

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
    _loadPostsLiked(
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
            itemCount: widget.vm.postsLiked.length,
            itemBuilder: (context, index) => Post(
                  key: Key(widget.vm.postsLiked[index].id.toString()),
                  post: widget.vm.postsLiked[index],
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
