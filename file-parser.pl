#!/usr/bin/perl

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

sub print_lines {
  my @args = @_;
  $l_count = 0;
  my $arg1 = $args[0];
  
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
#END OF SUB-ROUTINES

if($parameters == 1) {
  # parseFile [FILE]
  $file_name = $ARGV[0];
  parse_and_chomp($file_name);
  print_lines();
}

if($parameters == 2) {
  # parseFile [...OPTIONS] [FILE]
  my $file_opt = $ARGV[0];
  my @opt_list = split(/(?=[[:graph:]])(?<=[[:graph:]])/,$file_opt);
  $file_name = $ARGV[1];
 
  #ERROR HANDLING
  if(not grep(/^-[^\s-]+$/,$file_opt)) {
    print "error: invalid option syntax!";
    exit 1;
  }
  if(grep(/([[:alpha:]])\1/,$file_opt)) {
    print "error: recurring options!";
    exit 1;
  }
  if(grep(/lu/,$file_opt) or grep(/ul/,$file_opt)) {
    print "error: logically conflicting options!";
    exit 1;
  }
  if(grep(/[[:digit:]]/,$file_opt)) {
    print "error: invalid option syntax!";
    exit 1;
  }
  #END OF ERROR HANDLING

  parse_and_chomp($file_name);

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

  foreach $opt_char (@opt_list) {
    print "$opt_char\n";
  }

}
