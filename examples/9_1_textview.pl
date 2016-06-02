#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

# a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('TextView Example');
$window->set_default_size(300, 450);
$window->set_border_width(5);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# a scrollbar for the child widget (that is going to be the textview!)
my $scrolled_window = Gtk3::ScrolledWindow->new();
$scrolled_window->set_border_width(5);
# we scroll only if needed
$scrolled_window->set_policy('automatic','automatic');

# a text buffer (stores text)
my $buffer1 = Gtk3::TextBuffer->new();

# a textview
my $textview = Gtk3::TextView->new();
# displays the buffer
$textview->set_buffer($buffer1);
# wrap the text, if needed, breaking lines in between words
$textview->set_wrap_mode('word');

# textview is scrolled
$scrolled_window->add($textview);

$window->add($scrolled_window);

# show the window and run the Application
$window -> show_all();
Gtk3->main();
