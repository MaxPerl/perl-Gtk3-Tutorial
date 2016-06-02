#!/usr/bin/perl

use strict;
use Glib ('TRUE','FALSE');
use Gtk3 -init;

my @books =	(['Tolstoy, Leo', ['Warand Peace', TRUE], ['Anna Karenina', FALSE]],
             	['Shakespeare, William', ['Hamlet', FALSE], ['Macbeth', TRUE], ['Othello', FALSE]],
             	['Tolkien, J.R.R.', ['The Lord of the Rings', FALSE]],);

my $window=Gtk3::Window->new('toplevel');
$window->set_title('Library');
$window->set_default_size(250,100);
$window->set_border_width(10);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit});

# the data are stored in the moel
# create a treestore with two column
my $store = Gtk3::TreeStore->new('Glib::String', 'Glib::Boolean');

# fill in the model
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
	$store->set($iter, 0 => "$books[$i][0]", 1 => FALSE);

	for (my $j=1; $j <= $#{$books[$i]}; $j++) {
		# in dieser Spalter fügen wir Kind Iters zu den Eltern Iters hinzu
		# und fügen diesen Kind Iters Daten hinzu / erneut nur 1 Spalte
		my $iter_child = $store->append($iter);
		$store->set($iter_child, 0 => "$books[$i][$j][0]", 1 =>"$books[$i][$j][1]");
		}
	}

# the treeview shows the model
# create a treeview on the model $store
my $view = Gtk3::TreeView->new();
$view->set_model($store);

# the cellrenderer for the first column - text
my $renderer_books = Gtk3::CellRendererText->new();
# the first column is created
my $column_books = Gtk3::TreeViewColumn->new_with_attributes('Books by Author', $renderer_books, 'text'=>0);
# and it is appended to the treeview
$view->append_column($column_books);

# the books are sortable by authors
$column_books->set_sort_column_id(0);

# the cellrenderer for the second column - boolean renderer as a toggle
my $renderer_in_out = Gtk3::CellRendererToggle->new();
# the second column is created
my $column_in_out = Gtk3::TreeViewColumn->new_with_attributes('Out?', $renderer_in_out, 'active'=>1);
# and it is appended to the treeview
$view->append_column($column_in_out);
# connect the cellrenderertoggle with a callback function
$renderer_in_out->signal_connect('toggled' => \&on_toggled);

# add the treeview to the window
$window->add($view);

# show the window and run the Application
$window->show_all;
Gtk3->main();

# callback function for the signa emitted by the cellrenderertoggle
sub on_toggled {
	my ($widget, $path_string) = @_;
	
	# Get the boolean value (1=TRUE, 0=FALSE) of the selected row
	# first generate a Gtk3::TreePath, by using $path_string as a argument 
	# to the new_from_string method of Gtk3::TreePath.
	# This will give us a 'geographical' indication which row was edited.
	my $path = Gtk3::TreePath->new_from_string($path_string);
	# the get the Gt3::Treeiter of the TreePath $path, which will refer 
	# to a row
	my $iter = $store->get_iter($path);
	# last get the value with the function get_value on the model
	my $current_value = $store->get_value($iter,1);

	# change the value of the toggled item
	# instead of the if/elsif construction you can simple write this line
	# '$current_value ^= 1;' [but I don't understand why this works :-)]
	if ($current_value == 0) {$current_value = 1;}
	elsif ($current_value==1){$current_value = 0; }
	$store->set( $iter, 1, $current_value);

	# check if length if the path is 1
	# (that is, if we are selecting an author (= parent cell)
	if (length($path_string) == 1) {

		# get the number of the childrens that the parent $iter has
		my $n = $store->iter_n_children($iter);

		# get the iter associated with its first child		
		my $citer = $store->iter_children($iter);
				
		foreach (my $i = 0; $i <= $n-1; $i++) {
			$store->set($citer,1 => $current_value);
			$store->iter_next($citer);
			}
		}

	# if the length of the path is not 1 
	# (that is if we are selecting a book)
	else {
		# get the parent and the first child of the parent 
		# (that is the first book of the author)
		my $piter = $store->iter_parent($iter);
		my $citer = $store->iter_children($piter);

		# get the number of the childrens that the parent $iter has
		my $n = $store->iter_n_children($piter);

		# Erzeuge eine Variable, mit der mittels einer Schleife 
		#überprüft wird, ob alle Kinder items selected sind
		my $all_selected;

		# check if all children are selected
		foreach (my $i = 0; $i <= $n-1; $i++) {
			my $value = $store->get_value($citer,1);
			if ($value == 1) {
				$all_selected = 1;
				}
			if ($value == 0) {
				$all_selected = 0;
				last;
				}
			$store->iter_next($citer);
			}
		
		# wenn all_selected = 1 (=TRUE) soll auch das Eltern item
		# ausgewählt werden
		if ($all_selected == 1) {
			$store->set($piter, 1, 1);
			}
		# wenn ich alle Kind Elemente selektiert sind
		# soll auch das Eltern Element nicht selektiert sein
		elsif ($all_selected == 0) {
			$store->set($piter, 1, 0);
			}
		}


	}
