import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:group_selection/src/bl/models/models.dart';

void main() {
  test('Group.fromJson work correctly', () {
    final Group group = Group.fromJson(jsonDecode(
        '{"id" : "id", "facultyId" : "facultyId", "name" : "Name", "year" : 3, "subgroups" : [{"id" : "id", "name" : "Name"}, {"id" : "id", "name" : "Name"}]}'));

    expect(group.id, "id");
    expect(group.name, "Name");
    expect(group.facultyId, "facultyId");
    expect(group.year, 3);
    expect(group.subgroups!.length, 2);
    expect(group.subgroups![0].name, 'Name');
    expect(group.subgroups![0].id, 'id');
  });
}
