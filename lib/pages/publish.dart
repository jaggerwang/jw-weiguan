import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../theme.dart';
import '../models/models.dart';
import '../actions/actions.dart';
import '../components/components.dart';
import 'pages.dart';

class PublishPage extends StatelessWidget {
  static final _bodyKey = GlobalKey<_BodyState>();

  PublishPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
            type: store.state.publish.type,
            text: store.state.publish.text,
            images: store.state.publish.images,
            videos: store.state.publish.videos,
          ),
      builder: (context, vm) => Scaffold(
            appBar: AppBar(
              title: Text('发动态'),
              actions: <Widget>[
                GestureDetector(
                  onTap: Feedback.wrapForTap(
                      () => _bodyKey.currentState.submit(), context),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      '提交',
                      style: TextStyle(fontSize: WgTheme.fontSizeLarge),
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _bodyKey.currentState.switchType(
                        PostType.values.firstWhere(
                          (v) => v.toString() == value,
                        ),
                      ),
                  initialValue: PostType.image.toString(),
                  itemBuilder: (context) => PostType.values
                      .skip(1)
                      .map<PopupMenuEntry<String>>((v) => PopupMenuItem<String>(
                            value: v.toString(),
                            child: Text(PostEntity.typeNames[v]),
                          ))
                      .toList(),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      PostEntity.typeNames[vm.type],
                      style: TextStyle(
                        fontSize: WgTheme.fontSizeLarge,
                        color: WgTheme.whiteNormal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: _Body(
              key: _bodyKey,
              store: StoreProvider.of<AppState>(context),
              vm: vm,
            ),
            bottomNavigationBar: WgTabBar(tabIndex: 1),
          ),
    );
  }
}

class _ViewModel {
  final PostType type;
  final String text;
  final List<String> images;
  final List<String> videos;

  _ViewModel({
    @required this.type,
    @required this.text,
    @required this.images,
    @required this.videos,
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
  TextEditingController _textEditingController;
  var _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController(text: widget.vm.text);
  }

  void switchType(PostType type) {
    widget.store.dispatch(PublishSaveAction(
      type: type,
    ));
  }

  void _saveText(String value) {
    widget.store.dispatch(PublishSaveAction(
      text: value.trim(),
    ));
  }

  Future _addFile() async {
    var source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('从相册选取'),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
                ListTile(
                  title: Text('用相机拍摄'),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
              ],
            ));
    if (source == null) {
      return;
    }

    if (widget.vm.type == PostType.image) {
      var file = await ImagePicker.pickImage(source: source);
      if (file != null) {
        widget.store.dispatch(PublishAddImageAction(
          image: file.path,
        ));
      }
    } else if (widget.vm.type == PostType.video) {
      var file = await ImagePicker.pickVideo(source: source);
      if (file != null) {
        widget.store.dispatch(PublishAddVideoAction(
          video: file.path,
        ));
      }
    }
  }

  _removeFile(File file) {
    if (widget.vm.type == PostType.image) {
      widget.store.dispatch(PublishRemoveImageAction(
        image: file.path,
      ));
    } else if (widget.vm.type == PostType.video) {
      widget.store.dispatch(PublishRemoveVideoAction(
        video: file.path,
      ));
    }
  }

  void submit() {
    if (_isSubmitting) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('请勿重复提交'),
      ));
      return;
    }

    if ((widget.vm.type == PostType.text && widget.vm.text == '') ||
        (widget.vm.type == PostType.image && widget.vm.images.length == 0) ||
        (widget.vm.type == PostType.video && widget.vm.videos.length == 0)) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('内容不能为空'),
      ));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    widget.store.dispatch(publishPostAction(
      type: widget.vm.type,
      text: widget.vm.text,
      images: widget.vm.images,
      videos: widget.vm.videos,
      onSucceed: (id) {
        setState(() {
          _isSubmitting = false;
        });

        widget.store.dispatch(ResetPublishStateAction());
        _textEditingController.clear();

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('发布成功'),
          duration: Duration(hours: 24),
          action: SnackBarAction(
            onPressed: () => Scaffold.of(context).removeCurrentSnackBar(),
            label: '知道了',
          ),
        ));
      },
      onFailed: (notice) {
        setState(() {
          _isSubmitting = false;
        });

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('发布失败：${notice.message}'),
          duration: Duration(hours: 24),
          action: SnackBarAction(
            onPressed: () => Scaffold.of(context).removeCurrentSnackBar(),
            label: '知道了',
          ),
        ));
      },
    ));
  }

  Widget _buildImagePicker() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double margin = 5;
        final columns = 3;
        final width = (constraints.maxWidth - (columns - 1) * margin) / columns;
        final height = width;
        final images = widget.vm.images.map<File>((v) => File(v)).toList();

        final children = images
            .asMap()
            .entries
            .map<Widget>((entry) => Container(
                  width: width,
                  height: height,
                  color: WgTheme.greyLight,
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: Feedback.wrapForTap(
                            () => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ImagesPlayerPage(
                                        files: images,
                                        initialIndex: entry.key,
                                      ),
                                )),
                            context),
                        child: Image.file(
                          entry.value,
                          width: width,
                          height: height,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: Feedback.wrapForTap(
                              () => _removeFile(entry.value), context),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.clear, color: WgTheme.whiteLight),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList();

        if (widget.vm.images.length < 6) {
          children.add(GestureDetector(
            onTap: Feedback.wrapForTap(_addFile, context),
            child: Container(
              width: width,
              height: height,
              color: WgTheme.greyLight,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: WgTheme.greyNormal,
                  size: 32,
                ),
              ),
            ),
          ));
        }

        return Wrap(
          spacing: margin,
          runSpacing: margin,
          children: children,
        );
      },
    );
  }

  Widget _buildVideoPicker() {
    final videos = widget.vm.videos.map<File>((v) => File(v));

    final children = videos
        .map<Widget>((video) => Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                VideoPlayerWithControlBar(file: video),
                Container(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap:
                        Feedback.wrapForTap(() => _removeFile(video), context),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.clear, color: WgTheme.whiteLight),
                    ),
                  ),
                ),
              ],
            ))
        .toList();

    if (widget.vm.videos.length < 1) {
      children.add(AspectRatio(
        aspectRatio: 16 / 9,
        child: GestureDetector(
          onTap: Feedback.wrapForTap(_addFile, context),
          child: Container(
            color: WgTheme.greyLight,
            child: Center(
              child: Icon(
                Icons.add,
                color: WgTheme.greyNormal,
                size: 32,
              ),
            ),
          ),
        ),
      ));
    }
    return Column(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: ListView(
            padding: EdgeInsets.all(WgTheme.paddingSizeNormal),
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: WgTheme.whiteLight,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '说点儿啥',
                    border: InputBorder.none,
                  ),
                  onChanged: _saveText,
                  autofocus: widget.vm.type == PostType.text,
                  maxLength: widget.vm.type == PostType.text ? 10000 : 1000,
                  maxLengthEnforced: true,
                  maxLines: widget.vm.type == PostType.text ? 10 : 5,
                  controller: _textEditingController,
                ),
              ),
              Visibility(
                visible: widget.vm.type == PostType.image,
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: _buildImagePicker(),
                ),
              ),
              Visibility(
                visible: widget.vm.type == PostType.video,
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: _buildVideoPicker(),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isSubmitting,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
