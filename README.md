# AI Chat Flutter

AI Chat Flutter - это мобильное приложение на Flutter для общения с ИИ-моделями через API OpenRouter или VSEGPT. Поддерживает чат, статистику использования, расходы и настройки.

## Особенности

- Чат с ИИ-моделями (GPT, Claude, DeepSeek и другие)
- Поддержка бесплатных моделей
- Отслеживание расходов и токенов
- Статистика использования моделей
- Экспорт истории чата и логов
- Настройки API (OpenRouter.ai и VSEGPT.ru)
- Темная тема, русский интерфейс

## Требования

- Flutter 3.0+
- Dart 3.0+
- API ключ от OpenRouter или VSEGPT

## Установка

1. Клонируйте репозиторий:
   ```
   git clone https://github.com/yourusername/aichatflutter.git
   cd aichatflutter
   ```

2. Установите зависимости:
   ```
   flutter pub get
   ```

3. Создайте файл `.env` на основе `.env.example` и добавьте ваш API ключ:
   ```
   OPENROUTER_API_KEY=your_api_key_here
   BASE_URL=https://openrouter.ai/api/v1
   MAX_TOKENS=1000
   TEMPERATURE=0.7
   ```

4. Запустите приложение:
   ```
   flutter run
   ```

## Настройка

В приложении перейдите в Настройки:
- Выберите провайдера: OpenRouter или VSEGPT
- Введите API ключ
- Сохраните настройки

Для VSEGPT baseUrl автоматически устанавливается на `https://api.vsegpt.ru/v1`.

## Использование

1. Выберите модель в чате
2. Введите сообщение и отправьте
3. Просматривайте историю, статистику и расходы в соответствующих вкладках
4. Используйте кнопку обновления для перезагрузки моделей

## Структура проекта

- `lib/api/openrouter_client.dart` - Клиент для API
- `lib/providers/chat_provider.dart` - Провайдер состояния чата
- `lib/screens/` - Экраны приложения (Home, Stats, Expenses, Settings)
- `lib/services/` - Сервисы (Database, Analytics)
- `assets/` - Активы

## API Поддержка

- OpenRouter.ai: Полный список моделей, баланс в $
- VSEGPT.ru: Российский сервис, баланс в ₽, поддержка моделей

## Лицензия

MIT License
