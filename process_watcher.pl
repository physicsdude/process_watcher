#!/usr/bin/perl 
use strict;
use warnings;
use 5.10.1;
use autodie;
use Data::Dumper;

my $proc        = shift || 'sublime';
my $cpu_thresh  = shift || 10;
my $mem_thresh  = shift || 10;
my $delay       = shift || 2;
my $proc_o = $proc;
$proc =~ s/^(\w)/[$1]/;

while (1) {
	my @res = `ps auxwww | grep $proc`;

	foreach my $line (@res) {
# USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
		my ($user,$pid,$cpu,$mem,$vsz,$rss,$tty,$stat,$start,$time,$command) = split(/\s+/,$line);
		print "%cpu $cpu, %mem $mem, time $time, start $start, $command, ";
		if ($cpu > $cpu_thresh) {
			print "warning: cpu > $cpu_thresh\a, ";
		}
		if ($mem > $mem_thresh) {
			print "warning: mem > $mem_thresh\a, ";
		}
		print "\n";
	}

	sleep $delay;
}
