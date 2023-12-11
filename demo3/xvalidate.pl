#!/usr/bin/perl -s

use strict;
$|=1;

$::fold=10 if(!defined($::fold));

my $class1 = shift;
my $class2 = shift;

# Read the data file
my $header = <>;
my @data = ();
while(<>)
{
    chomp;
    push @data, $_;
}

my @uniqueClass1 = GetUnique($class1, @data);
my @uniqueClass2 = GetUnique($class2, @data);

for(my $fold=0; $fold<$::fold; $fold++)
{
    my $testFile  = "test_${fold}.csv";
    my $trainFile = "train_${fold}.csv";
    open(my $fhTest,  '>', $testFile)  || die "Can't write $testFile";
    open(my $fhTrain, '>', $trainFile) || die "Can't write $trainFile";

    print $fhTest  $header;
    print $fhTrain $header;

    print "Writing fold $fold: test/PD ... ";
    WriteFold($fhTest, 1, $fold, $::fold, $class1,  \@data, \@uniqueClass1);
    print "test/SNP ... ";
    WriteFold($fhTest, 1, $fold, $::fold, $class2, \@data, \@uniqueClass2);

    print "train/PD ... ";
    WriteFold($fhTrain, 0, $fold, $::fold, $class1,  \@data, \@uniqueClass1);
    print "train/SNP ... ";
    WriteFold($fhTrain, 0, $fold, $::fold, $class2, \@data, \@uniqueClass2);
    print "done\n";

    close($fhTest);
    close($fhTrain);
}


sub WriteFold
{
    my($fh, $match, $fold, $nFolds, $class, $aData, $aIDs) = @_;

    my $nItems       = scalar(@$aIDs);
    my $itemsPerFold = int(0.5 + ($nItems / $nFolds));

    my $start = $fold * $itemsPerFold;
    my $stop  = ($fold+1) * $itemsPerFold;
    if(($stop + $itemsPerFold) > $nItems)
    {
        $nItems = $nItems;
    }

    foreach my $datum (@$aData)
    {
        my($id, $thisClass) = GetID($datum);
        if($class eq $thisClass)
        {
            my $inFold = CheckDatum($datum, $class, $start, $stop, $aIDs);
            if($match && $inFold)
            {
                print $fh "$datum\n";
            }
            if(!$match && !$inFold)
            {
                print $fh "$datum\n";
            }
        }
    }
}

sub CheckDatum
{
    my($datum, $class, $start, $stop, $aIDs) = @_;
    for(my $i=$start; $i<$stop; $i++)
    {
        my($id, $thisClass) = GetID($datum);
        if($id eq $$aIDs[$i])
        {
            return(1);
        }
    }
    return(0);
}

# Returns the identifier (here the PDB code) and the class
sub GetID
{
    my ($datum) = @_;

    my @fields = split(/\,/, $datum);
    my $class = $fields[scalar(@fields)-1];
    my $code = $fields[0];
    my @subcodes = split(/\:/, $code);
#    my $id = $subcodes[1] . $subcodes[3] . $subcodes[2] . $subcodes[4];
    my $id = $subcodes[0];
    return($id, $class);
}

# Goes through the dataset calling the GetID() function on each line.
# This returns the identifier and the class. If it's the class of interest
# then we store the ID as the key of a hash and then return the sorted
# list of keys (which will be unique).
sub GetUnique
{
    my($class, @data) = @_;
    my %unique = ();

    foreach my $datum (@data)
    {
        my ($id, $thisClass) = GetID($datum);

        if($thisClass eq $class)
        {
            $unique{$id} = 1;
        }
    }
    return(sort keys %unique);
}
