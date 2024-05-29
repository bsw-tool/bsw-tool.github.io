from http.server import HTTPServer, SimpleHTTPRequestHandler

class CORSRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        super().end_headers()

# Define the IP address and port number
host = 'localhost'
port = 8000

# Create a simple HTTP server with the specified host and port
server_address = (host, port)
httpd = HTTPServer(server_address, CORSRequestHandler)

print(f"Server running at http://{host}:{port}")

# Start the server
httpd.serve_forever()
