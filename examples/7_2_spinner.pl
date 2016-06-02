#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('StatusBar Example');
$window->set_default_size(200,100);
$window->signal_connect('key-press-event' => \&do_key_press_event);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a spinner
my $spinner = Gtk3::Spinner->new();
# that by default spins
$spinner -> start();
# add the spinner to the window
$window->add($spinner);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# event handler
# a signal from the keyboard (space) controls if the spinner stops/starts
sub do_key_press_event {
	# keyname is the symbolic name of the key value given by the event
	my ($widget, $event) = @_;
	my $keyval = $event->keyval;	
	my $keyname = Gtk3::Gdk::keyval_name($keyval);
	
	# if  it is 'space'
	if ($keyname == 'space') {
		# an the spinner ist active
		if ($spinner->get_property('active')) {
			# stop the spinner
			$spinner->stop();
			}
		# if the spinner is not active
		else {
			# start it again
			$spinner->start();
			}
		}
	# stop the signal emission
	return TRUE;
}
