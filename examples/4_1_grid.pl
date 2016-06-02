#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

my $window = Gtk3::Window->new('toplevel');
$window->set_title('Grid Example');
$window->signal_connect('delete_event' => sub {Gtk3->main_quit});

# three labels
my $label_top_left = Gtk3::Label->new('This is Top Left');
my $label_top_right = Gtk3::Label->new('This is Top Right');
my $label_bottom = Gtk3::Label->new('This is Bottom');

# a grid
my $grid = Gtk3::Grid->new();

# some space between the columns of the grid
$grid->set_column_spacing(20);

# in the grid:
# attach the first label in the top left corner
$grid->attach($label_top_left,0,0,1,1);

# attach the second label
$grid->attach($label_top_right,1,0,1,1);

# attach the third label below the first label
$grid->attach_next_to($label_bottom, $label_top_left, 'bottom', 2, 1);

# add the grid to the window
$window->add($grid);

# show the window and run the Application
$window->show_all;
Gtk3->main();
