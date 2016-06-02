#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('SpinButton Example');
$window->set_default_size(210,70);
$window->set_border_width(5);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# an adjustment (initial value, max value,
# step increment - press cursor keys or +/- buttons to see!,
# page increment  not used here,
# page size - not used here)
my $ad = Gtk3::Adjustment->new(0, 0, 100, 1, 0, 0);

# a spin button for integers (digits=0)
my $spin = Gtk3::SpinButton->new($ad, 1, 0);
# as wide as possible
$spin->set_hexpand(TRUE);

# we connect the signal 'value-changed' emitted by the spinbutton with the callback
# function spin_selected
$spin->signal_connect('value-changed' => \&spin_selected);

# a label
my $label = Gtk3::Label->new();
$label -> set_text('Choose a number');

# a grid to attach the widgets
my $grid = Gtk3::Grid->new();
$grid->attach($spin, 0, 0, 1, 1);
$grid->attach($label, 0, 1, 2, 1);

# add the grid to the window
$window->add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# callback function: the signal of the spinbutton is used to change the 
# text of the label
sub spin_selected {
	my $number = $spin->get_value_as_int();
	$label->set_text("The number you selected is $number");
	}
