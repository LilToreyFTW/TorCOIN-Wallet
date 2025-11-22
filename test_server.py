#!/usr/bin/env python3
"""
TorCOIN Test Web Server
Test version that runs on localhost for development/testing.
"""

import http.server
import socketserver
import os
import sys
from urllib.parse import unquote

# Configuration for testing
HOST_IP = "127.0.0.1"  # Localhost for testing
PORT = 50129  # Same port as production
HTML_FILE = "torcoin.html"

class CoinHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    """Custom HTTP request handler for serving the coin page."""

    def do_GET(self):
        """Handle GET requests."""
        path = unquote(self.path)

        if path == "/" or path == "":
            self.serve_coin_page()
        elif path == "/torcoin.html" or path == f"/{HTML_FILE}":
            self.serve_coin_page()
        else:
            self.send_response(302)
            self.send_header('Location', f'http://{HOST_IP}:{PORT}/')
            self.end_headers()

    def serve_coin_page(self):
        """Serve the TorCOIN HTML page."""
        try:
            if not os.path.exists(HTML_FILE):
                self.send_error(404, "Coin file not found")
                return

            with open(HTML_FILE, 'r', encoding='utf-8') as f:
                content = f.read()

            self.send_response(200)
            self.send_header('Content-type', 'text/html; charset=utf-8')
            self.send_header('Content-length', len(content.encode('utf-8')))
            self.send_header('Cache-Control', 'no-cache')
            self.end_headers()

            self.wfile.write(content.encode('utf-8'))

        except Exception as e:
            self.send_error(500, f"Server error: {str(e)}")

    def log_message(self, format, *args):
        """Override logging to show custom messages."""
        if "GET /" in format and "200" in format:
            print(f"[+] Served coin page to {self.address_string()}")
        elif "404" in format:
            print(f"[!] File not found: {self.path}")
        elif "500" in format:
            print(f"[!] Server error: {self.path}")

def main():
    """Main server function."""
    print("=" * 50)
    print("     TORCOIN TEST WEB SERVER")
    print("=" * 50)
    print(f"Testing on localhost: {HOST_IP}")
    print(f"Port: {PORT}")
    print(f"HTML File: {HTML_FILE}")
    print()
    print("Test your coin locally at:")
    print(f"http://{HOST_IP}:{PORT}/")
    print(f"http://{HOST_IP}:{PORT}/torcoin.html")
    print()
    print("For production, use coin_server.py with your IP")
    print("Press Ctrl+C to stop the test server")
    print("=" * 50)

    if not os.path.exists(HTML_FILE):
        print(f"[!] Error: {HTML_FILE} not found in current directory!")
        sys.exit(1)

    try:
        with socketserver.TCPServer((HOST_IP, PORT), CoinHTTPRequestHandler) as httpd:
            print(f"[+] Test server started successfully on {HOST_IP}:{PORT}")
            httpd.serve_forever()

    except KeyboardInterrupt:
        print("\n[!] Test server stopped by user")
        sys.exit(0)
    except Exception as e:
        print(f"[!] Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
