# 📊 NEOVIA Mod Download Tracker

Система для отслеживания скачиваний графических модов для Nintendo Switch игр.

## 🚀 Возможности

- ✅ Отслеживание скачиваний по каждой игре
- ✅ Статистика популярности модов
- ✅ Веб-интерфейс для просмотра статистики
- ✅ REST API для интеграции
- ✅ Экспорт данных в JSON
- ✅ Автоматическое обновление статистики

## 📦 Установка

1. Установите зависимости:
```bash
pip install flask sqlite3
```

2. Запустите API сервер:
```bash
python download_api.py
```

3. Откройте браузер: `http://localhost:5000`

## 🔧 Использование

### Веб-интерфейс
- Откройте `http://localhost:5000` для просмотра статистики
- Статистика обновляется автоматически каждые 30 секунд
- Нажмите "Refresh Statistics" для ручного обновления

### API Endpoints

#### Записать скачивание
```bash
curl -X POST http://localhost:5000/download/TOTK \
  -H "Content-Type: application/json" \
  -d '{"game_name": "The Legend of Zelda: Tears of the Kingdom", "mod_name": "Ultra Graphics Pack"}'
```

#### Получить статистику
```bash
# Все игры
curl http://localhost:5000/stats

# Конкретная игра
curl http://localhost:5000/stats?game_id=TOTK
```

#### Топ игр
```bash
curl http://localhost:5000/top?limit=10
```

#### Экспорт данных
```bash
curl http://localhost:5000/export
```

## 📈 Примеры использования

### Python
```python
from download_tracker import ModDownloadTracker

tracker = ModDownloadTracker()

# Записать скачивание
tracker.record_download("TOTK", "The Legend of Zelda: Tears of the Kingdom", "Ultra Graphics Pack")

# Получить статистику
stats = tracker.get_download_stats("TOTK")
print(f"Downloads: {stats[0][2]}")

# Топ игр
top_games = tracker.get_top_downloaded_games(5)
for game_id, game_name, downloads in top_games:
    print(f"{game_name}: {downloads} downloads")
```

### JavaScript
```javascript
// Записать скачивание
fetch('/download/TOTK', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
        game_name: 'The Legend of Zelda: Tears of the Kingdom',
        mod_name: 'Ultra Graphics Pack'
    })
});

// Получить статистику
fetch('/stats')
    .then(response => response.json())
    .then(data => console.log(data));
```

## 📊 Структура данных

### База данных SQLite
- `mod_downloads` - записи скачиваний
- `mod_stats` - агрегированная статистика

### JSON экспорт
```json
{
  "export_date": "2024-01-15T10:30:00",
  "total_games": 70,
  "total_downloads": 1250,
  "games": [
    {
      "game_id": "TOTK",
      "game_name": "The Legend of Zelda: Tears of the Kingdom",
      "total_downloads": 150,
      "last_download": "2024-01-15T10:25:00",
      "first_download": "2024-01-01T09:00:00"
    }
  ]
}
```

## 🎯 Интеграция с NEOVIA

Для интеграции с NEOVIA добавьте в modinfo.json:

```json
{
  "name": "Ultra Graphics Pack",
  "version": "1.0.0",
  "author": "Unix228",
  "game_id": "TOTK",
  "description": "Maximum graphics quality...",
  "type": "graphics",
  "downloads": 0,
  "tracking_url": "http://localhost:5000/download/TOTK"
}
```

## 🔍 Мониторинг

### Логи
- Все скачивания логируются в базу данных
- IP адреса и User-Agent сохраняются для аналитики

### Метрики
- Общее количество скачиваний
- Популярность по играм
- Временные тренды
- Географическое распределение

## 🛠️ Разработка

### Добавление новых метрик
```python
# В download_tracker.py
def get_geographic_stats(self):
    """Get downloads by country"""
    # Implementation here
```

### Расширение API
```python
# В download_api.py
@app.route('/analytics/geographic', methods=['GET'])
def get_geographic_analytics():
    """Get geographic download statistics"""
    # Implementation here
```

## 📝 Лицензия

MIT License - свободное использование и модификация.

## 🤝 Поддержка

Для вопросов и предложений создайте Issue в репозитории.