import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/chat_message.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  Timer? _simulationTimer;

  // Nomes para simular outros usuários
  final List<String> _fakeUsers = [
    'João Silva', 'Maria B.', 'Pedro Santos', 'Ana Vitória', 
    'Carlos D.', 'Luana M.', 'Rafaela', 'Guerreiro123'
  ];

  // Mensagens de apoio aleatórias
  final List<String> _fakeMessages = [
    'Força pessoal! Hoje completei 3 dias!',
    'Alguém mais sente muita vontade depois do almoço?',
    'Beba água, ajuda muito!',
    'Não desista, vale a pena.',
    'Estou aqui na luta também.',
    'O exercício de respiração me salvou hoje.',
    'Bom dia grupo! Mais um dia limpo.',
    'Parabéns pela conquista!',
  ];

  @override
  void initState() {
    super.initState();
    // Adicionar mensagens iniciais
    _addInitialMessages();
    
    // Simular chat ativo (uma mensagem a cada 5-10 segundos)
    _startSimulation();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _simulationTimer?.cancel();
    super.dispose();
  }

  void _addInitialMessages() {
    setState(() {
      _messages.addAll([
        ChatMessage(
          id: '1',
          text: 'Sejam bem-vindos ao Chat Global! Aqui nos apoiamos na jornada contra o cigarro. 🚭',
          senderName: 'Moderador',
          isMe: false,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ChatMessage(
          id: '2',
          text: 'Estou completando 1 mês hoje! 🎉',
          senderName: 'Carla Dias',
          isMe: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
      ]);
    });
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (Random().nextBool()) { // 50% de chance de mandar mensagem
        _receiveFakeMessage();
      }
    });
  }

  void _receiveFakeMessage() {
    final randomUser = _fakeUsers[Random().nextInt(_fakeUsers.length)];
    final randomMsg = _fakeMessages[Random().nextInt(_fakeMessages.length)];
    
    final message = ChatMessage(
      id: DateTime.now().toString(),
      text: randomMsg,
      senderName: randomUser,
      isMe: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().toString(),
      text: _controller.text,
      senderName: 'Você',
      isMe: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
      _controller.clear();
    });
    _scrollToBottom();

    // Simular resposta rápida de alguém
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            id: DateTime.now().add(const Duration(milliseconds: 100)).toString(),
            text: 'Isso aí! Continue firme! 👏',
            senderName: 'Comunidade Bot',
            isMe: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chat Global', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${124 + _messages.length} online',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Regras: Seja gentil e apoie os outros!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Área de mensagens
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatBubble(message: msg);
              },
            ),
          ),

          // Campo de entrada
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: _sendMessage,
                    elevation: 0,
                    mini: true,
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.send, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: isMe ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe 
                        ? Colors.white.withOpacity(0.7) 
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
