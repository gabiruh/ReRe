
use Test::More tests => 6;
use Test::Mojo;

use FindBin;
require "$FindBin::Bin/../bin/rere_server.pl";

my $t = Test::Mojo->new;
$t->get_ok('/redis/set/foo/1')->status_is(200)->content_like(qr/{"set":{"foo":"1"}}/);

$t->get_ok('/redis/type/foo')->status_is(200)->content_like(qr/{"type":{"foo":"string"}}/);
