#ifndef UTIL_H
#define UTIL_H

#include <string>
using namespace std;

namespace vyt {

/* stop process with message */
void terminateProcess(string message, int exitCode = 0);

} // namespace vyt

#endif // UTIL_H
