#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('ProgressBar Example');
$window->set_default_size(220,20);
$window->signal_connect('key-press-event' => \&do_key_press_event);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a progressbar
my $progressbar = Gtk3::ProgressBar->new();
# add the progressbar to the window
$window->add($progressbar);

# the method $pulse is called each 100 milliseconds
# and $source_id is set to be the ID of the event source
# (i.e. the bar changes position every 100 milliseconds)
my $source_id = Glib::Timeout->add(100, \&pulse);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# event handler
# any signal from the keyboard controls if the progressbar stops/starts
sub do_key_press_event {
	# if the progressbar has been stopped (therefore source_id == 0 - see
	# 'else' below) turn it back on
	if ($source_id == 0) {
		$source_id = Glib::Timeout->add(100, \&pulse);
		}
	# if the bar is moving, remove the source with the ID of source_id
	# from the main context (stop the bar) and set the source id to 0
	else {
		Glib::Source->remove($source_id);
		$source_id = 0;
		}
	# stop the signal emission
	return TRUE;
	}

# source function
# the progressbar is in 'activity mode' when this method is called
sub pulse {
	$progressbar->pulse();
	# call the function again
	return TRUE;
	}
