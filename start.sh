#!/bin/bash
echo "Starting MCP Aiven server..."
echo "Environment variables:"
echo "AIVEN_BASE_URL: $AIVEN_BASE_URL"
echo "AIVEN_PROJECT_NAME: $AIVEN_PROJECT_NAME"
echo "AIVEN_TOKEN: $AIVEN_TOKEN"

# Create a simple HTTP server that will keep running
cd /app
python -c "
import http.server
import socketserver
import os
import json
from urllib.parse import urlparse, parse_qs

class AivenHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        parsed_path = urlparse(self.path)
        
        if parsed_path.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b'''
            <html>
            <head><title>MCP Aiven Server</title></head>
            <body>
                <h1>MCP Aiven Server</h1>
                <p>This is a placeholder for the MCP Aiven server.</p>
                <p>Environment variables:</p>
                <ul>
                    <li>AIVEN_BASE_URL: ''' + os.environ.get('AIVEN_BASE_URL', '').encode() + b'''</li>
                    <li>AIVEN_PROJECT_NAME: ''' + os.environ.get('AIVEN_PROJECT_NAME', '').encode() + b'''</li>
                    <li>AIVEN_TOKEN: [REDACTED]</li>
                </ul>
            </body>
            </html>
            ''')
        elif parsed_path.path == '/api/projects':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({
                'projects': ['mcp-demo']
            }).encode())
        else:
            self.send_response(404)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'Not Found')

PORT = 8000
Handler = AivenHandler

with socketserver.TCPServer(('0.0.0.0', PORT), Handler) as httpd:
    print(f'Serving at port {PORT}')
    httpd.serve_forever()
" 