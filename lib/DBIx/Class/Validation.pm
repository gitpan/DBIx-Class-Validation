package DBIx::Class::Validation;

use strict;
use warnings;

use base qw( DBIx::Class );
use English qw( -no_match_vars );
use FormValidator::Simple 0.17;

#local $^W = 0; # Silence C:D:I redefined sub errors.
# Switched to C::D::Accessor which doesn't do this. Hate hate hate hate.

our $VERSION = '0.01001';

__PACKAGE__->mk_classdata( 'validation_profile' );
__PACKAGE__->mk_classdata( 'validation_auto' => 1 );
__PACKAGE__->mk_classdata( 'validation_filter' => 0 );
__PACKAGE__->mk_classdata( '_validation_module_accessor' );

__PACKAGE__->validation_module( 'FormValidator::Simple' );


=head1 NAME

DBIx::Class::Validation - Validate all data before submitting to your database.

=head1 SYNOPSIS

In your base L<"DBIx::Class"> package:

  __PACKAGE__->load_components(qw/... Validation/);

And in your subclasses:

  __PACKAGE__->validation(
    module => 'FormValidator::Simple',
    profile => { ... },
    filters => 0,
    auto => 1,
  );

And then somewhere else:

  eval{ $obj->validate() };
  if( my $results = $EVAL_ERROR ){
    ...
  }

=head1 METHODS

=head2 validation

  __PACKAGE__->validation(
    module => 'FormValidator::Simple',
    profile => { ... },
    filters => 0,
    auto => 1,
  );

Calls L</"validation_module">, L</"validation_profile"> and L</"validation_auto">
if the corresponding argument is defined.

=cut

sub validation {
    my $self = shift;
    my %args = @_;
    
    $self->validation_module( $args{module} ) if exists $args{module};
    $self->validation_profile( $args{profile} ) if exists $args{profile};
    $self->validation_auto( $args{auto} ) if exists $args{auto};
}

=head2 validation_module

  __PACKAGE__->validation_module('Data::FormValidator');

Sets the validation module to use.  Any module that supports a check() method
just like L<"Data::FormValidator">'s can be used here, such as
L<"FormValidator::Simple">.

Defaults to FormValidator::Simple.

=cut

sub validation_module {
    my ($self, $class) = @_;

    if ($class) {
        if (!eval "require $class") {
            $self->throw_exception("Unable to load the validation module '$class' because  $@");
        } elsif (!$class->can('check')) {
            $self->throw_exception("The '$class' module does not support the check() method");
        } else {
            $self->_validation_module_accessor($class->new);
        };
    };

    return ref $self->_validation_module_accessor;
}

=head2 validation_profile

  __PACKAGE__->validation_profile(
    { ... }
  );

Sets the profile that will be passed to the validation module.

=head2 validation_auto

  __PACKAGE__->validation_auto( 1 );

Turns on and off auto-validation.  This feature makes all UPDATEs and
INSERTs call the L</"validate"> method before doing anything.

The default is for validation_auto is to be on.

=head2 validation_filter

  __PACKAGE__->validation_filter( 1 );

Turns on and off validation filters. When on, this feature will make all
UPDATEs and INSERTs modify your data to that of the values returned by
your validation modules C<check> method. This is primarily meant for use
with L<"Data::FormValidator"> but may be used with any validation module
that returns a results object that supports a C<valid()> method just
like L<"Data::FormValidator::Results">.

B<Filters modify your data, so use them carefully>.

The default is for validation_filter is to be off.

=head2 validate

  $obj->validate();

Validates all the data in the object against the pre-defined validation
module and profile.  If there is a problem then a hard error will be
thrown.  If you put the validation in an eval you can capture whatever
the module's check() method returned.

=cut

sub validate {
    my $self = shift;
    my %data = $self->get_columns;
    my $module = $self->validation_module;
    my $profile = $self->validation_profile;
    my $result = $module->check( \%data => $profile );

    if ($result->success) {
    	if ($self->validation_filter && $result->can('valid')) {
    		 $self->set_column($_, $result->valid($_)) for ($result->valid);
    	}
        return $result;
    } else {
        $self->throw_exception($result);
    };
}

=head1 EXTENDED METHODS

The following L<"DBIx::Class::Row"> methods are extended by this module:-

=over 4

=item insert

=cut

sub insert {
    my $self = shift;
    $self->validate if $self->validation_auto;
    $self->next::method(@_);
}

=item update

=cut

sub update {
    my $self = shift;
    $self->validate if $self->validation_auto;
    $self->next::method(@_);
}

1;
__END__

=back

=head1 SEE ALSO

L<"DBIx::Class">, L<"FormValidator::Simple">, L<"Data::FormValidator">

=head1 AUTHOR

Aran C. Deltac <bluefeet@cpan.org>

=head1 CONTRIBUTERS

Tom Kirkpatrick <tkp@cpan.org>

=head1 LICENSE

You may distribute this code under the same terms as Perl itself.
