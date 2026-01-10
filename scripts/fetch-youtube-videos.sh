#!/bin/bash
#
# Fetches latest YouTube videos and saves to _data/youtube_videos.json
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
MAX_RESULTS=10
OUTPUT_FILE="_data/youtube_videos.json"

# Validate API key
if [ -z "$YOUTUBE_API_KEY" ]; then
    echo "Error: YOUTUBE_API_KEY environment variable is not set" >&2
    exit 1
fi

# Ensure _data directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Fetch videos from YouTube API
echo "Fetching latest $MAX_RESULTS videos from channel $CHANNEL_ID..."

response=$(curl -s "https://www.googleapis.com/youtube/v3/search?key=${YOUTUBE_API_KEY}&channelId=${CHANNEL_ID}&part=snippet&order=date&maxResults=${MAX_RESULTS}&type=video")

# Check for API errors
if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
    echo "API Error:" >&2
    echo "$response" | jq '.error' >&2
    exit 1
fi

# Check if we got any results
item_count=$(echo "$response" | jq '.items | length')
if [ "$item_count" -eq 0 ]; then
    echo "Warning: No videos found for channel $CHANNEL_ID" >&2
    exit 1
fi

# Transform response to cleaner format and save
echo "$response" | jq '[.items[] | {
    id: .id.videoId,
    title: .snippet.title,
    description: .snippet.description,
    publishedAt: .snippet.publishedAt,
    thumbnail: .snippet.thumbnails.high.url,
    thumbnailMedium: .snippet.thumbnails.medium.url
}]' > "$OUTPUT_FILE"

echo "Successfully saved $item_count videos to $OUTPUT_FILE"
echo ""
echo "Videos fetched:"
cat "$OUTPUT_FILE" | jq -r '.[].title'
