# NAME

File::Open - wrap open/sysopen/opendir and give them a nice and simple interface

# SYNOPSIS

```perl
use File::Open qw(
    fopen    fopen_nothrow
    fsysopen fsysopen_nothrow
    fopendir fopendir_nothrow
);

my $fh = fopen $file;
my $fh = fopen $file, $mode;
my $fh = fopen $file, $mode, $layers;

my $fh = fopen_nothrow $file or die "$0: $file: $!\n";
my $fh = fopen_nothrow $file, $mode or die "$0: $file: $!\n";
my $fh = fopen_nothrow $file, $mode, $layers or die "$0: $file: $!\n";

my $fh = fsysopen $file, $mode;
my $fh = fsysopen $file, $mode, \%flags;

my $fh = fsysopen_nothrow $file, $mode or die "$0: $file: $!\n";
my $fh = fsysopen_nothrow $file, $mode, \%flags or die "$0: $file: $!\n";

my $dh = fopendir $dir;

my $dh = fopendir_nothrow $dir or die "$0: $dir: $!\n";
```

# EXAMPLES

```perl
sub slurp {

print { fopen 'output.txt', 'w' } "hello, world!\n";
fopen('output.txt', 'a')->print("mtfnpy\n");  # handles are IO::Handle objects

my $lock_file = 'my.lock';
my $lock_fh = fsysopen $lock_file, 'w', { creat => 0644 };
flock $lock_fh, LOCK_EX or die "$0: $lock_file: $!\n";

my @entries = readdir fopendir '.';
```

# DESCRIPTION

This module provides convenience wrappers around
[`open`](https://metacpan.org/pod/perlfunc#open-FILEHANDLE-EXPR) and
[`sysopen`](https://metacpan.org/pod/perlfunc#sysopen-FILEHANDLE-FILENAME-MODE)
for opening simple files and a wrapper around
[`opendir`](https://metacpan.org/pod/perlfunc#opendir-DIRHANDLE-EXPR) for opening directories. Nothing
is exported by default; you have to specify every function you want to import
explicitly.

## Functions

- fopen FILE
- fopen FILE, MODE
- fopen FILE, MODE, LAYERS

    Opens _FILE_ and returns a filehandle. If the open fails, it throws an
    exception of the form `"$program: $filename: $!\n"`.

    _MODE_ is a string specifying how the file should be opened. The following
    values are supported:

    - `'r'`, `'<'`

        Open the file for reading.

    - `'w'`, `'>'`

        Open the file for writing. If the file exists, wipe out its contents and make
        it empty; if it doesn't exist, create it.

    - `'a'`, `'>>'`

        Open the file for appending. If the file doesn't exist, create it. All writes
        will go to the end of the file.

    - `'r+'`, `'+<'`

        Open the file for reading (like `'r'`), but also allow writes.

    - `'w+'`, `'+>'`

        Open the file for writing (like `'w'`), but also allow reads.

    - `'a+'`, `'+>>'`

        Open the file for appending (like `'a'`), but also allow reads.

    In addition you can append a `'b'` to each of the mode strings listed above.
    This will cause [`binmode`](https://metacpan.org/pod/perlfunc#binmode-FILEHANDLE-LAYER) to be called
    on the filehandle.

    If you don't specify a _MODE_, it defaults to `'r'`.

    If you pass _LAYERS_, `fopen` will combine it with the open mode in the
    underlying [`open`](https://metacpan.org/pod/perlfunc#open-FILEHANDLE-EXPR) call. This gives you
    greater control than the simple `'b'` in MODE (which is equivalent to passing
    `:raw` as _LAYERS_). For example, to read from a UTF-8 file:

    ```perl
    my $fh = fopen $file, 'r', ':encoding(UTF-8)';
    # does
    #   open my $fh, '<:encoding(UTF-8)', $file
    # under the hood

    while (my $line = readline $fh) {
        ...
    }
    ```

    See [PerlIO](https://metacpan.org/pod/PerlIO) and [Encode::Supported](https://metacpan.org/pod/Encode%3A%3ASupported) for a list of available layers and
    encoding names, respectively.

    If you don't pass _LAYERS_, `fopen` will use the default layers set via
    `use open ...`, if any (see [open](https://metacpan.org/pod/open)). Default layers aren't supported on old
    perls (i.e. anything before 5.10.0); on those you'll have to pass an explicit
    _LAYERS_ argument if you want to use encodings.

- fopen\_nothrow FILE
- fopen\_nothrow FILE, MODE
- fopen\_nothrow FILE, MODE, LAYERS

    Works exactly like [fopen](#fopen-file), but if the underlying `open` fails,
    it simply returns `undef`.

- fsysopen FILE, MODE
- fsysopen FILE, MODE, FLAGS

    Uses the more low-level interface of
    [`sysopen`](https://metacpan.org/pod/perlfunc#sysopen-FILEHANDLE-FILENAME-MODE) to open _FILE_.
    If it succeeds, it returns a filehandle; if it fails, it throws an exception of
    the form `"$program: $filename: $!\n"`.

    _MODE_ must be `'r'`, `'w'`, or `'rw'` to open the file for reading,
    writing, or both reading and writing, respectively (this corresponds to the
    open flags `O_RDONLY`, `O_WRONLY`, and `O_RDWR`).

    You can pass additional flags in _FLAGS_, which must be a hash reference. The
    hash keys are strings (specifying the flag) and the values are booleans
    (indicating whether the flag should be off (default) or on) – with one
    exception. The exception is the `'creat'` flag; if set, its value must be a
    number that specifies the permissions of the newly created file. See
    ["umask EXPR" in perlfunc](https://metacpan.org/pod/perlfunc#umask-EXPR) for details.

    The following flags are recognized:

    - `append`

        sets `O_APPEND`

    - `async`

        sets `O_ASYNC`

    - `creat`

        sets `O_CREAT` and specifies permissions of newly created files

    - `direct`

        sets `O_DIRECT`

    - `directory`

        sets `O_DIRECTORY`

    - `excl`

        sets `O_EXCL`

    - `noatime`

        sets `O_NOATIME`

    - `noctty`

        sets `O_NOCTTY`

    - `nofollow`

        sets `O_NOFOLLOW`

    - `nonblock`

        sets `O_NONBLOCK`

    - `sync`

        sets `O_SYNC`

    - `trunc`

        sets `O_TRUNC`

    See [Fcntl](https://metacpan.org/pod/Fcntl) and [open(2)](http://man.he.net/man2/open) for the meaning of these flags. Some of them may
    not exist on your system; in that case you'll get a runtime exception when you
    try to specify a non-existent flag.

- fsysopen\_nothrow FILE, MODE
- fsysopen\_nothrow FILE, MODE, FLAGS

    Works exactly like [`fsysopen`](#fsysopen-file-mode), but if the underlying
    `sysopen` fails, it simply returns `undef`.

- fopendir DIR

    Opens _DIR_ and returns a directory handle. If the underlying `opendir`
    fails, it throws an exception of the form `"$program: $dirname: $!\n"`.

- fopendir\_nothrow DIR

    Works exactly like ["fopendir DIR" in fopendir](https://metacpan.org/pod/fopendir#fopendir-DIR), but if the underlying `opendir`
    fails, it simply returns `undef`.

## Methods

The returned filehandles behave like [IO::Handle](https://metacpan.org/pod/IO%3A%3AHandle) objects (actually
[IO::File](https://metacpan.org/pod/IO%3A%3AFile) objects, which is a subclass of [IO::Handle](https://metacpan.org/pod/IO%3A%3AHandle)). However, on perl
versions before 5.14.0 you have to `use IO::Handle;` manually before you can
call any methods on them. (Current perl versions will do this for you
automatically, but it doesn't hurt to load [IO::Handle](https://metacpan.org/pod/IO%3A%3AHandle) anyway.)

Here is a toy example that copies all lines from one file to another, using
method calls instead of functions:

```perl
use File::Open qw(fopen);
use IO::Handle;  # not needed on 5.14+

my $fh_in  = fopen $file_in,  'r';
my $fh_out = fopen $file_out, 'w';

while (defined(my $line = $fh_in->getline)) {
    $fh_out->print($line) or die "$0: $file_out: $!\n";
}

$fh_out->close or die "$0: $file_out: $!\n";
$fh_in->close;
```

# SEE ALSO

["open FILEHANDLE,EXPR" in perlfunc](https://metacpan.org/pod/perlfunc#open-FILEHANDLE-EXPR),
["binmode FILEHANDLE, LAYER" in perlfunc](https://metacpan.org/pod/perlfunc#binmode-FILEHANDLE-LAYER),
["sysopen FILEHANDLE,FILENAME,MODE" in perlfunc](https://metacpan.org/pod/perlfunc#sysopen-FILEHANDLE-FILENAME-MODE),
["opendir DIRHANDLE,EXPR" in perlfunc](https://metacpan.org/pod/perlfunc#opendir-DIRHANDLE-EXPR),
[perlopentut](https://metacpan.org/pod/perlopentut),
[IO::Handle](https://metacpan.org/pod/IO%3A%3AHandle),
[Fcntl](https://metacpan.org/pod/Fcntl),
[open(2)](http://man.he.net/man2/open)

# AUTHOR

Lukas Mai, `<l.mai at web.de>`

# COPYRIGHT & LICENSE

Copyright 2011, 2013, 2016, 2023 Lukas Mai.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See [https://dev.perl.org/licenses/](https://dev.perl.org/licenses/) for more information.
