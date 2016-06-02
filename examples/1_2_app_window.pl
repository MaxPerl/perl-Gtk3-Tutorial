#!/usr/bin/perl

# Make a binding to the Gio API in the Perl program (just copy&paste ;-))
# This is necessary mainly for Gtk3::Application and some more stuff
# Alternatively you find an early implementation as a Perl module
# on https://git.gnome.org/browse/perl-Glib-IO (not yet published on CPAN!)
# Hopefully this module simplifies the use of the Gio API in the future
# (see also the notes above).
BEGIN {
  use Glib::Object::Introspection;
  Glib::Object::Introspection->setup(
    basename => 'Gio',
    version => '2.0',
    package => 'Glib::IO');
}

use strict;
use warnings;
 
use Gtk3;
use Glib qw/TRUE FALSE/;

# The MAIN FUNCTION should be as small as possible and do almost nothing except creating 
# your Gtk3::Application and running it
# The "real work" should always be done in response to the signals fired by Gtk3::Application.
# see below
my $app = Gtk3::Application->new('app.test', 'flags-none');
 
$app->signal_connect('startup'  => \&_init     );
$app->signal_connect('activate' => \&_build_ui );
$app->signal_connect('shutdown' => \&_cleanup  );
 
$app->run(\@ARGV);
 
exit;
 

# The CALLBACK FUNCTIONS to the SIGNALS fired by the main function.
# Here we do the "real work" (see above)
sub _init {
	my ($app) = @_;
 
	# Handle program initialization
     	print "Hello world!\n";
 
 }
 
sub _build_ui {
 
     	my ($app) = @_;
 
     	my $window = Gtk3::ApplicationWindow->new($app);
     	$window->set_title ('Welcome to GNOME');
     	$window->set_default_size (200, 200);
     	$window->signal_connect( 'delete_event' => sub {$app->quit()} );
     	$window->show();

}
 
sub _cleanup {
 
     	my ($app) = @_;
 
     	# Handle cleanup
     	print "Goodbye world!\n";
     
} 

