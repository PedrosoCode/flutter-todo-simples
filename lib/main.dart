import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> _todos = [];

  TextEditingController _controller = TextEditingController();
  TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _todos.add(TodoItem(text: 'Exemplo de tarefa', isCompleted: false));
  }

  void _addTodo() {
    setState(() {
      String todoText = _controller.text;
      if (todoText.isNotEmpty) {
        _todos.add(TodoItem(text: todoText, isCompleted: false));
        _controller.clear();
      }
    });
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _toggleTodoCompletion(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  void _editTodo(int index) {
    _editController.text = _todos[index].text;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextField(
            controller: _editController,
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                setState(() {
                  _todos[index].text = _editController.text;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (BuildContext context, int index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(
                    todo.text,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: todo.isCompleted ? Colors.green : Colors.red,
                    ),
                  ),
                  onTap: () {
                    _toggleTodoCompletion(index);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editTodo(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _removeTodo(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Adicionar Tarefa',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTodo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem {
  String text;
  bool isCompleted;

  TodoItem({required this.text, required this.isCompleted});
}
