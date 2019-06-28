module TestProgressMeter

export insertProgress, removeProgress

@doc raw"
    insertProgress(f = 'runtests.jl'; toplevel = true, s = 1)
assuming `f` is a `runtest` folder, `insertProgress`
inserts the necessary statements into `f` such that a progress-bar
is presented during testing which is updated all `s` seconds.
The progress-bar gives equal weight to each `@test...`- statement
except `@testset`.

To undo, apply `removeProgress(f)`.
"
function insertProgress(f = "runtests.jl"; toplevel = true, s = 1)
    counter = 0
    isfile(f) || throw(ArgumentError("$f is not a file"))

    lines = readlines(f)

    if toplevel && any(x -> occursin("using ProgressMeter", x), lines)
        removeProgress(f)
        insertProgress(f, toplevel = toplevel, s = s)
    end

    for i in 1:length(lines)
        m = match(r"^([ \t]*)@test[^s]", lines[i])
        if m != nothing
            lines[i] = string(m.captures[],"next!(p)\n", lines[i])
            counter += 1
        end
        m = match(r"(include\(\")([^\")]*)(\"\))", lines[i])
        if m != nothing
            dir = dirname(f)
            nf  = joinpath(dir, m.captures[2])
            counter += insertProgress(nf; toplevel = false)
        end
    end
    toplevel && pushfirst!(lines, "using ProgressMeter", "p = Progress($counter, $s)")

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
                        occursin("p = Progress", lines[i]) ||
                        occursin("next!(p)", lines[i])

        m = match(r"(include\(\")([^\")]*)(\"\))", lines[i])
        if m != nothing
            dir = dirname(f)
            nf  = joinpath(dir, m.captures[2])
            removeProgress(nf)
        end
    end

    deleteat!(lines, toremove)
    open(f, "w") do io
        write(io, join(lines,'\n'))
    end
    return nothing
end

end # module
