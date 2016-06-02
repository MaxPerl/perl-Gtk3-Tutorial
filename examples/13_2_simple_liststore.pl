#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

my @columns = ('First Name','Last Name','Phone Number');
my @phonebook =(['Jurg', 'Billeter', '555-0123'],
             	['Johannes', 'Schmid', '555-1234'],
             	['Julita', 'Inca', '555-2345'],
             	['Javier', 'Jardon', '555-3456'],
             	['Jason', 'Clinton', '555-4567'],
             	['Random J.', 'Hacker', '555-5678']);

my $window=Gtk3::Window->new('toplevel');
$window->set_title('My Phone Book');
$window->set_default_size(200,100);
$window->set_border_width(10);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit});

# the data in the model
# (three strings for each row, one for each column)
my $listmodel = Gtk3::ListStore->new('Glib::String','Glib::String','Glib::String');

# append the values in the model
for (my $i=0; $i <= $#phonebook; $i++) {
	# Das Hinzufügen von Daten geschieht in 2 Schritten
	# 1) Dem Treestore wird eine leere Reihe hinzugefügt und zu 
	# dieser Reihe wird eine Referenz bzw. ein Pointer ($iter) 
	# erstellt
	# 2) Um die Reihe mit Inhalt zu füllen, muss die 
	# Gtk3::Treestore set-Methode auf diese angewendet werden
	# !!! Die Liste der Paare muss so viele Elemente enthalten wie 
	# die Zahl der Spalten im Tree- bzw. ListStore!!!
	# example: $liststore ->set ($iter, 0 => "Inhalt der Zeile in 
	# Spalte 1", 1 => ("Inhalt der Zeile in der Spalte 2 etc.)

	my $iter = $listmodel->append();
	$listmodel->set($iter, 	0 => "$phonebook[$i][0]", 
				1 => "$phonebook[$i][1]",
				2 => "$phonebook[$i][2]");	
	}

# a treeview to see the data stored in the model
my $view = Gtk3::TreeView->new($listmodel);

# create a cellrenderer to render the text for each of the 3 columns
for (my $i=0; $i <= $#columns; $i++) {
	my $cell = Gtk3::CellRendererText->new();

	# the text in the first column should be in boldface
	if ($i == 0) {
		$cell->set_property('weight_set',TRUE);
		# !!! Pango.Weight.BOLD is not recognized in perl I don't know
		# why. I took instead 800 for bold (default value (ie normal) is 			# 400)
		$cell->set_property('weight',800);
		}
	
	# the column is created
	# Usage: 
	# Gtk3::TreeViewColumn->new_with_attributes (title, cell_renderer, 
	# attr1 => col1, ...)
	my $col = Gtk3::TreeViewColumn->new_with_attributes($columns[$i],$cell,'text' => $i);

	# alternatively you can do the same as following(see the first example):
	# first: create a TreeViewColumn
	#my $col = Gtk3::TreeViewColumn->new();
	# second: pack the renderer into the beginning of the column, 
	# allocating no more space than needed
	#$col->pack_start($cell, FALSE);	
	# third: set the title
	#$col -> set_title($columns[$i]);
	# fourth: add the attributes
	# 	USAGE: add_attribute(cell_renderer, attribute=>column);
	#$col->add_attribute($cell, text=>$i);

	# and it is appended to the treeview
	$view->append_column($col)
	}

# create a TreeSelection Objekt
my $treeselection=$view->get_selection();
# when a row is selected, it emits a signal
$treeselection->signal_connect('changed' => \&on_changed);

# the label we use to show the selection
my $label = Gtk3::Label->new();
$label->set_text('');

# a grid to attach the widgets
my $grid = Gtk3::Grid->new();
$grid->attach($view, 0,0,1,1);
$grid->attach($label, 0,1,1,1);

# attach the grid to the window
$window->add($grid);

# show the window and run the Application
$window->show_all;
Gtk3->main();

sub on_changed {
	my ($sel) = @_;
	
	# get the model and the iterator that points at the data in the model
	my ($model, $iter) = $sel->get_selected();
	
	# set the label to a new value depending on the selection, if there is
        # one
	if ($iter != '') {
		# we want the data at the model's column 0  
		# where the iter is pointing
		my $value = $model->get_value($iter,0);
		# set the label to a new value depending on the selection
		$label->set_text("$value");
		}
	else {
		$label->set_text('');
		}
	return TRUE;
	}
