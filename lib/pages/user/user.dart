import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../theme.dart';
import '../../utils/number.dart';
import '../../components/components.dart';

class UserPage extends StatefulWidget {
  final int userId;

  UserPage({
    Key key,
    @required this.userId,
  }) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _tabs = ['动态', '喜欢', '关注'];
  static final _bodyKey = GlobalKey<_BodyState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        user: store.state.user.users[widget.userId.toString()] ??
            UserEntity(id: widget.userId),
        postsPublished:
            (store.state.post.postsPublished[widget.userId.toString()] ?? [])
                .map<PostEntity>((v) => store.state.post.posts[v.toString()])
                .toList(),
        postsLiked:
            (store.state.post.postsLiked[widget.userId.toString()] ?? [])
                .map<PostEntity>((v) => store.state.post.posts[v.toString()])
                .toList(),
        usersFollowing:
            (store.state.user.usersFollowing[widget.userId.toString()] ?? [])
                .map<UserEntity>((v) => store.state.user.users[v.toString()])
                .toList(),
      ),
      builder: (context, vm) => Scaffold(
        body: DefaultTabController(
          length: _tabs.length,
          child: _Body(
            key: _bodyKey,
            store: StoreProvider.of<AppState>(context),
            vm: vm,
            tabs: _tabs,
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final UserEntity user;
  final List<PostEntity> postsPublished;
  final List<PostEntity> postsLiked;
  final List<UserEntity> usersFollowing;

  _ViewModel({
    @required this.user,
    @required this.postsPublished,
    @required this.postsLiked,
    @required this.usersFollowing,
  });
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;
  final List<String> tabs;

  _Body({
    Key key,
    @required this.store,
    @required this.vm,
    @required this.tabs,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final scrollController = ScrollController();
  var _isLoading = false;
  var _isLoadingPostsPublished = false;
  var _isLoadingPostsLiked = false;
  var _isLoadingUsersFollowing = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);

    _loadUserInfo();
    _loadPostsPublished(recent: true, more: false);
    _loadPostsLiked(recent: true, more: false);
    _loadUsersFollowing(recent: true, more: false);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    super.dispose();
  }

  void _scrollListener() {
    final index = DefaultTabController.of(context).index;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (index == 0) {
        _loadPostsPublished();
      } else if (index == 1) {
        _loadPostsLiked();
      } else if (index == 2) {
        _loadUsersFollowing();
      }
    }
  }

  void _loadUserInfo() {
    widget.store.dispatch(userInfoAction(
      userId: widget.vm.user.id,
      onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(notice.message),
        duration: notice.duration,
      )),
    ));
  }

  void _loadPostsPublished({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    Completer<Null> completer,
  }) {
    if (_isLoadingPostsPublished) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoadingPostsPublished = true;
      });
    }

    int beforeId;
    if (more && widget.vm.postsPublished.isNotEmpty) {
      beforeId = widget.vm.postsPublished.last.id;
    }
    int afterId;
    if (recent && widget.vm.postsPublished.isNotEmpty) {
      afterId = widget.vm.postsPublished.first.id;
    }
    widget.store.dispatch(postsPublishedAction(
      userId: widget.vm.user.id,
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (posts) {
        if (!refresh) {
          setState(() {
            _isLoadingPostsPublished = false;
          });
        }

        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoadingPostsPublished = false;
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

  void _loadPostsLiked({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    Completer<Null> completer,
  }) {
    if (_isLoadingPostsLiked) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoadingPostsLiked = true;
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
      userId: widget.vm.user.id,
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (posts) {
        if (!refresh) {
          setState(() {
            _isLoadingPostsLiked = false;
          });
        }

        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoadingPostsLiked = false;
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

  void _loadUsersFollowing({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    Completer<Null> completer,
  }) {
    if (_isLoadingUsersFollowing) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoadingUsersFollowing = true;
      });
    }

    int offset;
    if (more) {
      offset = widget.vm.usersFollowing.length;
    }
    widget.store.dispatch(usersFollowingAction(
      userId: widget.vm.user.id,
      offset: offset,
      refresh: refresh,
      onSucceed: (posts) {
        if (!refresh) {
          setState(() {
            _isLoadingUsersFollowing = false;
          });
        }

        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoadingUsersFollowing = false;
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

  void _followUser() {
    setState(() {
      _isLoading = true;
    });

    widget.store.dispatch(followUserAction(
        followingId: widget.vm.user.id,
        onSucceed: () {
          setState(() {
            _isLoading = false;
          });
        },
        onFailed: (notice) {
          setState(() {
            _isLoading = false;
          });

          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(notice.message),
            duration: notice.duration,
          ));
        }));
  }

  void _unfollowUser() {
    setState(() {
      _isLoading = true;
    });

    widget.store.dispatch(unfollowUserAction(
      followingId: widget.vm.user.id,
      onSucceed: () {
        setState(() {
          _isLoading = false;
        });
      },
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  void _followOrUnfollowUser() {
    if (widget.vm.user.isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  Widget _buildSilverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      child: SliverAppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: _followOrUnfollowUser,
            child: Text(
              widget.vm.user.isFollowing ? '取消关注' : '关注',
              style: TextStyle(
                color: WgTheme.whiteNormal,
                fontSize: WgTheme.fontSizeLarge,
              ),
            ),
          ),
        ],
        expandedHeight: MediaQuery.of(context).size.width * 3 / 4,
        forceElevated: innerBoxIsScrolled,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            image: widget.vm.user.avatar == ''
                ? null
                : DecorationImage(
                    image: CachedNetworkImageProvider(widget.vm.user.avatar),
                    fit: BoxFit.cover,
                  ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  widget.vm.user.username,
                  style: TextStyle(
                    color: WgTheme.whiteLight,
                    fontSize: WgTheme.fontSizeLarge,
                    fontWeight: WgTheme.fontWeightHeavy,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  widget.vm.user.intro,
                  maxLines: 3,
                  style: TextStyle(color: WgTheme.whiteNormal),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: WgTheme.whiteNormal),
                    children: <TextSpan>[
                      TextSpan(
                        style: TextStyle(color: WgTheme.whiteLight),
                        text: numberWithProperUnit(widget.vm.user.postCount),
                      ),
                      TextSpan(text: ' 动态 '),
                      TextSpan(
                        style: TextStyle(color: WgTheme.whiteLight),
                        text: numberWithProperUnit(widget.vm.user.likeCount),
                      ),
                      TextSpan(text: ' 喜欢 '),
                      TextSpan(
                        style: TextStyle(color: WgTheme.whiteLight),
                        text:
                            numberWithProperUnit(widget.vm.user.followingCount),
                      ),
                      TextSpan(text: ' 关注 '),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottom: TabBar(
          tabs: widget.tabs.map<Widget>((name) => Tab(text: name)).toList(),
        ),
      ),
    );
  }

  Future<Null> _refreshPostsPublished() {
    final completer = Completer<Null>();
    _loadPostsPublished(
      more: false,
      refresh: true,
      completer: completer,
    );
    return completer.future;
  }

  Widget _buildPostsPublished(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refreshPostsPublished,
          child: CustomScrollView(
            key: PageStorageKey<String>('postsPublished'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Post(
                    key: Key(widget.vm.postsPublished[index].id.toString()),
                    post: widget.vm.postsPublished[index],
                  ),
                  childCount: widget.vm.postsPublished.length,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isLoadingPostsPublished,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Future<Null> _refreshPostsLiked() {
    final completer = Completer<Null>();
    _loadPostsLiked(
      more: false,
      refresh: true,
      completer: completer,
    );
    return completer.future;
  }

  Widget _buildPostsLiked(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refreshPostsLiked,
          child: CustomScrollView(
            key: PageStorageKey<String>('postsLiked'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Post(
                    key: Key(widget.vm.postsLiked[index].id.toString()),
                    post: widget.vm.postsLiked[index],
                  ),
                  childCount: widget.vm.postsLiked.length,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isLoadingPostsLiked,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Future<Null> _refreshUsersFollowing() {
    final completer = Completer<Null>();
    _loadUsersFollowing(
      more: false,
      refresh: true,
      completer: completer,
    );
    return completer.future;
  }

  Widget _buildUsersFollowing(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refreshUsersFollowing,
          child: CustomScrollView(
            key: PageStorageKey<String>('usersFollowing'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => UserTile(
                    key: Key(widget.vm.usersFollowing[index].id.toString()),
                    user: widget.vm.usersFollowing[index],
                  ),
                  childCount: widget.vm.usersFollowing.length,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isLoadingUsersFollowing,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      children: widget.tabs
          .map<Widget>((name) => SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (context) {
                    if (name == '动态') {
                      return _buildPostsPublished(context);
                    } else if (name == '喜欢') {
                      return _buildPostsLiked(context);
                    } else if (name == '关注') {
                      return _buildUsersFollowing(context);
                    } else {
                      return null;
                    }
                  },
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            _buildSilverAppBar(context, innerBoxIsScrolled),
          ],
          body: _buildTabBarView(),
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
