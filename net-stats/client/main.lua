-- network statistics and diagnostics on the middle-left of the screen, toggled with /netstats

local REFRESH_SECONDS = 0.5
local FONT_SIZE = 14
local LINE_HEIGHT = 16
local MARGIN = 10
local PADDING = 6
local WIDTH = 520

local COLOR_TEXT = vec4(1, 1, 1, 1)
local COLOR_HEADER = vec4(0.4, 0.8, 1, 1)
local COLOR_GOOD = vec4(0.4, 1, 0.4, 1)
local COLOR_WARN = vec4(1, 0.85, 0.3, 1)
local COLOR_BAD = vec4(1, 0.35, 0.35, 1)
local COLOR_BG = vec4(0, 0, 0, 0.55)

local visible = true
local lines = {}
local last_refresh = -math.huge

local function fmt_bytes(bytes)
	local units = { "B", "KB", "MB", "GB" }
	local unit = 1

	while bytes >= 1024 and unit < #units do
		bytes = bytes / 1024
		unit = unit + 1
	end

	return unit == 1 and string.format("%d B", bytes) or string.format("%.2f %s", bytes, units[unit])
end

local function fmt_duration(seconds)
	seconds = math.floor(seconds)

	return string.format("%02d:%02d:%02d", math.floor(seconds / 3600), math.floor(seconds / 60) % 60, seconds % 60)
end

local function level_color(value, warn, bad)
	return value >= bad and COLOR_BAD or value >= warn and COLOR_WARN or COLOR_GOOD
end

local function percent(part, total)
	return total > 0 and part * 100 / total or 0
end

local function build_lines(stats)
	local out = {}

	local function add(text, color)
		out[#out + 1] = { text = text, color = color or COLOR_TEXT }
	end

	local function add_traffic(name, t)
		add(string.format("  %s %d pkts, %s | %.0f pkt/s, %s/s | peak %s/s", name, t.packets, fmt_bytes(t.bytes),
			t.packetsPerSec, fmt_bytes(t.bytesPerSec), fmt_bytes(t.peakBytesPerSec)))
	end

	local function add_flow(f)
		add_traffic("up  ", f.sent)
		add_traffic("down", f.received)
	end

	local local_client = World.LocalClient()

	add("NETWORK", COLOR_HEADER)
	add(string.format("Client %s | NID %s", Client.Version, local_client and tostring(local_client:GetNetId()) or "-"))
	add(string.format("FPS %.0f | players %d", 1 / math.max(World.GetRenderDeltaTime(), 0.0001), #World.GetPlayers()))

	if not stats then
		add("Not connected", COLOR_BAD)
		return out
	end

	local p = stats.peer
	local ping = math.floor(p.rtt / 2)

	add(string.format("Connected %s", fmt_duration(p.connectedSeconds)))
	add(string.format("Ping %d ms (rtt %d, variance %d, last %d, lowest %d)", ping, p.rtt, p.rttVariance, p.lastRtt, p.lowestRtt),
		level_color(ping, 80, 150))
	add(string.format("Packet loss %.2f%% (variance %.2f%%)", p.packetLoss, p.packetLossVariance), level_color(p.packetLoss, 1, 5))
	add(string.format("Reliable lost %d / %d (%.2f%%)", p.reliableLost, p.reliableSent, percent(p.reliableLost, p.reliableSent)),
		level_color(percent(p.reliableLost, p.reliableSent), 1, 5))
	add(string.format("Throttle %.0f%% | mtu %d | window %s", p.throttle, p.mtu, fmt_bytes(p.windowSize)), level_color(100 - p.throttle, 10, 50))
	add(string.format("In flight %s | awaiting ack %d | waiting %s", fmt_bytes(p.reliableInFlightBytes), p.awaitingAck, fmt_bytes(p.waitingBytes)))

	add("WIRE (UDP, ENet overhead included)", COLOR_HEADER)
	add_flow(stats.wire)

	add("APP (kraus packets)", COLOR_HEADER)
	add_flow(stats.app)
	add(string.format("  wire/app size: up %.1f%%, down %.1f%%", percent(stats.wire.sent.bytes, stats.app.sent.bytes),
		percent(stats.wire.received.bytes, stats.app.received.bytes)))

	add("CHANNELS", COLOR_HEADER)

	for _, name in ipairs({ "ReliableHigh", "ReliableLow", "Unreliable", "Position" }) do
		local c = stats.channels[name]

		add(string.format("  %-12s up %s/s (%d) | down %s/s (%d)", name, fmt_bytes(c.sent.bytesPerSec), c.sent.packets,
			fmt_bytes(c.received.bytesPerSec), c.received.packets))
	end

	local c = stats.compression

	add("COMPRESSION", COLOR_HEADER)

	if c.enabled then
		add(string.format("  level %d | out %s -> %s (%.1f%%) | %d skipped", c.level, fmt_bytes(c.compressedInBytes),
			fmt_bytes(c.compressedOutBytes), percent(c.compressedOutBytes, c.compressedInBytes), c.skipped))
		add(string.format("  in %s -> %s | %d failed", fmt_bytes(c.decompressedInBytes), fmt_bytes(c.decompressedOutBytes), c.failed),
			c.failed > 0 and COLOR_BAD or COLOR_TEXT)
	else
		add("  disabled")
	end

	local cfg = stats.config

	add("CONFIG", COLOR_HEADER)
	add(string.format("  mtu %d | timeout %ds | ping interval %d ms | packet id bits %d", cfg.mtu, cfg.timeout, cfg.pingInterval, cfg.packetIdBits))

	return out
end

Cmd.Add("netstats", function()
	visible = not visible
end)

-- Client.GetNetStats must be read on the update thread, so the lines are built here and only drawn in OnRender

Event.Add("OnUpdate", function()
	local now = Client.GetElapsedSeconds()

	if not visible or now - last_refresh < REFRESH_SECONDS then
		return
	end

	last_refresh = now
	lines = build_lines(Client.GetNetStats())
end)

Event.Add("OnRender", function()
	if not visible or #lines == 0 then
		return
	end

	local height = #lines * LINE_HEIGHT + PADDING * 2
	local pos = vec2(MARGIN, (Render.GetSize().y - height) / 2)

	Render.FillRect(pos, vec2(WIDTH, height), COLOR_BG)

	for i, line in ipairs(lines) do
		Render.DrawText(line.text, vec2(pos.x + PADDING, pos.y + PADDING + (i - 1) * LINE_HEIGHT), FONT_SIZE, line.color, false, 1)
	end
end)