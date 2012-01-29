package Lecstor::Catalyst::WebApp;
use Moose;
use MooseX::StrictConstructor;

# ABSTRACT: App Component Container

has _request => (
    is => 'ro',
    handles => [qw! session request user req !],
);

has _app => (
    is => 'ro',
    handles => [qw! model validator config log template !],
);

=attr config

=attr model

=attr validator

=attr log

=cut

=method login

    $app->login($user);

=cut

sub login{
    my ($self, $user) = @_;
warn "webapp login: ".(ref $user);
#    $self->session->set_user($user);
    $self->user->set_record($user);
}

=method authenticate

    my $user = $app->authenticate({ email => 'me@my.co', password => 'memy' });

=cut

sub authenticate{
    my ($self, $params, $realm) = @_;
    my $id_type = $params->{email} ? 'email'
                : $params->{username} ? 'username' : undef;
    return unless $id_type;
    my $user = $self->model->user->search({ $id_type => $params->{$id_type} })->first;
    return $user if $user && $user->check_password($params->{password});
    return;
}

sub register_user{
    shift->model->user->register(@_);
}

sub visitor_add_to_jobs{
    my ($self, $params) = @_;
    my $job = $self->model->job->create($params);
    $self->user->add_to_jobs($job) if $job;
    return $job;
}

__PACKAGE__->meta->make_immutable;

1;
