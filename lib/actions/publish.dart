import 'package:meta/meta.dart';

import '../models/models.dart';

class PublishSaveAction {
  final PostType type;
  final String text;

  PublishSaveAction({
    this.type,
    this.text,
  });
}

class PublishAddImageAction {
  final String image;

  PublishAddImageAction({
    @required this.image,
  });
}

class PublishRemoveImageAction {
  final String image;

  PublishRemoveImageAction({
    @required this.image,
  });
}

class PublishAddVideoAction {
  final String video;

  PublishAddVideoAction({
    @required this.video,
  });
}

class PublishRemoveVideoAction {
  final String video;

  PublishRemoveVideoAction({
    @required this.video,
  });
}
