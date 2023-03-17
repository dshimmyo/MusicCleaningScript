# MusicCleaningScript
This is a Perl  script that I wrote to aid in identifying and removing duplicate music files in my Apple Music library directory.

You will need to have Perl language installed on your machine, and you should be familiar with Perl scripting already. I've written the script such that if you run it without arguments it won't do anything, but it will show you a general usage prompt that looks like this:

Usage:
  cleanMusic.pl -d : Delete mode. Finds and deletes redundant music files in $path

  cleanMusic.pl -s : Safe mode. Finds and lists redundant music files in $path

  Note: $path is hard-coded in the script and should point to a Music/Media.localized folder.
  
  
Warning: This script is designed to delete files so you should have a backup of whatever folder you decide to run it on.
You will need to edit the script in order to point it to your media directory.
