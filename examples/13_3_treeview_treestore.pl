#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

my @books =	(['Tolstoy, Leo', 'Warand Peace', 'Anna Karenina'],
             	['Shakespeare, William', 'Hamlet', 'Macbeth', 'Othello'],
             	['Tolkien, J.R.R.', 'The Lord of the Rings']);

my $window=Gtk3::Window->new('toplevel');
$window->set_title('Library');
$window->set_default_size(250,100);
$window->set_border_width(10);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit});

# the data are stored in the moel
# create a treestore with one column
my $store = Gtk3::TreeStore->new('Glib::String');

# append the values in the model
for (my $i=0; $i <= $#books; $i++) {
	# Vorbemerkung: Das Hinzufügen von Daten geschieht grds. in 2 Schritten
	# 1) Dem Treestore wird eine leere Reihe hinzugefügt und zu 
	# dieser Reihe wird eine Referenz bzw. ein Pointer ($iter) 
	# erstellt
	# 2) Um die Reihe mit Inhalt zu füllen, muss die 
	# Gtk3::Treestore set-Methode auf diese angewendet werden
	# !!! Die Liste der Paare muss so viele Elemente enthalten wie 
	# die Zahl der Spalten im Tree- bzw. ListStore!!!
	# example: $liststore ->set ($iter, 0 => "Inhalt der Zeile in 
	# Spalte 1", 1 => ("Inhalt der Zeile in der Spalte 2 etc.)
	
	# Zunächst wird das Eltern Iter erstellt und die Eltern Zellen eingefügt
	# diese befinen sich jeweils an erster Stelle (d.h. $books[$i][0]
	# i.Ü. wird nur eine Spalte benötigt
	my $iter = $store->append();
	$store->set($iter, 0 => "$books[$i][0]");

	for (my $j=1; $j <= $#{$books[$i]}; $j++) {
		# in dieser Spalter fügen wir Kind Iters zu den Eltern Iters hinzu
		# und fügen diesen Kind Iters Daten hinzu / erneut nur 1 Spalte
		my $iter_child = $store->append($iter);
		$store->set($iter_child, 0 => "$books[$i][$j]");
		}
	}

# the treeview shows the model
# create a treeview on the model $store
my $view = Gtk3::TreeView->new();
$view->set_model($store);

# the cellrenderer for the column - text
my $renderer_books = Gtk3::CellRendererText->new();
# the column is created
my $column_books = Gtk3::TreeViewColumn->new_with_attributes('Books by Author', $renderer_books, 'text'=>0);
# and it is appended to the treeview
$view->append_column($column_books);

# the books are sortable by authors
$column_books->set_sort_column_id(0);

# add the treeview to the window
$window->add($view);

# show the window and run the Application
$window->show_all;
Gtk3->main();
