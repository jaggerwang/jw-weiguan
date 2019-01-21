import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final publishReducer = combineReducers<PublishState>([
  TypedReducer<PublishState, PublishSaveAction>(_save),
  TypedReducer<PublishState, PublishAddImageAction>(_addImage),
  TypedReducer<PublishState, PublishRemoveImageAction>(_removeImage),
  TypedReducer<PublishState, PublishAddVideoAction>(_addVideo),
  TypedReducer<PublishState, PublishRemoveVideoAction>(_removeVideo),
]);

PublishState _save(PublishState state, PublishSaveAction action) {
  return state.copyWith(
    type: action.type,
    text: action.text,
  );
}

PublishState _addImage(PublishState state, PublishAddImageAction action) {
  var images = List<String>.from(state.images);
  images.add(action.image);

  return state.copyWith(
    images: images,
  );
}

PublishState _removeImage(PublishState state, PublishRemoveImageAction action) {
  var images = List<String>.from(state.images);
  images.remove(action.image);

  return state.copyWith(
    images: images,
  );
}

PublishState _addVideo(PublishState state, PublishAddVideoAction action) {
  var videos = List<String>.from(state.videos);
  videos.add(action.video);

  return state.copyWith(
    videos: videos,
  );
}

PublishState _removeVideo(PublishState state, PublishRemoveVideoAction action) {
  var videos = List<String>.from(state.videos);
  videos.remove(action.video);

  return state.copyWith(
    videos: videos,
  );
}
