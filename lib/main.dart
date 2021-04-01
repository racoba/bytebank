import 'package:flutter/material.dart';

void main() {
  runApp(BytebankApp());
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencia(),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Criando Transferência')),
        body: Column(children: <Widget>[
          Editor(controlador: controladorCampoNumeroConta, rotulo: 'Numero da Conta', dica: '0000',),
          Editor(controlador:controladorCampoValor, rotulo:'Valor',dica: '0000',icone: Icons.monetization_on),

          RaisedButton(
              onPressed: () => _criaTransferencia(context),
              child: Text(
                'Confirmar',
              )),
        ]));
  }

  void _criaTransferencia(BuildContext context) {
    
    final int numeroConta =
        int.tryParse(controladorCampoNumeroConta.text);
    final double valor =
        double.tryParse(controladorCampoValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      debugPrint('Criando transferencia');
      debugPrint('$transferenciaCriada');
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {

  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;

  const Editor({ this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          icon: icone!=null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListaTransferencia extends StatefulWidget {

  final List<Transferencia> _transferencias = List();

 

@override
  State<StatefulWidget> createState() {
    return ListaTransferenciasState();
  }
   
  }
}



class ListaTransferenciasState extends State<ListaTransferencia>{


  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transferências'),
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice){
         final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
         final Future<Transferencia> future = Navigator.push(context,MaterialPageRoute(builder: (context){
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida){
            debugPrint('chegou no then do future');
            debugPrint('$transferenciaRecebida');
            widget._transferencias.add(transferenciaRecebida)
          });
        },
      ),
    );
  }

  }




class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta';
  }
}
