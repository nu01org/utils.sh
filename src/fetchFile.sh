fetch_url_file() {
    local url="$1"
    local file="${url##*/}"   # filename from URL

    local remote_size
    remote_size=$(
        curl -fsSI "$url" | awk '
        BEGIN { IGNORECASE=1 }
        /^Content-Length:/ {
            gsub("\r", "", $2)
            print $2
        }'
    )

    if [ -z "$remote_size" ]; then
        echo "ERROR: Could not determine remote file size: $url" >&2
        return 1
    fi

    local local_size=0
    if [ -f "$file" ]; then
        local_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")
    fi

    if [ "$remote_size" != "$local_size" ]; then
        echo "Fetching $file ($local_size -> $remote_size bytes)"
        curl -fsSL "$url" -o "$file"
    else
        echo "$file is up to date"
    fi
}
