#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

FILE *f1 = NULL, *f2 = NULL, *f3 = NULL;

const char *F1_PATH = "/sys/class/power_supply/BAT0/charge_start_threshold";
const char *F2_PATH = "/sys/class/power_supply/BAT0/charge_stop_threshold";
const char *F3_PATH = "/var/tmp/current_battery_limit";

bool validate(const char *str) {
    for (const char *c = str; *c != 0; c++) {
        if (!isdigit(*c) && *c != '\n') {
            return false;
        }
    }
    return true;
}

int f() {
    f1 = fopen(F1_PATH, "w");
    if (!f1) {
        perror("Could not open start threshold file");
        return 1;
    }

    f2 = fopen(F2_PATH, "w");
    if (!f2) {
        perror("Could not open stop threshold file");
        return 1;
    }

    char *line = NULL;
    size_t n = 0;
    if (getline(&line, &n, stdin) == -1) {
        fprintf(stderr, "Could not read line\n");
        return 1;
    }

    if (!validate(line)) {
        fprintf(stderr, "Invalid input string\n");
        return 1;
    }

    int32_t wanted_battery_cap = -1;
    if (!sscanf(line, "%u", &wanted_battery_cap)) {
        fprintf(stderr, "Failed reading max battery capacity\n");
        return 1;
    }

    if (!(wanted_battery_cap > 10 && wanted_battery_cap <= 100)) {
        fprintf(stderr, "Invalid battery capacity\n");
        return 1;
    }

    f3 = fopen(F3_PATH, "w");
    if (!f3) {
        perror("Could not open current battery limit file");
        return 1;
    }

    if (fchown(fileno(f3), 0, 0) == -1) {
        perror("Could not change owner of battery limit file");
        return 1;
    }

    fprintf(f1, "%u", 0);
    fprintf(f2, "%u", wanted_battery_cap);
    fprintf(f3, "%u", wanted_battery_cap);
    return 0;
}

int main() {
    int retval = f();
    if(f1) fclose(f1);
    if(f2) fclose(f2);
    if(f3) fclose(f3);
    return retval;
}
