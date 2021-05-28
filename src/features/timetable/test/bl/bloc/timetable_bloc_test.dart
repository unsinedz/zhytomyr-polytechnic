import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import 'package:timetable/src/bl/abstractions/timetable_repository.dart';
import 'package:timetable/src/bl/abstractions/group_repository.dart';
import 'package:timetable/src/bl/abstractions/tutor_repository.dart';
import 'package:timetable/src/bl/bloc/timetable_bloc.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableLoaderMock extends Mock implements TimetableRepository {
  @override
  Future<Timetable> loadTimetableByReferenceId(int? referenceId,
          [String? userGroupId]) =>
      super.noSuchMethod(
        Invocation.method(
            #loadTimetableByReferenceId, [referenceId, userGroupId]),
        returnValue: Future.value(
          Timetable(
            items: [],
            timetableData: TimetableData(
              enabled: false,
              id: '',
              lastModified: DateTime.now(),
              weekDetermination: WeekDetermination.Odd,
              expiredAt: DateTime.now(),
            ),
          ),
        ),
      );

  @override
  Future<List<TimetableItemUpdate>> getTimetableItemUpdates() =>
      super.noSuchMethod(Invocation.method(#getTimetableItemUpdates, []),
          returnValue: Future.value(<TimetableItemUpdate>[]));
}

class GroupRepositoryMock extends Mock implements GroupRepository {}

class TutorRepositoryMock extends Mock implements TutorRepository {}

void main() {
  test('TimetableBloc.loadTimetable work correctly', () async {
    TimetableLoaderMock timetableLoaderMock = TimetableLoaderMock();
    GroupRepositoryMock groupRepositoryMock = GroupRepositoryMock();

    TimetableBloc timetableBloc = TimetableBloc(
      timetableRepository: timetableLoaderMock,
      errorSink: StreamController<String>().sink,
      groupRepository: groupRepositoryMock,
      tutorRepository: TutorRepositoryMock(),
    );

    when(timetableLoaderMock.loadTimetableByReferenceId(any, any)).thenAnswer(
      (_) => Future.value(
        Timetable(
          items: [],
          timetableData: TimetableData(
            enabled: false,
            id: '',
            lastModified: DateTime.now(),
            weekDetermination: WeekDetermination.Odd,
            expiredAt: DateTime.now(),
          ),
        ),
      ),
    );

    List<Timetable?> results = <Timetable?>[];

    timetableBloc.timetable.listen((groups) => results.add(groups));
    timetableBloc.loadTimetable(0);

    await Future.delayed(const Duration());

    expect(results[0], null);
    // expect(results[1]!.weekDetermination, WeekDetermination.Even);
    expect(results[1]!.items.length, 0);
  });

  test('TimetableBloc.getTimetableItemUpdates work correctly', () async {
    TimetableLoaderMock timetableLoaderMock = TimetableLoaderMock();
    GroupRepositoryMock groupRepositoryMock = GroupRepositoryMock();

    TimetableBloc timetableBloc = TimetableBloc(
      timetableRepository: timetableLoaderMock,
      errorSink: StreamController<String>().sink,
      groupRepository: groupRepositoryMock,
      tutorRepository: TutorRepositoryMock(),
    );

    when(timetableLoaderMock.getTimetableItemUpdates())
        .thenAnswer((_) => Future.value(<TimetableItemUpdate>[
              TimetableItemUpdate(time: '1', timetableItem: null, date: '1'),
              TimetableItemUpdate(time: '2', timetableItem: null, date: '2'),
            ]));

    List<List<TimetableItemUpdate>?> results = <List<TimetableItemUpdate>?>[];

    timetableBloc.timetableItemUpdates
        .listen((timetableItemUpdates) => results.add(timetableItemUpdates));
    timetableBloc.loadTimetableItemUpdates();

    await Future.delayed(const Duration());

    expect(results[0], null);
    expect(results[1]!.length, 2);
    expect(results[1]![0].time, '1');
    expect(results[1]![0].date, '1');
    expect(results[1]![0].timetableItem, null);

    expect(results[1]![1].time, '2');
    expect(results[1]![1].date, '2');
    expect(results[1]![1].timetableItem, null);
  });
}
