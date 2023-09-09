#ifndef MAIN_H
#define MAIN_H

namespace vyt {

// The version name of this project
#define VYT_VERSION "0.1.0"
// Developer mode toggle (off when creating a release)
#define DEVMODE true

}

/* show help message and exit */
void show_help();

/* main cli function */
int main(int argc, char *argv[]);

#endif // MAIN_H
