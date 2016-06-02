#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

my $window = Gtk3::Window->new('toplevel');
$window->set_title('AboutDialog Example');
$window->set_default_size(200,200);
$window->signal_connect('destroy'=>sub {Gtk3->main_quit;});

# a menubar created in the method create_menubar (see below)
my $menubar = create_menubar();

# add the menubar to a grid
my $grid=Gtk3::Grid->new();
$grid->attach($menubar,0,0,1,1);

# add the grid to window
$window->add($grid);

$window->show_all();
Gtk3->main();

sub create_menubar {
	# create a menubar
	my $menubar=Gtk3::MenuBar->new();

	# create a menubar item
	my $menubar_item=Gtk3::MenuItem->new('Anwendung');

	# add the menubar item to the menubar
	$menubar->insert($menubar_item,0);

	# create a menu
	my $menu=Gtk3::Menu->new();

	# add 2 items to the menu
	my $item1=Gtk3::MenuItem->new('About');
	$item1->signal_connect('activate'=>\&about_cb);

	my $item2=Gtk3::MenuItem->new('Quit');
	$item2->signal_connect('activate'=> sub {Gtk3->main_quit();});


	$menu->insert($item1,0);
	$menu->insert($item2,1);

	# add the menu to the menubar(_item!)
	$menubar_item->set_submenu($menu);
	
	# return the complete menubar
	return $menubar;	
	}

sub about_cb {
	# a Gtk3::AboutDialog
	my $aboutdialog = Gtk3::AboutDialog->new();

	# lists of authors and documenters (will be used later)
	my @authors = ('GNOME Documentation Team');
	my @documenters = ('GNOME Documentation Team');

	# we fill in the aboutdialog
	$aboutdialog->set_program_name('AboutDialog Example');
	$aboutdialog->set_copyright(
		"Copyright \xa9 2012 GNOME Documentation Team");
	# important: set_authors and set_documenters need an array ref!
	# with a normal array it doesn't work!	
	$aboutdialog->set_authors(\@authors);
	$aboutdialog->set_documenters(\@documenters);
	$aboutdialog->set_website('http://developer.gnome.org');
	$aboutdialog->set_website_label('GNOME Developer Website');

	# we do not want to show the title, which by default would be 'About AboutDialog Example'
	# we have to reset the title of the messagedialog window after setting
	# the prorgam name
	$aboutdialog->set_title('');

	# to close the aboutdialog when 'close' is clicked we connect
	# the 'response' signal to on_close
	$aboutdialog->signal_connect('response'=>\&on_close);
	# show the aboutdialog
	$aboutdialog->show();
	}

# destroy the aboutdialog
sub on_close {
	my ($aboutdialog) = @_;
	$aboutdialog->destroy();
	}
