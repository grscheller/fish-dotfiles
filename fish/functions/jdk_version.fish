# Setup the JDK environment for the current fish instance.
#
# Assumptions, which are deliberate rather than incidental:
#
#   linux_debian  Debian/Ubuntu layout - JDKs under /usr/lib/jvm named
#                 java-<ver>-openjdk-<arch>, with java-1.<ver>.0-openjdk-<arch>
#                 symlinks alongside for update-java-alternatives, which still
#                 speaks the pre-JEP-223 version scheme. Symlinks are skipped.
#
#   windows  Eclipse Adoptium (Temurin) under C:\Program Files, named
#            jdk-<ver>.<patch>-hotspot. Other vendors install elsewhere
#            (Microsoft under Microsoft\, Corretto under Amazon Corretto\)
#            and are not discovered.
#
# $JAVA_HOME is set in native form on each platform -- POSIX on Linux,
# Windows on Windows via cygpath -- because it is read by native Java
# tools. The $PATH entry stays POSIX on both, since that is what MSYS2
# expects.
#
# Uses `set -gx`, so different fish instances can select their own JDK.

function jdk_version --description 'Setup JDK environment'

    set -f jdk_version_number

    # Parse user input
    if test (count $argv) -gt 0
        set jdk_version_number (string split --no-empty --max 1 ' ' (string trim $argv[1]))
        test (count $jdk_version_number) -gt 1
        and set jdk_version_number $jdk_version_number[1]
    end

    # Make sure at least one Java JDK is installed in default location
    set -f jvm_dir jvm_dirs jvm_dirs_and_links

    switch $OS_GRS
        case windows
            set jvm_dirs_and_links /c/Program\ Files/Eclipse\ Adoptium/jdk-*-hotspot
        case linux_debian
            set jvm_dirs_and_links /usr/lib/jvm/java-*-openjdk*
        case '*'
            if set -q OS_GRS
                printf 'Unsupported OS: %s\n' "$OS_GRS" >&2
                return 1
            else
                printf 'OS_GRS not defined\n' >&2
                return 1
            end
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
    if test -z "$jdk_version_number"
        printf 'Available Java Versions:'
        for jvm_dir in $jvm_dirs
            set -l jvm_dirs_split (string split - $jvm_dir)
            set jvm_dirs_split (string split . $jvm_dirs_split[2])
            printf ' %s' $jvm_dirs_split[1] >&2
        end
        printf '\n' >&2
        return 0
    end

    # Sanity check user input
    if not string match -qr '^\d+$' $jdk_version_number[1]
        printf 'Malformed JDK version number: "%s"\n' $jdk_version_number >&2
        return 1
    end

    switch $OS_GRS
        case windows
            set -f java_home /c/Program\ Files/Eclipse\ Adoptium/jdk-{$jdk_version_number}.*-hotspot
            set -f java_location C:\\Program\ Files\\Eclipse\ Adoptium
        case linux_debian
            set -f java_home /usr/lib/jvm/java-{$jdk_version_number}-openjdk-*
            set -f java_location /usr/lib/jvm
    end

    # Bail if Java version is not installed
    if not test -d "$java_home"
        printf 'No JDK found for Java version %s in %s\n' $jdk_version_number $java_location >&2
        return 1
    end

    # Set JAVA_HOME
    switch $OS_GRS
        case windows
            set -gx JAVA_HOME (cygpath -w $java_home)
        case linux_debian
            set -gx JAVA_HOME $java_home
    end

    # Set JDK_VERSION
    set -gx JDK_VERSION $jdk_version_number

    # Fix PATH
    set -f match_str
    set -f index 0

    switch $OS_GRS
        case windows
            for ii in (seq 1 (count $PATH))
                if string match -q '/c/Program Files/Eclipse Adoptium/jdk-*-hotspot/bin' $PATH[$ii]
                    set index $ii
                    break
                end
            end
        case linux_debian
            for ii in (seq 1 (count $PATH))
                if string match -q '/usr/lib/jvm/java-*-openjdk*/bin' $PATH[$ii]
                    set index $ii
                    break
                end
            end
    end

    if test $index -eq 0
        set -p PATH $java_home/bin
        set index 1
    else
        set PATH[$index] $java_home/bin
    end

    switch $OS_GRS
        case windows
            set match_str '/c/Program Files/Eclipse Adoptium/jdk-*-hotspot/bin'
        case linux_debian
            set match_str '/usr/lib/jvm/java-*-openjdk*/bin'
    end

    for ii in (seq (count $PATH) -1 (math $index + 1))
        if string match -q $match_str $PATH[$ii]
            set -e PATH[$ii]
        end
    end

    return 0
end
