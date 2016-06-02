#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

# create the window
my $window = Gtk3::Window->new('toplevel');
$window->set_title('Welcome to GNOME');
$window->set_default_size(200,100);
$window->signal_connect('delete_event'=>sub{Gtk3->main_quit()});

# create a label
my $label = Gtk3::Label->new();

# set the text of the label
$label -> set_text('Hello GNOME!');

# or set the text in the Pango Markup Language
#$label->set_markup	("Text can be <small>small</small>, <big>big</big>,".
#			"<b>bold</b>, <i>italic</i> and even point to somewhere".
#			"in the <a href=\"http:://www.gtk.org\" ".
#			"title=\"Click to find out more\">internets</a>");

# add the label to the window
$window->add($label);

# show the window and run the application
$window->show_all;
Gtk3->main();
