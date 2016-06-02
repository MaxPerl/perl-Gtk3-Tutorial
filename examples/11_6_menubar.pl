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
 	$window->set_title ('MenuBar Example');
     	$window->set_default_size (200, 200);
     	$window->signal_connect( 'delete_event' => sub {$app->quit()} );
     	
     	# action without a state created (name, parameter type)
     	my $copy_action = Glib::IO::SimpleAction->new('copy',undef);
     	# connected with the callback function
     	$copy_action->signal_connect('activate'=>\&copy_callback);
     	# added to the window
     	$window->add_action($copy_action);

     	# action without a state created (name, parameter type)
     	my $paste_action = Glib::IO::SimpleAction->new('paste',undef);
     	# connected with the callback function
     	$paste_action->signal_connect('activate'=>\&paste_callback);
     	# added to the window
     	$window->add_action($paste_action);
     	
     	# action with a state created
     	# options: (name, parameter type, initial state)
     	my $shape_action = Glib::IO::SimpleAction->new_stateful('shape', Glib::VariantType->new('s'), Glib::Variant->new_string('line'));
     	# connected to the callback function
     	$shape_action->signal_connect('activate'=>\&shape_callback);
     	# added to the windows
     	$window->add_action($shape_action);
    	
    	# action with a state created
    	my $about_action = Glib::IO::SimpleAction->new('about',undef);
    	# action connected to the callback function
    	$about_action->signal_connect('activate'=>\&about_callback);
    	# action added to the application
    	$window->add_action($about_action);
     	
     	return $window;
 }
 
 # callback function for the copy action
sub copy_callback {
	print "\"Copy\" activated \n";
}

# callback function for the paste action
sub paste_callback {
	print "\"Paste\" activated \n";
}

# callback function for the shape action
sub shape_callback {
	my ($action, $parameter) = @_;
	my $string = $parameter->get_string();
	print "Shape is set to $string \n";
	
	# Note that we set the state of the action!
	$action->set_state($parameter);
}
 
 # callback function for about (see AboutDialog example)
 sub about_callback {
 	my ($action, $parameter) = @_;
 	print "About activated \n";
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
	
	# action without a state created
 	my $new_action = Glib::IO::SimpleAction->new('new',undef);
 	# action connected to the callback function
 	$new_action->signal_connect('activate'=>\&new_callback);
 	# action added to the application
 	$app->add_action($new_action);
 	
 	# action without a state created
 	my $quit_action = Glib::IO::SimpleAction->new('quit',undef);
 	# action connected to the callback function
 	$quit_action->signal_connect('activate'=>\&quit_callback);
 	# action added to the application
 	$app->add_action($quit_action);
 	
	# action with a state created
	my $state_action = Glib::IO::SimpleAction->new_stateful('state', Glib::VariantType->new('s'), Glib::Variant->new_string('off'));
	# action connected to the callback function
	$state_action->signal_connect('activate'=>\&state_callback);
	# action added to the application
	$app->add_action($state_action);
	
	# action with a state created
	my $awesome_action = Glib::IO::SimpleAction->new_stateful('awesome', undef, Glib::Variant->new_boolean(TRUE));
	# action connected to the callback function
	$awesome_action->signal_connect('activate'=>\&awesome_callback);
	# action added to the application
	$app->add_action($awesome_action);
	
 	# A builder to add the UI designed with glade to the grid
	my $builder = Gtk3::Builder->new();
	$builder->add_from_file('11_6_menubar.ui') or die 'file not found';
	
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
 
sub _cleanup {
     	my ($app) = @_;
} 

# callback function for new
sub new_callback {
	print "You clicked \"New \" \n";
}

# callback function for quit
sub quit_callback {
	print "You clicked \"Quit\" \n";
	$app->quit();
}

# callback function for state
sub state_callback {
	my ($action, $parameter) = @_;
	my $string = $parameter->get_string();
	print "State is set to $string \n";
	
	$action->set_state($parameter);
}

# callback function for awesome
sub awesome_callback {
	my ($action, $parameter) = @_;
	my $state = $action->get_state();
	my $boolean = $state->get_boolean();
	if ($boolean) {
		print "You unchecked \"Awesome\" \n";
		$action->set_state(Glib::Variant->new_boolean(FALSE));
	}
	else {
		print "You checked \"Awesome\" \n";
		$action->set_state(Glib::Variant->new_boolean(TRUE));
	}
}
