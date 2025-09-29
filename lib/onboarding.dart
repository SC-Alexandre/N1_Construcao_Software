import 'package:flutter/material.dart';
import 'package:todoapp/welcomeScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // lista imagens onboard
  final List<String> _imagePaths = [
    'assets/images/onboard-001.png',
    'assets/images/onboard-002.png',
    'assets/images/onboard-003.png',
  ];

  // Lista titulos onboard
  final List<String> _titles = [
    'Gerencie suas tarefas',
    'Crie sua rotina diaria',
    'Organize suas tarefas',
  ];

  // Lista titulos descrições onboard
  final List<String> _descriptions = [
    'Você pode gerenciar facilmente todas as suas \ntarefas diárias no Uptodo gratuitamente',
    'No Uptodo você pode criar sua \nrotina personalizada para se manter produtivo',
    'Você pode organizar suas tarefas diárias \nadicionando-as em categorias separadas',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Widget para construir o indicador de página
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_titles.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 4.0,
          width: _currentPage == index ? 24.0 : 8.0, // Barra ativa é mais larga
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.white : Colors.white38,
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // Lógica para pular o tutorial
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
            child: Text(
              'Pular',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _titles.length, // Usamos o tamanho de uma das listas
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Usamos o 'index' para pegar o item de cada lista
                      Image.asset(_imagePaths[index], height: 250),
                      const SizedBox(height: 50),
                      Text(
                        _titles[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _descriptions[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            _buildPageIndicator(),
            const SizedBox(height: 60),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0).copyWith(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: Text(
                'Voltar',
                style: TextStyle(
                  color: _currentPage > 0 ? Colors.white.withOpacity(0.7) : Colors.transparent,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_currentPage == _titles.length - 1) {
                  // Lógica para ir para a tela principal/login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: Text(
                _currentPage == _titles.length - 1 ? 'Começar' : 'Avançar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}