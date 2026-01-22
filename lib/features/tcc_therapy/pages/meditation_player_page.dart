import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class MeditationPlayerPage extends StatefulWidget {
  final String exerciseId;

  const MeditationPlayerPage({super.key, required this.exerciseId});

  @override
  State<MeditationPlayerPage> createState() => _MeditationPlayerPageState();
}

class _MeditationPlayerPageState extends State<MeditationPlayerPage> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Mapa de exercícios com URLs de exemplo (sons relaxantes públicos)
  final Map<String, Map<String, String>> _exercises = {
    'rain_ambience': {
      'title': 'Chuva Suave',
      'url': 'https://actions.google.com/sounds/v1/weather/rain_heavy_loud.ogg',
      'image': 'assets/images/rain.jpg', // Placeholder
    },
    'forest_sounds': {
      'title': 'Floresta Calma',
      'url': 'https://actions.google.com/sounds/v1/ambiences/forest_morning.ogg',
      'image': 'assets/images/forest.jpg',
    },
    'guided_relax': {
      'title': 'Relaxamento Guiado',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', // Exemplo provisório
      'image': 'assets/images/meditate.jpg',
    },
  };

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listeners
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });
    
    // Auto-play ao abrir
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    final exercise = _exercises[widget.exerciseId] ?? _exercises.values.first;
    try {
      await _audioPlayer.setSourceUrl(exercise['url']!);
    } catch (e) {
      print("Erro ao carregar áudio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _exercises[widget.exerciseId] ?? _exercises.values.first;

    return Scaffold(
      backgroundColor: Colors.grey[900], // Fundo escuro para imersão
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Capa do Álbum (Visualização)
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.music_note,
              size: 100,
              color: Colors.white.withOpacity(0.5),
            ),
          ),

          // Informações
          Column(
            children: [
              Text(
                exercise['title']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Terapia Sonora',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
            ],
          ),

          // Controles de Progresso
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble()),
                  activeColor: AppColors.primary,
                  inactiveColor: Colors.white.withOpacity(0.2),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTime(_position),
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                      Text(
                        _formatTime(_duration),
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Botões de Controle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 40,
                icon: const Icon(Icons.replay_10, color: Colors.white),
                onPressed: () {
                   final newPos = _position - const Duration(seconds: 10);
                   _audioPlayer.seek(newPos < Duration.zero ? Duration.zero : newPos);
                },
              ),
              const SizedBox(width: 20),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 64,
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    if (_isPlaying) {
                      await _audioPlayer.pause();
                    } else {
                      await _audioPlayer.resume();
                    }
                  },
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                iconSize: 40,
                icon: const Icon(Icons.forward_10, color: Colors.white),
                onPressed: () {
                   final newPos = _position + const Duration(seconds: 10);
                   _audioPlayer.seek(newPos > _duration ? _duration : newPos);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
