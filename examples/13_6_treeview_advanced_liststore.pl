#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

my @list_of_dvds = ('The Usual Suspects','Gilda','The Godfather', 'Pulp Fiction', 'Once Upon a Time in the West', 'Rear Window');

my $window=Gtk3::Window->new('toplevel');
$window->set_title('My DVDs');
$window->set_default_size(250,100);
$window->set_border_width(10);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit});

# the data are stored in the model
# create a liststore with one column
my $listmodel = Gtk3::ListStore->new('Glib::String');

# speichere die Anzahl der Zeilen in einer eignen Variablen
my $row_count = 0;

# append the values in the model
for (my $i=0; $i <= $#list_of_dvds; $i++) {
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
	$listmodel->set($iter, 	0 => "$list_of_dvds[$i]");
	
	# Wenn eine Zeile hinzugefügt wurde, erhöhe die Variable $row_count
	$row_count++;
	}

# a treeview to see the data stored in the model
my $view = Gtk3::TreeView->new($listmodel);

# cellrenderer for the first column
my $cell = Gtk3::CellRendererText->new();
# the first column is created
my $col = Gtk3::TreeViewColumn->new_with_attributes('Title',$cell,'text' => 0);
# and it is appended to the treeview
$view->append_column($col);

# create a TreeSelection Objekt
my $selection=$view->get_selection();
# when a row is selected, it emits a signal
$selection->signal_connect('changed' => \&on_changed);

# the label we use to show the selection
my $label = Gtk3::Label->new();
$label->set_text('');

# a button to ad new titles, connected to a callback function
my $button_add = Gtk3::Button->new('Add');
$button_add->signal_connect('clicked' => \&add_cb);

# an entry to enter titles
my $entry = Gtk3::Entry->new();

# a button to remove titles, connected to a callback function
my $button_remove = Gtk3::Button->new('Remove');
$button_remove->signal_connect('clicked'=>\&remove_cb);

# a button to remove all titles, connected to a callback function
my $button_remove_all = Gtk3::Button->new('Remove All');
$button_remove_all->signal_connect('clicked' => \&remove_all_cb);

# a grid to attach the widgets
my $grid = Gtk3::Grid->new();
$grid->attach($view, 0, 0, 4, 1);
$grid->attach($label, 0, 1, 4, 1);
$grid->attach($button_add, 0, 2, 1, 1);
$grid->attach_next_to($entry, $button_add, 'right', 1, 1);
$grid->attach_next_to($button_remove, $entry, 'right', 1, 1);
$grid->attach_next_to($button_remove_all, $button_remove, 'right', 1, 1);

# ad the grid to the window
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

sub add_cb {
	# append to the model the title that is in the entry
	my $title = $entry->get_text();
	my $add_iter = $listmodel->append();
	$listmodel->set($add_iter, 0 => "$title");
	# and print a message in the terminal
	print "$title has been added \n";

	# Wenn eine Zeile hinzugefügt wurde, erhöhe die Variable $row_count
	$row_count++;
	}

sub remove_cb {
	# check if there is still an entry in the model		
	# the methode iter_n_children($iter) returns the number of children 
	# that iter has or here with $iter=NULL the number of toplevel nodes
	# which are in a liststore (no childs!!) the number of lines 
	my $len = $listmodel->iter_n_children();	
	#if ($len != 0) {
	# another way is the methode $listmodel->get_iter_first which returns
	# FALSE if the tree is empty	
	#if ($listmodel->get_iter_first()) {

	# last but not least you can save the lenght of rows in an own 
	# variable (here: $rows (see below)
	if ($row_count != 0) {
		# get the selection
		my ($model, $iter) = $selection->get_selected();
		# if there is a selection, print a message in the terminal
            	# and remove it from the model (TO DO)
		
		# we want the data at the model's column 0  
		# where the iter is pointing
		my $value = $model->get_value($iter,0);
		print "$value has been removed \n";
		$listmodel->remove($iter);

		# wenn eine Zeile gelöscht wurde, erniedrige die Variable $row_count
		$row_count--;
		}
	else {
		print "Empty list \n";
		}
	}
sub remove_all_cb {
	# check if there is still an entry in the model
	if ($row_count != 0) {
		# remove all the entries in the model
		for (my $i=1; $i <= $row_count; $i++) {
			my $iter = $listmodel->get_iter_first;
			$listmodel->remove($iter);
			}
		
		# Setze die Anzahl der Zeilen auf 0
		$row_count = 0;
		}
	else {
		print "Empty list \n";
		}
	}
