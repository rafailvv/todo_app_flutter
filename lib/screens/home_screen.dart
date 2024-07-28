import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _future = Supabase.instance.client.from('todo').select();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: ((context, index) {
              final task = tasks[index];
              final bool isDone = task['isDone'] == 1;
              return ListTile(
                title: Text(
                  task['title'],
                  style: TextStyle(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTask(task['id']);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        _toggleTaskDone(task['id'], !isDone);
                      },
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить задачу'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Название задачи'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста введите название задачи';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addTask();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Добавить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  void _addTask() async {
    final title = _titleController.text;
    final response = await Supabase.instance.client
        .from('todo')
        .insert({'title': title, 'isDone': 0});
    if (response.error != null) {
      // Handle error
      print('Error adding task: ${response.error!.message}');
    } else {
      print('Task added successfully!');
      // Optionally, you can update the UI to reflect the changes
      setState(() {
        _titleController.clear();
      });
    }
  }

  void _deleteTask(int taskId) async {
    final response =
        await Supabase.instance.client.from('todo').delete().eq('id', taskId);
    if (response.error != null) {
      print('Error deleting task: ${response.error!.message}');
    } else {
      print('Task deleted successfully!');
      // Optionally, you can update the UI to reflect the changes
    }
  }

  void _toggleTaskDone(int taskId, bool isDone) async {
    final response = await Supabase.instance.client
        .from('todo')
        .update({'isDone': isDone}).eq('id', taskId);
    if (response.error != null) {
      print('Error toggling task done: ${response.error!.message}');
    } else {
      print('Task toggled successfully!');
      // Optionally, you can update the UI to reflect the changes
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
