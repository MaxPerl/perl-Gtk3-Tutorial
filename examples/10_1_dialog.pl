#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# construct a window (the parent window)
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('GNOME Button');
$window->set_default_size(250,50);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a button on the parent window
my $button = Gtk3::Button->new('Click me');
# connect the signal 'clicked' of the button with the function
# on_button_click()
$button->signal_connect('clicked', \&on_button_click);
# add the button to the window
$window->add($button);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# callback function for the signal 'clicked' of the button in the parent 
# window
sub on_button_click {
	# create a Dialog
	my $dialog = Gtk3::Dialog->new();
	$dialog->set_title('A Gtk+ Dialog');

	# the window defined in the constructor ($window) is the parent of
	# the dialog. 
	# Furthermore, the dialog is on top of the parent window
	$dialog->set_transient_for($window);
	
	# set modal true: no interaction with other windows of the application
	$dialog->set_modal(TRUE);

	# add a button to the dialog window
	$dialog->add_button('OK','ok');

	# connect the 'response' signal (the button has been clicked) to the
	# function on_response()
	$dialog->signal_connect('response' => \&on_response);

	# get the content area of the dialog, add a label to it
	my $content_area = $dialog->get_content_area();
	my $label = Gtk3::Label->new('This demonstrates a dialog with a label');
	$content_area->add($label);

	# show the dialog
	$dialog->show_all(); 
	}

sub on_response {
	my ($widget, $response_id) = @_;
	print "response_id is $response_id \n";
	# destroy the widget (the dialog) when the function on_response() is called
	# (that is, when the button of the dialog has been clicked)
	$widget->destroy(); 
	}
