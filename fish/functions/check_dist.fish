function check_dist --description 'check PyPI build artifacts for clutter'
    if not test -d dist
        printf 'No dist/ directory!\n' >&2
        return 1
    end

    set -f clutter 'mypy_cache|ruff_cache|pytest_cache|__pycache__|\.DS_Store'
    set -f rc 0

    set -f wheels (ls dist/ | string match '*.whl')
    if test (count $wheels) -ne 1
        printf 'Expected exactly one wheel, found %d\n' (count $wheels) >&2
        return 1
    end

    set -f sdists (ls dist/ | string match '*.tar.gz')
    if test (count $sdists) -ne 1
        printf 'Expected exactly one sdist, found %d\n' (count $sdists) >&2
        return 1
    end

    set -f found (python -m zipfile -l dist/$wheels[1] | string match -r $clutter)
    if test (count $found) -gt 0
        printf 'POLLUTED wheel — do not publish\n'
        printf '  %s\n' $found
        set rc 1
    else
        printf 'Wheel clean\n'
    end

    if test (count $sdists) -eq 1
        set -f found (tar -tzf dist/$sdists[1] | string match -r $clutter)
        if test (count $found) -gt 0
            printf 'POLLUTED sdist — do not publish\n'
            printf '  %s\n' $found
            set rc 1
        else
            printf 'Sdist clean\n'
        end
    end

    return $rc
end
