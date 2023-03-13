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
#END OF GLOBALS

#SUB-ROUTINES
sub parse_and_chomp {
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

sub multi_parse_and_chomp {
  my $i;
  my @args = @_;
  my $arg_offset = $args[0];
  $i = $arg_offset ? $i + $arg_offset : 0;
  for(; $i < $parameters; $i++) {
    parse_and_chomp($ARGV[$i]);
  }
}
sub print_lines {
  my @args = @_;
  $l_count = 0;
  my $arg1 = $args[0];

  print CYAN,"TOTAL LINES: " . scalar(@file_lines) . "\n",RESET;

  foreach $f_line (@file_lines) {
    if($arg1 eq "numbered") {
      $l_count += 1;
      print "$l_count. $f_line\n";
    }
    elsif($arg1 eq "numbered-and-upper") {
      $l_count += 1;
      print uc("$l_count. $f_line\n");
    }
    elsif($arg1 eq "upper") {
      print uc("$f_line\n");
    }
    elsif($arg1 eq "numbered-and-lower") {
      $l_count += 1;
      print lc("$l_count. $f_line\n");
    }
    elsif($arg1 eq "lower") {
      print lc("$f_line\n");
    }
    else {
      print "$f_line\n";
    }
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
  if(grep(/n/,@opt_list) and grep(/u/,@opt_list)) {
    print_lines($f_property{'nu'});
  }
  elsif(grep(/n/,@opt_list) and grep(/l/,@opt_list)) {
    print_lines($f_property{'nl'});
  }
  elsif(grep(/n/,@opt_list)) {
    print_lines($f_property{'n'});
  }
  elsif(grep(/u/,@opt_list)) {
    print_lines($f_property{'u'});
  }
  elsif(grep(/l/,@opt_list)) {
    print_lines($f_property{'l'});
  }
}
#END OF SUB-ROUTINES

if($parameters == 1) {
  # parseFile [FILE]
  $file_name = $ARGV[0];
  if(grep(/^-.*/,$file_name)) {
    print "invalid single argument!\n";
    exit 1;
  }
  multi_parse_and_chomp();
  print_lines();
}
elsif($parameters == 2) {
  # parseFile [...OPTIONS] [FILE]
 
  my $file_opt = $ARGV[0];
  my @opt_list = split(/(?=[[:graph:]])(?<=[[:graph:]])/,$file_opt);
  $file_name = $ARGV[1];
  my $opt_len = scalar(@opt_list);
  # To make sure that these are not 2 or 3-length file names , that they are indeed options
  if(($opt_len == 3 or $opt_len == 2) and (index (join("",@opt_list),'-') eq 0)) {
    handle_opt_error($file_opt);
    multi_parse_and_chomp(1);
    eval_file_opt(@opt_list);
  }
  # In cases where they are results of pathname expansions and their names are not preceeded by -
  elsif (not (grep(/^-.*/,$ARGV[0]) or grep (/^-.*/,$ARGV[1]))) {
    multi_parse_and_chomp();
    print_lines();
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
    print "parameter expansions only!";
    multi_parse_and_chomp();
    print_lines();
  }elsif(grep (/^(-[[:alpha:]]{1,2}\s)?((?<=\b)\w[[:graph:]]*\s?)+$/,"@ARGV")) {
    # options are provided alongside file lists or expanded pathnames 
    my $file_opt = $ARGV[0];
    my @opt_list = split(/(?=[[:graph:]])(?<=[[:graph:]])/,$file_opt);
    $file_name = $ARGV[1];
    my $opt_len = scalar(@opt_list);
    multi_parse_and_chomp(1);
    eval_file_opt(@opt_list);
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
