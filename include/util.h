#ifndef UTIL_H
#define UTIL_H

#include <string>
using namespace std;

namespace vyt {

/* stop process with message */
void terminateProcess(const string& message, int exitCode = 0);

/* read an ascii file */
string readASCIIFile(const string& fileName);

/* check if file exists  */
bool fileExists(const string& fileName);

} // namespace vyt

#endif // UTIL_H
