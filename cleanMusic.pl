#!/usr/bin/perl
use warnings;
use strict;

my $delete = 0;
my $get_args = $#ARGV + 1;  
my $path = "/Volumes/Videos2023/Music/Media.localized";

print ("Usage:\n  cleanMusic.pl -d : Delete mode. Finds and deletes redundant music files in \$path\n");
print ("\n  cleanMusic.pl -s : Safe mode. Finds and lists redundant music files in \$path\n");
print ("\n  Note: \$path is hard-coded in the script and should point to a Music/Media.localized folder.\n");
print ("\n");

if ($get_args > 0)
{
  if ($ARGV[0] eq "-d"){
    $delete = 1;
  }
  elsif ($ARGV[0] eq "-s"){
    $delete = 0;
  }
  else
  {
    print("Argument \"".$ARGV[0]. "\" not recognized...\n\n");
    exit;
  }
}
else
{
  exit;
}

my $dirCmd = ("ls -R1 ".$path);
my @dir = `$dirCmd`;
# print ("dir:\n\n".$dir."\n");
my $currentDir = "";
my @duplicates = ();
my $dupNum = 0;
for (my $i=0;$i<$#dir;$i++)
{
  my $item = $dir[$i];
  $item =~ s/\n|\r$//; #remove whitespace
  my $strLen = length($item);
  #if ($strLen < 1)
  #{ 
    #print "\n";
  #}
  #else
  {
    if (substr($item,-1) eq ":") 
    {
       $currentDir = $item;
       $currentDir =~ s/:$//;
       #print("dir: ". $currentDir . "\n");
    }
    else
    {
      my $ext = substr $item ,-4,4;
      if ($ext =~ /^\./ && $ext !~ /\s/)
      {
        my $extOnly = substr $ext, 1,3;#strip off leading .
        if ($extOnly =~ /\./) #if it finds more periods it's not a valid extension
        {
          $ext = "";
        }
      }
      if ($ext eq ".m4a" || lc($ext) eq ".mp3" || $ext eq ".wav" || $ext eq ".m4p" || $ext eq ".m4v")
      {
        #print("file: ".$item);
        my $sub = substr $item,0,length($item)-4;
        if ($sub =~ / 1$/)
        {
          print("file: ".$item." (possible duplicate)\n");
          $duplicates[$dupNum++]=($currentDir."/".$item);
        }
        #print("\n");
      }
      else 
      {
        #print("skip: ".$item."\n");
        if ($ext =~ /^\./ && $ext !~ /\s/ && $ext ne ".pdf" && $ext ne ".tmp") # no whitespace
        {
          print ("******unknown ext: " .$ext ."\n");
          exit;
        }
      }
    }
  }
}

print ("\n\nduplicates found: ".$dupNum."\n\n");
my $numConfirmed = 0;
for (my $j = 0; $j < $dupNum; $j++)
{
  print ($duplicates[$j]."  ");
  my $origPath = substr $duplicates[$j],0,length($duplicates[$j]) - 6;
  my $origExt = substr $duplicates[$j],-4,4;
  my $origPath1 = ($origPath . $origExt);
  print ("\norig: ". $origPath1);
  if (-e $origPath1)
  {
    print " exists!\n";
    #delete the duplicate file
    my $newPath = $duplicates[$j];
    $newPath =~ s/\ /\\ /g;
    $newPath =~ s/\(/\\\(/g; #fix open parens in rm command
    $newPath =~ s/\)/\\\)/g; #fix close parens
    $newPath =~ s/\'/\\\'/g; #fix apostrophe in rm command
    $newPath =~ s/\&/\\\&/g; #fix ampersand in rm command
    $newPath =~ s/\;/\\\;/g; #fix semicolon in rm command
    $newPath =~ s/\,/\\\,/g; #fix comma in rm command
    $newPath =~ s/\`/\\\`/g; #fix backtick in rm command
    my $deleteCmd = ("rm " . $newPath );
    print ("cmd: " . $deleteCmd . "\n");
    $numConfirmed++;
    if ($delete == 1)
    {
      `$deleteCmd`;  #uncomment this line to delete all duplicates if you trust this program
    }
  }
  else
  {
    print " skipping...\n";    
  }

}

print ("\n\nduplicates suspected: ".$dupNum."\n");
print ("duplicates confirmed: ".$numConfirmed."\n");

print("\n\nbye" . "\n");

exit;

