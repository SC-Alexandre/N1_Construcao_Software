import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Controladores para obter o texto dos campos de input
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    // É importante limpar os controladores para libertar memória
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            // Campo de Texto para o Título da Tarefa
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Titulo Tarefa',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                border: InputBorder.none, // Remove a linha de baixo
              ),
            ),
            
            const SizedBox(height: 16),

            // Campo de Texto para a Descrição
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Descrição',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
            
            const Spacer(), // Empurra os itens seguintes para o fundo

            // Botões de Ação (Calendário, Categoria, Prioridade)
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Lógica para abrir o seletor de data
                  },
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    // Lógica para abrir o seletor de categoria
                  },
                  icon: const Icon(Icons.sell_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    // Lógica para abrir o seletor de prioridade
                  },
                  icon: const Icon(Icons.flag_outlined, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      // Botão Flutuante para criar a tarefa
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para salvar a nova tarefa
          // Exemplo:
          // final title = _titleController.text;
          // final description = _descriptionController.text;
          // print('Tarefa: $title, Descrição: $description');
          Navigator.of(context).pop(); // Fecha a tela após adicionar
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}