#! /usr/bin/perl

# Make a binding to the Gio API in the Perl program (just copy&paste ;-))
BEGIN {
  use Glib::Object::Introspection;
  Glib::Object::Introspection->setup(
    basename => 'Gio',
    version => '2.0',
    package => 'Glib::IO');
}
 

# The CLASS MyWindow, where we build the Gtk3::ApplicationWindow and its content
package MyWindow;
use strict;
use warnings;
use Gtk3;
use Glib ('TRUE', 'FALSE');
# Our class must be a subclass of Gtk3::ApplicationWindow to inherit
# the methods, properties etc.pp. of Gtk3::ApplicationWindow
use base 'Gtk3::ApplicationWindow';
 
sub new {
 	my ($window, $app) = @_;
 	$window = bless Gtk3::ApplicationWindow->new($app);
 	$window->set_title ('MenuBar Example');
     	$window->set_default_size (200, 200);
     	$window->signal_connect( 'delete_event' => sub {$app->quit()} );
     	
	return $window;
}

# The MAIN FUNCTION should be as small as possible and do almost nothing except creating 
# your Gtk3::Application and running it
# The "real work" should always be done in response to the signals fired by Gtk3::Application.
# see below
package main;

use strict;
use warnings;
 
use Gtk3;
use Glib ('TRUE', 'FALSE');

my $app = Gtk3::Application->new('app.test', 'flags-none');
 
$app->signal_connect('startup'  => \&_init);
$app->signal_connect('activate' => \&_build_ui);
$app->signal_connect('shutdown' => sub {$app->quit();});
 
$app->run(\@ARGV);
 
exit;


# The CALLBACK FUNCTIONS to the SIGNALS fired by the main function.
# Here we do the "real work" (see above)
sub _init {
	my ($app) = @_;
	
 	# A builder to add the UI designed with glade to the grid
	my $builder = Gtk3::Builder->new();
	$builder->add_from_file('11_6_menubar-firststep.ui') or die 'file not found';
	
	# we use the method Gtk3::Application->set_menubar('menubar')
	# to add the menubar to the application (Note: NOT the window!)
	my $menubar=$builder->get_object('menubar');
	$app->set_menubar($menubar);
 
 }
 
sub _build_ui {
	my ($app) = @_;
	# Building the Gtk3::ApplicationWindow and its content is here done 
	# by a seperate class (see above)
	my $window = MyWindow->new($app);
	$window->show();
}
