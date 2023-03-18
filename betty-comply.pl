#!/usr/bin/perl
use Term::ANSIColor qw(:constants);

=for
====== WELCOME TO MY LITTLE PROJECT! ======
  DESCRIPTION : BASIC FILE PROCESSING PROGRAM WRITTEN IN PERL.
=cut

#GLOBALS
$parameters = $#ARGV + 1;
@file_lines = ();
%f_property = ('nu',"numbered-and-upper",'nl',"numbered-and-lower",'n',"numbered",'u',"upper",'l',"lower");
%f_long_property = ('--stop-at='=>"set-stop",'--offset='=>"set-offset");
#END OF GLOBALS

#SUB-ROUTINES
sub parse_and_format {
  my $args = scalar(@_);
  if($args != 1){
    print "Wrong argument in subroutine!";
    exit;
  }

  @vecs = @_;
  my $arg1 = $vecs[0];
  my $arg2 = $vecs[1];
  open(MYINPUTFILE, $vecs[0]) or die "can't open: $!";
  while(<MYINPUTFILE>)
  {
    # Good practice to store $_ value because
    # subsequent operations may change it.
    my($line) = $_;

    # Good practice to always strip the trailing newline from the line.
    chomp($line);
    push(@file_lines,$line);
  }

}

sub multi_parse_and_format {
  my $i;
  my @args = @_;
  my $arg_offset = $args[0];
  $i = $arg_offset ? $i + $arg_offset : 0;
  for(; $i < $parameters; $i++) {
    parse_and_format($ARGV[$i]);
  }
}

sub handle_opt_error {
  my @args = @_;  
  my $file_opt = $args[0];
#ERROR HANDLING
  if(not grep(/^-[^\s-]+$/,$file_opt)) {
     print "error: invalid option syntax! 1";
     exit 1;
  }
  if(grep(/([[:alpha:]])\1/,$file_opt)) {
    print "error: recurring options!";
    exit 1;
  }
  if(grep(/lu/,$file_opt) or grep(/ul/,$file_opt)) { print "error: logically conflicting options!";
    exit 1;
  }
  if(grep(/^-.*[[:digit:]]/,$file_opt)) {
    print "error: invalid option syntax!"; exit 1;
  }
#END OF ERROR HANDLING
}

sub eval_file_opt {
  my @args = @_;
  my @opt_list = @args;

}

sub validate_opt_length {
  my ($file_opt, $opt_len, @opt_list) = @_;
  printf "args: @_\n";
  print " file opt: $file_opt\n opt list: @opt_list\n opt len : $opt_len\n"
  #if(($opt_len == 3 or $opt_len == 2) and (index (join("",@opt_list),'-') eq 0)) {
   #handle_opt_error($file_opt);
   #multi_parse_and_format(1);
   #eval_file_opt(@opt_list);
   #print "two parameter argument including options\n";
   #}
}

#END OF SUB-ROUTINES

if($parameters == 1) {
  # parseFile [FILE]
  $file_name = $ARGV[0];
  if(grep(/^-.*/,$file_name)) {
    print "invalid single argument!\n";
    exit 1;
  }
  multi_parse_and_format();
  print "one parameter argument\n";
}
elsif($parameters == 2) {
  # parseFile [...OPTIONS] [FILE]
 
  my $file_opt = $ARGV[0];
  my @opt_list = split(/(?=[[:graph:]])(?<=[[:graph:]])/,$file_opt);
  $file_name = $ARGV[1];
  my $opt_len = scalar(@opt_list);
  # To make sure that these are not 2 or 3-length file names , that they are indeed options
  validate_opt_length($file_opt, $opt_len, @opt_list);
  if(($opt_len == 3 or $opt_len == 2) and (index (join("",@opt_list),'-') eq 0)) {
    handle_opt_error($file_opt);
    multi_parse_and_format(1);
    eval_file_opt(@opt_list);
    print "two parameter argument including options\n";
  }
  # In cases where they are results of pathname expansions and their names are not preceeded by -
  elsif (not (grep(/^-.*/,$ARGV[0]) or grep (/^-.*/,$ARGV[1]))) {
    multi_parse_and_format();
    print "pathname expanded";
  }
  else {
    print "error: \n.1 unrecognizable synopsis specified 2-parameter mode\n\t check the man page for guide or visit our official documentation at https://github.com:HazelDaniel/perl-practice\n";
  }

}
else {
  # multiple file mode with/without options:
  # ERROR HANDLING
  if(grep (/^((?<=\b)\w[[:graph:]]*\s?)+$/,"@ARGV")) {
    # no options are provided. only pathname expansions or file lists
    multi_parse_and_format();
    print "multi parameter argument (pathnames only)\n";

  }elsif(grep (/^(-[[:alpha:]]{1,2}\s)?((?<=\b)\w[[:graph:]]*\s?)+$/,"@ARGV")) {
    # options are provided alongside file lists or expanded pathnames 
    my $file_opt = $ARGV[0];
    my @opt_list = split(/(?=[[:graph:]])(?<=[[:graph:]])/,$file_opt);
    $file_name = $ARGV[1];
    my $opt_len = scalar(@opt_list);
    multi_parse_and_format(1);
    eval_file_opt(@opt_list);
    print "multi parameter argument (options provided)\n";
  }
  elsif (grep(/^--[[:graph:]]+/,$ARGV[1])) {
    # parseFile [...OPTIONS] [--...LONG-OPTIONS] [FILE]
    
    my $file_opt = $ARGV[0];
    my @opt_list = split(/(?=[[:graph:]])(?<=[[:graph:]])/,$file_opt);
    my $opt_len = scalar(@opt_list);
    validate_opt_length($file_opt, $opt_len, @opt_list);
    # a repeated validation logic about to happen. why not find a way to export that into a re-usable function
    my $file_param = $ARGV[1];
    my @param_list = split(/(?=[[:graph:]])(?<=[[:graph:]])/,$file_param);
    my $param_string = join("",@param_list);
    my @param_text_naive = split(/(?<=--)(?=[[:alpha:]])/,$param_string);
    my @param_text = split(/(?==)/,$param_text_naive[1]);
    my $param = $param_text[0];
    my $param_val_naive = $param_text[1];
    my @param_val = split(/((?<==)(?=[[:alnum:]])|(?<==)(?=\'))/,$param_val_naive);
    my $val = $param_val[2];
    print "param val naive : $param_val_naive\n";
    print "param text: $param\n";
    print "param val: $val\n";
    print "long parameter argument\n";

    if (not $val) {
      print "no parameter value provided\n";
      exit 1;
    }
  }
  else {
    print"error: \n.1 unrecognizable synopsis specified multi-parameter mode\n\t check the man page for guide or visit our official documentation at https://github.com:HazelDaniel/perl-practice\n";
    exit;
  }
}


=for

EDGE CASES:
  when parameter length satisfies the above checks but due to a pathname expansion or a command substitution
  when pathname expands to n parameters
  when pathname expands to n parameters and options are provided
  when pathname expands to n parameters and long options are provided

=cut
