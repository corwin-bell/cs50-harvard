import csv
import sys


def main():

    # TODO: Check for command-line usage
    # first CLA: STR CSV, second CLA: DNA sequence txt file
    # if CLA count != 2, print usage guidance string
    if len(sys.argv) != 3:
        print("usage: dna.py database.csv sequence.txt")

    # else CLA count == 2, continue
    else:
        database = sys.argv[1]
        seq_file = sys.argv[2]

    # TODO: Read database file into a variable
    # refactor as dict with form {name:{str:count, str:count}}
    database_ls = []
    with open(database) as file:
        reader = csv.DictReader(file)
        str_ls = reader.fieldnames[1:]
        for row in reader:
            database_ls.append(row)
        name_dict = {
            person["name"]: {key: val for key, val in person.items() if key != "name"}
            for person in database_ls
        }

    # TODO: Read DNA sequence file into a variable
    with open(seq_file, "r", encoding="utf-8") as file:
        sequence = file.read()

    # TODO: Find longest match of each STR in DNA sequence
    str_match_dict = {str: longest_match(sequence, str) for str in str_ls}

    # TODO: Check database for matching profiles
    # for each name in database_dict if str_match_dict in value, print the name
    for name in name_dict:
        if name_dict[name] == str_match_dict:
            print(name)
            return
    print("No match")
    return


def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):

        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        # If a match, move substring to next potential match in sequence
        # Continue moving substring and checking for matches until out of consecutive matches
        while True:

            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in seqeuence, return longest run found
    return str(longest_run)


main()
