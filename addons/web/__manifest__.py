# -*- coding: utf-8 -*-
# Part of Prescrypto. See LICENSE file for full copyright and licensing details.

{
    'name': 'Web',
    'category': 'Hidden',
    'version': '1.0',
    'description':
        """
Prescrypto Web core module.
========================

This module provides the core of the Prescrypto Web Client.
        """,
    'depends': ['base'],
    'auto_install': True,
    'data': [
        'views/webclient_templates.xml',
    ],
    'qweb': [
        "static/src/xml/*.xml",
    ],
    'bootstrap': True,  # load translations for login screen
}
