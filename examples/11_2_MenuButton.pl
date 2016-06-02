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
use Glib ('TRUE', 'FALSE');
# Our class must be a subclass of Gtk3::ApplicationWindow to inherit
# the methods, properties etc.pp. of Gtk3::ApplicationWindow
use base 'Gtk3::ApplicationWindow';
 
sub new {
 	my ($window, $app) = @_;
 	$window = bless Gtk3::ApplicationWindow->new($app);
 	$window->set_title ('MenuButton Example');
 	$window->set_default_size(600,400);
     	$window->signal_connect( 'delete_event' => sub {$app->quit()} );
     	
     	my $grid = Gtk3::Grid->new();
     	
     	# a menubutton
     	my $menubutton = Gtk3::MenuButton->new();
     	$menubutton->set_size_request(80,35);
     	
     	$grid->attach($menubutton, 0, 0, 1, 1);
     	
     	# a menu with two actions
     	my $menumodel = Glib::IO::Menu->new();
     	$menumodel->append('New', 'app.new');
     	$menumodel->append('About','win.about');
     	
     	# a submenu with one action for the menu
     	my $submenu = Glib::IO::Menu->new();
     	$submenu->append('Quit','app.quit');
     	$menumodel->append_submenu('Other',$submenu);
     	
     	# the menu is set as the menu of the menubutton
     	$menubutton->set_menu_model($menumodel);
     	
     	# the action related to the window (about)
     	my $about_action = Glib::IO::SimpleAction->new('about',undef);
	$about_action->signal_connect('activate'=>\&about_cb);
	$window->add_action($about_action);
	
	$window->add($grid);

	return $window;
}

# callback function for "about"
sub about_cb {
	print "No AboutDialog for you. This is only a demonstration \n";
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
 
$app->signal_connect('startup'  => \&_init     );
$app->signal_connect('activate' => \&_build_ui );
$app->signal_connect('shutdown' => \&_cleanup  );
 
$app->run(\@ARGV);
 
exit;


# The CALLBACK FUNCTIONS to the SIGNALS fired by the main function.
# Here we do the "real work" (see above)
sub _init {
	my ($app) = @_;
	
	# the actions related to the application
	my $new_action = Glib::IO::SimpleAction->new('new',undef);
	$new_action->signal_connect('activate'=>\&new_cb);
	$app->add_action($new_action);
	
	my $quit_action = Glib::IO::SimpleAction->new('quit',undef);
	$quit_action->signal_connect('activate'=>\&quit_cb);
	$app->add_action($quit_action);
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
sub new_cb {
	print "This does nothing. It is only a demonstration. \n";
}

# callback function for "quit"
sub quit_cb {
	print "You have quit \n";
	$app->quit();
}
