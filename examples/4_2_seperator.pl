#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

my $window = Gtk3::Window->new('toplevel');
$window->set_title ('Separator Example');
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# three labels
my $label1 = Gtk3::Label->new();
$label1->set_text('Below, a horizontal separator.');

my $label2 = Gtk3::Label->new();
$label2->set_text('On the right, a vertical separator.');

my $label3 = Gtk3::Label->new();
$label3->set_text('On the left, a vertical separatoer');

# a horizotal separator
my $hseparator = Gtk3::Separator->new('horizontal');

# a vertical separator
my $vseparator = Gtk3::Separator->new('vertical');

# a grid to attach labels and separators
my $grid = Gtk3::Grid->new();
$grid -> attach ($label1, 0, 0, 3, 1);
$grid -> attach ($hseparator, 0, 1, 3, 1);
$grid -> attach ($label2, 0, 2, 1, 1);
$grid -> attach ($vseparator, 1, 2, 1, 1);
$grid -> attach ($label3, 2, 2, 1, 1);
$grid -> set_column_homogeneous(TRUE);

# add the grid to the window
$window -> add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();
