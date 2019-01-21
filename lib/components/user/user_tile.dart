import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../pages/pages.dart';

class UserTile extends StatelessWidget {
  final UserEntity user;

  UserTile({
    Key key,
    @required this.user,
  });

  void _followUser(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(followUserAction(
      followingId: user.id,
      onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(notice.message),
            duration: notice.duration,
          )),
    ));
  }

  void _unfollowUser(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(unfollowUserAction(
      followingId: user.id,
      onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(notice.message),
            duration: notice.duration,
          )),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(user.id.toString()),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserPage(userId: user.id),
          )),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage:
            user.avatar == '' ? null : CachedNetworkImageProvider(user.avatar),
        child: user.avatar == '' ? Icon(Icons.person) : null,
      ),
      title: Text(user.username),
      subtitle: Text(user.intro),
      trailing: user.isFollowing
          ? FlatButton(
              onPressed: () => _unfollowUser(context),
              textColor: Theme.of(context).accentColor,
              child: Text('取消关注'),
            )
          : FlatButton(
              onPressed: () => _followUser(context),
              textColor: Theme.of(context).accentColor,
              child: Text('关注'),
            ),
    );
  }
}
