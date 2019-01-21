// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageEntity _$ImageEntityFromJson(Map<String, dynamic> json) {
  return ImageEntity(
      url: json['url'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      size: json['size'] as int);
}

Map<String, dynamic> _$ImageEntityToJson(ImageEntity instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'size': instance.size
    };
