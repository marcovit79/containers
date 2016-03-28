#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""

Auteur :      thuban <thuban@yeuxdelibad.net>
licence :     GNU General Public Licence v3

Description :

"""


import bottle
import logging
import os
import sys

sys.path.append("/usr/local/apache2/cgi-bin/dontpanic/")

from dontpanic import DontPanic
from i18n import _
from utils import setup_logging, progname, progversion

serverlist = ["cgi", "paste", "cherrypy", "tornado", "auto"]
logger = logging.getLogger(__name__)


class DontpanicWSGI(DontPanic):
    def __init__(self, host, port, admin, adminpw):
        DontPanic.__init__(self, host, port, admin, adminpw, local_=False)
        #self.app = bottle.default_app()

    def run(self):
        logger.info("running on {}:{}".format(self.host, self.port))
        self.app.run(server='cgi')


srv = DontpanicWSGI("0.0.0.0", "9090", "admin", "admin")


application = srv.app
