Grep Lab
What I did
Completed the grep lab. The goal was to search a file of literary character records for specific patterns using grep and regular expressions.

File used
The data file had 28 records, one per line, in this format:

Name:Phone:Address, City, State Zip:Birthday:Salary

Example:

Huckleberry Finn:238-923-7366:95 Latham Lane, Easton, PA 83755:11/12/56:20300

The 10 questions and answers
1. Lines containing the string "Lane"

grep "Lane" GrepLab.txt

Simple substring match. Found seven lines including Huckleberry Finn, Betty Boop, Lizzie Bennett, Nancy Drew, Ephram Hardy, Dorothy Gale, and Molly Weasley. Note that it also matched the "Lane" inside "CarltonLane" for Ephram Hardy, since there is no space in that address.

2. Lines where the first name starts with "H"

grep "^H" GrepLab.txt

The ^ is a start of line anchor. Since every line starts with the person's first name, this finds first names starting with H.

3. Lines ending in three zeros

grep "000$" GrepLab.txt

The $ is an end of line anchor. The salary field is the last field, so this finds salaries that end in 000. Got 11 matches.

4. Lines that do not contain 408

grep -v "408" GrepLab.txt

The -v flag inverts the match, showing lines that do NOT contain the pattern.

5. Birthdays in the year 1935

grep "/35:" GrepLab.txt

Dates are stored as MM/DD/YY. Searching for /35: targets the year field specifically, avoiding false matches on phone numbers or other fields that happen to contain 35.

6. Phone numbers with area code starting with 8

grep ":8" GrepLab.txt

Every line has the format Name:Phone. So a colon followed by 8 matches lines where the phone starts with 8.

7. Lines with an uppercase letter, four lowercase, a space, and an uppercase letter

grep -E "[A-Z][a-z]{4} [A-Z]" GrepLab.txt

The -E flag enables extended regex so we can use {4}. The pattern matches 5-letter capitalized first names followed by a capitalized last name.

8. Addresses starting with a 2 or 3 digit number

grep -E ":[0-9]{2,3} " GrepLab.txt

The address field starts right after the second colon. [0-9]{2,3} matches exactly 2 or 3 digits. The trailing space ensures we do not match the first digits of a 4+ digit address.

9. Lines where the state is Mass or Illinois

grep -E " (MA|IL) " GrepLab.txt

The (MA|IL) means MA or IL. Spaces on either side make sure we are matching the state abbreviation field, not MA or IL embedded in a name.

10. Lines containing addresses that are not on a street

grep -Ev "(Street|St.)" GrepLab.txt

The -v inverts the match and -E allows the alternation. This excludes any line containing Street or St. Which leaves addresses that end in Lane, Place, Ave, Drive, Road, Boulevard, Way, Court, Terrace, Square, etc.

What I learned
The ^ and $ anchors for start and end of line

The -v flag to invert matches

The -E flag for extended regular expressions

How to combine word boundaries \b with patterns to avoid matching inside larger words

How escaping works for special characters like parentheses and slashes

Sources
man grep on the CentOS VM

Instructor's Grep page: https://www.aholdengouveia.name/LinuxAdmin/Grep.html
