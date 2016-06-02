#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('GNOME Button');
$window->set_default_size(250,50);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a button
my $button = Gtk3::Button->new();
# with a label
$button->set_label('Click me');

# connect the signal 'clicked' emitted by the button
# to the callback function do_clicked
$button->signal_connect('clicked' => \&do_clicked);

# add the button to the window
$window -> add ($button);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# callback function connected to the signal 'clicked' of the button
sub do_clicked {
	print("You clicked me! \n");
	}
