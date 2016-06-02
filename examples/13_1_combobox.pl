#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

my @distros = ('Select distribution', 'Fedora', 'Mint', 'Suse');

my $window=Gtk3::Window->new('toplevel');
$window->set_title('Welcome to GNOME');
$window->set_default_size(200,-1);
$window->set_border_width(10);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit});

# the data in the model, of type string
my $liststore = Gtk3::ListStore->new('Glib::String');

# append the data in the model
foreach my $data (@distros) {

	# Das Hinzufügen von Daten geschieht in 2 Schritten
	# 1) Dem Treestore wird eine leere Reihe hinzugefügt und zu dieser Reihe 		
	# wird eine Referenz bzw. ein Pointer ($iter) erstellt
	# 2) Um die Reihe mit Inhalt zu füllen, muss die Gtk3::Treestore 
	# set-Methode auf diese angewendet werden
	# !!! Die Liste der Paare muss so viele Elemente enthalten wie die 
	# Zahl der Spalten im Tree- bzw. ListStore!!!
	# example: $liststore ->set ($iter, 0 => 'Inhalt der Zeile in Spalte 1', 
	# 1 => ('Inhalt der Zeile in der Spalte 2 etc.)

	my $iter = $liststore->append();
	$liststore->set($iter, 0 => "$data");
	
	}

# a combobox to see the data stored in the model
my $combobox = Gtk3::ComboBox->new_with_model($liststore);

# a cellrenderer to render the text
my $cell = Gtk3::CellRendererText->new();

# pack the cell into the beginning of the combobox, allocating
# no more space than needed
$combobox->pack_start($cell, FALSE);
# associate/verknüpfe a property ('text') of the cellrenderer (cell) 
# to a column (column 0) in the model used by the combobox
$combobox->add_attribute($cell, 'text', 0);

# the first row is the active one by default at the beginning
$combobox->set_active(0);

# connect the signal emitted when a row is selected to the callback
# function
$combobox->signal_connect('changed'=>\&on_changed);

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
		print "You choose $distros[$active]. \n";
		}
	return TRUE;
	}
