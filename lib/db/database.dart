import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DBHive {
  static final DBHive _instance = DBHive._internal();
  factory DBHive() => _instance;
  DBHive._internal();

  late Box<dynamic> box;

  Future<bool> initDB(String nombreBox) async {
    if (!Hive.isBoxOpen(nombreBox)) {
      final directorio = await getApplicationSupportDirectory();
      Hive.init(directorio.path);
      box = await Hive.openBox(nombreBox);
    } else {
      box = Hive.box(nombreBox);
    }
    return box.isOpen;
  }

  Future<bool> addData<T>(T objeto) async {
    try {
      await box.add(objeto);
      return true;
    } catch (e) {
      print("Error al añadir dato: $e");
      return false;
    }
  }

  Map<dynamic, dynamic> readData() {
    return box.toMap();
  }

  Future<bool> deleteData(int index) async {
    try {
      await box.deleteAt(index);
      return true;
    } catch (e) {
      print("Error al eliminar dato: $e");
      return false;
    }
  }

  Future<bool> updateData<T>(int index, T objeto) async {
    try {
      await box.putAt(index, objeto);
      return true;
    } catch (e) {
      print("Error al actualizar dato: $e");
      return false;
    }
  }

  bool isBoxOpen(String nombreBox) {
    return Hive.isBoxOpen(nombreBox);
  }

  void dispose() {
    if (box.isOpen) {
      box.close();
    }
  }
}
