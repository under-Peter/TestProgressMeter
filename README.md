# TestProgressMeter

Do you know the anxiety of running tests and not being sure whether anything's happening at all?
Did time stop or your functions get stuck in a loop?
Add a progress-meter from ProgressMeter.jl to your tests!


# Install
In the julia-repl, enter the Pkg-mode by pressing `]` on an empty line and then enter
```julia
(v1.0) pkg> add https://github.com/under-Peter/TestProgressMeter
```

# Usage
This package exports two functions: `insertProgress` and `removeProgress`.
`insertProgress` takes as argument a filename `f` of a file with `@test`s,
usually (and default) `f="runtests.jl"` and adds the necessary lines to add a progress-meter to the test.

The rules are:
- In the file `f`, a `using ProgressMeter` is added and a `Progress`
- If `using ProgressMeter` is already present, don't do anything.
- Before each `@test...` except `@testset`, `next!(p::Progress)` is inserted
- The progressbar gives equal weight to each `@test...` in the file
- Files that are `include`d are included too

To have a `runtests.jl` with progressmeter,
 simply change the name of `pmruntests.jl` which is created by `insertProgress`
to `runtests.jl`.

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
you should see a progress-bar while your tests execute.
Apply
```julia
julia> removeProgress("[root]/TestProgressMeter/example/runtests.jl")
```
to undo `insertProgress`.

# Contribute

This is a tiny package I wrote for something I deemed useful. It's also my first code that manipulates files like that and if someone knows a better/safer/less intrusive way to achieve the same, let me know
