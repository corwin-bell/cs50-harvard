-- Authorities believe that the thief stole the duck and then,
-- shortly afterwards, took a flight out of town with the help of an accomplice.
-- All you know is that the theft took place on July 28, 2023 and that it took place on Humphrey Street.

-- review crime scene report from date of crime
SELECT description
    FROM crime_scene_reports
    WHERE year = 2023 AND month = 7 AND day = 28;

/*
Query Response:
Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery.
Interviews were conducted today with three witnesses who were present at the time
– each of their interview transcripts mentions the bakery.
*/
-- review interviews that mention bakery incident
SELECT transcript
    FROM interviews
    WHERE year = 2023
    AND month = 7
    AND day = 28
    AND transcript LIKE "%bakery%";

/*
Query Response:
Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away.
If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.                                                          |

I don't know the thief's name, but it was someone I recognized.
Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.                                                                                                 |

As the thief was leaving the bakery, they called someone who talked to them for less than a minute.
In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
The thief then asked the person on the other end of the phone to purchase the flight ticket.
*/

-- find suspect thief license plates, atm transactions, bank account info
WITH suspect_plate AS (
    SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2023
    AND month = 7
    AND day = 28
    AND hour = 10
    AND minute BETWEEN 15 AND 25
    AND activity = "exit"),
    suspect_account AS (
    SELECT account_number
    FROM atm_transactions
    WHERE year = 2023
    AND month = 7
    AND day = 28
    AND atm_location = "Leggett Street"
    AND transaction_type = "withdraw"),
    suspect_phone AS (
        SELECT caller
        FROM phone_calls
        WHERE year = 2023
        AND month = 7
        AND day = 28
        AND duration < 60)
    SELECT name,
    phone_number,
    passport_number
    FROM people
    JOIN bank_accounts ON people.id = bank_accounts.person_id
    WHERE license_plate IN suspect_plate
    AND account_number IN suspect_account
    AND phone_number IN suspect_phone;

/*
Suspects based on queries above
| name  |  phone_number  | passport_number |
+-------+----------------+-----------------+
| Bruce | (367) 555-5533 | 5773159633      |
| Diana | (770) 555-1861 | 3592750733
*/

-- review phone table to narrow suspect caller and accomplice
SELECT
    name AS caller_name,
    caller,
    receiver
    FROM phone_calls
    JOIN people ON phone_calls.caller = people.phone_number
    WHERE year = 2023
    AND month = 7
    AND day = 28
    AND duration < 60
    AND caller_name IN ("Bruce", "Diana");

/*
| caller_name |     caller     |    receiver    |
+-------------+----------------+----------------+
| Bruce       | (367) 555-5533 | (375) 555-8161 |
| Diana       | (770) 555-1861 | (725) 555-3243
*/

-- review flights for city escaped  to
-- interview mentioned first flight out of Fiftyville the next day

WITH fiftyville AS (
    SELECT id
    FROM airports
    WHERE city = "Fiftyville"
)
    SELECT
    flights.id AS flight_id,
    city AS destination_city,
    hour,
    minute
    FROM flights
    JOIN airports ON flights.destination_airport_id = airports.id
    WHERE year = 2023
    AND month = 7
    AND day = 29
    AND origin_airport_id IN fiftyville
    ORDER BY hour, minute
    LIMIT 1;

/*
| flight_id | destination_city | hour | minute |
+-----------+------------------+------+--------+
| 36        | New York City    | 8    | 20
*/

-- review flight passengers for match with thief passport_number
SELECT
    name,
    seat
    FROM passengers
    JOIN people ON passengers.passport_number = people.passport_number
    WHERE flight_id = 36
    AND name IN ("Bruce","Diana");

/*
| name  | seat |
+-------+------+
| Bruce | 4A
*/

-- Now I can identify the call receiver for Bruce
SELECT * FROM people WHERE phone_number = "(375) 555-8161";
/*
|   id   | name  |  phone_number  | passport_number | license_plate |
+--------+-------+----------------+-----------------+---------------+
| 864400 | Robin | (375) 555-8161 | NULL            | 4V16VO0    
*/
