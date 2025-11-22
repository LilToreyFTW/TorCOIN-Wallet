#!/usr/bin/env python3
"""
TorCOIN Self Proxy Server
A strict proxy that ONLY allows access to www.torcoin.cnet:50129
Blocks all other traffic for maximum security.
"""

import http.server
import socketserver
import urllib.request
import urllib.error
import socket
from urllib.parse import urlparse, urljoin
import time

# Hardcoded allowed destination
ALLOWED_HOST = "127.0.0.1"
ALLOWED_PORT = 50129
ALLOWED_URL = f"http://{ALLOWED_HOST}:{ALLOWED_PORT}"

class TorCOINProxyHandler(http.server.BaseHTTPRequestHandler):
    """Strict proxy handler that only allows TorCOIN access."""

    def do_GET(self):
        """Handle GET requests with strict filtering."""
        try:
            # Parse the requested URL
            parsed_url = urlparse(self.path)

            # Strict filtering: ONLY allow requests to our TorCOIN server
            if parsed_url.netloc != f"{ALLOWED_HOST}:{ALLOWED_PORT}" and \
               not self.path.startswith(f"http://{ALLOWED_HOST}:{ALLOWED_PORT}"):
                self.send_error(403, "Access Denied: Only TorCOIN server allowed")
                self.log_message("🚫 BLOCKED: %s", self.path)
                return

            # Reconstruct the target URL
            if self.path.startswith("http"):
                target_url = self.path
            else:
                target_url = urljoin(ALLOWED_URL, self.path)

            # Verify it's still pointing to our server
            target_parsed = urlparse(target_url)
            if target_parsed.hostname != ALLOWED_HOST or target_parsed.port != ALLOWED_PORT:
                self.send_error(403, "Access Denied: Invalid destination")
                self.log_message("🚫 BLOCKED INVALID: %s", target_url)
                return

            # Forward the request to TorCOIN server
            self.log_message("✅ PROXYING: %s", target_url)

            # Add timeout and headers
            req = urllib.request.Request(target_url)
            req.add_header('User-Agent', 'TorCOIN-Proxy/1.0')

            # Copy original headers (except host)
            for header, value in self.headers.items():
                if header.lower() not in ['host', 'connection', 'keep-alive', 'proxy-authenticate',
                                        'proxy-authorization', 'te', 'trailers', 'transfer-encoding',
                                        'upgrade']:
                    req.add_header(header, value)

            # Make the request with timeout
            with urllib.request.urlopen(req, timeout=10) as response:
                # Send response back to client
                self.send_response(response.status)

                # Copy response headers
                for header, value in response.headers.items():
                    if header.lower() not in ['connection', 'keep-alive', 'proxy-authenticate',
                                            'proxy-authorization', 'te', 'trailers', 'transfer-encoding',
                                            'upgrade', 'content-encoding']:
                        self.send_header(header, value)

                self.end_headers()

                # Stream the response body
                while True:
                    data = response.read(8192)
                    if not data:
                        break
                    self.wfile.write(data)

        except urllib.error.HTTPError as e:
            self.send_error(e.code, f"Upstream error: {e.reason}")
            self.log_message("❌ UPSTREAM ERROR: %s", e)
        except urllib.error.URLError as e:
            self.send_error(502, f"Connection error: {e.reason}")
            self.log_message("❌ CONNECTION ERROR: %s", e)
        except socket.timeout:
            self.send_error(504, "Gateway timeout")
            self.log_message("⏰ TIMEOUT: Request timed out")
        except Exception as e:
            self.send_error(500, f"Proxy error: {str(e)}")
            self.log_message("💥 PROXY ERROR: %s", e)

    def do_POST(self):
        """Handle POST requests (same strict filtering)."""
        # For simplicity, treat POST like GET with body forwarding
        try:
            content_length = int(self.headers.get('Content-Length', 0))
            post_data = self.rfile.read(content_length) if content_length > 0 else b''

            # Use the same filtering logic as GET
            parsed_url = urlparse(self.path)

            if parsed_url.netloc != f"{ALLOWED_HOST}:{ALLOWED_PORT}" and \
               not self.path.startswith(f"http://{ALLOWED_HOST}:{ALLOWED_PORT}"):
                self.send_error(403, "Access Denied: Only TorCOIN server allowed")
                self.log_message("🚫 BLOCKED POST: %s", self.path)
                return

            if self.path.startswith("http"):
                target_url = self.path
            else:
                target_url = urljoin(ALLOWED_URL, self.path)

            target_parsed = urlparse(target_url)
            if target_parsed.hostname != ALLOWED_HOST or target_parsed.port != ALLOWED_PORT:
                self.send_error(403, "Access Denied: Invalid destination")
                self.log_message("🚫 BLOCKED INVALID POST: %s", target_url)
                return

            self.log_message("✅ PROXYING POST: %s", target_url)

            req = urllib.request.Request(target_url, data=post_data, method='POST')
            req.add_header('User-Agent', 'TorCOIN-Proxy/1.0')

            for header, value in self.headers.items():
                if header.lower() not in ['host', 'connection', 'keep-alive', 'proxy-authenticate',
                                        'proxy-authorization', 'te', 'trailers', 'transfer-encoding',
                                        'upgrade', 'content-length']:
                    req.add_header(header, value)

            with urllib.request.urlopen(req, timeout=10) as response:
                self.send_response(response.status)

                for header, value in response.headers.items():
                    if header.lower() not in ['connection', 'keep-alive', 'proxy-authenticate',
                                            'proxy-authorization', 'te', 'trailers', 'transfer-encoding',
                                            'upgrade', 'content-encoding']:
                        self.send_header(header, value)

                self.end_headers()

                while True:
                    data = response.read(8192)
                    if not data:
                        break
                    self.wfile.write(data)

        except Exception as e:
            self.send_error(500, f"Proxy error: {str(e)}")
            self.log_message("💥 PROXY POST ERROR: %s", e)

    def log_message(self, format, *args):
        """Override logging with custom format."""
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{timestamp}] TorCOIN-Proxy: {format % args}")

def main():
    """Main proxy server function."""
    PROXY_PORT = 8080  # Standard proxy port

    print("=" * 60)
    print("         TORCOIN SELF PROXY SERVER")
    print("=" * 60)
    print(f"🛡️  STRICT MODE: Only allowing access to {ALLOWED_URL}")
    print(f"🌐 Proxy listening on port: {PROXY_PORT}")
    print()
    print("🔒 SECURITY FEATURES:")
    print("✅ Blocks all traffic except TorCOIN server")
    print("✅ No external internet access through proxy")
    print("✅ Request/response filtering")
    print("✅ Timeout protection")
    print()
    print("📋 USAGE:")
    print(f"Set browser proxy to: localhost:{PROXY_PORT}")
    print("Then access: http://www.torcoin.cnet")
    print()
    print("🛑 Press Ctrl+C to stop the proxy")
    print("=" * 60)

    try:
        with socketserver.ThreadingTCPServer(("", PROXY_PORT), TorCOINProxyHandler) as httpd:
            print(f"[✅] TorCOIN Proxy started on port {PROXY_PORT}")
            print("[🛡️ ] STRICT MODE ACTIVE - Only TorCOIN traffic allowed!")
            httpd.serve_forever()

    except KeyboardInterrupt:
        print("\n[🛑] Proxy stopped by user")
    except PermissionError:
        print(f"[❌] Permission denied. Cannot bind to port {PROXY_PORT}")
        print("Try running as Administrator or use a port > 1024")
    except OSError as e:
        print(f"[❌] Error starting proxy: {e}")
    except Exception as e:
        print(f"[💥] Unexpected error: {e}")

if __name__ == "__main__":
    main()
