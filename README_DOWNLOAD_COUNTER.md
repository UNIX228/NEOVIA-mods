# 📊 NEOVIA Mod Download Counter

Простая система для отслеживания скачиваний графических модов для Nintendo Switch игр.

## 🚀 Возможности

- ✅ Автоматическое обновление счетчика в modinfo.json
- ✅ Сохранение статистики в JSON файл
- ✅ Веб-интерфейс для просмотра статистики
- ✅ API для интеграции
- ✅ Топ самых популярных модов

## 📦 Использование

### Базовое использование

```python
from download_counter import DownloadCounter

# Создать счетчик
counter = DownloadCounter()

# Записать скачивание
counter.record_download("TOTK", "The Legend of Zelda: Tears of the Kingdom")

# Получить статистику
stats = counter.get_stats("TOTK")
print(f"Downloads: {stats['downloads']}")

# Топ игр
top_games = counter.get_top_games(5)
for game_id, game_data in top_games:
    print(f"{game_data['game_name']}: {game_data['downloads']} downloads")
```

### Демонстрация

```bash
# Запустить демо
python3 demo_downloads.py

# Запустить веб-интерфейс
python3 stats_viewer.py
# Открыть http://localhost:5000
```

## 📊 Структура данных

### modinfo.json
```json
{
  "name": "Ultra Graphics Pack",
  "version": "1.0.0",
  "author": "Unix228",
  "game_id": "TOTK",
  "description": "Maximum graphics quality...",
  "type": "graphics",
  "downloads": 15
}
```

### download_stats.json
```json
{
  "total_downloads": 150,
  "games": {
    "TOTK": {
      "game_name": "The Legend of Zelda: Tears of the Kingdom",
      "downloads": 25,
      "first_download": "2025-07-31T01:38:36.382698",
      "last_download": "2025-07-31T01:39:19.455063"
    }
  },
  "last_updated": "2025-07-31T01:39:19.455063"
}
```

## 🎯 API Методы

### DownloadCounter.record_download(game_id, game_name)
Записывает скачивание для конкретной игры и обновляет modinfo.json

### DownloadCounter.get_stats(game_id=None)
Получает статистику:
- Без параметров: общая статистика
- С game_id: статистика конкретной игры

### DownloadCounter.get_top_games(limit=10)
Получает топ игр по скачиваниям

### DownloadCounter.print_stats()
Выводит статистику в консоль

## 🌐 Веб-интерфейс

### Запуск
```bash
python3 stats_viewer.py
```

### Доступные страницы
- `/` - Основная страница со статистикой
- `/api/stats` - JSON API для получения статистики

## 📈 Примеры интеграции

### В NEOVIA
```python
# При скачивании мода
counter = DownloadCounter()
counter.record_download(game_id, game_name)
```

### В веб-приложении
```javascript
// Получить статистику
fetch('/api/stats')
    .then(response => response.json())
    .then(data => console.log(data));
```

## 🔧 Настройка

### Добавление новых игр
Просто вызовите `record_download()` с новым game_id - система автоматически создаст запись.

### Изменение формата данных
Отредактируйте методы в `DownloadCounter` для изменения структуры данных.

## 📊 Текущая статистика

Запустите демо для просмотра текущей статистики:
```bash
python3 demo_downloads.py
```

## 🎮 Поддерживаемые игры

Система автоматически поддерживает все 70 игр:
- The Legend of Zelda: Tears of the Kingdom (TOTK)
- The Legend of Zelda: Breath of the Wild (BOTW)
- Minecraft (MC)
- Super Mario Odyssey (SMO)
- Mario Kart 8 Deluxe (MK8D)
- И многие другие...

## 🚀 Быстрый старт

1. **Записать скачивание:**
```python
from download_counter import DownloadCounter
counter = DownloadCounter()
counter.record_download("TOTK", "The Legend of Zelda: Tears of the Kingdom")
```

2. **Посмотреть статистику:**
```python
counter.print_stats()
```

3. **Запустить веб-интерфейс:**
```bash
python3 stats_viewer.py
```

## 📝 Лицензия

MIT License - свободное использование и модификация.