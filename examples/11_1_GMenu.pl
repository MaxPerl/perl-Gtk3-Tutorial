#! /usr/bin/perl

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
 

# The CLASS MyWindow, where we build the Gtk3::ApplicationWindow and its content
package MyWindow;
use strict;
use warnings;
use Gtk3;
use Glib qw/TRUE FALSE/;
# Our class must be a subclass of Gtk3::ApplicationWindow to inherit
# the methods, properties etc.pp. of Gtk3::ApplicationWindow
use base 'Gtk3::ApplicationWindow';
 
 sub new {
 	my ($window, $app) = @_;
 	$window = bless Gtk3::ApplicationWindow->new($app);
 	$window->set_title ('GMenu Example');
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

my $app = Gtk3::Application->new('app.id', 'flags-none');
 
$app->signal_connect('startup'  => \&_init     );
$app->signal_connect('activate' => \&_build_ui );
$app->signal_connect('shutdown' => \&_cleanup  );
 
$app->run(\@ARGV);
 
exit;


# The CALLBACK FUNCTIONS to the SIGNALS fired by the main function.
# Here we do the "real work" (see above)
sub _init {
	my ($app) = @_;
	
	# create a menu
	my $menu = Glib::IO::Menu->new();
	
	# append to the menu three options
	$menu->append('New', 'app.new');
	$menu->append('About','app.about');
	$menu->append('Quit','app.quit');
	# set the menu as menu of the application
	$app->set_app_menu($menu);
	
	# create an actionfor the option "new" of the menu
	my $new_action = Glib::IO::SimpleAction->new('new',undef);
	# connect it to the callback  function new_cb
	$new_action->signal_connect('activate'=>\&new_cb);
	# add the action to the application
	$app->add_action($new_action);
	
	# option "about"
	my $about_action = Glib::IO::SimpleAction->new('about',undef);
	$about_action->signal_connect('activate'=>\&about_cb);
	$app->add_action($about_action);
	
	# option "quit"
	my $quit_action = Glib::IO::SimpleAction->new('quit',undef);
	$quit_action->signal_connect('activate'=>\&quit_cb);
	$app->add_action($quit_action);
}

sub _build_ui {
	my ($app) = @_;
	my $window = MyWindow->new($app);
	$window->show();
}

sub _cleanup {
	my ($app) = @_;
}

# callback function for "new"
sub new_cb {
	print "This does nothing. It is only a demonstration. \n";
}

# callback function for "about"
sub about_cb {
	print "No AboutDialog for you. This is only a demonstration \n";
}

# callback function for "quit"
sub quit_cb {
	print "You have quit \n";
	$app->quit();
}
