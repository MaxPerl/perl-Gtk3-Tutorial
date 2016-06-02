#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;


# create a window
my $window = Gtk3::Window->new('toplevel');
$window->set_default_size(300,300);
$window->set_title('Welcome to GNOME');
$window->signal_connect('delete_event'=>sub{Gtk3->main_quit()});

# create an image
my $image = Gtk3::Image->new();

# set the content of the image as the file filename.png
$image->set_from_file('gnome-image.png');

# add the image to the window
$window->add($image);

# show the window and run the app
$window->show_all;
Gtk3->main();
