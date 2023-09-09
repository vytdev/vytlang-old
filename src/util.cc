#include "../include/util.h"

#include <iostream>
#include <fstream>
#include <string>
using namespace std;

#include "../include/main.h"

namespace vyt {

void debug(const string& message) {
#if DEVMODE
    // show debug message
    cout << "[debug] " << message << endl;
#endif
}

void terminateProcess(const string& message, int exitCode) {
    // show message
    if (exitCode > 0) cerr << "vyt: " << message << endl;
    else              cout << "vyt: " << message << endl;
    // exit program
    exit(exitCode);
}

string readASCIIFile(const string& fileName) {
    // attempt to open file
    ifstream file(fileName);

    // failed to open
    if (!file.is_open()) terminateProcess((string)"could not open file: " + fileName, 1);

    // get the file size
    file.seekg(0, ios::end);
    streampos fileSize = file.tellg();
    file.seekg(0, ios::beg);

    // read the file
    string fileContent;
    fileContent.resize(fileSize);
    file.read(&fileContent[0], fileSize);

    // close the file stream explicitly
    file.close();

    // return result
    return fileContent;
}

bool fileExists(const string& fileName) {
    ifstream file(fileName);
    return file.good();
}

} // namespace vyt
