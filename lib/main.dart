import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galeria de Imagens',
      debugShowCheckedModeBanner: false, // Remove o debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 192, 187, 187)),
      ),
      home: const MyHomePage(title: 'Galeria de Imagens'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0; // Índice da imagem atual
  late AnimationController _controller;
  late Animation<double> _animation;

  // Lista de URLs de imagens
  final List<String> imageUrls = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQAtQUGNqLTf6OP70M-6FnAiKa0RRGFW6XXg&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQn_-sU1SX1swvGcOk4rGtgA0iXW8DR8myNOw&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSk1wByJn5xCkmSlSQKluby2XXXZh3zE_6JIw&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgcPHZ7amNYti2lVX6jHhwQsFqYqBr05oXbQ&s',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeImage(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
    _controller.forward(from: 0); // Reinicia a animação
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 249, 242, 229),
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[_currentIndex],
                    imageBuilder: (context, imageProvider) => Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: ResizeImage(imageProvider, width: 300, height: 300),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red, size: 48),
                  ),
                );
              },
            ),
          ),
          // Botão voltar (à esquerda)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_circle_left_outlined,
                  size: 40,
                  color: Colors.blue,
                ),
                onPressed: () {
                  _changeImage((_currentIndex - 1 + imageUrls.length) % imageUrls.length);
                },
              ),
            ),
          ),
          // Botão avançar (à direita)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_circle_right_outlined,
                  size: 40,
                  color: Colors.blue,
                ),
                onPressed: () {
                  _changeImage((_currentIndex + 1) % imageUrls.length);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}