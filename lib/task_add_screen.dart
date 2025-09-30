import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Controladores para obter o texto dos campos de input
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  int? _selectedPriority;
  String? _selectedCategory;

  @override
  void dispose() {
    // limpar os controladores para libertar memória
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    // Primeiro, mostramos o seletor de data
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Data inicial que aparece
      firstDate: DateTime(2020),   // Data mínima que pode ser escolhida
      lastDate: DateTime(2040),    // Data máxima que pode ser escolhida
    );

    if (pickedDate == null) return;

    // Depois, se uma data foi escolhida, mostramos o seletor de hora
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Hora inicial que aparece
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (pickedTime == null) return;

    final DateTime finalDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    
    setState(() {
      _selectedDate = finalDateTime;
    });
  }

  Future<void> _selectPriority(BuildContext context) async {
    // showModalBottomSheet para criar o painel que sobe
    final int? result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: const Color(0xFF272727), // Cor de fundo do painel
      builder: (BuildContext context) {
        // O conteúdo do painel
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ocupa o mínimo de altura
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Prioridade da tarefa', style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true, // Impede o GridView de ter scroll infinito
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 colunas
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  final priority = index + 1;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, priority);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.flag_outlined, color: Colors.white),
                          Text('$priority', style: const TextStyle(color: Colors.white)),
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

  // --- FUNÇÃO DE CATEGORIA ATUALIZADA ---
  Future<void> _selectCategory(BuildContext context) async {
    // 1. Em vez de uma lista de Strings, usamos um Map para associar nomes a ícones.
    final Map<String, IconData> categoriesWithIcons = {
      'Trabalho': Icons.work,
      'Faculdade': Icons.school,
      'Mercado': Icons.shopping_cart,
      'Esporte': Icons.sports_soccer,
      'Design': Icons.design_services,
      'Entretenimento': Icons.movie,
      'Saúde': Icons.health_and_safety,
      'Social': Icons.people,
      'Outro': Icons.more_horiz,
    };
    
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
              const Text('Selecione a Categoria', style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                // 2. Mapeamos as entradas do Map em vez da lista.
                children: categoriesWithIcons.entries.map((entry) {
                  final categoryName = entry.key;
                  final categoryIcon = entry.value;

                  return GestureDetector(
                    onTap: () {
                      // Ao tocar, continuamos a retornar apenas o nome da categoria.
                      Navigator.pop(context, categoryName);
                    },
                    child: Chip(
                      // 3. Usamos a propriedade 'avatar' do Chip para exibir o ícone.
                      avatar: Icon(categoryIcon, color: Colors.white, size: 18),
                      label: Text(categoryName),
                      backgroundColor: Colors.grey[800],
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white), // Ícone "X" para fechar
          onPressed: () {
            Navigator.of(context).pop(); // Volta para a tela anterior
          },
        ),
        title: const Text(
          'Adicionar tarefa',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Titulo Tarefa',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                border: InputBorder.none,
              ),
            ),
            
            const SizedBox(height: 16),

            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Descrição',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
            
            const Spacer(),

            Row(
              children: [
                if (_selectedDate != null)
                  Chip(
                    label: Text(DateFormat('dd/MM/yy HH:mm').format(_selectedDate!)),
                    backgroundColor: Colors.blue,
                  ),
                if (_selectedPriority != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      avatar: const Icon(Icons.flag, color: Colors.white),
                      label: Text('$_selectedPriority'),
                      backgroundColor: Colors.red,
                    ),
                  ),
                if (_selectedCategory != null)
                  Chip(
                    label: Text(_selectedCategory!),
                    backgroundColor: Colors.purple,
                  ),
              ],
            ),

            Row(
              children: [
                IconButton(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => _selectCategory(context),
                  icon: const Icon(Icons.sell_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => _selectPriority(context),
                  icon: const Icon(Icons.flag_outlined, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_titleController.text.isNotEmpty) {
            final newTask = Task(
              title: _titleController.text,
              description: _descriptionController.text,
              date: _selectedDate,
              priority: _selectedPriority,
              category: _selectedCategory,
            );
            Navigator.of(context).pop(newTask);
          }
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}