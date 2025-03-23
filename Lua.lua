local HttpService = game:GetService("HttpService")

-- 🔥 Đường dẫn API GitHub
local GitHub_File = "https://api.github.com/repos/Phatdepzaicrystal/Key/contents/hwids.json"
local GitHub_Raw = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/hwids.json"

-- 🔥 Thay token GitHub của bạn vào đây
local Token = "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"

-- 🖥️ Lấy HWID của người chơi
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
local PlayerName = game.Players.LocalPlayer.Name

-- 📡 Lấy dữ liệu HWID hiện tại từ GitHub
local success, response = pcall(function()
    return game:HttpGet(GitHub_Raw)
end)

if success then
    local hwid_data = HttpService:JSONDecode(response)

    -- 🔄 Thêm HWID mới vào danh sách
    hwid_data[PlayerName] = HWID
    local new_data = HttpService:JSONEncode(hwid_data)

    -- 📝 Tạo request cập nhật file JSON trên GitHub
    local update_request = {
        message = "Update HWID List",
        content = HttpService:UrlEncode(new_data),
        sha = "SHA_OF_CURRENT_FILE"
    }

    local update_json = HttpService:JSONEncode(update_request)

    local request_data = {
        Url = GitHub_File,
        Method = "PUT",
        Headers = {
            ["Authorization"] = "token " .. Token,
            ["Content-Type"] = "application/json"
        },
        Body = update_json
    }

    local update_response = request(request_data)
    if update_response.Success then
        print("✅ Cập nhật HWID thành công lên GitHub!")
    else
        warn("❌ Cập nhật HWID thất bại!")
    end
else
    warn("❌ Không thể lấy dữ liệu từ GitHub!")
end
