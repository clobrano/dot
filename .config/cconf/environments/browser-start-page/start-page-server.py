#!/usr/bin/env python3
"""http.server + endpoint /feed?url=... per la start page (solo stdlib)."""
import argparse
import functools
import urllib.error
import urllib.parse
import urllib.request
import socket
import threading
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

MAX_BYTES = 5 << 20
UA = "startpage-feed-proxy/1.0"
ACCEPT = "application/rss+xml, application/atom+xml, application/xml;q=0.9, */*;q=0.1"


class Handler(SimpleHTTPRequestHandler):
    def do_GET(self):
        parts = urllib.parse.urlsplit(self.path)
        if parts.path != "/feed":
            return super().do_GET()

        target = urllib.parse.parse_qs(parts.query).get("url", [""])[0]
        t = urllib.parse.urlsplit(target)
        if t.scheme not in ("http", "https") or not t.netloc:
            return self.send_error(400, "bad url")

        req = urllib.request.Request(target, headers={"User-Agent": UA, "Accept": ACCEPT})
        try:
            with urllib.request.urlopen(req, timeout=15) as r:
                body = r.read(MAX_BYTES + 1)
                ctype = r.headers.get("Content-Type", "application/xml")
        except urllib.error.HTTPError as e:
            return self.send_error(502, f"upstream HTTP {e.code}")
        except Exception as e:
            return self.send_error(502, f"upstream error: {type(e).__name__}")

        if len(body) > MAX_BYTES:
            return self.send_error(502, "feed too large")

        self.send_response(200)
        self.send_header("Content-Type", ctype)  # preserva il charset originale
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "max-age=300")
        self.end_headers()
        self.wfile.write(body)


class V6Server(ThreadingHTTPServer):
    address_family = socket.AF_INET6


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--bind", action="append",
                   help="indirizzo di ascolto, ripetibile (default: 127.0.0.1 e ::1)")
    p.add_argument("--port", type=int, default=8420)
    p.add_argument("--directory", default=".")
    a = p.parse_args()

    handler = functools.partial(Handler, directory=a.directory)
    servers = []
    for addr in a.bind or ["127.0.0.1", "::1"]:
        cls = V6Server if ":" in addr else ThreadingHTTPServer
        servers.append(cls((addr, a.port), handler))

    for s in servers[1:]:
        threading.Thread(target=s.serve_forever, daemon=True).start()
    servers[0].serve_forever()


if __name__ == "__main__":
    main()

