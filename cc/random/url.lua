-- YouTube Video Length Fetcher for ComputerCraft
-- This program extracts the length of a YouTube video from its URL

-- Function to extract video ID from a YouTube URL
local function extractVideoID(url)
    -- Match patterns for different YouTube URL formats
    local patterns = {
      "youtube.com/watch%?v=([%w-_]+)",
      "youtu.be/([%w-_]+)",
      "youtube.com/v/([%w-_]+)",
      "youtube.com/embed/([%w-_]+)"
    }
    
    for _, pattern in ipairs(patterns) do
      local videoID = string.match(url, pattern)
      if videoID then
        return videoID
      end
    end
    
    return nil
  end
  
  -- Function to format seconds into HH:MM:SS
  local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if hours > 0 then
      return string.format("%02d:%02d:%02d", hours, minutes, secs)
    else
      return string.format("%02d:%02d", minutes, secs)
    end
  end
  
  -- Main function to get video length
  local function getVideoLength(url)
    if not http then
      print("HTTP API is not enabled. Please enable it in the ComputerCraft config.")
      return nil
    end
    
    -- Extract video ID
    local videoID = extractVideoID(url)
    if not videoID then
      print("Invalid YouTube URL. Could not extract video ID.")
      return nil
    end
    
    -- Use YouTube oEmbed API to get video info
    local apiUrl = "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=" .. videoID .. "&format=json"
    print("Requesting video information...")
    
    local response, err = http.get(apiUrl)
    if not response then
      print("Error making HTTP request: " .. (err or "Unknown error"))
      return nil
    end
    
    local data = response.readAll()
    response.close()
    
    -- Parse the JSON response
    local title = string.match(data, '"title":"(.-)"')
    
    -- Since oEmbed doesn't directly provide duration, we need to fetch the video page
    local videoPageUrl = "https://www.youtube.com/watch?v=" .. videoID
    local videoPage, pageErr = http.get(videoPageUrl)
    
    if not videoPage then
      print("Error accessing video page: " .. (pageErr or "Unknown error"))
      return nil
    end
    
    local pageContent = videoPage.readAll()
    videoPage.close()
    
    -- Try to extract length from the page content
    -- This pattern might need adjustment as YouTube changes their page structure
    local lengthSeconds = string.match(pageContent, '"lengthSeconds":"(%d+)"')
    
    if not lengthSeconds then
      print("Could not extract video length from the page.")
      return nil
    end
    
    return {
      videoID = videoID,
      title = title and title:gsub('\\"', '"') or "Unknown title",
      length = tonumber(lengthSeconds),
      formattedLength = formatTime(tonumber(lengthSeconds))
    }
  end
  
  -- Main program
  print("YouTube Video Length Fetcher")
  print("---------------------------")
  
  while true do
    print("\nEnter a YouTube URL (or 'exit' to quit):")
    local input = read()
    
    if input:lower() == "exit" then
      print("Exiting program.")
      break
    end
    
    local videoInfo = getVideoLength(input)
    
    if videoInfo then
      print("\nVideo information:")
      print("Title: " .. videoInfo.title)
      print("Video ID: " .. videoInfo.videoID)
      print("Length: " .. videoInfo.formattedLength .. " (" .. videoInfo.length .. " seconds)")
    end
  end