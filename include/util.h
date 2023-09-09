#ifndef UTIL_H
#define UTIL_H

#include <string>
using namespace std;

namespace vyt {

/* show debug message when DEVMODE (in main.h) */
void debug(const string& message);

/* stop process with message */
void terminateProcess(const string& message, int exitCode = 0);

/* read an ascii file */
string readASCIIFile(const string& fileName);

/* check if file exists  */
bool fileExists(const string& fileName);

} // namespace vyt

#endif // UTIL_H
