import 'dart:io';

import 'package:app_contactbook/helpers/contact_hepler.dart';
import 'package:app_contactbook/ui/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = new ContactHelper();
  List<Contact> contacts = [];

/*
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Contact c = Contact();
    c.name = "Raimunda Ferreira de Souza";
    c.email = "kaiserPrussian@gmail.com";
    c.phone = "99945561122";
    c.img = "imagem";

    helper.saveContact(c);
    helper.deleteContact(0);
    helper.getAllContacts().then((list) => print(list));

  }
*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllContacts();
  }

  Future<Null> getAllContacts() async {
    helper.getAllContacts().then((list) => setState(() {
          contacts = list as List<Contact>;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        }, // length of contacts
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: contacts[index].img != ""
                          ? FileImage(File(contacts[index].img))
                          : AssetImage("images/person.png") as ImageProvider,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name != "" ? contacts[index].name : "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email != "" ? contacts[index].email : "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contacts[index].phone != "" ? contacts[index].phone : "",
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        _showContactPage(contact: contacts[index]);
      },
    );
  }

  void _showContactPage({Contact? contact}) async{
    final recContact = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact))
    );
    if( recContact != null ){
      if( contact != null ){ // Está editando um contato
        await helper.updateContact(recContact); // Atualiza Contato
        getAllContacts(); // Lista
      }else{
        // Novo contato
        await helper.saveContact(recContact);
      }
      getAllContacts(); // Lista
    }
  }

}
