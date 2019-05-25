import 'dart:async';
import 'dart:math';

final _random = Random();

final _user1 = {
  'id': 1,
  'username': 'jaggerwang',
  'intro': 'Coding for Free',
  'avatar':
      'https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/avatar-1.jpg',
  'mobile': '18666668888',
  'email': 'jaggerwang@weiguan.app',
  'postCount': 100,
  'likeCount': 1000,
  'followingCount': 10,
  'isFollowing': false,
  'createdAt': '2018-06-02T06:52:56Z',
};

final _user2 = {
  'id': 2,
  'username': '天火',
  'intro': '变形金刚',
  'avatar': '',
  'mobile': '18666660000',
  'email': 'tianhuo@weiguan.app',
  'postCount': 200,
  'likeCount': 2000,
  'followingCount': 20,
  'isFollowing': false,
  'createdAt': '2018-06-02T06:52:56Z',
};

final _user3 = {
  'id': 3,
  'username': '灭霸',
  'intro': '复联3',
  'avatar': '',
  'mobile': '18666661111',
  'email': 'meiba@weiguan.app',
  'postCount': 300,
  'likeCount': 3000,
  'followingCount': 30,
  'isFollowing': false,
  'createdAt': '2018-06-02T06:52:56Z',
};

final _users = [_user1, _user2, _user3];

final _textPost = {
  "id": 1,
  "type": "text",
  "text":
      "Flutter 是 Google 在 2017 I/O 大会上推出的全新 UI 框架，目前主打移动平台，包括 Android 和 iOS，未来还会扩展到其它平台，包括桌面平台。经过一年多时间的发展，Flutter 团队于 2018/12/4 号正式释放出了 1.0 版本",
  "images": null,
  "video": null,
  "likeCount": 0,
  "isLiked": false,
  "creatorId": 1,
  "createdAt": "2019-01-15T12:57:15+08:00",
  "creator": _user1,
};

final _imagePost = {
  "id": 2,
  "type": "image",
  "text": "",
  "images": [
    {
      "original": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-1.jpg",
        "width": 1280,
        "height": 1393
      },
      "thumb": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-1-thumb.jpg",
        "width": 540,
        "height": 588
      }
    },
    {
      "original": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-2.jpg",
        "width": 1280,
        "height": 720
      },
      "thumb": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-2-thumb.jpg",
        "width": 540,
        "height": 360
      }
    },
    {
      "original": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-3.jpg",
        "width": 1280,
        "height": 720
      },
      "thumb": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-3-thumb.jpg",
        "width": 540,
        "height": 360
      }
    },
    {
      "original": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-4.jpg",
        "width": 1280,
        "height": 608
      },
      "thumb": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-4-thumb.jpg",
        "width": 540,
        "height": 304
      }
    },
    {
      "original": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-5.jpg",
        "width": 1280,
        "height": 720
      },
      "thumb": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-5-thumb.jpg",
        "width": 540,
        "height": 360
      }
    },
    {
      "original": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-6.jpg",
        "width": 1280,
        "height": 720
      },
      "thumb": {
        "url":
            "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/image/post-image-6-thumb.jpg",
        "width": 540,
        "height": 360
      }
    },
  ],
  "video": null,
  "likeCount": 165077,
  "isLiked": false,
  "creatorId": 2,
  "createdAt": "2018-06-02T11:09:04+08:00",
  "creator": _user2,
};

final _videoPost = {
  "id": 3,
  "type": "video",
  "text": "",
  "images": null,
  "video": {
    "url":
        "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/video/post-video-1.mp4",
    "cover":
        "https://jw-asset.oss-cn-shanghai.aliyuncs.com/course/flutter-in-practice/video/post-video-1-cover.jpg",
    "width": 640,
    "height": 360,
    "duration": 14,
  },
  "likeCount": 0,
  "isLiked": false,
  "creatorId": 3,
  "createdAt": "2018-12-22T21:11:13+08:00",
  "creator": _user3,
};

final _posts = [
  _textPost,
  _imagePost,
  _videoPost,
];

final mockApis = <String, Future Function(String, dynamic)>{
  '/account/register': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              'user': _user1,
            }
          }),
  '/account/login': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              'user': _user1,
            }
          }),
  '/account/logout': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': null,
          }),
  '/account/info': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              'user': _user1,
            }
          }),
  '/account/edit': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              'user': _user1
                ..update('username', (v) => data['username'] ?? v)
                ..update('mobile', (v) => data['mobile'] ?? v),
            }
          }),
  '/account/send/mobile/verify/code': (String method, dynamic data) =>
      Future.delayed(
          Duration(
            seconds: _random.nextInt(2) + 1,
            milliseconds: _random.nextInt(1000),
          ),
          () => {
                'code': 0,
                'message': '',
                'data': null,
              }),
  '/post/create': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              "id": 1,
            },
          }),
  '/post/delete': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': null,
          }),
  '/post/published': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              'posts': List<Map<String, dynamic>>.generate(
                10,
                (i) => _posts[_random.nextInt(_posts.length)],
              ).toList(),
            }
          }),
  '/post/liked': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              'posts': List<Map<String, dynamic>>.generate(
                10,
                (i) => Map.from(_posts[_random.nextInt(_posts.length)])
                  ..update('isLiked', (v) => true),
              ).toList(),
            }
          }),
  '/post/like': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': null,
          }),
  '/post/unlike': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': null,
          }),
  '/post/following': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              'posts': List<Map<String, dynamic>>.generate(
                10,
                (i) => _posts[_random.nextInt(_posts.length)],
              ).toList(),
            },
          }),
  '/user/info': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              'user': _users.firstWhere((v) => v['id'] == data['userId']),
            }
          }),
  '/user/infos': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              'users': (data['ids'] as List<int>)
                  .map((v) => _users.firstWhere((v1) => v1['id'] == v)),
            }
          }),
  '/user/followings': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              'users': List<Map<String, dynamic>>.generate(
                10,
                (i) => Map.from(_users[_random.nextInt(_users.length)])
                  ..update('isFollowing', (v) => true),
              ).toList(),
            }
          }),
  '/user/followers': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': {
              'users': List<Map<String, dynamic>>.generate(
                10,
                (i) => _users[_random.nextInt(_users.length)],
              ).toList(),
            }
          }),
  '/user/follow': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': null,
          }),
  '/user/unfollow': (String method, dynamic data) => Future.delayed(
      Duration(
        seconds: _random.nextInt(2) + 1,
        milliseconds: _random.nextInt(1000),
      ),
      () => {
            'code': 0,
            'message': '',
            'data': null,
          }),
};
