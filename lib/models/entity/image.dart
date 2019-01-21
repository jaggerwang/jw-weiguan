import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
@immutable
class ImageEntity {
  final String url;
  final int width;
  final int height;
  final int size;

  const ImageEntity({
    this.url = '',
    this.width = 0,
    this.height = 0,
    this.size = 0,
  });

  factory ImageEntity.fromJson(Map<String, dynamic> json) =>
      _$ImageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ImageEntityToJson(this);

  double get ratio {
    return width != 0 && height != 0 ? width / height : 16 / 9;
  }
}
