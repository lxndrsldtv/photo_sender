enum CommandResultCode { success, fail }

class CommandResult {
  final CommandResultCode code;
  final String description;

  CommandResult({required this.code, required this.description});
}
