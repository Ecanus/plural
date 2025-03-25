class Environments {
  static const String pocketbaseUrl = String.fromEnvironment(
    "POCKETBASE_URL",
    defaultValue: "http://127.0.0.1:8090"
  );
}