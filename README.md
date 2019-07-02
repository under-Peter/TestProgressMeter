**Disclaimer**: This package changes files and there's no guarantee that files can't be lost or made unreadable. Read the source and backup your files before using it.

# TestProgressMeter

Do you know the anxiety of running tests and not being sure whether anything's happening at all?
Did time stop or your functions get stuck in a loop?
Add a progress-indicator from ProgressMeter.jl to your tests!


# Install
In the julia-repl, enter the Pkg-mode by pressing `]` on an empty line and then enter
```julia
(v1.0) pkg> add https://github.com/under-Peter/TestProgressMeter
```

# Usage

This package provides two functions, `insertProgress` and `removeProgress`.
```julia
help?> insertProgress
search: insertProgress

  insertProgress(f = 'runtests.jl'; toplevel = true, ntests = nothing, loops = true, pmargs = ())


  recursively inserts next! statements before each test that's included in f and initializes the ProgressMeter at the beginning of the file according to the following rules:

    •    if ntests - the number of tests - is provided, a progressbar will be shown with equal weight to each of the ntests tests

    •    if ntests is not provided but loops=false, all @test will be counted and a progressbar will be shown with equal weight to each test

    •    if neither ntests is provided nor loops=true, a simple counter will be shown of how many tests have been run

  via pmargs, keyword-arguments to the ProgressMeter-object can be provided such as e.g.

  julia> insertProgress("example/runtest.jl", pmargs = (desc = "Text next to errorbar", dt = 0.1), ntests = 10)


  to get a progressbar that updates up to ever 0.1 seconds and has the text in desc next to it.

help?> removeProgress
search: removeProgress

  removeProgress(f = 'runtests.jl')


  assuming f is a runtest folder, removeProgress removes all statements inserted by insertProgress.
```

**Important:** the name of the `Progress`-variable is hardcoded to `pmobj` - if you have any
variable of that name in your tests, you'll run into trouble.

# Example
[![asciicast](https://asciinema.org/a/BzQ4Y5WhBoTKUALgj5C6f8ozw.svg)](https://asciinema.org/a/BzQ4Y5WhBoTKUALgj5C6f8ozw)

# Limitations

- `@test` is only recognized if it appears first on a line (usually after some whitespace)

- `include`d files are always included unless they are commented out, i.e. preceded by a `#` although no checks are made whether that `#` is not e.g. in a string.

- You need to add `ProgressMeter.jl` manually to your (test-) dependencies.

if your files are simple, don't have conditional `include`s and such, it should work fine


# Contribute

This is a tiny package I wrote for something I deemed useful. It's also my first code that manipulates files like that and if someone knows a better/safer/less intrusive way to achieve the same, let me know.
Contributions are welcome to improve it, make it more powerful or improve the `pmobj` situation
mentioned above.
