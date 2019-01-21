// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeEntity _$NoticeEntityFromJson(Map<String, dynamic> json) {
  return NoticeEntity(
      message: json['message'] as String,
      level: _$enumDecodeNullable(_$NoticeLevelEnumMap, json['level']),
      duration: json['duration'] == null
          ? null
          : durationFromMillseconds(json['duration'] as int));
}

Map<String, dynamic> _$NoticeEntityToJson(NoticeEntity instance) =>
    <String, dynamic>{
      'message': instance.message,
      'level': _$NoticeLevelEnumMap[instance.level],
      'duration': instance.duration == null
          ? null
          : durationToMilliseconds(instance.duration)
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

const _$NoticeLevelEnumMap = <NoticeLevel, dynamic>{
  NoticeLevel.info: 'info',
  NoticeLevel.warning: 'warning',
  NoticeLevel.error: 'error'
};
