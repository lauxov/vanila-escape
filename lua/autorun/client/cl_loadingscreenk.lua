/*
    Made by Atlant Studio
*/

local screenx = 1920*ScrW()
local screeny = 1080*ScrH()

atl = {}
atl.hook = hook.Add

function atl.weight(x)
    return x/1920*ScrW()
end

function atl.height(y)
    return y/1080*ScrH()
end

///////////////////////////////
////////////КОНФИГ////////////
//////////////////////////////

local mainpanel -- не трогать

atl.fonts = {
    size1 = atl.height(100), --размер шрифта для заглавного текста
    size2 = atl.weight(51) --размер шрифта для текста на кнопках
}

atl.image = "https://i.imgur.com/7b3iGaC.jpeg" --картинка на заднем плане

atl.title = "Your Server" -- заглавный текст

atl.texts = { --текст на кнопках
    {
        text="Играть",
        func = function() mainpanel:Remove() end,
    },
    {
        text="Правила",
        func = function() gui.OpenURL("ссылка") end,
    },
    {
        text="DISCORD",
        func = function() gui.OpenURL("ссылка") end,
    },
    {
        text="Покинуть сервер",
        func = function() RunConsoleCommand("disconnect") end,
    }
}

atl.colors = {
    default = Color(255,192,252,170), --цвет кнопки когда курсор не наведён
    hovered = Color(234,126,229,142), --цвет кнопки когда курсор наведён
    text = Color(255,255,255), -- цвет текста на кнопках
    title = Color(255,255,255), -- цвет заглавного текста
}

///////////////////////////////
////////////СКРИПТ////////////
//////////////////////////////

local file, Material, Fetch, find = file, Material, http.Fetch, string.find

local errorMat = Material("debug/debugvertexcolor")
local WebImageCache = {}
function http.DownloadMaterial(url, path, callback)
    if WebImageCache[url] then return callback(WebImageCache[url]) end

    local data_path = "data/".. path
        Fetch(url, function(img)
            if img == nil or find(img, "<!DOCTYPE HTML>", 1, true) then return callback(errorMat) end
            
            file.Write(path, img)
            WebImageCache[url] = Material(data_path, "smooth")
            callback(WebImageCache[url])
        end, function()
            callback(errorMat)
        end)
end

surface.CreateFont("AtlantFontMain",{
    font = "Roboto",
    size=atl.fonts.size1,
    antialias=true
})

surface.CreateFont("AtlantFontButton",{
    font = "Roboto",
    extended=true,
    size=atl.fonts.size2,
    antialias=true
})

chat.AddText(Color(0,255,191),"Сделано Atlant Coding Studio: https://keqwerty.xyz/atlant/")
chat.AddText(Color(255,0,255),"Сделано Atlant Coding Studio: https://keqwerty.xyz/atlant/")
chat.AddText(Color(0,255,34),"Сделано Atlant Coding Studio: https://keqwerty.xyz/atlant/")

local function startscreen()
    mainpanel = vgui.Create("EditablePanel")
    mainpanel:MakePopup()
    mainpanel:SetPos(0,0)
    mainpanel:SetSize(ScrW(),ScrH())
    mainpanel.Paint = function(self,w,h)
        http.DownloadMaterial(atl.image,"atl_menu.png",function(image)
            surface.SetMaterial(image)
            surface.SetDrawColor(255,255,255)
            surface.DrawTexturedRect(0,0,w,h)
        end)
        draw.SimpleText(atl.title,"AtlantFontMain",w/2,0+height(150),atl.colors.title,1,1)
    end
    local buttonspan = vgui.Create("Panel",mainpanel)
    buttonspan:SetPos(weight(660),height(430))
    buttonspan:SetSize(weight(598),height(588))
    local buttons = vgui.Create("DIconLayout",buttonspan)
    buttons:Dock(FILL)
    buttons:SetSpaceY(height(36))
    for i=1,4 do
        print(atl.texts[i].text)
        local button = buttons:Add("DButton")
        button:SetSize(buttonspan:GetWide(),height(120))
        button:SetFont("AtlantFontButton")
        button:SetText(atl.texts[i].text)
        button:SetTextColor(atl.colors.text)
        button.Paint = function(self,w,h)
            if self:IsHovered() then
                self.color = atl.colors.hovered
            else
                self.color = atl.colors.default
            end
            draw.RoundedBox(26,0,0,w,h,self.color)
        end
        button.DoClick = atl.texts[i].func
    end
end

atl.hook("InitPostEntity","atlLoadingScreen",startscreen)

atl.hook("PreRender","atlEscMenu",function()
    if input.IsKeyDown(KEY_ESCAPE) && gui.IsGameUIVisible() then
        if ValidPanel(mainpanel)  then
            gui.HideGameUI()
            mainpanel:Remove()
        else
            gui.HideGameUI()
            startscreen()
        end
    end
end)