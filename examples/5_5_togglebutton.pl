#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('ToggleButton Example');
$window->set_default_size(300,300);
$window->set_border_width(30);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a spinner animation
my $spinner = Gtk3::Spinner->new();
# with extra horizontal space
$spinner->set_hexpand(TRUE);
# with extra vertical space
$spinner->set_vexpand(TRUE);

# a toggle button
my $button = Gtk3::ToggleButton->new_with_label('Start/Stop');
# connect the signal 'toggled' emitted by the togglebutton
# when its state is changed to callback function toggled_cb
$button->signal_connect('toggled' => \&toggled_cb);

# a grid to allocate the widgets
my $grid = Gtk3::Grid->new();
$grid->set_row_homogeneous(FALSE);
$grid->set_row_spacing(15);
$grid->attach($spinner, 0, 0, 1, 1);
$grid->attach($button, 0, 1, 1, 1);

# add the grid to the window
$window->add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# callback function for the signal 'toggled'
sub toggled_cb {
	# if the togglebutton is active, start the spinner	
	if ($button->get_active()) {
		$spinner->start();
		}
	# else, stop it
	else 	{
		$spinner->stop();
		}
	}
