module TestProgressMeter

export insertProgress

@doc raw"
    insertProgress(f = 'runtests.jl'; toplevel = true, s = 1)
assuming `f` is a `runtest` folder, `insertProgress`
inserts the necessary statements into `f` such that a progress-bar
is presented during testing which is updated all `s` seconds.
The progress-bar gives equal weight to each `@test...`- statement
except `@testset`.
All changed files are baked up with prefix 'bkup' in the same
folder.

If `ProgressMeter` is already imported, it's assumed that the
function has been applied before and nothing happens.
"
function insertProgress(f = "runtests.jl"; toplevel = true, s = 1)
    counter = 0
    isfile(f) || throw(ArgumentError("$f is not a file"))

    lines = readlines(f)
    any(x -> occursin("using ProgressMeter", x), lines) && return
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
            lines[i] =  m.captures[1] *
                        joinpath(dirname(m.captures[2]), "pm" * basename(m.captures[2])) *
                        m.captures[3]
        end
    end
    join(lines, '\n')
    toplevel && pushfirst!(lines, "using ProgressMeter", "p = Progress($counter, $s)")
    f = joinpath(dirname(f), "pm" * basename(f))

    open(f, "w") do io
        write(io, join(lines,'\n'))
    end

    return counter
end

end # module
