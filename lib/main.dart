import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=5f09359f";

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
      )));
}

Future<Map> getData() async {
  //retorna um mapa no futuro
  http.Response response = await http.get(
      request); //http retorna o dado no futuro, então o await espera o dado chegar
  return json
      .decode(response.body); // pega a resposta em JSON e transforma em Map
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();

  double dolar;
  double euro;
  double bitcoin;
  
  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    bitcoinController.text = (real/bitcoin).toStringAsFixed(2);
  }
    void _dolarChanged(String text){
    // double dolar = double.parse(text);
    // realController.text = (dolar * this.dolar).toStringAsFixed(2);
    // euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);

     
  }
    void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro *this.euro / dolar).toStringAsFixed(2);
  }
    void _bitcoinChanged(String text){
    print (text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$Conversor\$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            //O Corpo é um future builder que contem um mapa, que é oque foi retornado acima
            future: getData(), //Especificar o futuro que ele quer que construa
            builder: (context, snapshot) {
              // Especificar o que vai mostrar na tela em cada um dos casos
              switch (snapshot.connectionState) {
                //Dar o switch para ver se ele esta esperando ou não conectado
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Carregando Dados...",
                    //style: _textStyle,
                    textAlign: TextAlign.center,
                  ));
                default: //Se obteu o erro
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao carregar os Dados =(",
                      //style: _textStyle,
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    // Se der tudo certo ele vai retornar os dados
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    bitcoin =
                        snapshot.data["results"]["currencies"]["BTC"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(
                          10.0), // Distancia da borda para a lateral da tela
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.amber),
                          buildTextField("Reais", "R\$", realController, _realChanged),
                          Divider(),
                          buildTextField("Dólares", "US\$", dolarController, _dolarChanged),
                          Divider(),
                          buildTextField("Euros", "\€", euroController, _euroChanged),
                          Divider(),
                          buildTextField("Bitcoins", "₿", bitcoinController, _bitcoinChanged),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f) {
  return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix,
      ),
      textAlign: TextAlign.right, 
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: Colors.amber, fontSize: 25.0
        ),
        onChanged: f,
        );
}
