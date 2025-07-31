#!/usr/bin/env python3
"""
Simple Download Counter for NEOVIA Mods
Updates download count in modinfo.json files
"""

import json
import os
import glob
from datetime import datetime

class DownloadCounter:
    def __init__(self):
        self.stats_file = "download_stats.json"
        self.load_stats()
    
    def load_stats(self):
        """Load existing download statistics"""
        if os.path.exists(self.stats_file):
            with open(self.stats_file, 'r') as f:
                self.stats = json.load(f)
                # Ensure proper structure
                if "games" not in self.stats:
                    self.stats["games"] = {}
                if "total_downloads" not in self.stats:
                    self.stats["total_downloads"] = 0
        else:
            self.stats = {
                "total_downloads": 0,
                "games": {},
                "last_updated": datetime.now().isoformat()
            }
    
    def save_stats(self):
        """Save download statistics"""
        self.stats["last_updated"] = datetime.now().isoformat()
        with open(self.stats_file, 'w') as f:
            json.dump(self.stats, f, indent=2)
    
    def record_download(self, game_id, game_name):
        """Record a download for a specific game"""
        # Update global stats
        self.stats["total_downloads"] += 1
        
        # Update game-specific stats
        if game_id not in self.stats["games"]:
            self.stats["games"][game_id] = {
                "game_name": game_name,
                "downloads": 0,
                "first_download": datetime.now().isoformat(),
                "last_download": datetime.now().isoformat()
            }
        
        self.stats["games"][game_id]["downloads"] += 1
        self.stats["games"][game_id]["last_download"] = datetime.now().isoformat()
        
        # Update modinfo.json file
        self.update_modinfo(game_id)
        
        # Save stats
        self.save_stats()
        
        print(f"✅ Download recorded for {game_name} ({game_id})")
        print(f"📊 Total downloads: {self.stats['games'][game_id]['downloads']}")
    
    def update_modinfo(self, game_id):
        """Update download count in modinfo.json"""
        # Find modinfo.json file for this game
        pattern = f"*/UltraGraphicsPack_{game_id}/modinfo.json"
        files = glob.glob(pattern)
        
        if files:
            modinfo_path = files[0]
            try:
                with open(modinfo_path, 'r') as f:
                    modinfo = json.load(f)
                
                # Update download count
                modinfo["downloads"] = self.stats["games"][game_id]["downloads"]
                
                with open(modinfo_path, 'w') as f:
                    json.dump(modinfo, f, indent=2)
                
                print(f"📝 Updated {modinfo_path}")
                
            except Exception as e:
                print(f"❌ Error updating {modinfo_path}: {e}")
        else:
            print(f"❌ No modinfo.json found for {game_id}")
    
    def get_stats(self, game_id=None):
        """Get download statistics"""
        if game_id:
            return self.stats["games"].get(game_id, {})
        return self.stats
    
    def get_top_games(self, limit=10):
        """Get top downloaded games"""
        games = list(self.stats["games"].items())
        games.sort(key=lambda x: x[1]["downloads"], reverse=True)
        return games[:limit]
    
    def print_stats(self):
        """Print current statistics"""
        print(f"\n📊 NEOVIA Mod Download Statistics")
        print(f"📅 Last updated: {self.stats['last_updated']}")
        print(f"🎮 Total games: {len(self.stats['games'])}")
        print(f"📥 Total downloads: {self.stats['total_downloads']}")
        
        if self.stats["games"]:
            print(f"\n🏆 Top downloaded games:")
            top_games = self.get_top_games(5)
            for i, (game_id, game_data) in enumerate(top_games, 1):
                print(f"  {i}. {game_data['game_name']} ({game_id}): {game_data['downloads']} downloads")
        else:
            print(f"\n📭 No downloads recorded yet")

# Example usage and testing
if __name__ == "__main__":
    counter = DownloadCounter()
    
    # Example: Record some downloads
    print("🎮 Recording sample downloads...")
    counter.record_download("TOTK", "The Legend of Zelda: Tears of the Kingdom")
    counter.record_download("BOTW", "The Legend of Zelda: Breath of the Wild")
    counter.record_download("TOTK", "The Legend of Zelda: Tears of the Kingdom")
    counter.record_download("MC", "Minecraft")
    counter.record_download("SMO", "Super Mario Odyssey")
    
    # Print statistics
    counter.print_stats()
    
    # Show how to use the counter
    print(f"\n💡 Usage:")
    print(f"  counter.record_download('GAME_ID', 'Game Name')")
    print(f"  counter.get_stats('GAME_ID')")
    print(f"  counter.get_top_games(5)")