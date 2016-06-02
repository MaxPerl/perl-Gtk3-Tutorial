#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('StatusBar Example');
$window->set_default_size(200,100);
# a key press event for the keyboard input
$window->signal_connect('key-press-event' => \&do_key_press_event);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a label
my $label = Gtk3::Label->new('Press any key or ');

# a button
my $button = Gtk3::Button->new('click me.');
# connected to a callback
$button->signal_connect('clicked', \&button_clicked_cb);

# the statusbar
my $statusbar = Gtk3::Statusbar->new();
# its context_id - not shown in the UI but needed to uniquely identify
# the source of a message
my $context_id = $statusbar->get_context_id('example');
# we push a message onto the statusbar's stack
$statusbar->push($context_id, 'Waiting for you to do something...');

# a grid to attach the widgets
my $grid = Gtk3::Grid->new();
$grid->set_column_spacing(5);
$grid->set_column_homogeneous(TRUE);
$grid->set_row_homogeneous(TRUE);
$grid->attach($label, 0, 0, 1, 1);
$grid->attach_next_to($button, $label, 'right', 1, 1);
$grid->attach($statusbar, 0, 1, 2, 1);

# add the grid to the window
$window->add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# callback function for the  button clicked
# if the button is clicked the event is signaled to the statusbar
# onto which we push a new status
sub button_clicked_cb {
	$statusbar->push($context_id, 'You clicked the button.');
	}

# event handler
# any signal from the keyboard is signaled to the statusbar
# onto which we push a new status with the symbolic name
# of the key pressed
sub do_key_press_event {
	my ($widget, $event) = @_;
	my $keyval = $event->keyval;
	# !!! WICHTIG: Die perlische Schreibweise Gtk3::Gdk->keyval_name($event); scheint buggy zu sein  !!!
	my $key = Gtk3::Gdk::keyval_name($keyval);
	$statusbar->push($context_id, "$key key was pressed.");

	# stop the signal emission
	return TRUE;
	}
