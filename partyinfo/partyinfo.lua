--[[
* Ashita - Copyright (c) 2014 - 2016 atom0s [atom0s@live.com]
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
* Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*
* By using Ashita, you agree to the above license and its terms.
*
*      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
*                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
*                    endorses you or your use.
*
*   Non-Commercial - You may not use the material (Ashita) for commercial purposes.
*
*   No-Derivatives - If you remix, transform, or build upon the material (Ashita), you may not distribute the
*                    modified material. You are, however, allowed to submit the modified works back to the original
*                    Ashita project in attempt to have it added to the original project.
*
* You may not apply legal terms or technological measures that legally restrict others
* from doing anything the license permits.
*
* No warranties are given.
]]--

_addon.author   = 'lejar';
_addon.name     = 'partyinfo';
_addon.version  = '1.0.1';

require 'common'


-- Because HP and MP can have a different number of digits between all players,
-- we save the length of the longest HP/MP so that all party members have the
-- same padding for the numbers.
local last_longest_number = 0;


----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    imgui.SetNextWindowSize(300, 500, ImGuiSetCond_Always);
end);

----------------------------------------------------------------------------------------------------
-- func: render
-- desc: Called when the addon is rendering.
----------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
    -- Obtain needed information managers.
    local party = AshitaCore:GetDataManager():GetParty();

    -- Locate the players zone.
    local zone = party:GetMemberZone(0);

    local target = GetEntity(AshitaCore:GetDataManager():GetTarget():GetTargetIndex());

    -- Initialize the window draw.
    if (imgui.Begin('PartyInfo') == false) then
        imgui.End();
        return;
    end

    local longest_number = 0;
    for x = 0, 5 do
        if not (x ~= 0 and party:GetMemberActive(x) == 0) then
            local name = party:GetMemberName(x);
            local hp = party:GetMemberCurrentHP(x);
            local hpp = party:GetMemberCurrentHPP(x);
            local mp = party:GetMemberCurrentMP(x);
            local mpp = party:GetMemberCurrentMPP(x);
            local tp = party:GetMemberCurrentTP(x);

            -- Save the longest number of all hp an mp so that we can correctly pad the numbers
            -- for the whole group.
            longest_number = math.max(longest_number, string.len(string.format('%d', hp)));
            longest_number = math.max(longest_number, string.len(string.format('%d', mp)));

            imgui.Separator();
            -- If the current party member is selected, make it visible.
            if (target ~= nil and string.lower(target.Name) == string.lower(name)) then
                imgui.PushStyleColor(ImGuiCol_Text, 0.5, 1.0, 0.5, 1.0);
                imgui.Text('> ' .. name);
                imgui.PopStyleColor(1);
            else
                imgui.Text(name);
            end
            imgui.Separator();

            -- Draw the labels and progress bars.
            imgui.PushStyleColor(ImGuiCol_PlotHistogram, 1.0, 0.61, 0.61, 0.6);
            imgui.Text('  HP:');
            imgui.SameLine();

            if zone == party:GetMemberZone(x) then
                -- Color the hp amount.
                if hpp > 75 then -- While
                    imgui.PushStyleColor(ImGuiCol_Text, 1.0, 1.0, 1.0, 1.0);
                elseif hpp > 50 then -- Yellow
                    imgui.PushStyleColor(ImGuiCol_Text, 0.98, 1.00, 0.38, 1.0);
                elseif hpp > 25 then -- Orange
                    imgui.PushStyleColor(ImGuiCol_Text, 1.00, 0.63, 0.38, 1.0);
                else -- Red
                    imgui.PushStyleColor(ImGuiCol_Text, 1.00, 0.38, 0.38, 1.0);
                end
                -- Pad the HP on the left.
                local hp_amount = string.format('%d', hp)
                while string.len(hp_amount) < last_longest_number do
                    hp_amount = ' ' .. hp_amount;
                end
                imgui.Text(hp_amount);
                imgui.SameLine();
                imgui.PushStyleColor(ImGuiCol_Text, 1.0, 1.0, 1.0, 1.0);
                imgui.ProgressBar(hpp / 100, -1, 14);
                imgui.PopStyleColor(3);
            else
                imgui.Text('N/A');
            end

            imgui.PushStyleColor(ImGuiCol_PlotHistogram, 0.0, 0.61, 0.61, 0.6);
            imgui.Text('  MP:');
            imgui.SameLine();
            if zone == party:GetMemberZone(x) then
                -- Pad the MP on the left.
                local mp_amount = string.format('%d', mp)
                while string.len(mp_amount) < last_longest_number do
                    mp_amount = ' ' .. mp_amount;
                end
                imgui.Text(mp_amount);
                imgui.SameLine();
                imgui.PushStyleColor(ImGuiCol_Text, 1.0, 1.0, 1.0, 1.0);
                imgui.ProgressBar(mpp / 100, -1, 14);
                imgui.PopStyleColor(2);
            else
                imgui.Text('N/A');
            end

            imgui.PushStyleColor(ImGuiCol_PlotHistogram, 0.4, 1.0, 0.4, 0.6);
            imgui.Text('  TP:');
            imgui.SameLine();
            if zone == party:GetMemberZone(x) then
                imgui.PushStyleColor(ImGuiCol_Text, 1.0, 1.0, 1.0, 1.0);
                imgui.ProgressBar(tp / 3000, -1, 14, tostring(tp));
                imgui.PopStyleColor(2);
            else
                imgui.Text('N/A');
            end
        end
    end

    last_longest_number = longest_number;

    imgui.End();
end);