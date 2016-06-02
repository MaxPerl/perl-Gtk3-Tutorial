#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

my $window = Gtk3::Window->new('toplevel');
$window->set_title ('Paned Example');
$window->set_default_size(450, 350);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a new widget with two adjustable panes
# on on the left and one on the right
my $paned = Gtk3::Paned->new('horizontal');

# two images
my $image1 = Gtk3::Image->new();
$image1 -> set_from_file('gnome-image.png');

my $image2 = Gtk3::Image->new();
$image2 -> set_from_file('tux.png');

# add the first image to the left pane
$paned -> add1($image1);

# add the second image to the right pane
$paned -> add2($image2);

# add the panes to the window
$window -> add($paned);

# show the window and run the Application
$window -> show_all();
Gtk3->main();
