#!/usr/bin/env python3
"""
TorCOIN Web Server
Serves the 3D animated coin HTML page at the specified IP address.
"""

import http.server
import socketserver
import os
import sys
from urllib.parse import unquote

# Configuration
HOST_IP = "0.0.0.0"  # Bind to all available interfaces
PORT = 50129  # Custom port
DISPLAY_URL = "https://www.torcoin.cnet"  # Ultra hardcoded display URL
HTML_FILE = "torcoin_website.html"

class CoinHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    """Custom HTTP request handler for serving the coin page."""

    def do_GET(self):
        """Handle GET requests."""
        # Decode the path to handle special characters
        path = unquote(self.path)

        # Serve the coin page for root requests
        if path == "/" or path == "":
            self.serve_coin_page()
        elif path == "/torcoin.html" or path == f"/{HTML_FILE}":
            self.serve_coin_page()
        else:
            # For any other requests, redirect to the main page
            self.send_response(302)
            self.send_header('Location', f'http://{HOST_IP}:{PORT}/')
            self.end_headers()

    def serve_coin_page(self):
        """Serve the TorCOIN HTML page."""
        try:
            # Check if the HTML file exists
            if not os.path.exists(HTML_FILE):
                self.send_error(404, "Coin file not found")
                return

            # Read the HTML file
            with open(HTML_FILE, 'r', encoding='utf-8') as f:
                content = f.read()

            # Send the response
            self.send_response(200)
            self.send_header('Content-type', 'text/html; charset=utf-8')
            self.send_header('Content-length', len(content.encode('utf-8')))
            self.send_header('Cache-Control', 'no-cache')
            self.end_headers()

            # Write the content
            self.wfile.write(content.encode('utf-8'))

        except Exception as e:
            self.send_error(500, f"Server error: {str(e)}")

    def log_message(self, format, *args):
        """Override logging to show custom messages."""
        # Only log important messages, suppress directory listings
        if "GET /" in format and "200" in format:
            print(f"[+] Served coin page to {self.address_string()}")
        elif "404" in format:
            print(f"[!] File not found: {self.path}")
        elif "500" in format:
            print(f"[!] Server error: {self.path}")

def main():
    """Main server function."""
    print("=" * 50)
    print("        TORCOIN WEB SERVER")
    print("=" * 50)
    print(f"Server bound to: {HOST_IP}:{PORT}")
    print(f"HTML File: {HTML_FILE}")
    print()
    print("🎯 ULTRA HARDCODED ACCESS LINK:")
    print(DISPLAY_URL)
    print()
    print("(Note: Domain must be configured in DNS/hosts file)")
    print()
    print("Press Ctrl+C to stop the server")
    print("=" * 50)

    # Check if HTML file exists
    if not os.path.exists(HTML_FILE):
        print(f"[!] Error: {HTML_FILE} not found in current directory!")
        print("Make sure torcoin.html is in the same directory as this script.")
        sys.exit(1)

    # Create server
    try:
        with socketserver.TCPServer((HOST_IP, PORT), CoinHTTPRequestHandler) as httpd:
            print(f"[+] Server started successfully on {HOST_IP}:{PORT}")
            print("[+] Ready to serve your 3D coin!")
            print()

            # Start serving
            httpd.serve_forever()

    except PermissionError:
        print(f"[!] Permission denied. Try running with sudo (for port {PORT})")
        print("Or change PORT to a number above 1024 (e.g., 8080)")
        sys.exit(1)
    except OSError as e:
        if "Address already in use" in str(e):
            print(f"[!] Port {PORT} is already in use. Try a different port.")
        else:
            print(f"[!] Error starting server: {e}")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\n[!] Server stopped by user")
        sys.exit(0)

if __name__ == "__main__":
    main()
