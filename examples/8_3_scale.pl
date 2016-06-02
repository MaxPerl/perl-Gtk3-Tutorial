#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('Scale Example');
$window->set_default_size(400,300);
$window->set_border_width(5);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# two adjustments (initial value, min value, max value, 
# step incremnt - press cursor keys to see!, 
# page increment - click around the handle to see!,
# page size - not used here)
my $ad1 = Gtk3::Adjustment->new(0,0,100,5,10,0);
my $ad2 = Gtk3::Adjustment->new(50,0,100,5,10,0);

# a horizontal scale
my $h_scale = Gtk3::Scale->new('horizontal',$ad1);
# of integers (no digits)
$h_scale->set_digits(0);
# that can expand horizontally if there is space in the grid (see
# below)
$h_scale->set_hexpand(TRUE);
# that is aligned at the top of the space allowed in the grid (see
# below)
$h_scale->set_valign('start');

# we connect the signal 'value-changed' emittet by the scale with the 
# callback function scale_moved
$h_scale->signal_connect('value-changed' => \&scale_moved);

# a vertical scale
my $v_scale = Gtk3::Scale->new('vertical',$ad2);
# that can expand vertically if there is space in the grid (see
# below)
$v_scale->set_vexpand(TRUE);

# we connect the signal 'value-changed' emittet by the scale with the 
# callback function scale_moved
$v_scale->signal_connect('value-changed' => \&scale_moved);

# a label
my $label = Gtk3::Label->new();
$label->set_text('Move the scale handles...');

# a grid to attach the widgets
my $grid = Gtk3::Grid->new();
$grid ->set_column_spacing(10);
$grid->set_column_homogeneous(TRUE);
$grid->attach($h_scale, 0, 0, 1, 1);
$grid->attach_next_to($v_scale, $h_scale, 'right', 1, 1);
$grid->attach($label, 0, 1, 2, 1);

$window->add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# any signal from the scales is signaled to the label the text of which is
# changed
sub scale_moved {
	my ($widget, $event) = @_;
	my $h_value = $h_scale->get_value();
	my $v_value = $v_scale->get_value();
	$label->set_text("Horizontal scale is $h_value; vertical scale is $v_value.");
	}
