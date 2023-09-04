#include "../include/util.h"

#include <iostream>
#include <string>
using namespace std;

namespace vyt {

void terminateProcess(string message, int exitCode) {
    // show message
    if (exitCode > 0) cerr << "vyt: " << message << endl;
    else              cout << "vyt: " << message << endl;
    // exit program
    exit(exitCode);
}

} // namespace vyt
