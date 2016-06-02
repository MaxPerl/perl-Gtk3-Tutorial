#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ("TRUE","FALSE");

# construct a window
my $window = Gtk3::Window->new("toplevel", "app");
$window->set_title ("Gtk3 Menu Example");
$window->set_default_size (200, 200);
$window->signal_connect("delete_event" => sub {Gtk3->main_quit()});

# create a menubar
my $menubar = Gtk3::MenuBar->new;
$menubar->show();

# create an item onto the menubar
my $menubar_item = Gtk3::MenuItem->new_with_label("Anwendung");
$menubar->insert($menubar_item,0);

# create the menu
my $menu = Gtk3::Menu->new();

# append to the menu three options
my $menu_item_new = Gtk3::MenuItem->new();
$menu_item_new->set_label("New");
$menu->insert($menu_item_new,0);
$menu_item_new->signal_connect("activate" => \&cb_activate);

my $menu_item_about = Gtk3::MenuItem->new();
$menu_item_about->set_label("About");
$menu->insert($menu_item_about,1);
$menu_item_about->signal_connect("activate" => \&cb_activate);
 
my $menu_item_quit = Gtk3::MenuItem->new();
$menu_item_quit->set_label("Quit");
$menu->insert($menu_item_quit,2);
$menu_item_quit->signal_connect("activate" => \&cb_activate);

# das Menu muss nun dem Menubaritem hinzugefügt werden
$menubar_item->set_submenu($menu);

# add the menubar to a grid
my $grid=Gtk3::Grid->new();
$grid->attach($menubar,0,0,1,1);

# Füge die Box dem Windows hinzu
$window->add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

sub cb_activate {
	# Die Klammer ist erforderlich, um den Listenkontext zu erzwingen, ansonsten würde lediglich die Anzahl der Elemente (hier 1) zurückgegeben werden. Alternativ könnte man auch "my $widget = $_[0];" schreiben
	my ($widget) = @_;
	my $label = $widget->get_label();
	if ($label eq "New") {
		print "This does nothing. It is only a demonstration. \n";
		}
	elsif ($label eq "About") {
		print "No AboutDialog for you. It is only a demonstration. \n";
		}
	elsif ($label eq "Quit") {
		print "You have quit. \n";
		Gtk3->main_quit();
		}
	}
