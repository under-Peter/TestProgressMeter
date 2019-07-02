module TestProgressMeter

export insertProgress, removeProgress

@doc raw"
    insertProgress(f = 'runtests.jl'; toplevel = true, ntests = nothing, loops = true, pmargs = ())
recursively inserts `next!` statements before each test that's included in `f`
and initializes the `ProgressMeter` at the beginning of the file according to the
following rules:
- if `ntests` - the number of tests - is provided, a progressbar will be shown with equal weight to each of the `ntests` tests
- if `ntests` is not provided but `loops=false`, all `@test` will be counted and a progressbar will be shown with equal weight to each test
- if neither `ntests` is provided nor `loops=true`, a simple counter will be shown of how many tests have been run

via `pmargs`, keyword-arguments to the `ProgressMeter`-object can be provided such as e.g.
```julia
julia> insertProgress(\"example/runtest.jl\", pmargs = (desc = \"Text next to errorbar\", dt = 0.1), ntests = 10)
```
to get a progressbar that updates up to ever `0.1` seconds and has the text in `desc` next to it.
"
function insertProgress(f = "runtests.jl"; toplevel = true,
                                            ntests = nothing,
                                            loops = true,
                                            pmargs = ())
    counter = 0
    isfile(f) || throw(ArgumentError("$f is not a file"))

    lines = readlines(f)

    # if ProgressMeter is already used, assume its from TestProgressMeter and strip
    # all lines that were inserted
    if toplevel && any(x -> occursin("using ProgressMeter", x), lines)
        removeProgress(f)
        insertProgress(f, toplevel = toplevel, ntests = ntests, loops = loops, pmargs = pmargs)
        return nothing
    end

    for i in 1:length(lines)
        m = match(r"^([ \t]*)@test[^s]", lines[i])
        if m != nothing
            lines[i] = string(m.captures[],"next!(pmobj)\n", lines[i])
            counter += 1
        end
        m = match(r"^[^\#]*(include\(\")([^\")]*)(\"\))", lines[i])
        if m != nothing
            nf  = joinpath(dirname(f), m.captures[2])
            counter += insertProgress(nf; toplevel = false)
        end
    end
    if toplevel
        if length(pmargs) == 1
            pmargsstring = chop(string(pmargs), head=1, tail=2)
        else
            pmargsstring = chop(string(pmargs), head=1, tail=1)
        end
        if ntests isa Integer
            counter = ntests
            pushfirst!(lines,
                "pmobj = Progress($counter, $(pmargsstring))")
        elseif loops == false
            pushfirst!(lines,
             "pmobj = Progress($counter, $(pmargsstring))")
        else
            pushfirst!(lines,
             "pmobj = ProgressUnknown($(pmargsstring))")
            lastend = findlast(x -> occursin("end", x), lines)
            insert!(lines, lastend, "finish!(pmobj)")
        end
        pushfirst!(lines, "using ProgressMeter")
        push!(lines, "println()")
    end

    open(f, "w") do io
        write(io, join(lines,'\n'))
    end
    return counter
end

@doc raw"
    removeProgress(f = 'runtests.jl')
assuming `f` is a `runtest` folder, `removeProgress`
removes all statements inserted by `insertProgress`.
"
function removeProgress(f = "runtests.jl")
    isfile(f) || throw(ArgumentError("$f is not a file"))

    lines = readlines(f)
    toremove = falses(length(lines))
    for i in 1:length(lines)
        toremove[i] =   occursin("using ProgressMeter", lines[i]) ||
                        occursin("pmobj = Progress", lines[i]) ||
                        occursin("next!(pmobj)", lines[i]) ||
                        occursin("finish!(pmobj)", lines[i])

        m = match(r"(include\(\")([^\")]*)(\"\))", lines[i])
        if m != nothing
            dir = dirname(f)
            nf  = joinpath(dir, m.captures[2])
            removeProgress(nf)
        end
    end
    lines[end] == "println()" && (toremove[end] = true)

    deleteat!(lines, toremove)
    open(f, "w") do io
        write(io, join(lines,'\n'))
    end
    return nothing
end


end # module
