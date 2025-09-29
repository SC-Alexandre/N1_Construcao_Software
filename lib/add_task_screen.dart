import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    // É importante limpar os controladores para libertar memória
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- 2. FUNÇÃO PARA O SELETOR DE DATA E HORA ---
  // A função é 'async' porque temos que 'await' (esperar) a resposta do utilizador.
  Future<void> _selectDate(BuildContext context) async {
    // Primeiro, mostramos o seletor de data
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Data inicial que aparece
      firstDate: DateTime(2020),   // Data mínima que pode ser escolhida
      lastDate: DateTime(2040),    // Data máxima que pode ser escolhida
    );

    // Se o utilizador não escolher uma data (cancelar), não fazemos nada.
    if (pickedDate == null) return;

    // Depois, se uma data foi escolhida, mostramos o seletor de hora
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Hora inicial que aparece
      initialEntryMode: TimePickerEntryMode.input,
    );

    // Se o utilizador não escolher uma hora, não fazemos nada.
    if (pickedTime == null) return;

    // Se ambos foram escolhidos, combinamos a data e a hora num único DateTime.
    final DateTime finalDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    
    // Usamos setState para atualizar a nossa variável de estado e reconstruir a UI
    // para mostrar a data e hora selecionadas.
    setState(() {
      _selectedDate = finalDateTime;
    });
  }

  // --- 3. FUNÇÃO PARA O SELETOR DE PRIORIDADE ---
  Future<void> _selectPriority(BuildContext context) async {
    // Usamos showModalBottomSheet para criar o painel que sobe (Página 15)
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
              // Usamos GridView para criar a grelha de 1 a 10
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
                  // Usamos GestureDetector para tornar cada item clicável
                  return GestureDetector(
                    onTap: () {
                      // Ao clicar, fechamos o painel e retornamos o número da prioridade
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

    // Se o utilizador selecionou uma prioridade, atualizamos o estado
    if (result != null) {
      setState(() {
        _selectedPriority = result;
      });
    }
  }

  // --- 4. FUNÇÃO PARA O SELETOR DE CATEGORIA (similar à prioridade) ---
  Future<void> _selectCategory(BuildContext context) async {
    // Lista de categorias de exemplo, como na página 17
    final List<String> categories = ['Mercado', 'Trabalho', 'Esporte', 'Design', 'Faculdade', 'Social', 'Musica', 'Saúde', 'Filme'];
    
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
              // Usamos Wrap para que as categorias quebrem a linha automaticamente
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, category);
                    },
                    child: Chip(
                      label: Text(category),
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

            // --- 5. EXIBIR VALORES SELECIONADOS ---
            // Esta Row mostra os valores escolhidos pelo utilizador.
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

            // Botões de Ação (Calendário, Categoria, Prioridade)
            Row(
              children: [
                IconButton(
                  onPressed: () => _selectDate(context), // Chama a função do seletor de data
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => _selectCategory(context), // Chama a função do seletor de categoria
                  icon: const Icon(Icons.sell_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => _selectPriority(context), // Chama a função do seletor de prioridade
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