Awk Lab
What I did
Completed the awk lab. The goal was to practice field-based processing: printing specific fields, filtering records by conditions, doing arithmetic on fields, and writing an awk script.

File used
Same data format, but with the AWKLab.txt set:

Name:Phone:Contribution1:Contribution2:Contribution3

Example:

Samuel Vimes:(510) 548-1278:250:100:175

Fields:

$1 = name (may contain middle names or quoted nicknames)

$2 = phone in (NNN) NNN-NNNN format

$3, $4, $5 = three monthly campaign contributions

Key questions and answers
1. Print all first names

awk -F: '{split($1, name, " "); print name[1]}' AWKLab.txt

The -F: sets the field separator to colon. Since names can have middle names, I split the name field on spaces and grab the first word.

5. Last names beginning with T or D

awk -F: '{n = split($1, name, " "); last = name[n]; if (last ~ /^[TD]/) print last}' AWKLab.txt

Because names can have three parts (like Adora Belle Dearheart), I split the name and take the last word rather than assuming $2 is the last name.

6. First names with four or fewer characters

awk -F: '{split($1, name, " "); if (length(name[1]) <= 4) print name[1]}' AWKLab.txt

The length function returns character count.

10. People who contributed more than $110 last month

awk -F: '$5 > 110 {n = split($1, name, " "); print name[1], name[n], $5}' AWKLab.txt

Field 5 is the last month contribution. The condition $5 > 110 restricts to those people.

13. People who contributed less than $700 over three months

awk -F: '{t = $3 + $4 + $5} t < 700 {n = split($1, name, " "); print name[1], name[n], t}' AWKLab.txt

Two pattern-action blocks: the first calculates the total, the second tests it and prints.

19. Change Samwise Gamgee's name to Sean Astin

awk -F: 'BEGIN {OFS=":"} /Samwise Gamgee/ {$1 = "Sean Astin"; print $0}' AWKLab.txt

The BEGIN block sets the output field separator to colon because awk rebuilds $0 using OFS when you assign to a field, and the default OFS is a space.

20. Awk script

Script file awk_script.awk:

#!/usr/bin/awk -f
BEGIN { FS = ":" }
/Took/ {
n = split($1, name, " ")
total = $3 + $4 + $5
print name[1], total
}
$5 >= 10 && $5 <= 200 {
print $1, $5
}
{
avg = ($3 + $4 + $5) / 3
if (avg < 300) print $1, avg
}

Run with:

awk -f awk_script.awk AWKLab.txt

Three sections: print first names and totals for anyone named Took, print full names and amounts for last month contributions between 10 and 200, and print name plus average for anyone averaging under 300.

What I learned
The -F flag for setting a field separator

How to split a field into an array

Pattern-action blocks and how conditions work with $

The length, substr, and split functions

Why awk rebuilds $0 when you assign to a field

How to write an awk script file

Sources
man awk on the CentOS VM

The Grymoire on Awk: https://www.grymoire.com/Unix/Awk.html

Instructor's Awk page: https://www.aholdengouveia.name/LinuxAdmin/Awk.html
