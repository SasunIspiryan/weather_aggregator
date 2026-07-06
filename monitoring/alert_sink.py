from http.server import BaseHTTPRequestHandler, HTTPServer
import json


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        body = self.rfile.read(int(self.headers.get("Content-Length", 0)) or 0)
        data = json.loads(body or b"{}")

        for alert in data.get("alerts", []):
            status = alert.get("status", "").upper()
            name = alert.get("labels", {}).get("alertname", "unknown-alert")
            summary = alert.get("annotations", {}).get("summary", "")
            print(f"[{status}] {name} - {summary}", flush=True)

        self.send_response(200)
        self.end_headers()

    def log_message(self, *_):
        # Silence default access logs to keep output focused on alert payloads.
        return


if __name__ == "__main__":
    print("alert-sink listening on :8080 ...", flush=True)
    HTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
