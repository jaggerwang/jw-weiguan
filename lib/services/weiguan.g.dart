// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weiguan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WgApiResponse _$WgApiResponseFromJson(Map<String, dynamic> json) {
  return WgApiResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$WgApiResponseToJson(WgApiResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data
    };
