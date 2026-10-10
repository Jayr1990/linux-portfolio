Sed Lab
What I did
Completed the sed lab. The goal was to practice stream editing: substitution, deletion, pattern matching, ranges, and writing a sed script.

File used
Same format as the grep lab:

Name:Phone:Address, City, State Zip:Birthday:Salary

But with blank lines between each record.

The 10 questions and answers
1. Change the name Jo to Josephine

sed 's/\bJo\b/Josephine/' SedLab.txt

The s means substitute. I added \b word boundaries so it only matches "Jo" as a standalone word. Without those, sed would also change the Jo inside Joliet and San Jose.

2. Delete the last 5 lines

tac SedLab.txt | sed '1,5d' | tac

tac reverses the file so the last line comes out first. Then sed deletes the first five lines of that reversed stream. Then tac reverses it back. This works no matter how long the file is.

3. Print lines 3 through 15

sed -n '3,15 p' SedLab.txt

The -n flag turns off default printing. The p command prints, and the range 3,15 restricts it to those lines.

4. Delete lines for people who live in California

sed '/CA/ d' SedLab.txt

The /CA/ pattern matches lines containing CA. The d command deletes them. Case sensitive by default, so "ca" inside a name like Caldwell does not match.

5. Print birthdays in the first week of the month

sed -n '//[1-7]//p' SedLab.txt

Birthdays are MM/DD/YY so the day sits between two slashes. The pattern matches slash, digit 1-7, slash. The backslashes escape the interior slashes so sed does not treat them as pattern delimiters.

6. Append three asterisks to lines starting with Sir

sed '/^Sir/ s/$/***/' SedLab.txt

The /^Sir/ address matches lines starting with Sir. The substitution replaces the end of the line ($) with ***.

7. Replace the Westley Pirate line with "As you wish."

sed '/Westley Pirate/ c
As you wish.' SedLab.txt

The c command replaces the whole line. The backslash after c means the new text continues on the next line.

8. Change Minerva's birthday to 10/04/1935 using regex

sed '/Minerva/ s#[0-9][0-9]*/[0-9][0-9]*/[0-9][0-9]*#10/04/1935#' SedLab.txt

I used # as the delimiter because the pattern contains slashes. [0-9][0-9]* matches one or more digits, so the pattern works on any MM/DD/YY date without needing to know the original birthday.

9. Delete all blank lines

sed '/^$/ d' SedLab.txt

^$ matches an empty line (start of line immediately followed by end of line). The d command deletes them.

10. Sed script

Script file transform.sed:

1 i
Great Literary Characters
s/:[0-9][0-9][0-9]-/:1+(\1)/
$ a
Happily Ever after. The End

Run with:

sed -f transform.sed SedLab.txt

Three parts: insert the title before line 1, add 1+( to every phone number's area code using backreferences, and append a footer at the last line.

What I learned
1. The difference between s (substitute) and c (change line)

2. How to use address patterns to restrict commands

3. Why some patterns need alternate delimiters

4. How backreferences work with ... and \1

5. How to write a sed script file

Sources
man sed on the CentOS VM

The Grymoire on Sed: https://www.grymoire.com/Unix/Sed.html

Instructor's Sed page: https://www.aholdengouveia.name/LinuxAdmin/Sed.html
