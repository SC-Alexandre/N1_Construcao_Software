// home.dart

import 'package:flutter/material.dart';
import 'package:todoapp/task_add_screen.dart';
import 'package:todoapp/task_edit_screen.dart'; 
import 'package:todoapp/task_list_item.dart';
import 'package:todoapp/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [];

  List<Task> get _incompleteTasks => _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get _completedTasks => _tasks.where((task) => task.isCompleted).toList();

  void _navigateToAddTaskScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (result != null && result is Task) {
      setState(() {
        _tasks.add(result);
      });
    }
  }

  // Função atualizada para lidar com edição E deleção
  void _navigateToEditScreen(Task taskToEdit) async {
    final int taskIndex = _tasks.indexOf(taskToEdit);

    // O resultado pode ser um Task (editado) ou uma String ('delete')
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskScreen(initialTask: taskToEdit)),
    );

    if (result != null) {
      setState(() {
        if (result is Task) {
          // Se for uma Task, atualizamos a tarefa na lista
          _tasks[taskIndex] = result;
        } else if (result == 'delete') {
          // Se for a string 'delete', removemos a tarefa da lista
          _tasks.removeAt(taskIndex);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Index', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/zeroitens.png", width: 250, height: 250),
                  const SizedBox(height: 20),
                  const Text('O que você quer fazer hoje?', style: TextStyle(color: Colors.white, fontSize: 20)),
                  const Text('clique no + para adicionar suas tarefas', style: TextStyle(color: Colors.white)),
                ],
              ),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for your task...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      fillColor: const Color(0xFF1D1D1D),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                if (_incompleteTasks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Hoje', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  ),
                ..._incompleteTasks.map((task) {
                  return TaskListItem(
                    task: task,
                    onTap: () {
                      _navigateToEditScreen(task);
                    },
                    onToggleCompleted: (value) {
                      setState(() {
                        task.isCompleted = value ?? false;
                      });
                    },
                  );
                }),
                if (_completedTasks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Concluídas', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  ),
                ..._completedTasks.map((task) {
                  return TaskListItem(
                    task: task,
                    onTap: () {
                      _navigateToEditScreen(task);
                    },
                    onToggleCompleted: (value) {
                      setState(() {
                        task.isCompleted = value ?? false;
                      });
                    },
                  );
                }),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskScreen,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}