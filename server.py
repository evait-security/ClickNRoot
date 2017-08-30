#!/usr/bin/env python2

import posixpath
import argparse
import urllib
import os

from SimpleHTTPServer import SimpleHTTPRequestHandler
from BaseHTTPServer import HTTPServer


class RootedHTTPServer(HTTPServer):

    def __init__(self, base_path, *args, **kwargs):
        HTTPServer.__init__(self, *args, **kwargs)
        self.RequestHandlerClass.base_path = base_path


class RootedHTTPRequestHandler(SimpleHTTPRequestHandler):

    def translate_path(self, path):
        path = posixpath.normpath(urllib.unquote(path))
        words = path.split('/')
        words = filter(None, words)
        path = self.base_path
        for word in words:
            drive, word = os.path.splitdrive(word)
            head, word = os.path.split(word)
            if word in (os.curdir, os.pardir):
                continue
            path = os.path.join(path, word)
        return path


def test(HandlerClass=RootedHTTPRequestHandler, ServerClass=RootedHTTPServer):

    parser = argparse.ArgumentParser()
    parser.add_argument('--port', '-p', default=80, type=int)
    parser.add_argument('--dir', '-d', default=os.path.dirname(os.path.abspath(__file__)), type=str)
    args = parser.parse_args()

    server_address = ('', args.port)

    httpd = ServerClass(args.dir, server_address, HandlerClass)

    sa = httpd.socket.getsockname()
    print "Serving HTTP on", sa[0], "port", sa[1], "..."
    httpd.serve_forever()

if __name__ == '__main__':
    test()
