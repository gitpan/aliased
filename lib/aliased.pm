package aliased;
$VERSION = '0.1';

use strict;

sub import {
    my ($class, $package, $alias, @import) = @_;
    require Carp && Carp::croak("You must supply a package name to aliased")
        unless defined $package;
    $alias ||= _get_alias($package);
    {
        local $SIG{'__DIE__'};
        my $callpack = caller(0);
        eval "package $callpack; require $package; sub $alias () { '$package' }";
        die $@ if $@;
    }
    my $import_method = $package->can('import');
        @_ = ($package, @import);
    goto $import_method if $import_method;
}

sub _get_alias {
    my $package = shift;
    $package    =~ s/.*(?:::|')//;
    return $package;
}

1;
__END__

=head1 NAME

aliased - Use shorter versions of class names.

=head1 SYNOPSIS

  use aliased 'My::Company::Namespace::Customer';
  my $cust = Customer->new;

  use aliased 'My::Company::Namespace::Preferred::Customer' => 'Preferred';
  my $pref = Preferred->new;

=head1 DESCRIPTION

C<aliased> is simple in concept but is a rather handy module.  It loads the
class you specify and exports into your namespace a subroutine that returns the
class name.  You can explicitly alias the class to another name or, if you
prefer, you can do so implicitly.  In the latter case, the name of the
subroutine is the last part of the class name.  Thus, it does something similar
to the following:

  #use aliased 'Some::Annoyingly::Long::Module::Name::Customer';

  use Some::Annoyingly::Long::Module::Name::Customer;
  sub Customer {
    return 'Some::Annoyingly::Long::Module::Name::Customer';
  }
  my $cust = Customer->new;

This module is useful if you prefer a shorter name for a class.  It's also
handy if a class has been renamed.

(Some may object to the term "aliasing" because we're not aliasing one
namespace to another, but it's a handy term.  Just keep in mind that this is
done with a subroutine and not with typeglobs and weird namespace munging.)

Note that this is B<only> for C<use>ing OO modules.  You cannot use this to
load procedural modules.  See the L<Why OO Only?|Why OO Only?> section.  Also,
don't let the version number fool you.  This code is ridiculously simple and is
just fine for most use.

=head2 Implicit Aliasing

The most common use of this module is:

  use aliased 'Some::Module::name';

C<aliased> will  allow you to reference the class by the last part of the class
name.  Thus, C<Really::Long::Name> becomes C<Name>.  It does this by exporting
a subroutine into your namespace with the same name as the aliased name.  This
subroutine returns the original class name.

For example:

  use aliased "Acme::Company::Customer";
  my $cust = Customer->find($id);

Note that any class method can be called on the shorter version of the class
name, not just the constructor.

=head2 Explicit Aliasing

Sometimes two class names can cause a conflict (they both end with C<Customer>
for example), or you already have a subroutine with the same name as the
aliased name.  In that case, you can make an explicit alias by stating the name
you wish to alias to:

  use aliased 'Original::Module::Name' => 'NewName';

Here's how we use C<aliased> to avoid conflicts:

  use aliased "Really::Long::Name";
  use aliased "Another::Really::Long::Name" => "Aname";
  my $name  = Name->new;
  my $aname = Aname->new;

You can even alias to a different package:

  use aliased "Another::Really::Long::Name" => "Another::Name";
  my $aname = Another::Name->new;

Messing around with different namespaces is a really bad idea and you probably
don't want to do this.  However, it might prove handy if the module you are
using has been renamed.  If the interface has not changed, this allows you to
use the new module by only changing one line of code.

  use aliased "New::Module::Name" => "Old::Module::Name";
  my $thing = Old::Module::Name->new;

=head2 Import Lists

Sometimes, even with an OO module, you need to specify extra arguments when using
the module.  When this happens, simply use L<Explicit Aliasing> followed by the
import list:

Snippet 1:

  use Some::Module::Name qw/foo bar/;
  my $o = Some::Module::Name->some_class_method; 

Snippet 2 (equivalent to snippet 1):

  use aliased 'Some::Module::Name' => 'Name', qw/foo bar/;
  my $o = Name->some_class_method;

B<Note>:  remember, you cannot use import lists with L<Implicit Aliasing>.  As
a result, you may simply prefer to only use L<Explicit Aliasing> as a matter of
style.

=head2 Why OO Only?

Some people have asked why this code only support object-oriented modules (OO).
If I were to support normal subroutines, I would have to allow the following
syntax:

  use aliased 'Some::Really::Long::Module::Name';
  my $data = Name::data();

That causes a serious problem.  The only (reasonable) way it can be done is to
handle the aliasing via typeglobs.  Thus, instead of a subroutine that provides
the class name, we alias one package to another (as the L<namespace|namespace>
module does.)  However, we really don't want to simply alias one package to another
and wipe out namespaces willy-nilly.  By merely exporting a single subroutine 
to a namespace, we minimize the issue. 

Fortunately, this doesn't seem to be that much of a problem.  Non-OO modules
generally support exporting of the functions you need and this eliminates the
need for a module such as this.

=head1 EXPORT

This modules exports a subroutine with the same name as the "aliased" name.

=head1 BUGS

There are no known bugs in this module, but feel free to email me reports.

=head1 SEE ALSO

The L<namespace|namespace> module.

=head1 THANKS

Many thanks to Rentrak, Inc. (http://www.rentrak.com/) for graciously allowing
me to replicate the functionality of some of their internal code.

=head1 AUTHOR

Curtis Poe, E<lt>eop_divo_sitruc@yahoo.comE<gt>

Reverse the name to email me.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Curtis "Ovid" Poe

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.5 or,
at your option, any later version of Perl 5 you may have available.

=cut
