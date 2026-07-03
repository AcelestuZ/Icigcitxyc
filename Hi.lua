local HttpService = game:GetService("HttpService")

local userKey = "PREMIUM-4949-1111" -- The key you generated in Phase 1
local apiUrl = "https://system-auth-gateway.schoolonline12341.workers.dev" -- Paste your Cloudflare URL here

-- 🛡️ SECURITY PRE-CHECK 1: Anti-Loadstring Environment Tampering Detection
-- Detects if a thief modified 'loadstring' to dump incoming server payloads into a file.
if tostring(loadstring) ~= "function: builtin#loadstring" and tostring(loadstring) ~= "function" then
    game:GetService("Players").LocalPlayer:Kick("Security Violation: Native environment manipulation detected.")
    return
end

-- 🛡️ SECURITY PRE-CHECK 2: Hardware Signature Acquisition
local myHWID = "STUDIO_DEV"
if gethwid then 
    myHWID = gethwid() 
elseif game:GetService("Players").LocalPlayer then
    myHWID = tostring(game:GetService("Players").LocalPlayer.UserId)
end

-- Package the license data cleanly
local payload = HttpService:JSONEncode({ 
    key = userKey,
    hwid = myHWID
})

local success, response = pcall(function()
    -- Dynamically check for high-level executor request methods to transmit custom headers safely
    local httpRequest = (syn and syn.request) or (http and http.request) or request
    
    if httpRequest then
        local res = httpRequest({
            Url = apiUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Custom-Auth"] = "MY_SUPER_SECRET_PASSPHRASE_999" -- MUST match Worker Phase 2!
            },
            Body = payload
        })
        return res.Body
    else
        -- Basic fallback configuration
        return HttpService:PostAsync(apiUrl, payload, Enum.HttpContentType.ApplicationJson)
    end
end)

if success then
    local data = HttpService:JSONDecode(response)
    if data.success and data.script then
        -- 🛡️ SECURITY EXECUTION: Compiles code straight to RAM. Leaves 0 trail on hard disks.
        local secureRun = loadstring(data.script)
        secureRun()
    else
        warn("Authentication Rejected: " .. tostring(data.message))
    end
else
    warn("Critical Failure: Unable to establish a secure connection with the validation network.")
end

