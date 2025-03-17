# AI Buddy

A modern Flutter application that leverages Google's Gemini API to provide intelligent chat interactions with text, PDFs, and images. The app offers a clean, user-friendly interface for having conversations with different types of AI assistants.

## Features

🤖 **Multiple Chat Types**

- Text-based chat with Gemini AI
- PDF document analysis and Q&A
- Image-based discussions
- Streaming responses for real-time interaction
- Chat history management

📱 **Modern UI/UX**

- Clean and intuitive interface
- Smooth animations
- Dark theme support
- Responsive design
- Custom UI components

🔒 **Security & Storage**

- Secure API key storage
- Local chat history
- Efficient data management with Hive
- PDF text extraction and processing
- Image handling and analysis

🎨 **Design Elements**

- Custom background patterns
- Elegant color schemes
- Consistent typography
- Intuitive navigation
- Responsive layouts

## Technical Stack

### Frontend

- Flutter for cross-platform development
- Riverpod for state management
- Custom widgets and animations
- Hive for local storage
- Google Fonts for typography

### AI Integration

- Google Gemini API
- PDF processing
- Image analysis
- Text embeddings
- Real-time chat streaming

## Getting Started

### Prerequisites

- Flutter (latest version)
- Google Gemini API key
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository

```bash
git clone https://github.com/yourusername/ai_buddy.git
```

2. Install dependencies

```bash
cd ai_buddy
flutter pub get
```

3. Configure Gemini API

- Get your API key from Google's Makersuite
- Add the API key in the app settings
- Start chatting with AI!

4. Run the app

```bash
flutter run
```

## Project Structure

```
lib/
├── core/                 # Core functionality
│   ├── app/             # App configuration
│   ├── config/          # Constants and configs
│   ├── extension/       # Extension methods
│   ├── navigation/      # Routing
│   └── ui/             # Shared UI components
├── feature/            # Feature modules
│   ├── chat/          # Chat functionality
│   ├── gemini/        # Gemini API integration
│   ├── hive/          # Local storage
│   ├── home/          # Home screen
│   └── welcome/       # Welcome screen
└── main.dart          # Entry point
```

## Features in Detail

### Chat Features

- Real-time streaming responses
- Multiple chat types (Text, PDF, Image)
- Chat history management
- Message persistence
- Rich text formatting

### PDF Features

- Document text extraction
- Content analysis
- Question answering
- Text chunk processing
- Semantic search

### Image Features

- Image upload and analysis
- Visual question answering
- Image context understanding
- Real-time responses

## Contributing

Contributions are welcome! Please feel free to submit a pull request or ask for any contributions.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
