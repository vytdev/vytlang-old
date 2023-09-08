#ifndef IOTTY_H
#define IOTTY_H

// (in/out teletypewritter)
// contains information whether stdin, stdout, or stderr is a tty

namespace vyt {

#ifdef _WIN32
#include <io.h>
#define STDIN_TTY _isatty(_fileno(stdin))
#define STDOUT_TTY _isatty(_fileno(stdout))
#define STDERR_TTY _isatty(_fileno(stderr))
#else
#include <unistd.h>
#define STDIN_TTY isatty(fileno(stdin))
#define STDOUT_TTY isatty(fileno(stdout))
#define STDERR_TTY isatty(fileno(stderr))
#endif

} // vyt

#endif // IOTTY_H
