#include <cs50.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    // get long int input from user
    long card_num = get_long("Number: ");
    // get number of digits
    int n_digits = floor(log10(labs(card_num))) + 1;
    // return the first one or two digits
    long power = pow(10, n_digits - 2);
    int first_digits = card_num / power;

    // implement Luhn's algorithm to ensure valid credit card number entered
    //  Multiply every other digit by 2, starting with the number’s second-to-last digit, and then add those products’ digits
    //  together.
    int digit_sum = 0;
    for (int i = 1; i < n_digits; i += 2)
    {
        long pow_divide = card_num / pow(10, i);
        long digit_mod = (pow_divide % 10) * 2;
        // add logic to split out the product's digits if greater than 9
        digit_sum += floor(digit_mod / 10) + (digit_mod % 10);
    }

    // Add the sum to the sum of the digits that weren’t multiplied by 2.
    for (int i = 0; i < n_digits; i += 2)
    {
        long pow_divide = card_num / pow(10, i);
        long digit_mod = (pow_divide % 10);
        digit_sum += digit_mod;
    }
    // If the total’s last digit is 0, the number is valid!
    bool last_digit_zero = (digit_sum % 10 == 0);
    if (last_digit_zero == true)
    // validate as VISA, MASTERCARD, AMEX, INVALID
    {
        // VISA: starts with 4, is 13 or 16 digits long
        if ((n_digits == 13 || n_digits == 16) && (first_digits >= 40 && first_digits <= 49))
        {
            printf("VISA\n");
        }
        // MASTERCARD: starts with 51, 52, 53, 54, or 55, is 16 digits long
        else if ((n_digits == 16) && (first_digits >= 51 && first_digits <= 55))
        {
            printf("MASTERCARD\n");
        }
        // AMEX: starts with 34 or 37, is 15 digits long
        else if ((n_digits == 15) && (first_digits == 34 || first_digits == 37))
        {
            printf("AMEX\n");
        }
        else
        {
            printf("INVALID\n");
        }
    }
    // INVALID: does not follow patterns above
    else
    {
        printf("INVALID\n");
    }
}
