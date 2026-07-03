local HttpService = game:GetService("HttpService")

local userKey = "PREMIUM-4949-1111" 
local apiUrl = "https://system-auth-gateway.schoolonline12341.workers.dev" 

-- 🛡️ IMPROVED SECURITY PRE-CHECK 1: Safe Anti-Hook Detection
-- Checks if loadstring was replaced by a regular script. Safe for all executors!
local isTampered = false
local infoSuccess, sourceFile = pcall(function() return debug.info(loadstring, "s") end)

if infoSuccess and sourceFile ~= "=[C]" then
    isTampered = true
end

if isTampered then
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

local payload = HttpService:JSONEncode({ 
    key = userKey,
    hwid = myHWID
})

local success, response = pcall(function()
    local httpRequest = (syn and syn.request) or (http and http.request) or request
    
    if httpRequest then
        local res = httpRequest({
            Url = apiUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Custom-Auth"] = "MY_SUPER_SECRET_PASSPHRASE_999" 
            },
            Body = payload
        })
        return res.Body
    else
        return HttpService:PostAsync(apiUrl, payload, Enum.HttpContentType.ApplicationJson)
    end
end)

if success then
    local data = HttpService:JSONDecode(response)
    if data.success and data.script then
        local secureRun = loadstring(data.script)
        secureRun()
    else
        warn("Authentication Rejected: " .. tostring(data.message))
    end
else
    warn("Critical Failure: Unable to establish a secure connection with the validation network.")
end

