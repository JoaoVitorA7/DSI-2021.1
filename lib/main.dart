import 'dart:html';
import 'dart:ui';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class ParPalavra {
  String palavra1;
  String palavra2;

  first() {
    return palavra1;
  }

  second() {
    return palavra2;
  }

  gerarPares() {
    String par = palavra1 + palavra2;
    return par;
  }

  ParPalavra(this.palavra1, this.palavra2);
}

class Repository {
  List listaPalavras = [];

  addElement(String element) {
    listaPalavras.add(element);
  }

  getAll() {
    return listaPalavras;
  }

  getIndex(value) {
    return listaPalavras.indexOf(value);
  }

  void editarPalavra(palavraOri, palavraEdi) {
    listaPalavras[listaPalavras.indexOf(palavraOri)] = palavraEdi;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => RandomWords(),
        TelaEditar.rotaEditar: (context) => Sub()
      },
      title: 'Welcome to Flutter',
      theme: ThemeData(
        // Add the 5 lines from here...
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  bool _checkState = true;
  final _saved = [];
  final _biggerFont = const TextStyle(fontSize: 18);
  final rep = Repository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.line_style_rounded),
            iconSize: 40,
            tooltip: 'Mudar visualização',
            onPressed: () {
              setState(() {
                _checkState = !_checkState;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
          IconButton(
            icon: const Icon(Icons.plus_one),
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/telaEditar',
                    arguments: {'palavras': rep.getAll(), 'palavra': null});
              });
            },
            tooltip: 'Criar Palavra',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                RefreshCallback;
              });
            },
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    int variavel = 20;
    if (_checkState) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        // The itemBuilder callback is called once per suggested
        // word pairing, and places each suggestion into a ListTile
        // row. For even rows, the function adds a ListTile row for
        // the word pairing. For odd rows, the function adds a
        // Divider widget to visually separate the entries. Note that
        // the divider may be difficult to see on smaller devices.
        itemCount: variavel,
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row
          // in the ListView.

          // The syntax "i ~/ 2" divides i by 2 and returns an
          // integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings
          // in the ListView,minus the divider widgets.
          // If you've reached the end of the available word
          // pairings...
          if (i >= rep.getAll().length) {
            // ...then generate 10 more and add them to the
            // suggestions list.
            rep.addElement(ParPalavra(nouns[i], nouns[i + 1]).gerarPares());
          }
          return _buildRow(rep.listaPalavras[i]);
        },
      );
    } else {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 1.0,
          childAspectRatio: 8 / 2,
        ),
        itemCount: variavel,
        itemBuilder: (context, i) {
          if (i >= rep.getAll().length) {
            rep.addElement(ParPalavra(nouns[i], nouns[i + 1]).gerarPares());
          }

          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        _buildRow(rep.listaPalavras[i]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildRow(String pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair,
        style: _biggerFont,
      ),
      onTap: () {
        setState(() {
          Navigator.pushNamed(context, '/telaEditar',
              arguments: {'palavras': rep.getAll(), 'palavra': pair});
        });
      },
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite),
              color: alreadySaved ? Colors.red : null,
              onPressed: () {
                setState(() {
                  alreadySaved ? _saved.remove(pair) : _saved.add(pair);
                });
              },
            ),
            IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    rep.listaPalavras.remove(pair);
                    _saved.remove(pair);
                  });
                })
          ],
        ),
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.toString(),
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

class Sub extends StatefulWidget {
  @override
  TelaEditar createState() => TelaEditar();
}

class TelaEditar extends State<Sub> {
  static const rotaEditar = '/telaEditar';
  String variavel = 'Salvar';
  @override
  Widget build(BuildContext context) {
    final argumentos =
        (ModalRoute.of(context)?.settings.arguments ?? <List, String>{}) as Map;
    if (argumentos['palavra'] != null) {
      final palavraTextoEditar =
          TextEditingController(text: argumentos['palavra']);
      String palavra = argumentos['palavra'];
      List palavrasList = argumentos['palavras'];
      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Palavras'),
        ),
        body: Container(
          child: Column(
            children: [
              TextField(controller: palavraTextoEditar),
              TextButton(
                child: Text(variavel),
                onPressed: () {
                  setState(() {
                    palavrasList[palavrasList.indexOf(palavra)] =
                        palavraTextoEditar.text;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        ),
      );
    } else {
      final palavraInserida = TextEditingController();
      List palavrasList = argumentos['palavras'];
      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Palavras'),
        ),
        body: Container(
          child: Column(
            children: [
              TextField(controller: palavraInserida),
              TextButton(
                child: Text(variavel),
                onPressed: () {
                  setState(() {
                    palavrasList.insert(0, palavraInserida.text);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
