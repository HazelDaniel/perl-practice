#!/usr/bin/perl
$parameters = $#ARGV + 1;

if($parameters == 1) {
  $file_name = $ARGV[0];
  open(MYINPUTFILE, $file_name);
  while(<MYINPUTFILE>)
  {
  # Good practice to store $_ value because
  # subsequent operations may change it.
  my($line) = $_;

  # Good practice to always strip the trailing
  # newline from the line.
  chomp($line);
  
  # Print the line to the screen and add a newline
  print "$line\n";
  }

}
