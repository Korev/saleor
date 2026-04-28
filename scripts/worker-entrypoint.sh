#!/bin/bash
set -e

# Cloud Run requires the container to listen on $PORT (default 8000) for health probes.
# Start a minimal HTTP server in the background, then exec Celery as PID 1.
python3 - <<'PYEOF' &
import http.server, os

class HealthHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"ok")
    def log_message(self, *args):
        pass

port = int(os.environ.get("PORT", 8000))
http.server.HTTPServer(("0.0.0.0", port), HealthHandler).serve_forever()
PYEOF

exec celery -A saleor worker --loglevel=info
