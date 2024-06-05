#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler
from http.server import HTTPServer
from urllib.parse import urlparse, parse_qs
import os
import sys
from util import *
import json
import time

class HttpGetHandler(BaseHTTPRequestHandler):
    """Handler for SSE do_GET."""

    root = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'resources/public')

    def do_GET(self):
        parsed_path = urlparse(self.path)
        path = parsed_path.path
        if path == "/chart-event":
            self.send_response(200)
            self.send_header("Content-type", "text/event-stream")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            self.wfile.write(self.mk_event('fleet', self.root+'/chart/fleet.geojson').encode())
        elif path == "/view3d-event":
            self.send_response(200)
            self.send_header("Content-type", "text/event-stream")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            self.wfile.write(self.mk_event('czml', self.root+'/view3d/czml.json').encode())
        elif path == "/json-event":
            self.send_response(200)
            self.send_header("Content-type", "text/event-stream")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            self.wfile.write(self.mk_event('json', self.root+'/view3d/view_control.json').encode())
        elif path == "/command":
            params = parse_qs(parsed_path.query)
            self.send_command(params, self.root+'/view3d/command.fct')
            self.send_response(200)
        else:
            if path == '/chart':
                filename = self.root+'/LeafletChart.html'
            elif path == '/view3d':
                filename = self.root+'/View3d.html'
            else:
                filename = self.root+self.path
            self.send_response(200)           
            if filename[-4:] == '.css':
                self.send_header('Content-type', 'text/css')
            elif filename[-5:] == '.json':
                self.send_header('Content-type', 'application/javascript')
            elif filename[-3:] == '.js':
                self.send_header('Content-type', 'application/javascript')
            elif filename[-4:] == '.ico':
                self.send_header('Content-type', 'image/x-icon')
            else:
                self.send_header('Content-type', 'text/html')
            self.end_headers()
            with open(filename, 'rb') as fh:
                html = fh.read()
                #html = bytes(html, 'utf8')
                self.wfile.write(html)

    def log_message(self, format, *args):
        return

    def read_file(self, path):
        with open(path, "r") as f:
            data = f.read()
            f.close()
            return data
            
    def mk_event(self, kind, path):
        data = self.read_file(path)
        if len(data) > 0:
            return 'event: '+kind+'\ndata: '+data+'\n\n'
        else:
            return ''
        
    def send_command(self, params, path):
        kk = list(params.keys())
        if len(kk) > 0:
            cmd = kk[0]
            arg = params[cmd][0]
            with open(path, "w") as f:
                f.write('(Command '+cmd+' '+arg+')\n')
                f.close()
                
def run(server_class=HTTPServer, handler_class=HttpGetHandler, port=8448):
    global data_path
    server_address = ('127.0.0.1', port)
    httpd = server_class(server_address, handler_class)
    print('Display Server started on port {}..'.format(port))
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        httpd.server_close()
    finally:
        if server is not None:
            server.server_close()

port = sys.argv[1]
myboat = sys.argv[2]
if len(sys.argv) > 3:
    model = sys.argv[3]
else:
    model = ''

deffacts = """
(deffacts Start-facts
	(MYBOAT "$1")
	(NEW-MODEL "$2")
	(clock 0)
    (timestamp ""))
"""
deffacts = deffacts.replace('$1', myboat)
deffacts = deffacts.replace('$2', model)

save_file('clp/Facts.clp', deffacts)

race = 'EOF'

while True:
     race = load_file('NMEA_CACHE/RACE.txt')
     time.sleep(1)
     if race != 'EOF':
        break

save_file('NMEA_CACHE/'+race+'/AIVDM.txt', '')
save_file('NMEA_CACHE/'+race+'/GPRMC.txt', '')
save_file('resources/public/view3d/command.fct', '')

run(port=int(port))



      
    
      
