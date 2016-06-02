#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('GNOME LinkButton');
$window->set_default_size(250,50);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a button
my $button = Gtk3::LinkButton->new('http:://live.gnome.org');
# with a label
$button->set_label('Link to GNOME live');

# add the button to the window
$window -> add ($button);

# show the window and run the Application
$window -> show_all();
Gtk3->main();
