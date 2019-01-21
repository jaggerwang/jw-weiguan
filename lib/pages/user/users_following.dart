import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../components/components.dart';

class UsersFollowingPage extends StatelessWidget {
  final int userId;

  UsersFollowingPage({
    Key key,
    @required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
            userId: userId,
            usersFollowing: (store
                        .state.user.usersFollowing[userId.toString()] ??
                    [])
                .map<UserEntity>((v) => store.state.user.users[v.toString()])
                .toList(),
          ),
      builder: (context, vm) => Scaffold(
            appBar: AppBar(
              title: Text('关注'),
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
  final List<UserEntity> usersFollowing;

  _ViewModel({
    @required this.userId,
    @required this.usersFollowing,
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

    _loadUsersFollowing(recent: true, more: false);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadUsersFollowing();
    }
  }

  void _loadUsersFollowing({
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

    int offset;
    if (more) {
      offset = widget.vm.usersFollowing.length;
    }
    widget.store.dispatch(usersFollowingAction(
      userId: widget.vm.userId,
      offset: offset,
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
    _loadUsersFollowing(
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
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(height: 1),
            itemCount: widget.vm.usersFollowing.length,
            itemBuilder: (context, index) => UserTile(
                  key: Key(widget.vm.usersFollowing[index].id.toString()),
                  user: widget.vm.usersFollowing[index],
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
