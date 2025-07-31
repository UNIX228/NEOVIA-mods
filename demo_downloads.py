#!/usr/bin/env python3
"""
Demo script for NEOVIA Mod Download Counter
Shows how to record downloads and view statistics
"""

from download_counter import DownloadCounter
import time
import random

def demo_downloads():
    """Demonstrate download counter functionality"""
    counter = DownloadCounter()
    
    # List of games for demo
    games = [
        ("TOTK", "The Legend of Zelda: Tears of the Kingdom"),
        ("BOTW", "The Legend of Zelda: Breath of the Wild"),
        ("MC", "Minecraft"),
        ("SMO", "Super Mario Odyssey"),
        ("MK8D", "Mario Kart 8 Deluxe"),
        ("SSBU", "Super Smash Bros Ultimate"),
        ("SPLATOON", "Splatoon 3"),
        ("POKEMON", "Pokemon Scarlet and Violet"),
        ("FIREEMBLEM", "Fire Emblem Three Houses"),
        ("XENOBLADE", "Xenoblade Chronicles 3")
    ]
    
    print("🎮 NEOVIA Mod Download Counter Demo")
    print("=" * 50)
    
    # Record some random downloads
    print("📥 Recording sample downloads...")
    for i in range(15):
        game_id, game_name = random.choice(games)
        counter.record_download(game_id, game_name)
        time.sleep(0.1)  # Small delay for demo effect
    
    print("\n" + "=" * 50)
    
    # Show final statistics
    counter.print_stats()
    
    # Show top games
    print(f"\n🏆 Top 5 most downloaded games:")
    top_games = counter.get_top_games(5)
    for i, (game_id, game_data) in enumerate(top_games, 1):
        print(f"  {i}. {game_data['game_name']} ({game_id}): {game_data['downloads']} downloads")
    
    # Show API usage
    print(f"\n💡 API Usage Examples:")
    print(f"  # Record a download")
    print(f"  counter.record_download('TOTK', 'The Legend of Zelda: Tears of the Kingdom')")
    print(f"")
    print(f"  # Get stats for specific game")
    print(f"  stats = counter.get_stats('TOTK')")
    print(f"  print(f'Downloads: {{stats[\"downloads\"]}}')")
    print(f"")
    print(f"  # Get top games")
    print(f"  top_games = counter.get_top_games(10)")
    print(f"")
    print(f"  # Start web interface")
    print(f"  python3 stats_viewer.py")
    print(f"  # Then open http://localhost:5000")

if __name__ == "__main__":
    demo_downloads()