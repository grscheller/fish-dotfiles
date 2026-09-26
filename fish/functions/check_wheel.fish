function check_wheel --description 'check PyPI build for clutter'
    if not test -d dist
        printf 'No dist/ directory!'
        return 1
    end

    set -f num_wheels (ls dist/ | grep '.*\.whl' | wc -l)
    if test $num_wheels -eq 0
        printf 'No wheel found!\n'
        return 1
    else if test $num_wheels -ne 1
        printf 'Multiple wheels found!\n'
        return 1
    end

    python -m zipfile -l dist/*.whl | grep -E 'mypy_cache|ruff_cache|pytest_cache|__pycache__' 2>/dev/null
    and printf 'POLLUTED — do not publish\n'
    or printf 'Wheel clean\n'
end
