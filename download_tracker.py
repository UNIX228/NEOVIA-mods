#!/usr/bin/env python3
"""
Download Tracker for NEOVIA Graphics Mods
Tracks downloads per game and provides statistics
"""

import json
import os
import sqlite3
from datetime import datetime

class ModDownloadTracker:
    def __init__(self, db_path="mod_downloads.db"):
        self.db_path = db_path
        self.init_database()
    
    def init_database(self):
        """Initialize SQLite database for tracking downloads"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS mod_downloads (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                game_id TEXT NOT NULL,
                game_name TEXT NOT NULL,
                mod_name TEXT NOT NULL,
                download_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                user_ip TEXT,
                user_agent TEXT
            )
        ''')
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS mod_stats (
                game_id TEXT PRIMARY KEY,
                game_name TEXT NOT NULL,
                total_downloads INTEGER DEFAULT 0,
                last_download TIMESTAMP,
                first_download TIMESTAMP
            )
        ''')
        
        conn.commit()
        conn.close()
    
    def record_download(self, game_id, game_name, mod_name, user_ip=None, user_agent=None):
        """Record a new download"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # Record the download
        cursor.execute('''
            INSERT INTO mod_downloads (game_id, game_name, mod_name, user_ip, user_agent)
            VALUES (?, ?, ?, ?, ?)
        ''', (game_id, game_name, mod_name, user_ip, user_agent))
        
        # Update stats
        cursor.execute('''
            INSERT OR REPLACE INTO mod_stats (game_id, game_name, total_downloads, last_download, first_download)
            VALUES (
                ?,
                ?,
                (SELECT COUNT(*) FROM mod_downloads WHERE game_id = ?),
                CURRENT_TIMESTAMP,
                COALESCE((SELECT MIN(download_date) FROM mod_downloads WHERE game_id = ?), CURRENT_TIMESTAMP)
            )
        ''', (game_id, game_name, game_id, game_id))
        
        conn.commit()
        conn.close()
    
    def get_download_stats(self, game_id=None):
        """Get download statistics"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        if game_id:
            cursor.execute('''
                SELECT game_id, game_name, total_downloads, last_download, first_download
                FROM mod_stats WHERE game_id = ?
            ''', (game_id,))
        else:
            cursor.execute('''
                SELECT game_id, game_name, total_downloads, last_download, first_download
                FROM mod_stats ORDER BY total_downloads DESC
            ''')
        
        results = cursor.fetchall()
        conn.close()
        
        return results
    
    def get_top_downloaded_games(self, limit=10):
        """Get top downloaded games"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            SELECT game_id, game_name, total_downloads
            FROM mod_stats 
            ORDER BY total_downloads DESC 
            LIMIT ?
        ''', (limit,))
        
        results = cursor.fetchall()
        conn.close()
        
        return results
    
    def export_stats_to_json(self, filename="download_stats.json"):
        """Export statistics to JSON file"""
        stats = self.get_download_stats()
        
        data = {
            "export_date": datetime.now().isoformat(),
            "total_games": len(stats),
            "total_downloads": sum(row[2] for row in stats),
            "games": []
        }
        
        for row in stats:
            data["games"].append({
                "game_id": row[0],
                "game_name": row[1],
                "total_downloads": row[2],
                "last_download": row[3],
                "first_download": row[4]
            })
        
        with open(filename, 'w') as f:
            json.dump(data, f, indent=2)
        
        return filename

# Example usage
if __name__ == "__main__":
    tracker = ModDownloadTracker()
    
    # Example: Record some downloads
    tracker.record_download("TOTK", "The Legend of Zelda: Tears of the Kingdom", "Ultra Graphics Pack")
    tracker.record_download("BOTW", "The Legend of Zelda: Breath of the Wild", "Ultra Graphics Pack")
    tracker.record_download("TOTK", "The Legend of Zelda: Tears of the Kingdom", "Ultra Graphics Pack")
    
    # Get statistics
    print("Top downloaded games:")
    for game_id, game_name, downloads in tracker.get_top_downloaded_games(5):
        print(f"{game_name}: {downloads} downloads")
    
    # Export stats
    tracker.export_stats_to_json()
    print("Statistics exported to download_stats.json")