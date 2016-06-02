#!/usr/bin/perl

# Setze das Pragma uft8 damit Umlaute im Gtk GUI korrekt angezeigt werden
use utf8;
# Damit das Terminal nicht versucht, die Strings nach Latin-1 umzuwandeln
# mit der Folge, dass die Umlaute im Terminal falsch angezeigt werden
# muss die "Line Discipline" der Standardausgabe in den UTF 8 Modus gesetzt werden
binmode STDOUT, ":utf8";

use strict;
use Gtk3 -init;
use Glib ("TRUE","FALSE");

# a window
my $window = Gtk3::Window->new("toplevel");
$window->set_title ("Toolbar Example");
$window->set_default_size(400,200);
$window->signal_connect("delete_event" => sub {Gtk3->main_quit()});

# a grid to attach the toolbar
my $grid = Gtk3::Grid->new();

# a toolbar created in the method create_toolbar (see below)
my $toolbar = create_toolbar();
# with extra horizontal space
$toolbar->set_hexpand(TRUE);
# show the toolbar
$toolbar->show();

# attach the toolbar to the grid
$grid->attach($toolbar,0,0,1,1);

# add the grid to the window
$window->add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();


sub create_toolbar {
	# a toolbar
	my $toolbar = Gtk3::Toolbar->new();

	# which is the primary toolbar of the application - seems not to work in perl
	#$toolbar->get_style_context()->add_class("Gtk3::STYLE_CLASS_PRIMARY_TOOLBAR");	

	# create a button for the "new" action with a icon image
	my $new_icon = Gtk3::Image->new_from_icon_name("document-new", "16");	
	my $new_button = Gtk3::ToolButton->new($new_icon,"Neu");
	# label is shown
	$new_button->set_is_important(TRUE);
	# insert the button at position in the toolbar
	$toolbar->insert($new_button,0);
	# show the button
	$new_button->show();
	# connect with callback function cb_clicked
	$new_button->signal_connect("clicked" => \&cb_clicked);

	# create a button for the "open" action with a icon image
	my $open_icon = Gtk3::Image->new_from_icon_name("document-open", "16");	
	my $open_button = Gtk3::ToolButton->new($open_icon,"Öffnen");
	# label is shown
	$open_button->set_is_important(TRUE);
	# insert the button at position 1 in the toolbar
	$toolbar->insert($open_button,1);
	# show the button
	$open_button->show();
	$open_button->signal_connect("clicked" => \&cb_clicked);

	# create a button for the "undo" action with a icon image
	my $undo_icon = Gtk3::Image->new_from_icon_name("edit-undo", "16");	
	my $undo_button = Gtk3::ToolButton->new($undo_icon,"Rückgängig");
	# label is shown
	$undo_button->set_is_important(TRUE);
	# insert the button at position in the toolbar
	$toolbar->insert($undo_button,2);
	# show the button
	$undo_button->show();
	$undo_button->signal_connect("clicked" => \&cb_clicked);

	# create a button for the "fullscreen" action with a icon image
	my $fullscreen_icon = Gtk3::Image->new_from_icon_name("view-fullscreen", "16");	
	my $fullscreen_button = Gtk3::ToolButton->new($fullscreen_icon,"Vollbild");
	# label is shown
	$fullscreen_button->set_is_important(TRUE);
	# insert the button at position in the toolbar
	$toolbar->insert($fullscreen_button,3);
	# show the button
	$fullscreen_button->show();
	$fullscreen_button->signal_connect("clicked" => \&cb_clicked);

	# return the complete toolbar
	return $toolbar;
	}

sub cb_clicked {
	my ($widget) = @_;
	my $label = $widget->get_label();

	if ($label eq "Vollbild") {
		$window->fullscreen();
		my $leave_fullscreen_icon = Gtk3::Image->new_from_icon_name("view-restore", "16");
		$widget->set_icon_widget($leave_fullscreen_icon);
		$widget->set_label("Vollbild verlassen");
		$leave_fullscreen_icon->show();
		
		}


	elsif ($label eq "Vollbild verlassen") {				
		$window->unfullscreen();

		my $fullscreen_icon = Gtk3::Image->new_from_icon_name("view-fullscreen", "16");
		$widget->set_icon_widget($fullscreen_icon);
		$widget->set_label("Vollbild");
		$fullscreen_icon->show();
		}

	else {
		print "You clicked $label \n";
		}
	}
