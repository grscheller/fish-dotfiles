function jdk_version --description 'Setup JDK on Debian derived systems'
    set -f jdk_version

    # Parse user input
    if test (count $argv) -gt 0
        set jdk_version (string split --no-empty --max 1 ' ' (string trim $argv[1]))
        test (count $jdk_version) -gt 1
        and set jdk_version $jdk_version[1]
    end

    # Make sure at least one Java JDK is installed in default location
    set -f jvm_dir jvm_dirs jvm_dirs_and_links
    switch $GRS_OS
        case windows
            set jvm_dirs_and_links /c/Program\ Files/Eclipse\ Adoptium/jdk-*-hotspot
        case macos
            # set jvm_dirs_and_links /usr/lib/jvm/java-*-openjdk*
            printf 'Not implemented yet for macos\n'
        case linux
            set jvm_dirs_and_links /usr/lib/jvm/java-*-openjdk*
    end
    for jvm_dir in $jvm_dirs_and_links
        test -L $jvm_dir
        and continue
        test -d $jvm_dir
        and set -a jvm_dirs $jvm_dir
    end
    if test -z "$jvm_dirs"
        printf 'No JDK environments installed\n' >&2
        return 1
    end

    # If user gave no arguments, print available java versions to stdout.
    if test -z "$jdk_version"
        printf 'Available Java Versions:'
        for jvm_dir in $jvm_dirs
            set -l jvm_dirs_split (string split - $jvm_dir)
            set jvm_dirs_split (string split . $jvm_dirs_split[2])
            printf ' %s' $jvm_dirs_split[1]
        end
        printf '\n'
        return 0
    end

    # Sanity check user input
    if not string match -qr '^\d+$' $jdk_version[1]
        printf 'Malformed JDK version number: "%s"\n' $jdk_version >&2
        return 1
    end

    set -f java_home /usr/lib/jvm/java-$jdk_version*

    # Bail if Java version is not installed
    if not test -d "$java_home"
        printf 'No JDK found for Java version %s in /usr/lib/jvm\n' $jdk_version >&2
        return 1
    end

    # Set JAVA_HOME
    set -gx JAVA_HOME $java_home
    set -gx JDK_VERSION $jdk_version

    # Fix PATH
    set -f index 0
    for ii in (seq 1 (count $PATH))
        if string match -q '/usr/lib/jvm/java-*-openjdk*/bin' $PATH[$ii]
            set index $ii
            break
        end
    end

    if test $index -eq 0
        set -p PATH $java_home/bin
        set index 1
    else
        set PATH[$index] $java_home/bin
    end

    for ii in (seq (count $PATH) -1 (math $index + 1))
        if string match -q '/usr/lib/jvm/java-*-openjdk*/bin' $PATH[$ii]
            set -e PATH[$ii]
        end
    end

    return 0
end
