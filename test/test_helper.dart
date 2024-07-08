import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void initializeDatabaseForTests() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
