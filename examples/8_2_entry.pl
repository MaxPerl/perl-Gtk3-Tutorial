#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('What is your name?');
$window->set_default_size(300,100);
$window->set_border_width(10);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a single line entry
my $name_box = Gtk3::Entry->new();
# emits a signal when Enter key is pressed, connected to the
# callback function cb_activate
$name_box->signal_connect('activate', \&cb_activate);

# add the Entry to the window
$window->add($name_box);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# the content of the entry is used to write in the terminal
sub cb_activate {
	# retrieve the content of the widget
	my $entry = $_[0];
	my $name = $entry->get_text();
	# print it in a nice form in the terminal 
	#(ohne "\n" kommt keine Ausgabe auf dem Terminal, bis das Programm beendet wird!
	print "Hello $name! \n";
	}
