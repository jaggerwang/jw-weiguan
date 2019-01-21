// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publish.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublishState _$PublishStateFromJson(Map<String, dynamic> json) {
  return PublishState(
      type: _$enumDecodeNullable(_$PostTypeEnumMap, json['type']),
      text: json['text'] as String,
      images: (json['images'] as List)?.map((e) => e as String)?.toList(),
      videos: (json['videos'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$PublishStateToJson(PublishState instance) =>
    <String, dynamic>{
      'type': _$PostTypeEnumMap[instance.type],
      'text': instance.text,
      'images': instance.images,
      'videos': instance.videos
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$PostTypeEnumMap = <PostType, dynamic>{
  PostType.all: 'all',
  PostType.text: 'text',
  PostType.image: 'image',
  PostType.video: 'video'
};
