#!/usr/bin/perl 
# (1) check for the number of command-line arguments entered  
$number_args = $#ARGV + 1;
if ($number_args <= 2) {  
  print "wrong parameter length!";
  exit 1;  
}  
if ($number_args == 3) {
  # (3) searchNreplace [regex] [replacement] string
  $s_regex = $ARGV[0];
  $r_regex = $ARGV[1];
  $w_regex = $ARGV[2];
  $w_regex =~ s/$s_regex/$r_regex/g;
  print $w_regex;
}
if ($number_args == 4) {
  # (4) searchNreplace [OPTION] [regex] [replacement] string
  print "four parameter arguments";
}
if ($number_args == 5) {
  # (5) searchNreplace [--VARIABLE=WORD] [OPTION] [regex] [replacement] string
  print "five parameter arguments";
}
if ($number_args == 6) {
  # (6) searchNreplace 
}
