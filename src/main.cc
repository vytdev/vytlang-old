//
// Copyright (c) 2023 VYT. All rights reserved.
//
// This project is distributed and available under the terms of MIT License
// See LICENSE for more information
//

#include "../include/main.h"

#include <iostream>
#include <string>
#include <list>
using namespace std;

#include "../include/iotty.h"
#include "../include/lexer.h"
#include "../include/util.h"
using namespace vyt;

void show_help() {
    cout << "VYT Lang (v" << VYT_VERSION << ")"                             << endl;
    cout << ""                                                              << endl;
    cout << "  A custom programming language"                               << endl;
    cout << "  See the repository here: https://github.com/vytdev/vytlang"  << endl;
    cout << ""                                                              << endl;
    cout << "Usage:"                                                        << endl;
    cout << "    vyt [-?hv] [options] [--] [- | filename] [args ...]"       << endl;
    cout << ""                                                              << endl;
    cout << "Options:"                                                      << endl;
    cout << "    -                      Read script from stdin"             << endl;
    cout << "    --                     End of vyt options"                 << endl;
    cout << "    -h, -?, --help         Show this help and exit"            << endl;
    cout << "    -v, --version          Show version name and exit"         << endl;
    cout << ""                                                              << endl;
    cout << "Arguments:"                                                    << endl;
    cout << "    filename               Path to the script to execute,"     << endl;
    cout << "                           ignored when - is given"            << endl;
    cout << "    args                   Arguments to pass to the program"   << endl;
    cout << ""                                                              << endl;
    cout << "NOTE: This project is under development"                       << endl;

    exit(0);
}

int main(int argc, char *argv[]) {
    bool readFromStdin = !STDIN_TTY;
    bool stopParsing = false;
    list<string> args;

    bool nameFound = false;
    string fileName;

    // flags
    bool arg_help = false;
    bool arg_version = false;

    // parse arguments
    size_t i = 1;
    for ( ; i < argc ; ++i ) {
        string arg = argv[i];
        size_t argLength = arg.length();

        // stop parsing arguments
        if (stopParsing) {
            if (!nameFound) {
                fileName = arg;
                nameFound = true;
            }
            // new argument
            args.push_back(arg);
            continue;
        }

        // not a flag
        if (arg[0] != 45) {
            stopParsing = true;
            i--;
            continue;
        }

        // read from stdin
        if (argLength == 1) {
            nameFound = readFromStdin = true;
            fileName = arg;
        }

        // long flag
        if (arg[1] == arg[0]) {
            // stop flags
            if (argLength == 2) {
                stopParsing = true;
                continue;
            }

            const string flagName = arg.substr(2);
            if (flagName == "help") arg_help = true;
            else if (flagName == "version") arg_version = true;
            else terminateProcess("unrecognized flag: " + arg, 2);

            continue;
        }

        // short flag
        for (const char f : arg.substr(1)) switch (f) {
            case 63: case 104: arg_help    = true; break; // ?, h
            case 118:          arg_version = true; break; // v
            default: terminateProcess((string)"unrecognized flag: -- " + f, 2);
        }
    }

    // perform tasks

    // print help
    if (arg_help) show_help();

    // show version
    if (arg_version) cout << VYT_VERSION << endl;

    // file name included
    if (nameFound) {
        // read from stdin
        if (readFromStdin) {
            // stdin not redirected to a file
            if (STDIN_TTY) {
                terminateProcess("couldn't read stdin");
            }
        }

        // lets debug the lexer for a while
        Tokenizer lexer(readASCIIFile(fileName));
        lexer.tokenize();
    }

    return 0;
}
