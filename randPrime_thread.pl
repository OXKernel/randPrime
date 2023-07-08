# REFERENCES
# [1] https://perldoc.perl.org/threads::shared
use warnings;
use strict;
use bignum;
use Math::Primality qw/:all/;
use threads;
#use threads ('yield',
#    'stack_size' => 262144,
#    'exit' => 'threads_only',
#    'stringify');
use threads::shared;

my $EXIT_FILE=".randPrime.search.done";
my $MAX_PRIME=16384; #10000; #16384; #4096; #8192; #16384;
my $WAIT_INTERVAL=2;
my $FACTOR1=10;
my $FACTOR2=3;
my $done;
my $exit_count;
my $FAST_EXIT;
share($done);
share($exit_count);
share($FAST_EXIT);
share($EXIT_FILE);
$done="0"; # NOTE This is subtle, because we import bignum, can't assign 0 directly, must be string
$exit_count="0"; # bignum init from string and can have integer operations
$FAST_EXIT="1";  # pkill all processes once a prime is found, note more than one prime can be found

sub gen_rand {
  my $bits = shift;
  my $str = "";
  my $bit = 0;
  for(my $i = 0; $i < $bits; $i++) {
    $bit = int(rand(2));
    $str = $str . "$bit";
  }
  #print "str=$str\n";
  return oct("0b" . $str);
}

sub check_prime {
    my $split = shift;
    if(is_prime($split) >= 1) {
      #printf("prime %100.0f\n", $split);
      my $filename="./data/primes.$MAX_PRIME.$$.dat";
      open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
      print $fh "{$split}\n";
      close $fh;
      print "prime $split\n";
      #print "verifying:\n";
      #my $f = `factor $split`;
      #print "$f\n";
      return 1;
    }
    return 0;
}

sub gen_prime {
   my $DO_TRIALS = 100;
   my $count = 0;
   do {
    print("gen_prime::sleep...\n");
    sleep($FACTOR1);
    my $rand = gen_rand($MAX_PRIME);

    #print $rand,"\n";
    #printf("%10000.0f\n", $rand);

    my $split = $rand;
    #my $split = $rand/2;

    if(($split % 2) == 0) {
      $split--;
    }

    print $split,"\n";
    #printf("%10000.0f\n", $split);
    my $v_2 = 2;
    my $v_4 = 4;
    my $v_8 = 8;
    my $v_16 = 16;

    my $TRIALS=10;

    my $x = 0;
    for (my $i = 0; $i < $TRIALS && int($done) == 0; $i++) {
          # Formula from:
          # https://www.cut-the-knot.org/Generalization/primes.shtml#
          $x = $split;
          my $x2= $x * $x;
          print ("trial: $i\n");
          if(check_prime($x2 - $x + 41) == 1) {
            $done = "1";
            if(int($FAST_EXIT) == 1) {
                `echo "DONE" >> $EXIT_FILE`;
                `pkill -9 -f "perl randPrime_thread.pl"`;
                exit(0);
            }
          }
          if( -e $EXIT_FILE ) {
            exit(0);
          }
          $split++;  
          sleep($FACTOR2);
    }
    $count++;
  } while(int($done) == 0 and $count < $DO_TRIALS);
  if(int($done) == 0) {
    $exit_count++;
  }
}

#
# main
#
#my $pow2 = 2 ** 64;
#print $pow2,"\n";
#print $pow2 + 1,"\n";
#my $rand = int(rand($pow2) - rand(2 ** 32));
my $NR_THREADS=8;
my $thr1 = threads->create('gen_prime', 'argument');
$thr1->detach();
my $thr2 = threads->create('gen_prime', 'argument');
$thr2->detach();
my $thr3 = threads->create('gen_prime', 'argument');
$thr3->detach();
my $thr4 = threads->create('gen_prime', 'argument');
$thr4->detach();
my $thr5 = threads->create('gen_prime', 'argument');
$thr5->detach();
my $thr6 = threads->create('gen_prime', 'argument');
$thr6->detach();
my $thr7 = threads->create('gen_prime', 'argument');
$thr7->detach();
my $thr8 = threads->create('gen_prime', 'argument');
$thr8->detach();

if(! defined $done) {
    print("error\n");
}
print("done=={$done}\n");
while(int($done) == 0 and int($exit_count!=$NR_THREADS)) {
    # Wait
    sleep($WAIT_INTERVAL);
    print("waiting\n");
}

if(int($done) == 1) {
    print("prime found\n");
    `pkill -9 -f "perl randPrime_thread.pl"`;
} else {
    print("no match\n");
}
print "done\n";
