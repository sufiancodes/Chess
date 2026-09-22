# ♟️ Chess CLI

A classic two-player chess game built in Ruby and played directly in your terminal.



## ✨ Overview

Chess CLI brings the fundamentals of chess to the command line with a simple, interactive interface. Challenge a friend, make your moves, save your progress, and continue the game whenever you are ready.

## 📸 Preview

<img width="600" height="400" alt="Chess CLI game preview" src="https://github.com/user-attachments/assets/5e1442c0-3804-434b-aee3-ff132e1a6b66" />

## 🎯 Features

- ✅ Two-player local chess gameplay
- ✅ Checkmate detection
- ✅ Castling
- ✅ Save an in-progress game
- ✅ Load a previously saved game
- ✅ Quit safely at any time
- ✅ Interactive command-line board

## 🛠️ Built With

- [Ruby](https://www.ruby-lang.org/)
- [RSpec](https://rspec.info/) for testing
- [RuboCop](https://rubocop.org/) for code quality

## 🚀 Getting Started

### Prerequisites

Make sure Ruby and Bundler are installed on your machine.

### Installation

Clone the repository and install the project dependencies:

```bash
git clone https://github.com/sufiancodes/Chess.git
cd Chess
bundle install
```

### Run the game

```bash
ruby main.rb
```

## 🎮 Commands

During the game, enter one of the following commands when prompted to choose a piece:

| Command | Action |
| --- | --- |
| `save` | Save the current game |
| `load` | Load a saved game |
| `quit` | Exit the game |

For regular moves, follow the prompts shown in the terminal.

## 🧪 Running Tests

Run the test suite with:

```bash
bundle exec rspec
```

To check the code style with RuboCop:

```bash
bundle exec rubocop
```

## 🗺️ Roadmap

The following chess rules are still planned or under development:

- [ ] En passant
- [ ] Stalemate detection
- [ ] Improved input validation
- [ ] Additional gameplay polish

## 🤝 Contributing

Contributions, suggestions, and bug reports are welcome. Feel free to open an issue or submit a pull request.
