local AutoAcceptEnchantReplace = {}

AutoAcceptEnchantReplace.Version = 1.1;
AutoAcceptEnchantReplace.VersionBroadcast = 1;

function AutoAcceptEnchantReplace:Log(msg)
	if (msg == nil) then
		return;
	end

	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cff33ff99AAER:|cffffff78 %s", msg));
end

function AutoAcceptEnchantReplace:Initialize()
	if (1 == AutoAcceptEnchantReplace.VersionBroadcast) then
		AutoAcceptEnchantReplace.VersionBroadcast = 0;
		AutoAcceptEnchantReplace:Log(string.format("AutoAcceptEnchantReplace version %s loaded.", AutoAcceptEnchantReplace.Version));
	end
end

function AutoAcceptEnchantReplace:OnEvent(event, old_enchant, new_enchant, ...)	
	if (event == "ADDON_LOADED") then
		AutoAcceptEnchantReplace:Initialize();
	end
	
	if (event == "REPLACE_ENCHANT") then
		-- Because ReplaceEnchant() is a protected funtion we have to make sure that we are allowed to use it.
		-- The restriction is all based on if we are applying an 'Imbue' Enchant or not.
		-- http://forums.wowace.com/showthread.php?t=16545
		-- http://www.wowwiki.com/Imbue Imbue refers to a temporary enhant that can be added to equipment.
		-- So to keep things simple we will make sure that the player has their Enchant profession window open,
		-- this will not assure us that we are dealing with a real enchant but it is a nice easy way to get
		-- around the issue for now.
		--if ("Enchant" == GetTradeSkillInfo(GetTradeSkillSelectionIndex())) then
		if (GetTradeSkillInfo(GetTradeSkillSelectionIndex())):sub(1, 7) == "Enchant" then
			if (old_enchant == new_enchant) then
				--AutoAcceptEnchantReplace:Log(string.format("Auto Accepted replacing %s with %s", old_enchant, new_enchant))
				ReplaceEnchant();
			else
				return;
			end
		end
	end
end

AutoAcceptEnchantReplace.frame = CreateFrame("Frame");
AutoAcceptEnchantReplace.frame:SetScript("OnEvent", AutoAcceptEnchantReplace.OnEvent);
AutoAcceptEnchantReplace.frame:RegisterEvent("REPLACE_ENCHANT");
AutoAcceptEnchantReplace.frame:RegisterEvent("ADDON_LOADED");
--AutoAcceptEnchantReplace.frame:RegisterEvent("TRADE_SKILL_UPDATE");
