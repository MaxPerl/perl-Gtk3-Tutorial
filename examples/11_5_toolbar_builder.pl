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

# Setze das Pragma uft8 damit Umlaute im Gtk GUI korrekt angezeigt werden
use utf8;
# Damit das Terminal nicht versucht, die Strings nach Latin-1 umzuwandeln
# mit der Folge, dass die Umlaute im Terminal falsch angezeigt werden
# muss die "Line Discipline" der Standardausgabe in den UTF 8 Modus gesetzt werden
binmode STDOUT, ':utf8';

use Gtk3;
use Glib ('TRUE', 'FALSE');
# Our class must be a subclass of Gtk3::ApplicationWindow to inherit
# the methods, properties etc.pp. of Gtk3::ApplicationWindow
use base 'Gtk3::ApplicationWindow';
 
# the following variables will be used later in a method
# (therefore we have declare outside of the new constructor
# Alternative solutions:
# 1) You can pass the widgets through an anonymous array ref as additional
# arguments to the callback function fullscreen_cb (see the pure toolbar example)
# 2) You can declare these variables with our
# 3) You can define (!) the callback function in the new constructor (not nice)
my ($fullscreen_button, $leave_fullscreen_button, $window);
sub new {
 	$window = $_[0]; my $app = $_[1];
 	$window = bless Gtk3::ApplicationWindow->new($app);
 	$window->set_title ('Toolbar Example');
 	$window->set_default_size(400,200);
     	$window->signal_connect( 'delete_event' => sub {$app->quit()} );
     	
     	# a grid to attach the toolbar
     	my $grid = Gtk3::Grid->new();
     	$window->add($grid);
     	# we have to show the grid (and therefore the toolbar) with show(),
     	# as show_all() would show also the buttons in the toolbar that we want
     	# to be hidden (such as the leave_fullscreen button)
     	$grid->show();
     	
     	# a buidler to add the UI designed with Glade to the grid:
     	my $builder = Gtk3::Builder->new();
     	# get the file (if it is there)
     	$builder->add_from_file('11_5_toolbar_builder.ui') or die 'file not found';
     	# and attach it to the grid
     	my $toolbar = $builder->get_object('toolbar');
     	$grid->attach($toolbar, 0, 0, 1, 1);
	
	$fullscreen_button = $builder->get_object('fullscreen_button');
	$leave_fullscreen_button = $builder->get_object('leave_fullscreen_button');
	
     	# create the actions that control the window and connect their signal to a
     	# callback method (see below), add the action to the window:
	
	# undo
	my $undo_action = Glib::IO::SimpleAction->new('undo',undef);
	$undo_action->signal_connect('activate'=>\&undo_callback);
	$window->add_action($undo_action);
	
	# fullscreen
	my $fullscreen_action = Glib::IO::SimpleAction->new('fullscreen',undef);
	$fullscreen_action->signal_connect('activate'=>\&fullscreen_callback);
	$window->add_action($fullscreen_action);
	
	return $window;	
}

# callback for undo
sub undo_callback {
	my ($action, $parameter) = @_;
	print "You clicked \"Undo\" \n";
}
	
# callback for fullscreen
sub fullscreen_callback {
	# receive the GDK Window of the MyWindow object
	my $gdk_win = $window->get_window();
	# Get the state flags of the GDK Window
	my $is_fullscreen = $gdk_win->get_state();
	# Check whether the fullscreen flag is set
	if ($is_fullscreen =~ m/fullscreen/) {
		$window->unfullscreen();
		$leave_fullscreen_button->hide();
		$fullscreen_button->show();
	}
	else {
		$window->fullscreen();
		$fullscreen_button->hide();
		$leave_fullscreen_button->show();
	}
}


# The MAIN FUNCTION should be as small as possible and do almost nothing except creating 
# your Gtk3::Application and running it
# The "real work" should always be done in response to the signals fired by Gtk3::Application.
# see below
package main;
use strict;
use warnings;
 
# Setze das Pragma uft8 damit Umlaute im Gtk GUI korrekt angezeigt werden
use utf8;
# Damit das Terminal nicht versucht, die Strings nach Latin-1 umzuwandeln
# mit der Folge, dass die Umlaute im Terminal falsch angezeigt werden
# muss die "Line Discipline" der Standardausgabe in den UTF 8 Modus gesetzt werden
binmode STDOUT, ':utf8';
 
use Gtk3;
use Glib ('TRUE', 'FALSE');

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
	
	# create the actions that control the application: create, connect their signal
	# to a callback method (see below), add the action to the application
	
	# new
	my $new_action = Glib::IO::SimpleAction->new('new',undef);
	$new_action->signal_connect('activate'=>\&new_callback);
	$app->add_action($new_action);
	
	# open
	my $open_action = Glib::IO::SimpleAction->new('open',undef);
	$open_action->signal_connect('activate'=>\&open_callback);
	$app->add_action($open_action);
}

sub _build_ui {
	my ($app) = @_;
	my $window = MyWindow->new($app);
	# show the window - with show() not show_all() because that would show also
	# the leave_fullscreen_button
	$window->show();
}

sub _cleanup {
	my ($app) = @_;
}

# callback function for "new"
sub new_callback {
	print "You clicked \"New\". \n";
}

# callback function for "open"
sub open_callback {
	print "You clicked \"Open\" \n";
}
