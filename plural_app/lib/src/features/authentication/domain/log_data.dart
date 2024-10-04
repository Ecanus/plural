mixin LogData {
  DateTime get logCreationDate;
  DateTime? logDeletionDate;

  void setDeletionDate() {
    logDeletionDate = DateTime.now();
  }
}