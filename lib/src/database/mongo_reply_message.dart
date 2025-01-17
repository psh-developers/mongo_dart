part of mongo_dart;

class MongoReplyMessage extends MongoResponseMessage {
  static final flagsCursorNone = 0;
  static final flagsCursorNotFound = 1;
  static final flagsQueryFailure = 2;
  static final flagsShardConfigStale = 4;
  static final flagsAwaitCapable = 8;

  @Deprecated('Use flagsCursoNone instead')
  // ignore: non_constant_identifier_names
  static final FLAGS_CURSOR_NONE = flagsCursorNone;

  @Deprecated('Use flagsCursorNotFound instead')
  // ignore: non_constant_identifier_names
  static final FLAGS_CURSOR_NOT_FOUND = flagsCursorNotFound;

  @Deprecated('Use flagsQueryFailure instead')
  // ignore: non_constant_identifier_names
  static final FLAGS_QUERY_FAILURE = flagsQueryFailure;

  @Deprecated('Use flagsShardConfigStale instead')
  // ignore: non_constant_identifier_names
  static final FLAGS_SHARD_CONFIGSTALE = flagsShardConfigStale;

  @Deprecated('Use flagsAwaitCapable instead')
  // ignore: non_constant_identifier_names
  static final FLAGS_AWAIT_CAPABLE = flagsAwaitCapable;

  int? responseFlags;
  int cursorId = -1; // 64bit integer
  int? startingFrom;
  int numberReturned = -1;
  List<Map<String, dynamic>>? documents;

  @override
  MongoMessage deserialize(BsonBinary buffer) {
    readMessageHeaderFrom(buffer);
    responseFlags = buffer.readInt32();
    cursorId = buffer.readInt64();
    startingFrom = buffer.readInt32();
    numberReturned = buffer.readInt32();
    documents = List<Map<String, dynamic>>.filled(
        numberReturned, const <String, dynamic>{});
    for (var n = 0; n < numberReturned; n++) {
      var doc = BsonMap.fromBuffer(buffer);
      documents![n] = doc.value;
    }
    return this;
  }

  @override
  String toString() {
    if (documents?.length == 1) {
      return 'MongoReplyMessage(ResponseTo:$responseTo, cursorId: $cursorId, '
          'numberReturned:$numberReturned, responseFlags:$responseFlags, '
          '${documents!.first})';
    }
    return 'MongoReplyMessage(ResponseTo:$responseTo, cursorId: $cursorId, '
        'numberReturned:$numberReturned, responseFlags:$responseFlags, '
        '$documents)';
  }
}
