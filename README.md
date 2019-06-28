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
This package exports two functions: `insertProgress` and `removeProgress`.
`insertProgress` takes as argument a filename `f` of a file with `@test`s,
usually (and default) `f="runtests.jl"` and adds the necessary lines to add a progress-indicator to the test.

The rules are:
- In the file `f`, a `using ProgressMeter` and a `ProgressUnknown`is added
- Before each `@test...` except `@testset`, `next!(p::Progress)` is inserted
- Files that are `include`d are included too

To undo `insertProgress`, i.e. remove all inserted lines, apply `removeProgress`

# Example
Start a julia repl and execute
```julia
julia> insertProgress("[root]/TestProgressMeter/example/runtests.jl")
```
where `[root]` is the location where `TestProgressMeter` is installed
If you then run
```julia
julia> include("[root]/TestProgressMeter/example/runtests.jl")
```
you should see a progress-indicator while your tests execute.
Apply
```julia
julia> removeProgress("[root]/TestProgressMeter/example/runtests.jl")
```
to undo `insertProgress`.

# Contribute

This is a tiny package I wrote for something I deemed useful. It's also my first code that manipulates files like that and if someone knows a better/safer/less intrusive way to achieve the same, let me know
