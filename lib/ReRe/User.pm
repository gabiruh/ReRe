
package ReRe::User;

use Moose;
use Config::General;
use Data::Dumper;

# VERSION

has file => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has _users => (
    is => 'ro',
    isa => 'HashRef[HashRef]',
    traits => ['Hash'],
    default => sub { {} },
    handles => {
        _add_user => 'set',
        _find_user => 'get'
    }
);

sub _parse_config {
    my $self = shift;
    die "Where is config file for acl ?" unless -r $self->file;
    my $conf = new Config::General($self->file);
    return $conf->getall;
}

sub _setup {
    my $self = shift;
    my %config = $self->_parse_config;
    foreach my $username (keys $config{users}) {
        my $password = $config{users}{$username}{password};
        my $roles = $config{users}{$username}{roles};
        my $allow = $config{users}{$username}{allow};
        $self->_add_user(
            $username => {
                $password ? (password => $password) : (),
                $allow ? (allow => [ split(/ /, $allow) ]) : (),
                roles => [ split(/ /, $roles) ]
            });
    }

}

=head1 METHODS

=cut

=head2 auth

Authentication

(username, password)

=cut

sub auth {
    my ($self, $username, $password) = @_;
    return 0 unless $username and $password;
    my $user = $self->_find_user($username) or return 0;
    my $mem_password = $user->{password};
    return $mem_password eq $password ? 1 : 0;
}

=head2 has_role

Autorization

(username, role)

=cut

sub has_role {
    my ($self, $username, $role, $ip) = @_;
    return 0 unless $role;
    my $user = $self->_find_user($username) or return 0;
    my (@roles, @allow);
    @roles = @{$user->{roles}} if defined($user->{roles});
    @allow = @{$user->{allow}} if defined($user->{allow});
    return grep(/$role|all/, @roles) or grep(/$ip|all/, @allow) ? 1 : 0;
}

=head2 process

Initial process for acl.

=cut

sub process {
    my $self = shift;
    $self->_setup;
}

1;