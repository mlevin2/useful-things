#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>


/*********************************************************************

   High priority task starter.

   USE AT OWN RISK! THIS PROGRAM COMES WITHOUT *ANY*
   WARRANTY WHATSOEVER!

   This program executes a program (as defined in PROGRAM)
   at a given (usually higher than normal) priority (as
   defined in PRIORITY). Edit PROGRAM and PRIORITY to meet
   your needs. Sensible programs may be: cdrecord, MP3 or
   DVD players, etc. Sensible priorities range from -1 to -5.

   The program itself is *not* started SUID root but as the
   user invoking the task starter. Root privilegues are used
   *only* to set the desired priority (aka. nice level).

   Compile and install as follows:
   # gcc highpriostart.c -o startwhatever
   # cp startwhatever /usr/local/bin
   # chmod +s /usr/local/bin/startwhatever

   2002, Patrick Schemitz <schemitz@users.sourceforge.net>
   This program is released under the GNU Public License (GPL).

*********************************************************************/


/* The program to start with higher priority, with full path. */
#define PROGRAM "/usr/X11R6/bin/xclock"


/* The desired priority, ranging from 19 (very low) to -20 (too
   high). Sensible values from 0 (normal) to maybe -5 (pretty
   high).

   WARNING:

   DO NOT SET THIS TO -20, OR YOU WILL SEVERELY AND PERMANENTLY
   DAMAGE YOUR SYSTEM! Setting the priority too high causes your
   program to interfere with very important system tasks (like
   the swapper or the RAID daemons). Messing with the RAID
   daemons is a *VERY* bad idea!
*/
#define PRIORITY -1


/* You can increase this if your program can sensibly handle a
   very large number of parameters (like tar, ls, etc); normally
   the default (1024) should be plenty.
*/
#define MAX_ARGS 1024


int main (int argc, char **argv)
{
    int i;
    pid_t pid;
    char* args [MAX_ARGS+1] = { PROGRAM, NULL };
    /* first thing to do: drop privilegues */
    seteuid(getuid());
    /* copy over arguments */
    for (i=1; i<argc && i<MAX_ARGS; i++)
	args[i] = argv[i];
    args[i] = NULL;
    /* fork process for the program to be started */
    pid = fork();
    if (pid == 0) {
	/* new process starts actual program */
	execvp(PROGRAM,args);
    } else {
	/* original process regains privilegues */
	seteuid(0);
	/* set desired priority */
	setpriority(PRIO_PROCESS,pid,PRIORITY);
    }
    return 0;
}
