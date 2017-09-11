# -*- coding: utf-8 -*-
# Part of Prescrypto. See LICENSE file for full copyright and licensing details.

{
    "name" : "Norway - Accounting",
    "version" : "1.1",
    "author" : "Rolv Råen",
    'category': 'Localization',
    "description": """This is the module to manage the accounting chart for Norway in Prescrypto.

Updated for Prescrypto 9 by Bringsvor Consulting AS <www.bringsvor.com>
""",
    "depends" : ["account", "base_iban", "base_vat"],
    "data": ['data/l10n_no_chart_data.xml',
             'data/account_tax_data.xml',
             'data/account_chart_template_data.yml'],
    "active": False,
}
