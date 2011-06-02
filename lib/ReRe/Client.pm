
package ReRe::Client;

use Moose;
use Mojo::UserAgent;
use Data::Dumper;

# WARNING !!!! WARNING !!!! WARNING !!!!
# PLEASE, DON'T USE THIS !!!!!!

has url => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has username => (
    is => 'rw',
    isa => 'Str',
    default => ''
);

has password => (
    is => 'rw',
    isa => 'Str',
    default => ''
);

has ua => (
    is => 'rw',
    isa => 'Object',
    lazy => 1,
    default => sub { Mojo::UserAgent->new }
);

sub get_rere {
    my $self = shift;
    my $method = shift;
    my $var = shift;
    my $value = shift;

    my $username = $self->username;
    my $password = $self->password;

    my $userpass = $username && $password ? "$username:$password\@" : '';
    my $base_url = "http://$userpass" .
        join('/', $self->url, 'redis', $method, $var);

    $base_url .= '/' . $value if $value;
    
    my $json = $self->ua->get($base_url)->res->json;
    return $json;
}

sub get {
    my ($self, $var) = @_;
    my $json = $self->get_rere('get', $var);
    return $json->{get}{$var};
}

sub set {
    my ($self, $var, $value) = @_;
    my $json = $self->get_rere('set', $var, $value);
    return $json->{set}{$var};
}


1;
