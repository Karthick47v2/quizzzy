// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_set.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionSetAdapter extends TypeAdapter<QuestionSet> {
  @override
  final int typeId = 1;

  @override
  QuestionSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionSet(
      id: fields[0] as String,
      question: fields[1] as String,
      crctAns: fields[2] as String,
      allAns: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuestionSet obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.crctAns)
      ..writeByte(3)
      ..write(obj.allAns);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
