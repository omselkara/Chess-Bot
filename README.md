# Chess Bot - Advanced Chess Engine

A sophisticated chess engine built with Processing, featuring AI opponent with Alpha-Beta pruning, opening book database, and GUI interface.

## 🎯 Features

### Core Functionality
- **Interactive GUI**: Visual chess board with drag-and-drop piece movement
- **AI Opponent**: Intelligent bot using Alpha-Beta pruning algorithm
- **Opening Book**: Large database of opening moves for strategic play
- **Sound Effects**: Audio feedback for moves and captures
- **Move Validation**: Full chess rules implementation including:
  - En passant captures
  - Castling (kingside and queenside)
  - Pawn promotion
  - Check and checkmate detection
  - Stalemate and draw detection

### Advanced AI Features
- **Alpha-Beta Pruning**: Efficient search algorithm for move selection
- **Quiescence Search**: Extended search for tactical positions
- **Transposition Table**: Position caching for performance optimization
- **Zobrist Hashing**: Fast position identification
- **Move Ordering**: Optimized search order for better pruning
- **Iterative Deepening**: Progressive depth search within time constraints
- **Position Evaluation**: Sophisticated board evaluation including:
  - Material counting
  - Piece-square tables for positional play
  - Endgame-specific king evaluation

## 📋 Requirements

### Software Dependencies
- **Processing 3.x or 4.x**: [Download here](https://processing.org/download)
- **Processing Sound Library**: Required for audio playback
  - Install via: Sketch → Import Library → Add Library → Search "Sound"
  - Or visit: https://processing.org/reference/libraries/sound/index.html

## 🚀 Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/omselkara/Chess-Bot.git
   cd Chess-Bot
   ```

2. **Install Processing Sound Library**
   - Open Processing IDE
   - Go to `Sketch → Import Library → Add Library`
   - Search for "Sound"
   - Click "Install"

3. **Open the project**
   - Launch Processing
   - Open `Chess_Bot.pde`
   - Click Run button (▶️) to start

## 🎮 How to Use

### Playing Against the Bot
1. Run the sketch in Processing
2. The bot plays as **Black** by default (configurable)
3. Click and drag pieces to make your moves
4. The bot will automatically respond after your move
5. Game state and evaluation are displayed on the right panel

### Configuration

Edit `Bot.pde` to customize bot settings:

```java
boolean bot = true;           // Enable/disable bot
boolean botIsWhite = false;   // Set bot color (false = black, true = white)
int duration = 1000;          // Thinking time in milliseconds (1000 = 1 second)
```

### Display Information
- **Depth**: Current search depth the bot reached
- **Eval**: Position evaluation (positive = white advantage, negative = black advantage)

## 📁 Project Structure

```
Chess-Bot/
├── Chess_Bot.pde          # Main entry point, setup and draw loop
├── Bot.pde                # Bot AI controller and opening book player
├── AlphaBeta.pde          # Alpha-Beta search algorithm
├── MinMax.pde             # MinMax algorithm (alternative)
├── Game.pde               # Game state management and move generation
├── Gui.pde                # Graphical interface rendering
├── Evaluate_Board.pde     # Position evaluation functions
├── Move.pde               # Move representation
├── MoveList.pde           # Move list container
├── PrepareMoves.pde       # Move generation preparation
├── OrderMoves.pde         # Move ordering for alpha-beta
├── Transposition.pde      # Transposition table implementation
├── Zobrist.pde            # Zobrist hashing for positions
├── Repetetion_Table.pde   # Threefold repetition detection
├── SearchResult.pde       # Search result structure
├── Perft.pde              # Performance testing (move generation)
├── Pieces.pde             # Piece type definitions
├── Pos.txt                # Opening book positions (preprocessed)
├── Pieces/                # Chess piece images
│   ├── white-*.png        # White piece sprites
│   └── black-*.png        # Black piece sprites
├── Sounds/                # Audio files
│   ├── move-self.mp3      # Move sound effect
│   └── capture.mp3        # Capture sound effect
└── OpeningBook/           # Opening book data
    ├── Open.txt           # Raw opening lines
    ├── Pos.txt            # Processed positions
    └── Move Translate.py  # Opening book processor
```

## 🧠 Technical Details

### Search Algorithm
The engine uses **Alpha-Beta pruning** with several enhancements:
- **Iterative Deepening**: Searches progressively deeper until time limit
- **Quiescence Search**: Extends search in tactical positions (captures)
- **Transposition Table**: Stores evaluated positions to avoid recalculation
- **Move Ordering**: Prioritizes promising moves for better pruning

### Evaluation Function
Position scoring considers:
- **Material**: Pawn=1, Knight=3, Bishop=3, Rook=5, Queen=9
- **Piece-Square Tables**: Bonus/penalty for piece positions
- **King Safety**: Different evaluation for middlegame vs endgame
- **Tactical Awareness**: Checks, captures, and threats

### Opening Book
- Contains thousands of master-level opening positions
- Bot plays book moves when available for first ~10-15 moves
- Provides variety by selecting randomly from multiple book lines

## 🎯 Performance

- **Search Depth**: Typically reaches 6-8 ply in 1 second
- **Nodes per Second**: Varies based on position complexity
- **Opening Phase**: Instant moves from book database
- **Endgame**: Deeper search due to reduced pieces

## 🔧 Development

### Adding New Features
- Modify evaluation weights in `Evaluate_Board.pde`
- Adjust search parameters in `AlphaBeta.pde`
- Change time controls in `Bot.pde`

### Testing Move Generation
Uncomment the Perft test in `Chess_Bot.pde` setup function:
```java
for (int i=0;i<7;i++){
  int time = millis();
  depth = i;
  long count = Perft(0,game);
  println(str(i+1)+"  "+str((int)count)+ "  " +str((millis()-time)/1000.0f));
}
```

## 🐛 Troubleshooting

**Issue**: Sound library error
- **Solution**: Install Processing Sound library (see Requirements)

**Issue**: Images not loading
- **Solution**: Ensure `Pieces/` folder is in the sketch directory

**Issue**: Bot not moving
- **Solution**: Check `bot` variable is `true` in `Bot.pde`

**Issue**: Performance issues
- **Solution**: Reduce `duration` value in `Bot.pde` for faster (but weaker) moves

## 📝 License

This project is open source. Feel free to use, modify, and distribute.

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

## 👨‍💻 Author

Created by [omselkara](https://github.com/omselkara)

## 🌟 Acknowledgments

- Processing Foundation for the Processing platform
- Chess programming community for algorithms and techniques
- Opening book data from master games

---

## 🇹🇷 Türkçe Açıklama

### Kurulum
1. Processing'i indirin ve yükleyin
2. Processing Sound kütüphanesini yükleyin
3. Chess_Bot.pde dosyasını Processing'de açın
4. Çalıştır butonuna basın

### Kullanım
- Bot varsayılan olarak siyah renkte oynar
- Beyaz taşları sürükleyip bırakarak hamle yapın
- Bot otomatik olarak cevap verecektir
- `Bot.pde` dosyasından bot ayarlarını değiştirebilirsiniz

### Özellikler
- Gelişmiş yapay zeka (Alpha-Beta budama algoritması)
- Açılış kitabı desteği
- Ses efektleri
- Görsel arayüz
- Tam satranç kuralları implementasyonu
