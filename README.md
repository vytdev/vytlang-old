# VYT Lang

![GitHub](https://img.shields.io/github/license/vytdev/vytlang)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/vytdev/vytlang)
![GitHub last commit](https://img.shields.io/github/last-commit/vytdev/vytlang)

Welcome to VYT Lang, a custom programming language project.

> **Please note:** This project is currently under development.

## Introduction

VYT Lang is an innovative and versatile programming language designed for use
within a terminal. It offers a wide array of programming paradigms and
fine-grained control, making it suitable for a variety of applications.

### Key Features

- **Object-Oriented:** Harness the power of object-oriented design to create
  modular and reusable code.

- **Prototype-Based:** Embrace the elegance of prototype-based programming,
  enabling dynamic object creation and extension.

- **Type Safety:** Write code confidently with a robust type system that
  identifies errors at compile-time.

- **Functional:** Explore functional programming paradigms for concise and
  expressive solutions to complex problems.

- **Procedural:** Craft efficient procedural code when straightforward solutions
  are required.

- **Low-Level Control:** For those who demand peak performance, VYT offers precise
  control over memory management and resource optimization.

With VYT, your creative potential knows no bounds; it amplifies your capabilities.
As you embark on your programming journey, you will find a world of opportunities,
a supportive developer community, and a language that adapts to your unique
requirements.

Welcome to a new era of programming. Welcome to this innovative language.

<!--
For more details and to stay up-to-date with revisions, please visit the
[official documentation](https://vytdev.github.io/vytlang).
-->

## Installation

You can download the latest release from the
[Releases Section](https://github.com/vytdev/vytlang/releases). Choose between
the binary or installer based on your preference.

### Using the Installer

1. Open your terminal or command prompt.
2. Navigate to the folder containing the installer.
3. Run the following command to start the installation process:

   ```bash
   ./installer
   ```

4. Follow the prompts to complete the installation.

### Using the Binary

1. Open your terminal or command prompt.
2. Navigate to the folder containing the binary.
3. Copy the binary to your desired installation location (e.g., `/usr/local/bin`)
  using the following command:

   ```bash
   cp ./vyt /usr/local/bin
   ```

4. Add execute permissions to the binary:

   ```bash
   chmod u+x /usr/local/bin/vyt
   ```

5. (Optional) Test if the installation was successful by running:

   ```bash
   vyt -v
   ```

## Verifying

To ensure the integrity of the downloaded files, download `checksums.txt` from
the same folder where you obtained the binary or installer. Then, run the
appropriate command based on your system:

```bash
shasum -a 256 -c checksums.txt
# Or, for Linux systems...
sha256sum -c checksums.txt
```

This will verify that the downloaded files match their expected checksums,
providing an additional layer of security.

## Language Specification

For a detailed understanding of the VYT Language, please refer to the
[VYT Language Specification](/spec.txt). It covers the language's rules, syntax,
and other essential details.

This project is licensed under the MIT License. You can find a copy of the license
available at the provided [link](https://github.com/vytdev/vytlang/blob/main/LICENSE).

For any questions, issues, or contributions, please visit our
[GitHub repository](https://github.com/vytdev/vytlang).

Thank you for choosing VYT Lang!
