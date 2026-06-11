declare -A APT_RENAMES=(
    [python]=python3
    [netcat]=netcat-openbsd
    [postgresql-client]=postgresql-client
)

declare -A YUM_RENAMES=(
    [python]=python3
    [netcat]=nc
    [postgresql-client]=postgresql
)

installPkg() {
    local pkg="$1"
    local distro
    local corrected_pkg

    if command -v apt-get >/dev/null 2>&1; then
        distro="apt"
        corrected_pkg="${APT_RENAMES[$pkg]:-$pkg}"

        sudo apt-get update
        sudo apt-get install -y "$corrected_pkg"

    elif command -v dnf >/dev/null 2>&1; then
        distro="yum"
        corrected_pkg="${YUM_RENAMES[$pkg]:-$pkg}"

        sudo dnf install -y "$corrected_pkg"

    elif command -v yum >/dev/null 2>&1; then
        distro="yum"
        corrected_pkg="${YUM_RENAMES[$pkg]:-$pkg}"

        sudo yum install -y "$corrected_pkg"

    else
        echo "Unsupported package manager"
        return 1
    fi
}
