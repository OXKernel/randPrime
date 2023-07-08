# randPrime
Perl code to generate a random prime number

# HowTO
## run ./prun.sh

This will create multiple instances of randPrime\_thread.pl
which will search for a random prime starting with a random
number. Note that each of the perl scripts run has its
own threads. sleep calls are needed so as not to overheat
the processor. The processes should end when one of the
threads writes a file:

.randPrime.search.done

# Discovered primes
The discovered number is probably prime. 

The largest prime generated so far was 9800+ digits large.

The code writes it's results into a data directory,
which is included here for reference of example discovered
primes of random sizes.
