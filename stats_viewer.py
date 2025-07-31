#!/usr/bin/env python3
"""
Simple Web Interface for NEOVIA Mod Download Statistics
"""

from flask import Flask, render_template_string
from download_counter import DownloadCounter
import json

app = Flask(__name__)

# HTML template for statistics page
HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NEOVIA Mod Download Statistics</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: 300;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            padding: 30px;
        }
        .stat-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            border-left: 4px solid #667eea;
        }
        .stat-card h3 {
            margin: 0 0 15px 0;
            color: #333;
        }
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
        }
        .games-list {
            padding: 30px;
        }
        .game-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            margin: 10px 0;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        .game-info {
            flex: 1;
        }
        .game-name {
            font-weight: bold;
            color: #333;
        }
        .game-id {
            color: #666;
            font-size: 0.9em;
        }
        .download-count {
            background: #667eea;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
        }
        .refresh-btn {
            background: #667eea;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            margin: 20px;
        }
        .refresh-btn:hover {
            background: #5a6fd8;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎮 NEOVIA Mod Statistics</h1>
            <p>Track downloads and popularity of graphics mods</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Games</h3>
                <div class="stat-number">{{ stats.total_games }}</div>
            </div>
            <div class="stat-card">
                <h3>Total Downloads</h3>
                <div class="stat-number">{{ stats.total_downloads }}</div>
            </div>
            <div class="stat-card">
                <h3>Most Popular</h3>
                <div class="stat-number">{{ stats.top_game }}</div>
            </div>
        </div>
        
        <button class="refresh-btn" onclick="location.reload()">🔄 Refresh Statistics</button>
        
        <div class="games-list">
            <h2>📊 Download Statistics by Game</h2>
            {% for game_id, game_data in stats.games.items() %}
            <div class="game-item">
                <div class="game-info">
                    <div class="game-name">{{ game_data.game_name }}</div>
                    <div class="game-id">{{ game_id }}</div>
                </div>
                <div class="download-count">{{ game_data.downloads }} downloads</div>
            </div>
            {% endfor %}
        </div>
    </div>
</body>
</html>
"""

@app.route('/')
def index():
    """Main statistics page"""
    counter = DownloadCounter()
    stats_data = counter.get_stats()
    
    # Prepare data for template
    stats = {
        "total_games": len(stats_data["games"]),
        "total_downloads": stats_data["total_downloads"],
        "top_game": "None",
        "games": stats_data["games"]
    }
    
    # Find top game
    if stats_data["games"]:
        top_game = max(stats_data["games"].items(), key=lambda x: x[1]["downloads"])
        stats["top_game"] = top_game[1]["game_name"]
    
    return render_template_string(HTML_TEMPLATE, stats=stats)

@app.route('/api/stats')
def api_stats():
    """API endpoint for statistics"""
    counter = DownloadCounter()
    return counter.get_stats()

if __name__ == '__main__':
    print("🌐 Starting NEOVIA Statistics Server...")
    print("📊 Open http://localhost:5000 to view statistics")
    app.run(debug=True, host='0.0.0.0', port=5000)