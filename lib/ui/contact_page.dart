import 'dart:io';
import 'package:app_contactbook/helpers/contact_hepler.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  const ContactPage({Key? key, this.contact}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  Contact? _editedContact;
  bool _userEditted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.contact == null) {
      // Se for nulo
      _editedContact = Contact();
    } else {
      // Transformando o contato em mapa
      _editedContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text = _editedContact!.name;
      _emailController.text = _editedContact!.email;
      _phoneController.text = _editedContact!.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact!.name != ""
              ? _editedContact!.name
              : "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact!.name != null &&
                _editedContact!.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context)
                  .requestFocus(_nameFocus); // chama o Focus para o campo name
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          // Permite a formulário seja responsivel em relação ao teclado
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact!.img != ""
                          ? FileImage(File(_editedContact!.img))
                          : AssetImage("images/person.png") as ImageProvider,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEditted = true;
                  setState(() {
                    _editedContact!.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _userEditted = true;
                  _editedContact!.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text) {
                  _userEditted = true;
                  _editedContact!.phone = text;
                },
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEditted) {
      // Se editou algum campo, exibe pop up
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Continua na tela
                    },
                    child: Text("Cancelar")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Para remover
                      Navigator.pop(context);
                    },
                    child: Text("Sim")),
              ],
            );
          });
      return Future.value(false); // Não sai da tela automaticamente
    } else {
      return Future.value(true); // Sai da tela automaticamente
    }
  }
}
