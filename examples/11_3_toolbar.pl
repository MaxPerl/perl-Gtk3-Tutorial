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
 
sub new {
 	my ($window, $app) = @_;
 	$window = bless Gtk3::ApplicationWindow->new($app);
 	$window->set_title ('Toolbar Example');
 	$window->set_default_size(400,200);
     	$window->signal_connect( 'delete_event' => sub {$app->quit()} );
     	
     	# a grid to attach the toolbar
     	my $grid = Gtk3::Grid->new();
     	
     	#CREATE THE TOOLBAR
     	# a toolbar
	my $toolbar = Gtk3::Toolbar->new();
	
	# with extra horizontal space
	$toolbar->set_hexpand(TRUE);
	# which is the primary toolbar of the application - seems not to work in perl
	$toolbar->get_style_context()->add_class('Gtk3::STYLE_CLASS_PRIMARY_TOOLBAR');	

	# create a button for the "new" action with a icon image
	my $new_icon = Gtk3::Image->new_from_icon_name('document-new', '16');	
	my $new_button = Gtk3::ToolButton->new($new_icon,'Neu');
	# label is shown
	$new_button->set_is_important(TRUE);
	# insert the button at position in the toolbar
	$toolbar->insert($new_button,0);
	# show the button
	$new_button->show();
	# set the name of the action associated with the button.
	# The action controls the application ($app)
	$new_button->set_action_name('app.new');

	# create a button for the "open" action with a icon image
	my $open_icon = Gtk3::Image->new_from_icon_name('document-open', '16');	
	my $open_button = Gtk3::ToolButton->new($open_icon,'Öffnen');
	# label is shown
	$open_button->set_is_important(TRUE);
	# insert the button at position 1 in the toolbar
	$toolbar->insert($open_button,1);
	# show the button
	$open_button->show();
	$open_button->set_action_name('app.open');

	# create a button for the "undo" action with a icon image
	my $undo_icon = Gtk3::Image->new_from_icon_name('edit-undo', '16');	
	my $undo_button = Gtk3::ToolButton->new($undo_icon,'Rückgängig');
	# label is shown
	$undo_button->set_is_important(TRUE);
	# insert the button at position in the toolbar
	$toolbar->insert($undo_button,2);
	# show the button
	$undo_button->show();
	$undo_button->set_action_name('win.undo');

	# create a button for the 'fullscreen' action with a icon image
	my $fullscreen_icon = Gtk3::Image->new_from_icon_name('view-fullscreen', '16');	
	my $fullscreen_button = Gtk3::ToolButton->new($fullscreen_icon,'Vollbild');
	# label is shown
	$fullscreen_button->set_is_important(TRUE);
	# insert the button at position in the toolbar
	$toolbar->insert($fullscreen_button,3);
	# show the button
	$fullscreen_button->show();
	$fullscreen_button->set_action_name('win.fullscreen');
	
	# show the toolbar
	$toolbar->show();
     	
     	# attach the toolbar to the grid
     	$grid->attach($toolbar, 0, 0, 1, 1);
     	
     	# add the grid to the window
     	$window->add($grid);
     	
     	# create the actions that control the window and connect their signal to a
     	# callback method (see below)
	
	# undo
	my $undo_action = Glib::IO::SimpleAction->new('undo',undef);
	$undo_action->signal_connect('activate'=>\&undo_callback);
	$window->add_action($undo_action);
	
	# fullscreen
	my $fullscreen_action = Glib::IO::SimpleAction->new('fullscreen',undef);
	# important: We have to pass the toolbutton widget, where the signal occured, and the
	# window to the callback function as an anonym array ref!
	$fullscreen_action->signal_connect('activate'=>\&fullscreen_callback, [$fullscreen_button, $window]);
	$window->add_action($fullscreen_action);
	
	return $window;
}

sub fullscreen_callback {
	# IMPORTANT: the second argument that is given is $paramter which here is undef!!!
	my ($action, $parameter, $ref) = @_;
	my $toolbutton = $$ref[0];
	my $window = $$ref[1];
	# receive the GDK Window of the MyWindow object
	my $gdk_win = $window->get_window();
	# Get the state flags of the GDK Window
	my $is_fullscreen = $gdk_win->get_state();
	# Check whether the fullscreen flag is set
	if ($is_fullscreen =~ m/fullscreen/) {
		$window->unfullscreen();
		my $fullscreen_icon = Gtk3::Image->new_from_icon_name('view-fullscreen', '16');
		$toolbutton->set_icon_widget($fullscreen_icon);
		$toolbutton->set_label('Vollbild');
		$fullscreen_icon->show();
	}
	else {				
		$window->fullscreen();
		my $leave_fullscreen_icon = Gtk3::Image->new_from_icon_name('view-restore', '16');
		$toolbutton->set_icon_widget($leave_fullscreen_icon);
		$toolbutton->set_label('Vollbild verlassen');
		$leave_fullscreen_icon->show();		
	}
}

sub undo_callback {
	my ($widget) = @_;
	print "You clicked \"Rückgängig\" \n";
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
	
	# create the actions that control the window and connect their signal
	# to a callback method (see below)
	
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
	$window->show_all();
}

sub _cleanup {
	my ($app) = @_;
}

# callback function for "new"
sub new_callback {
	print "You clicked \"Neu\". \n";
}

# callback function for "open"
sub open_callback {
	print "You clicked \"Öffnen\" \n";
}
