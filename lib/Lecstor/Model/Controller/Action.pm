package Lecstor::Model::Controller::Action;
use Moose;
use Lecstor::Model::Instance::Action;

# ABSTRACT: interface to action records

extends 'Lecstor::Model::Controller';
#with 'Lecstor::Role::RequestData';

sub resultset_name{ 'Action' }

has model_class => ( isa => 'Str', is => 'ro', builder => '_build_model_class' );

sub _build_model_class{ 'Lecstor::Model::Instance::Action' }

=head1 SYNOPSIS

    my $action_set = Lecstor::Model::Controller::Action->new({
        schema => $dbic_schema,
    });

    my $action = $action_set->create(
        type => $type_str,
        session => $session_id,
        data => $data_hash,
        user => $user_id,
    );

=cut

around 'create' => sub{
    my ($orig, $self, $params) = @_;
    my $model_class = $self->model_class;
    return $model_class->new( _record => $self->$orig($params) );
};



__PACKAGE__->meta->make_immutable;

1;
