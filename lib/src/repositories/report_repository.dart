import 'package:domain/domain.dart';

import 'command_result.dart';

abstract class ReportRepository {
  Future<CommandResult> add({required Report report});
}
