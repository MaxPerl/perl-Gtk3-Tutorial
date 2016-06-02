#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

my @actions = (	['Select', ''],
		['New', 'document-new'], # same as 'gtk-new'
		['Open', 'document-open'], # same as 'gtk-open'
		['Save', 'document-save']); # same as 'gtk-save'

my $window=Gtk3::Window->new('toplevel');
$window->set_title('Welcome to GNOME');
$window->set_default_size(200,-1);
$window->set_border_width(10);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit});

# the data in the model, of type string on two columns
my $listmodel = Gtk3::ListStore->new('Glib::String','Glib::String');

# append the data
for (my $i; $i<=$#actions; $i++) {

	# Das Hinzufügen von Daten geschieht in 2 Schritten
	# 1) Dem Treestore wird eine leere Reihe hinzugefügt und zu dieser Reihe
	# wird eine Referenz bzw. ein Pointer ($iter) erstellt
	# 2) Um die Reihe mit Inhalt zu füllen, muss die Gtk3::Treestore 
	# set-Methode auf diese angewendet werden
	# !!! Die Liste der Paare muss so viele Elemente enthalten wie die 
	# Zahl der Spalten im Tree- bzw. ListStore!!!
	# example: $liststore ->set ($iter, 0 => "Inhalt der Zeile in Spalte 1", 
	# 1 => ("Inhalt der Zeile in der Spalte 2 etc.)

	my $iter = $listmodel->append();
	$listmodel->set($iter, 0 => "$actions[$i][0]", 1 => "$actions[$i][1]");
	
	}

# a combobox to see the data stored in the model
my $combobox = Gtk3::ComboBox->new_with_model($listmodel);

# cellrenderers to render the data
my $renderer_pixbuf = Gtk3::CellRendererPixbuf->new();
my $renderer_text = Gtk3::CellRendererText->new();

# we pack the cell into the beginning of the combobox, allocating
# no more space than needed;
# first the image, then the text;
# note that it does not matter in which order they are in the model,
# the visualization is decided by the order of the cellrenderers
$combobox->pack_start($renderer_pixbuf, FALSE);
$combobox->pack_start($renderer_text, FALSE);

# associate a property of the cellrenderer to a column in the model
# used by the combobox
$combobox->add_attribute($renderer_text, 'text' => 0);
$combobox->add_attribute($renderer_pixbuf, 'icon-name' => 1);

# the first row is the active one at the beginning
$combobox->set_active(0);

# connect the signal emitted when a row is selected to the callback
# function
$combobox->signal_connect('changed', \&on_changed);

# add the combobox to the window
$window->add($combobox);

# show the window and run the Application
$window->show_all;
Gtk3->main();

sub on_changed {
	# if the row selected is not the first one, write its value on the
	# terminal
	my ($combo) = @_;
	my $active = $combo->get_active();
	if ($active != 0) {
		print "You choose $actions[$active][0]. \n";
		}
	return TRUE;
	}
