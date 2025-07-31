#!/usr/bin/env python3
"""
Flask API for tracking mod downloads
Provides endpoints for recording downloads and getting statistics
"""

from flask import Flask, request, jsonify, render_template
from download_tracker import ModDownloadTracker
import json
import os

app = Flask(__name__)
tracker = ModDownloadTracker()

@app.route('/')
def index():
    """Main statistics page"""
    return render_template('stats.html')

@app.route('/download/<game_id>', methods=['POST'])
def record_download(game_id):
    """Record a download for a specific game"""
    try:
        data = request.get_json() or {}
        game_name = data.get('game_name', 'Unknown Game')
        mod_name = data.get('mod_name', 'Ultra Graphics Pack')
        user_ip = request.remote_addr
        user_agent = request.headers.get('User-Agent')
        
        tracker.record_download(game_id, game_name, mod_name, user_ip, user_agent)
        
        return jsonify({
            'success': True,
            'message': f'Download recorded for {game_name}',
            'game_id': game_id,
            'downloads': tracker.get_download_stats(game_id)[0][2] if tracker.get_download_stats(game_id) else 0
        })
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/stats', methods=['GET'])
def get_stats():
    """Get download statistics"""
    try:
        game_id = request.args.get('game_id')
        stats = tracker.get_download_stats(game_id)
        
        if game_id and stats:
            stat = stats[0]
            return jsonify({
                'game_id': stat[0],
                'game_name': stat[1],
                'total_downloads': stat[2],
                'last_download': stat[3],
                'first_download': stat[4]
            })
        elif not game_id:
            return jsonify({
                'total_games': len(stats),
                'total_downloads': sum(row[2] for row in stats),
                'games': [
                    {
                        'game_id': row[0],
                        'game_name': row[1],
                        'total_downloads': row[2],
                        'last_download': row[3],
                        'first_download': row[4]
                    } for row in stats
                ]
            })
        else:
            return jsonify({'error': 'Game not found'}), 404
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/top', methods=['GET'])
def get_top_games():
    """Get top downloaded games"""
    try:
        limit = int(request.args.get('limit', 10))
        top_games = tracker.get_top_downloaded_games(limit)
        
        return jsonify({
            'top_games': [
                {
                    'game_id': row[0],
                    'game_name': row[1],
                    'downloads': row[2]
                } for row in top_games
            ]
        })
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/export', methods=['GET'])
def export_stats():
    """Export statistics to JSON file"""
    try:
        filename = tracker.export_stats_to_json()
        
        return jsonify({
            'success': True,
            'message': f'Statistics exported to {filename}',
            'filename': filename
        })
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'service': 'NEOVIA Mod Download Tracker'})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)