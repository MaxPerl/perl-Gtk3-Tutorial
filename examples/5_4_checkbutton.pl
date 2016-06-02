#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('CheckButton Example');
$window->set_default_size(300,100);
$window->set_border_width(10);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a button
my $button = Gtk3::CheckButton->new();
# with a label
$button->set_label('Show Title');

# connect the signal 'toggled' emitted by the checkbutton
# with the callback function toggled_cb
$button->signal_connect('toggled' => \&toggled_cb);

# by default, the checkbutton is active
$button->set_active(TRUE);

# add the button to the window
$window -> add ($button);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

sub toggled_cb {
	# if the toggle button is active, set the title of the window
	# as 'Checkbutton Example'
	if ($button->get_active()) {
		$window->set_title ('CheckButton Example');
		}
	else {
		$window->set_title ('');
		}
	}
