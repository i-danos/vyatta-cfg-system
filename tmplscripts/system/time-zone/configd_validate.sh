#!/bin/bash
new_zone=$(basename $CONFIGD_PATH)
new_zone=${new_zone//\%2B/+}
new_zone=${new_zone//\%2F//}
# Debian's tzdata used to ship a posix/ tree alongside the top-level zone
# files; as of trixie it doesn't, and the top-level files are the posix ones.
# Fall back to those, matching on the TZif magic so that the non-zone files
# living in that directory (zone.tab, iso3166.tab, leapseconds, ...) aren't
# mistaken for valid zones.
for zonefile in /usr/share/zoneinfo/posix/"$new_zone" /usr/share/zoneinfo/"$new_zone"; do
    if [ -f "$zonefile" ] && [ "$(head -c 4 "$zonefile")" = TZif ]; then
        exit 0
    fi
done

echo "ERROR: $new_zone is not a valid time-zone"
exit 1
