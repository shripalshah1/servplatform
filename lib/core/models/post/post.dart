import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:servplatform/core/models/serializers.dart';

part 'post.g.dart';

/// An example post model that should be serialized.
///   - @nullable: means that its ok if the value is null
///   - @BuiltValueField: is the key that is in the JSON you
///     receive from an API
abstract class Post implements Built<Post, PostBuilder> {
  @nullable
  int get id;
  @nullable
  String get title;
  @nullable
  @BuiltValueField(wireName: 'body')
  @nullable
  String get description;
  @nullable
  int get userId;

  String toJson() {
    return json.encode(serializers.serializeWith(Post.serializer, this));
  }

  static Post fromJson(String jsonString) {
    return serializers.deserializeWith(
      Post.serializer,
      json.decode(jsonString),
    );
  }

  static Post fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(
      Post.serializer,
      map,
    );
  }

  Post._();
  static Serializer<Post> get serializer => _$postSerializer;
  factory Post([void Function(PostBuilder) updates]) = _$Post;
}
