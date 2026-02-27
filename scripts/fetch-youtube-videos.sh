#!/bin/bash
#
# Fetches all YouTube videos from a channel with view counts
# and saves to _data/youtube_videos.json
#
# Usage:
#   YOUTUBE_API_KEY=your_key ./scripts/fetch-youtube-videos.sh
#
# Environment variables:
#   YOUTUBE_API_KEY - Required. Your YouTube Data API v3 key
#   CHANNEL_ID      - Optional. Defaults to UCa--Aos-i1nb6CJalzhV-rg (SaturdayMP)
#

set -e

# Configuration
CHANNEL_ID="${CHANNEL_ID:-UCa--Aos-i1nb6CJalzhV-rg}"
OUTPUT_FILE="_data/youtube_videos.json"

# Validate API key
if [ -z "$YOUTUBE_API_KEY" ]; then
    echo "Error: YOUTUBE_API_KEY environment variable is not set" >&2
    exit 1
fi

# Ensure _data directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Remove old data file to ensure clean slate
if [ -f "$OUTPUT_FILE" ]; then
    rm "$OUTPUT_FILE"
    echo "Removed old video data"
fi

# -----------------------------------------------------------
# Phase 1: Fetch all videos via Search API (paginated)
# -----------------------------------------------------------
echo "Fetching all videos from channel $CHANNEL_ID..."

all_videos="[]"
page_token=""
page=0

while true; do
    page=$((page + 1))

    url="https://www.googleapis.com/youtube/v3/search?key=${YOUTUBE_API_KEY}&channelId=${CHANNEL_ID}&part=snippet&order=date&maxResults=50&type=video"
    if [ -n "$page_token" ]; then
        url="${url}&pageToken=${page_token}"
    fi

    response=$(curl -s "$url")

    # Check for API errors
    if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
        echo "Search API Error (page $page):" >&2
        echo "$response" | jq '.error' >&2
        exit 1
    fi

    # Extract videos from this page
    page_count=$(echo "$response" | jq '.items | length')
    echo "  Page $page: fetched $page_count videos"

    if [ "$page_count" -eq 0 ] && [ "$page" -eq 1 ]; then
        echo "Warning: No videos found for channel $CHANNEL_ID" >&2
        exit 1
    fi

    # Transform and accumulate
    page_videos=$(echo "$response" | jq '[.items[] | {
        id: .id.videoId,
        title: .snippet.title,
        description: .snippet.description,
        publishedAt: .snippet.publishedAt,
        thumbnail: .snippet.thumbnails.high.url,
        thumbnailMedium: .snippet.thumbnails.medium.url
    }]')

    all_videos=$(echo "$all_videos" "$page_videos" | jq -s '.[0] + .[1]')

    # Check for next page
    page_token=$(echo "$response" | jq -r '.nextPageToken // empty')
    if [ -z "$page_token" ]; then
        break
    fi
done

total_videos=$(echo "$all_videos" | jq 'length')
echo "Total videos fetched: $total_videos"

# -----------------------------------------------------------
# Phase 2: Fetch view counts via Videos API (batched by 50)
# -----------------------------------------------------------
echo ""
echo "Fetching view counts..."

# Extract all video IDs
all_ids=$(echo "$all_videos" | jq -r '.[].id')

stats="{}"
batch_ids=""
batch_count=0
batch_num=0

for vid_id in $all_ids; do
    if [ -n "$batch_ids" ]; then
        batch_ids="${batch_ids},${vid_id}"
    else
        batch_ids="$vid_id"
    fi
    batch_count=$((batch_count + 1))

    if [ "$batch_count" -eq 50 ]; then
        batch_num=$((batch_num + 1))
        echo "  Statistics batch $batch_num ($batch_count videos)..."

        stats_response=$(curl -s "https://www.googleapis.com/youtube/v3/videos?key=${YOUTUBE_API_KEY}&id=${batch_ids}&part=statistics")

        if echo "$stats_response" | jq -e '.error' > /dev/null 2>&1; then
            echo "Videos API Error (batch $batch_num):" >&2
            echo "$stats_response" | jq '.error' >&2
            exit 1
        fi

        batch_stats=$(echo "$stats_response" | jq '[.items[] | {(.id): (.statistics.viewCount | tonumber)}] | add // {}')
        stats=$(echo "$stats" "$batch_stats" | jq -s '.[0] * .[1]')

        batch_ids=""
        batch_count=0
    fi
done

# Process remaining batch
if [ "$batch_count" -gt 0 ]; then
    batch_num=$((batch_num + 1))
    echo "  Statistics batch $batch_num ($batch_count videos)..."

    stats_response=$(curl -s "https://www.googleapis.com/youtube/v3/videos?key=${YOUTUBE_API_KEY}&id=${batch_ids}&part=statistics")

    if echo "$stats_response" | jq -e '.error' > /dev/null 2>&1; then
        echo "Videos API Error (batch $batch_num):" >&2
        echo "$stats_response" | jq '.error' >&2
        exit 1
    fi

    batch_stats=$(echo "$stats_response" | jq '[.items[] | {(.id): (.statistics.viewCount | tonumber)}] | add // {}')
    stats=$(echo "$stats" "$batch_stats" | jq -s '.[0] * .[1]')
fi

# -----------------------------------------------------------
# Phase 3: Merge view counts into video data and save
# -----------------------------------------------------------
echo ""
echo "Merging view counts and saving..."

echo "$all_videos" | jq --argjson stats "$stats" '
    [.[] | . + {viewCount: ($stats[.id] // 0)}]
    | sort_by(.publishedAt) | reverse
' > "$OUTPUT_FILE"

echo "Successfully saved $total_videos videos to $OUTPUT_FILE"
echo ""
echo "Videos fetched:"
jq -r '.[] | "\(.title) (\(.viewCount) views)"' "$OUTPUT_FILE"
