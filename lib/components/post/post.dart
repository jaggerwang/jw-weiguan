import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../theme.dart';
import '../common/video_player.dart';
import '../../pages/pages.dart';
import '../../actions/actions.dart';
import '../../utils/number.dart';

class Post extends StatefulWidget {
  final PostEntity post;

  Post({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  var _isLoading = false;

  void _likePost(BuildContext context, _ViewModel vm) {
    setState(() {
      _isLoading = true;
    });
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(likePostAction(
      postId: widget.post.id,
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

  void _unlikePost(BuildContext context, _ViewModel vm) {
    setState(() {
      _isLoading = true;
    });
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(unlikePostAction(
      postId: widget.post.id,
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

  void _deletePost(BuildContext context, _ViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
            title: Text('确认删除'),
            content: Text('是否确认删除动态？'),
            actions: <Widget>[
              FlatButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                child: Text('取消'),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  Navigator.of(context, rootNavigator: true).pop();
                  final store = StoreProvider.of<AppState>(context);
                  store.dispatch(deletePostAction(
                    post: widget.post,
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
                },
                child: Text('确认'),
              ),
            ],
          ),
    );
  }

  Widget _buildHeader(BuildContext context, _ViewModel vm) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: Feedback.wrapForTap(
                    () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                UserPage(userId: widget.post.creatorId),
                          ),
                        ),
                    context,
                  ),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: vm.creator.avatar == ''
                        ? null
                        : CachedNetworkImageProvider(vm.creator.avatar),
                    child: vm.creator.avatar == '' ? Icon(Icons.person) : null,
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: Feedback.wrapForTap(
                      () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserPage(userId: widget.post.creatorId),
                            ),
                          ),
                      context,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        vm.creator.username,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: WgTheme.fontSizeLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.post.createdAt.toString().substring(0, 16),
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Text(
        text,
        style: Theme.of(context).textTheme.body1,
      ),
    );
  }

  Widget _buildImages(List<PostImage> images) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double margin = 5;
        final columns = 3;
        final width = (constraints.maxWidth - (columns - 1) * margin) / columns;
        final height = width;

        return Wrap(
          spacing: margin,
          runSpacing: margin,
          children: images
              .asMap()
              .entries
              .map<Widget>((entry) => GestureDetector(
                  onTap: Feedback.wrapForTap(
                    () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ImagesPlayerPage(
                                images: images
                                    .map<ImageEntity>((image) => image.original)
                                    .toList(),
                                initialIndex: entry.key,
                              ),
                        )),
                    context,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: entry.value.thumb.url,
                    fit: BoxFit.cover,
                    width: width,
                    height: height,
                  )))
              .toList(),
        );
      },
    );
  }

  Widget _buildVideo(VideoEntity video) {
    return VideoPlayerWithCover(video: widget.post.video);
  }

  Widget _buildBody(BuildContext context) {
    switch (widget.post.type) {
      case PostType.text:
        return Column(
          children: <Widget>[
            _buildText(widget.post.text),
          ],
        );
      case PostType.image:
        return Column(
          children: <Widget>[
            _buildText(widget.post.text),
            _buildImages(widget.post.images),
          ],
        );
      case PostType.video:
        return Column(
          children: <Widget>[
            _buildText(widget.post.text),
            _buildVideo(widget.post.video),
          ],
        );
      default:
        return null;
    }
  }

  Widget _buildFooter(BuildContext context, _ViewModel vm) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.whatshot,
                  color: Theme.of(context).hintColor,
                  size: 20,
                ),
                Text(
                  '${numberWithProperUnit(widget.post.likeCount)}',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              widget.post.isLiked
                  ? GestureDetector(
                      onTap: Feedback.wrapForTap(
                        () => _unlikePost(context, vm),
                        context,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.favorite,
                          size: 20,
                          color: WgTheme.redLight,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: Feedback.wrapForTap(
                        () => _likePost(context, vm),
                        context,
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Icon(
                          Icons.favorite_border,
                          size: 20,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
              Visibility(
                visible: widget.post.creatorId == vm.user.id,
                child: GestureDetector(
                  onTap: Feedback.wrapForTap(
                    () => _deletePost(context, vm),
                    context,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
            creator: store.state.user.users[widget.post.creatorId.toString()] ??
                UserEntity(),
            user: store.state.account.user,
          ),
      builder: (context, vm) => Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    _buildHeader(context, vm),
                    Divider(height: 1),
                    _buildBody(context),
                    Divider(height: 1),
                    _buildFooter(context, vm),
                  ],
                ),
              ),
              Visibility(
                visible: _isLoading,
                child: CircularProgressIndicator(),
              ),
            ],
          ),
    );
  }
}

class _ViewModel {
  final UserEntity creator;
  final UserEntity user;

  _ViewModel({
    @required this.creator,
    @required this.user,
  });
}
