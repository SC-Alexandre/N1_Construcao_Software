import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // AppBar com o título "Index"
      appBar: AppBar(
        title: const Text('Index'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Corpo da tela
      body: Stack(
        children: [
          // 1. Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/zeroitens.png"),
                Container(height: 20),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 2. Conteúdo de texto centralizado
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'What do you want to do today?', // 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap + to add your tasks', // 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // 3. Botão flutuante para adicionar tarefas
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para adicionar uma nova tarefa
        },
        child: const Icon(Icons.add), // 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}