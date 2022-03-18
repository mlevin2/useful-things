#!/usr/bin/perl

use LWP::UserAgent;

my $ACCOUNT_SID = "ACdd07e34787874d7ab34d0e1f24fd2b71";
my $AUTH_TOKEN = "AU3bfa40861a7145838298e84f8ff2ab36";

my $number = $ARGV[0];

$number =~ s/[^0-9]//g;
if (length $number == 10) {
	$number = "1" . $number;
}

if ($number ne "") {
	print lookupName($number) . "\n";
} else {
	print "Usage: $0 <phone number>\n";
}
exit;

sub lookupName
{
	my $num	      = shift;

	my $browser   = LWP::UserAgent->new;
	my $url       = "https://api.opencnam.com/v2/phone/$num?format=text&account_sid=$ACCOUNT_SID&auth_token=$AUTH_TOKEN";
	my $response  = $browser->get($url);
	my $content   = $response->content;

	my @dataLine  = split("\n", $content);

	return $dataLine[0];
}
