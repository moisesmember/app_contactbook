import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

// Data of Database
// The Standart SINGLETON (apenas uma instância)
class ContactHelper{
  // To create instance
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  Database? _db;
  Future<Database?> get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contactsApp.db');

    // open database
    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async{
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

  // To save contacts
  Future<Contact> saveContact(Contact contact) async{
    Database? dbContact = await db;
    contact.id = await dbContact!.insert(contactTable, contact.toMap());
    return contact;
  }

  // To get contacts
  Future<Contact?> getContact(int id) async{
    Database? dbContact = await db;
    List<Map> maps = await dbContact!.query(contactTable, columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
                                          where: "$idColumn = ?", whereArgs: [id]);
    if(maps.length > 0){
      return Contact.fromMap(maps.first);
    }else{
      return null;
    }
  }

  // To delete contacts
  Future<int> deleteContact(int id) async{
    Database? dbContact = await db;
    return await dbContact!.delete(contactTable,
                                    where: "$idColumn = ?", whereArgs: [id]);
  }

  // To update contacts
  Future<int> updateContact(Contact contact) async{
    Database? dbContact = await db;
    return await dbContact!.update(contactTable,
                                    contact.toMap(),
                                      where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  // To get all contacts
  Future<List> getAllContacts() async{
    Database? dbContact = await db;
    List listMap = await dbContact!.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = [];
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int?> getNumber() async{
    Database? dbContact = await db;
    return Sqflite.firstIntValue(await dbContact!.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {
    Database? dbContact = await db;
    dbContact!.close();
  }

}

class Contact{

  int id        = 0;
  String name   = "";
  String email  = "";
  String phone  = "";
  String img    = "";

  Contact();

  // To get Maps values to Atributes
  Contact.fromMap(Map map){
    id    = map[idColumn];
    name  = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img   = map[imgColumn];
  }

  // To convert Atributes in Maps
  toMap(){
    Map<String, dynamic> map = {
      nameColumn:  name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn:   img
    };
    if( id != 0 ){
      map[idColumn] = id;
    }
    return map;

  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}