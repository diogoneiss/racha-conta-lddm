import 'package:flutter/material.dart';

/*
Diogo Oliveira Neiss
LDDM 2021

App para cálculo da divisão de contas no bar.
 */

void main() => runApp(MyApp());

//cores utilizadas. A principal é pro design e a secundária pros textos
final Color corPrincipal = Colors.blue;
final Color corSecundaria = Colors.black;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Racha conta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: corPrincipal,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variaveis de armazenamento
  final _totalConta = TextEditingController();
  final _numeroPessoas = TextEditingController();
  final _valorTotalBebida = TextEditingController();
  final _numeroPessoasQueBebem = TextEditingController();

  var _totalText = "0.00";
  var _semBebidaText = "0.00";
  var _comBebidaText = "0.00";
  var _gorjetaText = "0.00";

  var _formKey = GlobalKey<FormState>();

  double valorSliderG = 10;
  String labelSliderG = "10%";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Racha Conta - Diogo Neiss"),
        centerTitle: true,
        actions: <Widget>[
          //botao que, ao clicado, reseta o form inteiro
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields)
        ],
      ),
      body: _body(),
    );
  }

  // resetar os campos
  void _resetFields() {
    _totalConta.text = "";
    _numeroPessoas.text = "";
    _valorTotalBebida.text = "";
    _numeroPessoasQueBebem.text = "";

    setState(() {
      _totalText = "0.00";
      _semBebidaText = "0.00";
      _comBebidaText = "0.00";
      _gorjetaText = "0.00";

      valorSliderG = 10;
      labelSliderG = "10%";

      _formKey = GlobalKey<FormState>();
    });
  }

  _body() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _editText("Valor total da conta:", _totalConta),
              _editText("Numero de pessoas:", _numeroPessoas),
              _editText("Valor total das bebidas:", _valorTotalBebida),
              _editText(
                  "Numero de pessoas que beberam:", _numeroPessoasQueBebem),
              _textTituloSlider(),
              _sliderGorjeta(),
              _buttonCalcular(),
              _textSemBebida(),
              _textComBebida(),
              _textGorjeta(),
              _textTotal(),
            ],
          ),
        ));
  }

  // Widget text
  _editText(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (s) => _validate(s, field),
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 22,
        color: corPrincipal,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize: 19,
          color: corSecundaria,
        ),
      ),
    );
  }

  // Validacao de campos
  String _validate(String text, String field) {
    if (text.isEmpty) {
      return "Digite $field";
    }
    return null;
  }

  // Botão de calcular, que vai puxar dos valores
  _buttonCalcular() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: corPrincipal,
        child: Text(
          "Calcular agora",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        //se estiver ok, ao apertar, calcula tudo
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _calcularConta();
          }
        },
      ),
    );
  }

  // calcular conta
  void _calcularConta() {
    setState(() {
      double total = double.parse(_totalConta.text);
      double totalBebida = double.parse(_valorTotalBebida.text);
      int nPessoas = int.parse(_numeroPessoas.text);
      int numeroPessoasQueBebem = int.parse(_numeroPessoasQueBebem.text);
      double gorjeta = valorSliderG;

      double totalIncluindoGorjeta = (total) * (1 + (gorjeta / 100));
      double valorGorjeta = (total) * (gorjeta / 100);
      double totalSBebida =
          ((total - totalBebida) / nPessoas) * (1 + (gorjeta / 100));
      double totalCBebida = (((total - totalBebida) / nPessoas) +
              (totalBebida / numeroPessoasQueBebem)) *
          (1 + (gorjeta / 100));

      //converter os valores numericos pra String com dupla precisão
      _totalText = totalIncluindoGorjeta.toStringAsFixed(2);
      _gorjetaText = valorGorjeta.toStringAsFixed(2);
      _semBebidaText = totalSBebida.toStringAsFixed(2);
      _comBebidaText = totalCBebida.toStringAsFixed(2);
    });
  }

  //slider da gorjeta
  _sliderGorjeta() {
    return Slider(
        value: valorSliderG,
        min: 0,
        max: 100,
        label: labelSliderG,
        divisions: 25,
        onChanged: (double novoValor) {
          setState(() {
            valorSliderG = novoValor;
            labelSliderG = novoValor.toInt().toString() + "%";
          });
        });
  }

  // --------------------------------------------------------------------------
  // textos

  _textTituloSlider() {
    return Text(
      "Gorjeta:",
      textAlign: TextAlign.left,
      style: TextStyle(color: corSecundaria, fontSize: 19),
    );
  }

  _textTotal() {
    return RichText(
        text: new TextSpan(
            style: new TextStyle(
              fontSize: 19,
              color: corSecundaria,

            ),
            children: <TextSpan>[
              new TextSpan(text: "Total a ser pago:"),
              new TextSpan(
                  text: "\nR\$" + _totalText + "\n",
                  style: new TextStyle(fontWeight: FontWeight.bold))
            ]));
  }

  _textSemBebida() {
    return RichText(
        text: new TextSpan(
            style: new TextStyle(
              fontSize: 19,
              color: corSecundaria,

            ),
            children: <TextSpan>[
          new TextSpan(text: "Valor individual para quem não bebeu durante a estadia:"),
          new TextSpan(
              text: "\nR\$" + _semBebidaText + "\n",
              style: new TextStyle(fontWeight: FontWeight.bold))
        ]));
  }

  _textComBebida() {
    return RichText(
        text: new TextSpan(
            style: new TextStyle(
              fontSize: 19,
              color: corSecundaria,

            ),
            children: <TextSpan>[
              new TextSpan(text: "Valor individual para quem bebeu:"),
              new TextSpan(
                  text: "\nR\$" + _comBebidaText + "\n",
                  style: new TextStyle(fontWeight: FontWeight.bold))
            ]));
  }

  _textGorjeta() {

    return RichText(
        text: new TextSpan(
            style: new TextStyle(
              fontSize: 19,
              color: corSecundaria,

            ),
            children: <TextSpan>[
              new TextSpan(text: "Valor da gorjeta paga:"),
              new TextSpan(
                  text: "\nR\$" + _gorjetaText + "\n",
                  style: new TextStyle(fontWeight: FontWeight.bold))
            ]));
  }
}
