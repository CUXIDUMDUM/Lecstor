package Lecstor::Role::Catalyst;
use Moose::Role;
use CatalystX::InjectComponent;
use Lecstor::App;
use namespace::autoclean;

# ABSTRACT: Lecstor Catalyst customisations

sub lecstor{ shift->model('Lecstor', @_) }

sub controllers{qw( Account )}

sub views{qw( TT )}

sub models{qw( Lecstor Schema )}

after 'setup_components' => sub {
    my $class = shift;

    foreach( $class->controllers ){
        my $comp = s/^\+// ? $_ : 'Lecstor::Catalyst::Controller::'.$_;
        CatalystX::InjectComponent->inject(
            component => $comp, into => $class, as => $_
        );
    }

    foreach( $class->views ){
        my $comp = s/^\+// ? $_ : 'Lecstor::Catalyst::View::'.$_;
        CatalystX::InjectComponent->inject(
            component => $comp, into => $class, as => $_
        );
    }

    foreach( $class->models ){
        my $comp = s/^\+// ? $_ : 'Lecstor::Catalyst::Model::'.$_;
        CatalystX::InjectComponent->inject(
            component => $comp, into => $class, as => $_
        );
    }

};

1;
