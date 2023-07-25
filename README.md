# randPrime
Perl code to generate a random prime number

# Usage
## ./prun.sh

This will create multiple instances of randPrime\_thread.pl
which will search for a random prime starting with a random
number. Note that each of the perl scripts run has its
own threads. sleep calls are needed so as not to overheat
the processor. The processes should end when one of the
threads writes a file:

.randPrime.search.done

And this happens when one of the threads discovers a prime.
At the same time, the discovered prime is written to the ./data
directory.

# Discovered primes
The discovered number is probably prime. 

The largest prime generated so far was 9800+ digits large.

The code writes it's results into a data directory,
which is included here for reference of example discovered
primes of random sizes.

# Note
This code uses an exhaustive search approach using multiple threads
and multiple starting random numbers. This allows for a larger probable 
prime to be discovered. This is different from traditional sieve algorithms
which may be constrained with the size of the initial buffer. The results
are random probable primes of user configurable size. The size of the primes
is based on the number of bits needed to represent the starting random number
from which the search proceeds.

# Author
Roger Doss

opensource [at] rdoss [dot] com
