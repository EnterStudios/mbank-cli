##!/usr/bin/env perl

# Copyright © 2014-2016 Jakub Wilk <jwilk@jwilk.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More;

if ($ENV{MBANK_CLI_ONLINE_TESTS}) {
    plan tests => 9;
} else {
    plan skip_all => 'set MBANK_CLI_ONLINE_TESTS=1 to enable online tests';
}

use English qw(-no_match_vars);

use IPC::Run ();

use FindBin ();
use lib "$FindBin::Bin";
use TestUtils;

for my $country (qw(cz sk pl)) {

    my $config_file = create_config(<<"EOF");
Country $country
CookieJar <tmp>/cookies
EOF

    my ($stdout, $stderr);
    my $cli = IPC::Run::start(
        [code_file(), '--config', $config_file, 'debug-https-get'],
        '>', \$stdout,
        '2>', \$stderr,
    );
    $cli->finish();
    cmp_ok($cli->result, '==', 0, 'no error');
    like($stdout, qr/<html>/i, 'HTML output');
    cmp_ok($stderr, 'eq', '', 'empty stderr');
    unlink(tmp_dir . '/cookies') or die $ERRNO;

}

# vim:ts=4 sts=4 sw=4 et
