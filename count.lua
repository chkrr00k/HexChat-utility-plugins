--countdown script for hexchat
hexchat.register("count.lua", "0.1", "Count down for streams and things")

-- created by chkrr00k with love
-- released in GNU GPLv3 license

-- SETTINGS
-- 		channel name 
local channel = "#channel"
local hook
local startAt = 3
local current = startAt
local counting = false

local function setCTX()
	local current = hexchat.find_context(server, channel)
	hexchat.set_context(current)
end


local function countDown()
	local cntDw = nil
	if current > startAt or current < 0 then
		current = startAt
	end
	if current == 0 then 
		cntDw = "go\a" 
		counting = false
	else 
		cntDw = current 
		counting = true
	end
	current = current - 1
	hexchat.print(cntDw)
	setCTX()
	hexchat.command(("PRIVMSG %s %s"):format(channel, cntDw))
	
end

local function processHook(input)
	if string.sub(input[4], 2, 7) == ".count" and input[3] == channel and not counting then
		setCTX()
		step = 1050
		if input[5] ~= nil and tonumber(input[5]) ~= nil and tonumber(input[5]) <= 5 and tonumber(input[5]) > 0 then
			step = tonumber(input[5])*1000
		end;
		hexchat.command(("PRIVMSG %s %s"):format(channel, "Countdown started!"))
		for i=startAt,0,-1 do
			hexchat.hook_timer(i*step, countDown)
		end
	elseif(string.sub(input[4], 2, 6) == ".help" and input[3] == channel) then
		setCTX()
		hexchat.command(("PRIVMSG %s %s"):format(channel, "use .count [seconds] to start a countdown, seconds must be lower than 6 seconds. default is 1s"))
	elseif(string.sub(input[4], 2, 6) == ".lewd" and input[3] == channel) then
		setCTX()
		hexchat.command(("PRIVMSG %s %s"):format(channel, ">///< Why you make me do such things?!?"))
	end
end

hook = hexchat.hook_server("PRIVMSG", processHook)