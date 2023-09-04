# VYT Lang

Custom programming language.

> This project is under development

## Installing

Go to [releases section](https://github.com/vytdev/vytlang/releases) and download
the binary or the installer there. Then do the following steps:

If you downloaded the installer...

1. Open your terminal or command prompt
2. `cd` to the folder where are the installer
3. Run `./installer` or `sh ./installer`
4. Answer all the prompts
5. Install will begin after confirmation

If you downloaded the binary...

1. Open your terminal or command prompt
2. `cd` to the folder where are the binary
3. Copy the binary where you want to install it, for example `/usr/local/bin`

    ```bash
    cp ./vyt /usr/local/bin
    ```

4. Add execute permission

    ```bash
    chmod u+x /usr/local/bin/vyt
    ```

5. (optional) Test if it is working by running:

    ```bash
    /usr/local/bin/vyt -v
    # or if the folder is in your PATH
    vyt -v
    ```

## Verifying

To verify the integrity of the downloaded files, also download `checksums.txt`
on the same folder and run the following command:

```bash
shasum -a 256 -c checksums.txt
```
