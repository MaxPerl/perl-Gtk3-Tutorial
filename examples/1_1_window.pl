#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;


# create a Gtk Window
my $window = Gtk3::Window->new('toplevel');

# set the title
$window->set_title('Welcome to GNOME');

# exit the program if user close the Application
$window->signal_connect('delete_event'=>sub{Gtk3->main_quit()});

# show the window
$window->show_all;

# create and run the application
Gtk3->main();
