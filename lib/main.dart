import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class ItemLista {
  final String nome;
  final String categoria;
  final double precoMaximo;

  ItemLista(this.nome, this.categoria, this.precoMaximo);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaComprasPage(),
    );
  }
}

class ListaComprasPage extends StatefulWidget {
  @override
  _ListaComprasPageState createState() => _ListaComprasPageState();
}

class _ListaComprasPageState extends State<ListaComprasPage> {
  List<ItemLista> itens = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras - Feito por: Rebeka Lacerda Paes 💜'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.png',
              height: 244, // Ajuste conforme necessário
              width: 275, // Ajuste conforme necessário
            ),
            Text('Sua lista de compras aqui'),
            Expanded(
              child: ListView.builder(
                itemCount: itens.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(itens[index].nome),
                    onDismissed: (direction) {
                      _excluirItem(index);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Item removido'),
                      ));
                    },
                    background: Container(color: Colors.red),
                    child: ListTile(
                      title: Text(itens[index].nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Categoria: ${itens[index].categoria}'),
                          Text(
                              'Preço Máximo: ${itens[index].precoMaximo.toStringAsFixed(2)}'),
                        ],
                      ),
                      onTap: () {
                        _mostrarOpcoes(context, index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarOpcoes(context, null);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarOpcoes(BuildContext context, int? index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add_shopping_cart),
              title: Text('Adicionar Item'),
              onTap: () {
                Navigator.pop(context);
                _adicionarItem(context);
              },
            ),
            if (index != null)
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar Item'),
                onTap: () {
                  Navigator.pop(context);
                  _editarItem(context, index);
                },
              ),
            if (index != null)
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Excluir Item'),
                onTap: () {
                  Navigator.pop(context);
                  _excluirItem(index);
                },
              ),
            if (index != null)
              ListTile(
                leading: Icon(Icons.refresh),
                title: Text('Atualizar Item'),
                onTap: () {
                  Navigator.pop(context);
                  _atualizarItem(context, index);
                },
              ),
            ListTile(
              leading: Icon(Icons.clear),
              title: Text('Cancelar'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _adicionarItem(BuildContext context) async {
    final novoItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdicionarItemPage()),
    );

    if (novoItem != null) {
      setState(() {
        itens.add(novoItem);
      });
    }
  }

  void _editarItem(BuildContext context, int index) async {
    final itemEditado = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditarItemPage(item: itens[index])),
    );

    if (itemEditado != null) {
      setState(() {
        itens[index] = itemEditado;
      });
    }
  }

  void _excluirItem(int index) {
    setState(() {
      itens.removeAt(index);
    });
  }

  void _atualizarItem(BuildContext context, int index) async {
    final itemAtualizado = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AtualizarItemPage(item: itens[index])),
    );

    if (itemAtualizado != null) {
      setState(() {
        itens[index] = itemAtualizado;
      });
    }
  }
}

class AdicionarItemPage extends StatefulWidget {
  @override
  _AdicionarItemPageState createState() => _AdicionarItemPageState();
}

class _AdicionarItemPageState extends State<AdicionarItemPage> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _precoController = TextEditingController();
  String? _categoriaSelecionada;
  final List<String> categorias = [
    'legumes',
    'verduras',
    'frutas',
    'proteína',
    'lácteo',
    'carboidrato',
    'gorduras',
    'doces',
    'açucares',
    'bebidas',
    'processados',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do Item',
              ),
            ),
            DropdownButtonFormField<String>(
              value: _categoriaSelecionada,
              decoration: InputDecoration(
                labelText: 'Categoria',
              ),
              items: categorias.map((String categoria) {
                return DropdownMenuItem<String>(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _categoriaSelecionada = newValue;
                });
              },
            ),
            TextField(
              controller: _precoController,
              decoration: InputDecoration(
                labelText: 'Preço Máximo',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _adicionarItem();
              },
              child: Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }

  void _adicionarItem() {
    final nome = _nomeController.text;
    final categoria = _categoriaSelecionada;
    final preco = double.tryParse(_precoController.text);

    if (nome.isNotEmpty && categoria != null && preco != null && preco >= 0) {
      Navigator.pop(context, ItemLista(nome, categoria, preco));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Por favor, preencha todos os campos corretamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }
}

class EditarItemPage extends StatefulWidget {
  final ItemLista item;

  EditarItemPage({required this.item});

  @override
  _EditarItemPageState createState() => _EditarItemPageState();
}

class _EditarItemPageState extends State<EditarItemPage> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _precoController = TextEditingController();
  String? _categoriaSelecionada;
  final List<String> categorias = [
    'legumes',
    'verduras',
    'frutas',
    'proteína',
    'lácteo',
    'carboidrato',
    'gorduras',
    'doces',
    'açucares',
    'bebidas',
    'processados',
  ];

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.item.nome;
    _categoriaSelecionada = widget.item.categoria;
    _precoController.text = widget.item.precoMaximo.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do Item',
              ),
            ),
            DropdownButtonFormField<String>(
              value: _categoriaSelecionada,
              decoration: InputDecoration(
                labelText: 'Categoria',
              ),
              items: categorias.map((String categoria) {
                return DropdownMenuItem<String>(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _categoriaSelecionada = newValue;
                });
              },
            ),
            TextField(
              controller: _precoController,
              decoration: InputDecoration(
                labelText: 'Preço Máximo',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _editarItem();
              },
              child: Text('Editar'),
            ),
          ],
        ),
      ),
    );
  }

  void _editarItem() {
    final nome = _nomeController.text;
    final categoria = _categoriaSelecionada;
    final preco = double.tryParse(_precoController.text);

    if (nome.isNotEmpty && categoria != null && preco != null && preco >= 0) {
      Navigator.pop(context, ItemLista(nome, categoria, preco));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Por favor, preencha todos os campos corretamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }
}

class AtualizarItemPage extends StatefulWidget {
  final ItemLista item;

  AtualizarItemPage({required this.item});

  @override
  _AtualizarItemPageState createState() => _AtualizarItemPageState();
}

class _AtualizarItemPageState extends State<AtualizarItemPage> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _precoController = TextEditingController();
  String? _categoriaSelecionada;
  final List<String> categorias = [
    'legumes',
    'verduras',
    'frutas',
    'proteína',
    'lácteo',
    'carboidrato',
    'gorduras',
    'doces',
    'açucares',
    'bebidas',
    'processados',
  ];

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.item.nome;
    _categoriaSelecionada = widget.item.categoria;
    _precoController.text = widget.item.precoMaximo.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do Item',
              ),
            ),
            DropdownButtonFormField<String>(
              value: _categoriaSelecionada,
              decoration: InputDecoration(
                labelText: 'Categoria',
              ),
              items: categorias.map((String categoria) {
                return DropdownMenuItem<String>(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _categoriaSelecionada = newValue;
                });
              },
            ),
            TextField(
              controller: _precoController,
              decoration: InputDecoration(
                labelText: 'Preço Máximo',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _atualizarItem();
              },
              child: Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _atualizarItem() {
    final nome = _nomeController.text;
    final categoria = _categoriaSelecionada;
    final preco = double.tryParse(_precoController.text);

    if (nome.isNotEmpty && categoria != null && preco != null && preco >= 0) {
      Navigator.pop(context, ItemLista(nome, categoria, preco));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Por favor, preencha todos os campos corretamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }
}
