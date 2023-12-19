/*
    ISH CLOCK version 1.2
    Copyright 1994-2023, Roger Dubar.
    
    This software is released under the MIT License.
    See the LICENSE file in the project root for more information.
*/
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h> 

void ishTime(char *result, int hour, int minute);
const char* number(int x);
const char* bittime(int m);
const char* daytime(int h);
void formatTime(char *result, int h24, int h12, int m, int s);

int main() {
    char result[100];
    time_t t = time(NULL);
    struct tm tm = *localtime(&t);

    // Get current ish time
    ishTime(result, tm.tm_hour, tm.tm_min);
    printf("%s\n", result);

    return 0;
}

void ishTime(char *result, int hour, int minute) {
    int h12 = hour % 12; // 12-hour format for ish time
    if (h12 == 0) h12 = 12;

    int m = minute;
    if (m > 57) m += 1; // round seconds
    if (m > 60) m = 0; // round up minutes
    if (m > 33) h12 = (h12 % 12) + 1; // round up hours

    formatTime(result, hour, h12, m, 0); // Pass both hour formats
}

const char* number(int x) {
    static const char *numbers[] = {
        "one", "two", "three", "four", "five", "six",
        "seven", "eight", "nine", "ten", "eleven", "twelve"
    };
    if (x >= 1 && x <= 12) {
        return numbers[x - 1];
    } else {
        return "";
    }
}

const char* bittime(int m) {
    if (m <= 7 || m > 53) return "five minutes";
    if (m <= 12 || m > 48) return "ten minutes";
    if (m <= 17 || m > 43) return "quarter";
    if (m <= 23 || m > 38) return "twenty minutes";
    if (m <= 28 || m > 33) return "twenty-five minutes";
    return "";
}

const char* daytime(int h) {
    if (h < 6 || h > 21) return "at night";
    if (h < 12) return "in the morning";
    if (h <= 17) return "in the afternoon";
    return "in the evening";
}

void formatTime(char *result, int h24, int h12, int m, int s) {
    const char *hourStr = number(h12);
    const char *dayTimeStr = daytime(h24);
    const char *minStr;
    char foo[20];

    if (m <= 3 || m > 57) {
        sprintf(result, "It is about %s o'clock %s.", hourStr, dayTimeStr);
        return;
    }

    if (m <= 33 && m > 28) {
        sprintf(result, "It is about half past %s %s.", hourStr, dayTimeStr);
        return;
    }

    if (m < 30) strcpy(foo, "past");
    else strcpy(foo, "to");

    minStr = bittime(m);
    sprintf(result, "It is about %s %s %s %s.", minStr, foo, hourStr, dayTimeStr);
}
