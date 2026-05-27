#!/usr/bin/env python3
"""Local preview server for the visualise gallery. Zero dependencies."""
import http.server
import os
import sys
import webbrowser

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8888
GALLERY = os.path.join(os.path.dirname(os.path.abspath(__file__)), "gallery")

os.chdir(GALLERY)
handler = http.server.SimpleHTTPRequestHandler
with http.server.HTTPServer(("", PORT), handler) as httpd:
    url = f"http://localhost:{PORT}"
    print(f"Gallery: {url}")
    webbrowser.open(url)
    httpd.serve_forever()
