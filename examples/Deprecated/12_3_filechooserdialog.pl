#!/usr/bin/perl

use strict;
use Gtk3 -init;
use Glib ('TRUE','FALSE');
use Encode;

# construct a window
my $window = Gtk3::Window->new('toplevel');
$window->set_title ('FileChooser Example');
$window->set_default_size (400, 400);
$window->signal_connect('delete_event' => sub {Gtk3->main_quit();});

# THE MENU (To do)
# create a menubar
my $menubar = Gtk3::MenuBar->new;
$menubar->show();

# create an item onto the menubar
my $menubar_item = Gtk3::MenuItem->new_with_label('Anwendung');
$menubar->insert($menubar_item,0);

# create the menu
my $menu = Gtk3::Menu->new();

# append to the menu three options
my $menu_item_new = Gtk3::MenuItem->new();
$menu_item_new->set_label('New');
$menu->insert($menu_item_new,0);
$menu_item_new->signal_connect('activate' => \&new_callback);

my $menu_item_open = Gtk3::MenuItem->new();
$menu_item_open->set_label('Open');
$menu->insert($menu_item_open,1);
$menu_item_open->signal_connect('activate' => \&open_callback);
 
my $menu_item_save = Gtk3::MenuItem->new();
$menu_item_save->set_label('Save');
$menu->insert($menu_item_save,2);
$menu_item_save->signal_connect('activate' => \&save_callback);

my $menu_item_save_as = Gtk3::MenuItem->new();
$menu_item_save_as->set_label('Save as');
$menu->insert($menu_item_save_as,3);
$menu_item_save_as->signal_connect('activate' => \&save_as_callback);

my $menu_item_quit = Gtk3::MenuItem->new();
$menu_item_quit->set_label('Quit');
$menu->insert($menu_item_quit,4);
$menu_item_quit->signal_connect('activate' => sub {Gtk3->main_quit();});

# das Menu muss nun dem Menubaritem hinzugefügt werden
$menubar_item->set_submenu($menu);


# THE MAIN PROGRAM
# the file
my $file = '';
my $filename = '';

# the textview with the buffer
my $buffer = Gtk3::TextBuffer->new();
my $textview = Gtk3::TextView->new();
$textview->set_buffer($buffer);
$textview->set_wrap_mode('word');

# a scrolled window for the textview
my $scrolled_window = Gtk3::ScrolledWindow->new();
$scrolled_window->set_policy('automatic', 'automatic');
$scrolled_window->add($textview);
$scrolled_window->set_border_width(5);
# use the set_hexpand and set_vexpand from Gtk3::Widget on the 
# ScrolledWindow to expand it!
$scrolled_window->set_hexpand(TRUE);
$scrolled_window->set_vexpand(TRUE);

# add the menubar and the scrolled window to a grid
my $grid=Gtk3::Grid->new();
$grid->attach($menubar,0,0,1,1);
$grid->attach($scrolled_window,0,1,1,1);

# add the grid to the window
$window->add($grid);

# show the window and run the Application
$window -> show_all();
Gtk3->main();

# THE CALLBACK FUNCTIONS FOR THE MENU

# callback for new
sub new_callback {
	$buffer->set_text('');
	$filename='';
	print "New file created \n";
	}

# callback for open
sub open_callback {
	# create a filechooserdialog to open:
	# the arguments are: title of the window, parent_window, action
	# (buttons, response)
	my $open_dialog = Gtk3::FileChooserDialog->new('Pick a file', 
						$window,
						'open',
						('gtk-cancel', 'cancel', 
						'gtk-open', 'accept'));

	# not only local files can be selected in the file selector
	$open_dialog->set_local_only(FALSE);

	# dialog always on top of the textview window
	$open_dialog->set_modal(TRUE);

	# connect the dialog with the callback function open_response_cb()
	$open_dialog->signal_connect('response' => \&open_response_cb);

	# show the dialog
	$open_dialog->show();

	}

# callback function for the dialog open_dialog
sub open_response_cb {
	my ($dialog, $response_id) = @_;
	my $open_dialog = $dialog;
	# if response id is 'ACCEPTED' (the button 'Open' has been clicked)
	if ($response_id eq 'accept') {
		print "accept was clicked \n";

		# $filename is the filename that we get from the FileChooserDialog
		# Note: More modern is to use '$open_dialog->get_file', whereby $file must 		
		# be a GFile Object. Unfortunately for that you need the Perl Module Glib::IO.
		# A very early and unready implementation of Glib::IO you can find on 
		# https://git.gnome.org/browse/perl-Glib-IO (not yet published on CPAN!)
		# Although the needed 'get_file' function already works, we don't want to use 
		# it here because of the early development status of the Glib::IO module		
		$filename = $open_dialog->get_filename();

		open my $fh, '<', $filename;
		my $content;		
		while (my $line=<$fh>) {
			$content = $content . $line;
		}
		# important: we need the length in byte!! Usually the perl function
		# length deals in logical characters, not in physical bytes! For how
		# many bytes a string encoded as UTF-8 would take up, we have to use
		# length(Encode::encode_utf8($content) (for that we have to 'use Encode'
		# first [see more http://perldoc.perl.org/functions/length.html]
		# Alternative solutions: 1) open with tag '<:encoding(utf8)'
		# 2) For insert all the text set length in the $buffer->set_text method 
		# 	to -1 (!text must be nul-terminated)
		# 3) In Perl Gtk3 the length argument is optional! Without length 
		#	all text is inserted
		my $length = length(Encode::encode_utf8($content));
		$buffer->set_text($content,$length);
		print "opened: $filename \n";
		$dialog->destroy();
		}
	# if response id is 'CANCEL' (the button 'Cancel' has been clicked)
	elsif ($response_id eq 'cancel') {
		print "cancelled: Gtk3::FileChooserAction::OPEN \n";
		$dialog->destroy();
		}
	}

# callback function for save_as
sub save_as_callback {
	# create a filechooserdialog to save:
	# the arguments are: title of the window, parent_window, action,
	# (buttons, response)
	my $save_dialog = Gtk3::FileChooserDialog->new('Pick a file', 
							$window, 
							'save', 
							('gtk-cancel', 'cancel',
							'gtk-save', 'accept'));
	# the dialog will present a confirmation dialog if the user types a file name
	# that already exists
	$save_dialog->set_do_overwrite_confirmation(TRUE);
	# dialog always on top of the textview window
	$save_dialog->set_modal(TRUE);

	if ($filename) {
	# With the following code line we make the opened file preselected!
	# Note: More modern is to use '$save_dialog->set_file($file)', whereby $file must 		
	# be a GFile Object. Unfortunately for that you need the Perl Module Glib::IO and 
	# create the GFile Object in the open_callback function with 
	# '$file = $open_dialog->get_file();' (see already above)
	# A very early and unready implementation of Glib::IO you can find on 
	# https://git.gnome.org/browse/perl-Glib-IO (not yet published on CPAN!)
	# Although the needed 'get_file' function already works, we don't want to use 
	# it here because of the early development status of the Glib::IO module
	$save_dialog->select_filename($filename);
	}

	# connect the dialog to the callback function save_response_cb
	$save_dialog->signal_connect('response' => \&save_response_cb);

	# show the dialog
	$save_dialog->show();
}

# callback function for the dialog save_dialog
sub save_response_cb {
	my ($dialog, $response_id) = @_;
	my $save_dialog = $dialog;

	# if $response_id is 'ACCEPT' (= the button 'Save' has been clicked)
	if ($response_id eq 'accept') {
		# get the currently selected file
		# more modern is to use the GFile Method $file->get_file (see above)
		$filename = $save_dialog->get_filename();

		# save to file
		
		# get the content of the buffer, without hidden characters
		my ($start, $end) = $buffer->get_bounds();
		my $content = $buffer->get_text($start, $end, FALSE);

		# write to the file
		open my $fh, '>:encoding(utf8)', $filename;
		print $fh "$content";
		close $fh;
		
		print "In diese Datei gespeichert: $filename \n";

		# destroy the FileChooserDialog
		$dialog->destroy;
	}
	elsif ($response_id eq 'cancel') {
		print "cancelled: FileChooserAction.SAVE \n";
		# destroy the FileChooserDialog
		$dialog->destroy;
	}
}

sub save_callback {
	# if $filename is already there
	if ($filename) {
		# get the content of the buffer, without hidden characters
		my ($start, $end) = $buffer->get_bounds();
		my $content = $buffer->get_text($start, $end, FALSE);

		# save to file
		open my $fh, '>:encoding(utf8)', $filename;
		print $fh "$content";
		close $fh;
		
		print "$content in $filename gespeichert \n";
	}
	else {
		# use save_as_callback
		save_as_callback();
	}
}
