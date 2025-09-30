// edit_task_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  // Recebe a tarefa original que será editada
  final Task initialTask;

  const EditTaskScreen({Key? key, required this.initialTask}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  // Variáveis de estado para armazenar os dados editados.
  // Iniciamos com os valores da tarefa original.
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  int? _selectedPriority;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Copia os dados da tarefa inicial para o estado local do widget
    _titleController = TextEditingController(text: widget.initialTask.title);
    _descriptionController = TextEditingController(
      text: widget.initialTask.description,
    );
    _selectedDate = widget.initialTask.date;
    _selectedPriority = widget.initialTask.priority;
    _selectedCategory = widget.initialTask.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- FUNÇÕES DE SELEÇÃO ---

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _selectPriority(BuildContext context) async {
    final int? result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: const Color(0xFF272727),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Prioridade da Tarefa',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  final priority = index + 1;
                  return GestureDetector(
                    onTap: () => Navigator.pop(context, priority),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.flag_outlined, color: Colors.white),
                          Text(
                            '$priority',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _selectedPriority = result;
      });
    }
  }

  Future<void> _selectCategory(BuildContext context) async {
    final List<String> categories = [
      'Mercado',
      'Trabalho',
      'Esporte',
      'Design',
      'Faculdade',
      'Social',
    ];
    final String? result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF272727),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Escolha a Categoria',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: categories.map((category) {
                  return ActionChip(
                    label: Text(category),
                    backgroundColor: Colors.grey[800],
                    labelStyle: const TextStyle(color: Colors.white),
                    onPressed: () => Navigator.pop(context, category),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedCategory = result;
      });
    }
  }

  // --- FUNÇÃO PARA DELETAR A TAREFA ---
  Future<void> _deleteTask(BuildContext context) async {
    final bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF272727),
          title: const Text(
            'Deletar Tarefa',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Você tem certeza que deseja deletar esta tarefa?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Deletar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      Navigator.of(context).pop('delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Editar Tarefa',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              final updatedTask = Task(
                title: _titleController.text,
                description: _descriptionController.text,
                date: _selectedDate,
                priority: _selectedPriority,
                category: _selectedCategory,
                isCompleted: widget.initialTask.isCompleted,
              );
              Navigator.pop(context, updatedTask);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white, fontSize: 24),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Título',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.grey),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Descrição',
              ),
            ),
            const SizedBox(height: 32),
            ListTile(
              onTap: () => _selectDate(context),
              leading: const Icon(
                Icons.calendar_today_outlined,
                color: Colors.white70,
              ),
              title: const Text(
                'Data e Hora',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _selectedDate == null
                    ? 'Não definida'
                    : DateFormat('dd MMM, HH:mm').format(_selectedDate!),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              onTap: () => _selectCategory(context),
              leading: const Icon(Icons.sell_outlined, color: Colors.white70),
              title: const Text(
                'Categoria',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _selectedCategory ?? 'Não definida',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              onTap: () => _selectPriority(context),
              leading: const Icon(Icons.flag_outlined, color: Colors.white70),
              title: const Text(
                'Prioridade',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _selectedPriority == null
                    ? 'Não definida'
                    : 'Prioridade $_selectedPriority',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: TextButton.icon(
                onPressed: () => _deleteTask(context),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  'Deletar Tarefa',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
