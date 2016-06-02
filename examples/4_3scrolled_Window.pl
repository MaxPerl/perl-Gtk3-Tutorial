#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

my $window=Gtk3::Window->new('toplevel');
$window->set_title('Scrolled Window Example');
$window->set_default_size(200,200);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

# the scrolled window
my $scrolled_window=Gtk3::ScrolledWindow->new();
$scrolled_window->set_border_width(10);

# there is always the scrollbar (otherwise: automatic - only if needed - or never
$scrolled_window->set_policy('always', 'always');

# an image - slightly arger than the window...
my $image = Gtk3::Image->new();
$image->set_from_file('gnome-image.png');

# add the image to the scrolled window
$scrolled_window->add_with_viewport($image);

# add the scrolled window to the window
$window->add($scrolled_window);

# show window and start MainLoop
$window->show_all();
Gtk3->main;
