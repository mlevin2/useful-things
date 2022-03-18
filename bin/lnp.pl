#!/usr/bin/perl

# Sample Number Portability Lookup Query using Perl LWP

# This code may be freely adapted and used in any project or software in
# order to leverage a carrier lookup through numberportabilitylookup.com

# NPL Account Credentials - customise to your own account details
# Free trial account available at www.numberportabilitylookup.com

use LWP::UserAgent;

my $username  = "mlevin";
my $password  = "shepard";

my $number = $ARGV[0];

$number =~ s/[^0-9]//g;
if (length $number == 10) {
	$number = "1" . $number;
}

if ($number ne "") {
	print lookupCarrier($number) . "\n";
} else {
	print "Usage: $0 <phone number>\n";
}
exit;

sub lookupCarrier
{
	my $msisdn    = shift;

	my $browser   = LWP::UserAgent->new;
	my $url       = "https://secure.comcetera.com/npl";
	my $queryData = "user=$username&pass=$password&msisdn=$msisdn&apiver=2.5&economy=1";
	my $response  = $browser->post($url, content=>$queryData);
	my $content   = $response->content;

	my @dataLine  = split("\n", $content);
	if ($dataLine[0] eq "QUERYOK")
	{
		($msisdn, $hlrdata) = split(" ", $dataLine[1]);
		($plmn, $msc, $imsi) = split(",", $dlrdata);
	}

	return $dataLine[1];
}
