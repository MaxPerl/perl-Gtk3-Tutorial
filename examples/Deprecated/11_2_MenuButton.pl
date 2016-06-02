#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib::Object::Introspection;

# a window
my $window = Gtk3::Window->new("toplevel");
$window->set_title ("MenuButton Example");
$window->set_default_size(600,400);
$window->signal_connect("delete_event" => sub {Gtk3->main_quit()});

# Erstelle den MenuButton
my $menubutton = Gtk3::MenuButton->new();
$menubutton->set_size_request(80,35);

# Füge den MenuButton zu einem Grid hinzu
my $grid = Gtk3::Grid->new();
$grid->attach($menubutton, 0,0,1,1);

# Erstelle das Menu, das dem Menubutton später hinzugefügt wird
my $menu = Gtk3::Menu->new();

# Füge dem Menü die einzelnen Optionen hinzu
my $new = Gtk3::MenuItem->new();
$new->set_label("New");
$menu->append($new);

my $about = Gtk3::MenuItem->new();
$about->set_label("About");
$menu->append($about);

my $other = Gtk3::MenuItem->new();
$other->set_label("Other");
$menu->append($other);

# Ein neues Menü mit neuen Optionen wird zu einem Untermenü zu dem Item Other
my $menu2 = Gtk3::Menu->new();
my $quit = Gtk3::MenuItem->new();
$quit->set_label("Quit");
$menu2->append($quit);
$other->set_submenu($menu2);


$menu->show_all();


$menubutton->set_popup($menu);

$window->add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();
