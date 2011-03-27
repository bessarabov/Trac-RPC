use inc::Module::Install;

name            'Trac-RPC';
author          'Ivan Bessarabov <ivan@bessarabov.ru>';
version         '0.01';
license         'perl';

requires        'RPC::XML';
requires        'Exception::Class';

auto_install;
WriteAll;
