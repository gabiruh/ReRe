
package ReRe::Role::Hook;

use strict;
use Moose::Role;
# VERSION

requires '_hook';

has method => (
    is      => 'rw',
    isa     => 'Str',
    default => ''
);

has args => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { [] }
);

1;

