class BaseConfig {
  String? _dbName;
  String get dbName => _dbName ?? "question_mult.db";

  set dbName(String value) {
    _dbName = value;
  }
}
