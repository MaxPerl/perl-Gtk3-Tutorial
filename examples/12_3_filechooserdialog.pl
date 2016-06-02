#! /usr/bin/perl

# Make a binding to the Gio API in the Perl program (just copy&paste ;-))
# This is necessary mainly for Gtk3::Application and some more stuff
# Alternatively you find an early implementation as a Perl module
# on https://git.gnome.org/browse/perl-Glib-IO (not yet published on CPAN!)
# Hopefully this module simplifies the use of the Gio API in the future so that for example the still 
# necessary converting of the bytes in a bytestring would be redundant(see also the notes above).
BEGIN {
  use Glib::Object::Introspection;
  Glib::Object::Introspection->setup(
    basename => 'Gio',
    version => '2.0',
    package => 'Glib::IO');
}


# The CLASS MyWindow, where we build the Gtk3::ApplicationWindow and its content
package MyWindow;
use strict;
use warnings;
use utf8;
use Gtk3;
use Glib ('TRUE', 'FALSE');
use Encode;
# Our class must be a subclass of Gtk3::ApplicationWindow to inherit
# the methods, properties etc.pp. of Gtk3::ApplicationWindow
use base 'Gtk3::ApplicationWindow';
 
# MyWindow instance variables (we need them in the callback functions):
my $window;
my $buffer;
my $file;
 
 sub new {
	$window = $_[0]; my $app = $_[1];
 	$window = bless Gtk3::ApplicationWindow->new($app);
 	$window->set_title ('FileChooserDialog Example');
 	$window->set_default_size(400,400);
     	$window->signal_connect( 'delete_event' => sub {$app->quit()} );
	
	# the file
	$file = undef;
	
	# the textview with the buffer
	$buffer = Gtk3::TextBuffer->new();
	my $textview = Gtk3::TextView->new();
	$textview->set_buffer($buffer);
	$textview->set_wrap_mode('word');

	# a scrolled window for the textview
	my $scrolled_window = Gtk3::ScrolledWindow->new();
	$scrolled_window->set_policy('automatic', 'automatic');
	$scrolled_window->add($textview);
	$scrolled_window->set_border_width(5);
	
	# add the scrolled window to the window
	$window->add($scrolled_window);
	
	# the actions for the window menu, connected to the callback functions
	my $new_action = Glib::IO::SimpleAction->new('new',undef);
	$new_action->signal_connect('activate'=>\&new_callback);
	$window->add_action($new_action);
	
	my $open_action = Glib::IO::SimpleAction->new('open',undef);
	$open_action->signal_connect('activate'=>\&open_callback);
	$window->add_action($open_action);
	
	my $save_action = Glib::IO::SimpleAction->new('save',undef);
	$save_action->signal_connect('activate'=>\&save_callback);
	$window->add_action($save_action);
	
	my $save_as_action = Glib::IO::SimpleAction->new('save-as',undef);
	$save_as_action->signal_connect('activate'=>\&save_as_callback);
	$window->add_action($save_as_action);
	
	return $window;
}

# callback for new
sub new_callback {
	my ($action, $parameter) = @_;
	$buffer->set_text('');
	print "New file created \n";
}

# callback for open
sub open_callback {
	my ($action, $parameter) = @_;
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

		# $file is the file that we get from the FileChooserDialog
		$file = $open_dialog->get_file();		
		
		# load the content of the file into memory:
		# success is a boolean depending on the success of the operation
		# content is self-explanatory
		# etags is an entity tag (can be used to quickly determine if the
		# file has been modified from the version on the file system)
		my ($success, $content, $etags) = Glib::IO::File::load_contents($file) or print "Error: Open failed \n";

		# NOTE: GIO reads and writes files in raw bytes format, 
		# which means everything is passed on without any encoding/decoding.
		# We have to convert these data so that Perl can understand them.
		# First we convert the bytes (= pure digits) to a bytestring without encoding
		$content = pack 'C*', @{$content};
		# Then we decode this bytestrng in the utf8 encoding format
		my $content_utf8 = decode('utf-8', $content);

		# important: we need the length in byte!! Usually the perl function
		# length deals in logical characters, not in physical bytes! For how
		# many bytes a string encoded as UTF-8 would take up, we have to use
		# length(Encode::encode_utf8($content) (for that we have to 'use Encode'
		# first [see more http://perldoc.perl.org/functions/length.html]
		# Alternative solutions:
		# 1) For insert all the text set length in the $buffer->set_text method 
		# 	to -1 (!text must be nul-terminated)
		# 2) In Perl Gtk3 the length argument is optional! Without length 
		#	all text is inserted
		my $length = length(Encode::encode_utf8($content_utf8));
		$buffer->set_text($content_utf8, $length);
		
		my $filename = $open_dialog->get_filename();
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

	if ($file) {
	$save_dialog->select_file($file) or print "Error Selecting file failed\n";
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
		$file = $save_dialog->get_file();
		
		# save to file (see below)
		save_to_file();
		
		# destroy the FileChooserDialog
		$dialog->destroy;
	}
	elsif ($response_id eq 'cancel') {
		print "cancelled: FileChooserAction.SAVE \n";
		# destroy the FileChooserDialog
		$dialog->destroy;
	}
}

# callback function for save
sub save_callback {
	my ($action, $parameter) = @_;
	# if $file is not already there
	if ($file) {
		save_to_file();
	}
	# $file is a new file
	else {
		# use save_as
		save_as_callback($action, $parameter);
	}
}

# save_to_file
sub save_to_file {
	# get the content of the buffer, without hidden characters
	my ($start, $end) = $buffer->get_bounds();
	my $current_contents = $buffer->get_text($start, $end, FALSE);
	if ($current_contents) {
		# NOTE AGAIN: Gio reads and writes files in raw bytes format (see above)
		# Therefore the method replace_readwrite expects an array reference containing
		# raw bytes!!! So we have to convert the perlish content into an array ref 
		# containing the raw bytes as follows:

		# First we have to reconvert the textstring with the utf8 encoding format to
		# to a bytestring
		my $content_utf8 = encode('utf-8', $current_contents);
		# Then we convert the bytestring in bytes and give a array reference to the function
		my @contents = unpack 'C*', $content_utf8;

		# set the content as content of $file
		# arguments: contents, etags, make_backup, flags, GError
		$file->replace_contents(\@contents,
					undef,
					FALSE,
					'none',
					undef) or print "Error: Saving failed\n";
		my $path = $file->get_path();
		print "saved $path \n";
	}
	# if the contents are empty
	else {
		# create (if the file does not exist) or overwrite the file in readwrite mode.
		# arguments: etags, make_backup, flags, GError
		$file->replace_readwrite(undef,
					FALSE,
					'none',
					undef);
		my $path = $file->get_path();
		print "saved $path \n";
	}
}


# The MAIN FUNCTION should be as small as possible and do almost nothing except creating 
# your Gtk3::Application and running it
# The "real work" should always be done in response to the signals fired by Gtk3::Application.
# see below
package main;

use strict;
use warnings;
use utf8;
 
use Gtk3;
use Glib ('TRUE', 'FALSE');

my $app = Gtk3::Application->new('app.test', 'flags-none');
 
$app->signal_connect('startup'  => \&_init     );
$app->signal_connect('activate' => \&_build_ui );
$app->signal_connect('shutdown' => \&_cleanup  );
 
$app->run(\@ARGV);
 
exit;


# The CALLBACK FUNCTIONS to the SIGNALS fired by the main function.
# Here we do the "real work" (see above)
sub _init {
	my ($app) = @_;
	
	# app action "quit", connected to the callback function
	my $quit_action = Glib::IO::SimpleAction->new('quit',undef);
	$quit_action->signal_connect('activate'=>\&quit_callback);
	$app->add_action($quit_action);
	
	# get the menu from the ui file with a builder
	my $builder = Gtk3::Builder->new();
	$builder->add_from_file('12_3_filechooserdialog.ui') or die "file not found \n";
	my $menu = $builder->get_object('appmenu');
	$app->set_app_menu($menu);
}

sub _build_ui {
	my ($app) = @_;
	my $window = MyWindow->new($app);
	$window->show_all();
}

sub _cleanup {
	my ($app) = @_;
}

# callback function for "quit"
sub quit_callback {
	print "You have quit \n";
	$app->quit();
}
