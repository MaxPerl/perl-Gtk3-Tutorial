#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('Calculator');
$window->set_default_size(350,200);
$window->set_border_width(10);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# an entry
my $entry = Gtk3::Entry->new();
# with an initial text
$entry->set_text('0');
# text aligned on the rigtht
$entry->set_alignment(1);
# the text in the entry cannot be modifier writing in it
$entry->set_can_focus(FALSE);

# a grid
my $grid = Gtk3::Grid->new();
$grid->set_row_spacing(5);

# to attach the entry
$grid->attach($entry, 0,0,1,1);

# the labels for the button
my @buttons = 	(7, 8, 9, '/',
		4, 5, 6, '*',
		1, 2, 3, '+',
		'C', 0, '=', '-');

# each row is a ButtonBox, attached to the grid
foreach my $i (0..3) {
	my $hbox = Gtk3::ButtonBox->new('horizontal');	
	$hbox->set_spacing(5);
	$grid->attach($hbox, 0, $i+1, 1, 1);
	# each ButtonBox has 4 buttons, connected to the callback function
	foreach my $j (0..3) {
		my $button=Gtk3::Button->new();
		$button->set_label("$buttons[$i*4+$j]");
		$button->set_can_focus(FALSE);
		$button->signal_connect('clicked' => \&button_clicked);
		$hbox->add($button);
		}
	}

# some variables for the calculations
my $first_number = 0;
my $second_number = 0;
my $counter = 0;
my $operation = '';

# add the grid to the window
$window->add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# callback function for all the buttons
sub button_clicked {
	# Die erste übergebene Variable enthält immer eine Referenz auf den 
	# geklickten Button
	my $button = $_[0];

	# Erhalte das Label des geklickten Button
	my $label = $button->get_label();
	
	# for the operations
	if ($label eq '+') {
		$counter += 1;
		if ($counter > 1) {
			do_operation();
			}
		$entry->set_text('0');
		$operation = 'plus';
		}
	elsif ($label eq '-') {
		$counter += 1;
		if ($counter > 1) {
			do_operation();
			}
		$entry->set_text('0');
		$operation = 'minus';
		}
	elsif ($label eq '*') {
		$counter += 1;
		if ($counter > 1) {
			do_operation();
			}
		$entry->set_text('0');
		$operation = 'multiplication';
		}
	elsif ($label eq '/') {
		$counter += 1;
		if ($counter > 1) {
			do_operation();
			}
		$entry->set_text('0');
		$operation = 'division';
		}
	 # for '='
	elsif ($label eq '=') {
		do_operation();
		$entry->set_text("$first_number");
		$counter = 1;
		}
	# for Cancel
	elsif ($label eq 'C') {
		$first_number = 0;
		$second_number = 0;
		$counter = 0;	
		$entry->set_text('0');
		$operation = '';
		}
	# for a digit button - für Zahl-Buttons
	else {
		my $new_digit = $button->get_label();
		# ZERO DIVISI ERROR -> TO DO!!!
		my $number = $entry->get_text();
		$number = $number * 10 + $new_digit;		
		if ($counter eq '0') {
			$first_number = $number;
			}
		else {
			$second_number = $number;
			}
		
		$entry->set_text("$number");
		}
	}

sub do_operation {
	if ($operation eq 'plus') {
	$first_number += $second_number;
		}
	elsif ($operation eq 'minus') {
	$first_number -= $second_number;
		}
	elsif ($operation eq 'multiplication') {
	$first_number *= $second_number;
		}
	elsif ($operation eq 'division') {
	$first_number = $first_number / $second_number;
	# ZERO DIVISI ERROR -> TO DO!!!
		}
	}
