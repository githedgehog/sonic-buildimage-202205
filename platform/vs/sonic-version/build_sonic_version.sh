export build_version="${sonic_version}"
export asic_type="${sonic_asic_platform}"
export commit_id="$(git rev-parse --short HEAD)"
export branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" == "HEAD" ]; then
    # Try to find branch by hash
    export branch=$(./get_branch_name.py)
fi
export build_date="$(date -u)"
export build_number="${BUILD_NUMBER:-0}"
export built_by="$USER@$BUILD_HOSTNAME"
j2 sonic_version.yml.j2 > $1
