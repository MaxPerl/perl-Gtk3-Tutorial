#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('RadioButton Example');
$window->set_default_size(250,100);
$window->set_border_width(20);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a new radiobutton with a label
my $button1 = Gtk3::RadioButton->new();
# with label 'Button 1'
$button1->set_label('Button 1');
# connect the signal 'toggled' emitted by the radiobutton
# with the callback function toggled_cb
$button1->signal_connect('toggled' => \&toggled_cb);

# another radio button, in the same group as button1
my $button2 = Gtk3::RadioButton->new_from_widget($button1);
# with label 'Button 2'
$button2->set_label('Button 2');
# connect the signal 'toggled' emitted by the radiobutton
# with the callback function toggled_cb
$button2->signal_connect('toggled' => \&toggled_cb);
# set button2 not active by default
$button2->set_active(FALSE);

# another radio button, in the same group as button1
# with label 'Button 3'
my $button3 = Gtk3::RadioButton->new_from_widget($button1);
# with label 'Button 3'
$button3->set_label('Button 3');
# connect the signal 'toggled' emitted by the radiobutton
# with the callback function toggled_cb
$button3->signal_connect('toggled' => \&toggled_cb);
# set button2 not active by default
$button3->set_active(FALSE);

# a grid to place the buttons
my $grid = Gtk3::Grid->new();
$grid->attach($button1, 0, 0, 1, 1);
$grid->attach($button2, 0, 1, 1, 1);
$grid->attach($button3, 0, 2, 1, 1);
# add the grid to the window
$window->add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# callback function
sub toggled_cb {	
	# Der erste Wert der von der Funktion übergebenen Variable beinhaltet immer eine Referenz auf das Widget, bei dem das Signal auftrat!
	my ($button) = @_;
	# a string to describe the state of the button
	my $state = 'unknown';
	# whenever the button is turned on, state is on
	if ($button->get_active()) {
		$state = 'on';		
		}
	# else state is off
	else {
		$state = 'off';
		}	
	# whenever the function is called (a button is turned on or off)
	# print on the terminal which button was turned on/off
	my $button_label = $button->get_label();	
	print ("$button_label was turned $state \n");
	}
