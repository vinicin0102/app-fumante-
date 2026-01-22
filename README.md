# 🍃 Livre.io

Aplicativo Flutter para ajudar pessoas a parar de fumar, com suporte a TCC (Terapia Cognitivo-Comportamental), gamificação e comunidade.

## 📱 Funcionalidades

### Dashboard
- ⏱️ Timer de abstinência em tempo real
- 💰 Economia calculada automaticamente
- ❤️ Benefícios de saúde com timeline
- 🎯 Missões diárias com XP

### Diário Emocional
- 📝 Registro de humor e vontades
- 🔍 Identificação de gatilhos
- 📊 Análise de padrões

### Terapia TCC
- 🧘 Exercícios de respiração guiados
- 🧠 Reestruturação cognitiva
- 🎧 Orientações por áudio

### Gamificação
- ⭐ Sistema de XP e níveis
- 🏆 Conquistas e badges
- 🔥 Streaks de dias sem fumar

### Comunidade
- 👥 Suporte entre usuários
- 💬 Posts anônimos
- ❤️ Likes e comentários

## 🛠️ Tecnologias

- **Flutter 3.x** - Framework UI
- **Firebase** - Auth, Firestore, Messaging
- **BLoC** - Gerenciamento de estado
- **GetIt** - Injeção de dependências
- **GoRouter** - Navegação

## 📁 Estrutura do Projeto

```
lib/
├── core/              # Tema, constantes, utils
├── data/              # Modelos, repositórios
├── domain/            # Entidades, use cases
├── presentation/      # BLoCs, Cubits
└── features/          # Módulos por funcionalidade
    ├── onboarding/
    ├── dashboard/
    ├── journal/
    ├── tcc_therapy/
    ├── community/
    └── settings/
```

## 🚀 Como Executar

1. **Instale o Flutter SDK**
   ```bash
   # Veja: https://docs.flutter.dev/get-started/install
   ```

2. **Clone e instale dependências**
   ```bash
   cd quitnow-pro
   flutter pub get
   ```

3. **Configure o Firebase**
   ```bash
   flutterfire configure
   ```

4. **Execute o app**
   ```bash
   flutter run
   ```

## 📦 Dependências Principais

```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.14.0
  cloud_firestore: ^4.15.0
  flutter_bloc: ^8.1.3
  go_router: latest
  google_fonts: ^6.1.0
  percent_indicator: ^4.2.3
  audioplayers: ^5.3.6
```

## 🎨 Design System

O app usa um design system customizado com:

- **Cores**: Paleta de verde-teal para saúde e bem-estar
- **Tipografia**: Google Fonts (Poppins)
- **Componentes**: Cards arredondados, animações suaves
- **Tema**: Suporte a modo claro e escuro

## 📈 Marcos de Saúde

O app mostra benefícios científicos baseados no tempo sem fumar:

| Tempo | Benefício |
|-------|-----------|
| 20 min | Pressão e pulso normalizam |
| 24h | Monóxido de carbono eliminado |
| 48h | Paladar e olfato melhoram |
| 72h | Respiração mais fácil |
| 1 semana | Circulação melhora |
| 1 mês | Tosse diminui |
| 1 ano | Risco cardíaco cai 50% |

## 🧪 Testes

```bash
flutter test
flutter test --coverage
```

## 📄 Licença

Este projeto está sob a licença MIT.

---

Desenvolvido com ❤️ para ajudar pessoas a terem uma vida mais saudável.
