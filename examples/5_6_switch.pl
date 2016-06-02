#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('Switch Example');
$window->set_default_size(300,100);
$window->set_border_width(10);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a switch
my $switch = Gtk3::Switch->new();
# turn on by default
$switch->set_active(TRUE);
# connect the signal notify::active emitted by the switch
# to the callback function activate_cb
$switch->signal_connect('notify::active' => \&activate_cb);

# a label
my $label = Gtk3::Label->new();
$label->set_text('Title');

# a grid to allocate the widgets
my $grid = Gtk3::Grid->new();
$grid->set_column_spacing(10);
$grid->attach($label, 0, 0 , 1, 1);
$grid->attach($switch, 1, 0 , 1, 1);

# add the grid to the window
$window->add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# Callback function. Since the signal is notify::activv
# we need the argument 'active'
sub activate_cb {
	if ($switch->get_active) {
		$window->set_title('Switch Example');
		}
	else {
		$window->set_title('');
		}
	}
