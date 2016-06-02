#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');

my $window = Gtk3::Window->new('toplevel');
$window->set_title('MessageDialog Example');
$window->set_default_size(400,200);
$window->signal_connect('destroy'=>sub {Gtk3->main_quit;});

my $label = Gtk3::Label->new();
$label->set_text('This appliccation goes boom');

# a menubar created in the method create_menubar (see below)
my $menubar = create_menubar();

# pack the menubar and the label in a vertical box
my $vbox = Gtk3::Box->new('vertical', 0);
# Pack a menubar always in a vertical box with option Expand and Fill false!
# alternatively you can use a grid (see the other examples)
$vbox->pack_start($menubar,FALSE,FALSE,0);
$vbox->pack_start($label,TRUE,TRUE,0);

$window->add($vbox);

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
	my $item1=Gtk3::MenuItem->new('Message');
	$item1->signal_connect('activate'=>\&message_cb);

	my $item2=Gtk3::MenuItem->new('Quit');
	$item2->signal_connect('activate'=> sub {Gtk3->main_quit();});

	$menu->insert($item1,0);
	$menu->insert($item2,1);

	# add the menu to the menubar(_item!)
	$menubar_item->set_submenu($menu);
	
	# return the complete menubar
	return $menubar;	
	}

# callback function for the signal 'activate' from the message_action
# in the menu of the parent window
sub message_cb {
	# a Gtk3::MessageDialog
	# the options are (parent,flags,MessageType,ButtonType,message) 
	my $messagedialog = Gtk3::MessageDialog->new(	$window,
							'modal',
							'warning',
							'ok_cancel',
							'This action will cause the universe to stop existing.');

	# connect the response (of the button clicked to the function
	# dialog_response
	$messagedialog->signal_connect('response'=>\&dialog_response);
	# show the messagedialog
	$messagedialog->show();
	}

sub dialog_response {
	my ($widget, $response_id) = @_;
	
	# if the button clicked gives response OK (-5)
	if ($response_id eq 'ok') {
		print "boom \n";
		}

	# if the button clicked gives response CANCEL (-6)
	elsif ($response_id eq 'cancel') {
		print "good choice \n";
		}

	# if messagedialog is destroyed (by pressing ESC)
	elsif ($response_id eq 'delete-event') {
		print "dialog closed or cancelled \n";
		}

	# finally, destroy the messagedialog
	$widget->destroy();
	}
