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
_addon.version  = '1.0.0';

require 'common'


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
    
    for x = 0, 5 do
        if not (x ~= 0 and zone ~= party:GetMemberZone(x) or party:GetMemberActive(x) == 0) then
            local name = party:GetMemberName(x);
            local hpp = party:GetMemberCurrentHPP(x);
            local mpp = party:GetMemberCurrentMPP(x);
            local tp = party:GetMemberCurrentTP(x);
            
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
            imgui.Text('HP:');
            imgui.SameLine();
            imgui.PushStyleColor(ImGuiCol_Text, 1.0, 1.0, 1.0, 1.0);
            imgui.ProgressBar(hpp / 100, -1, 14);
            imgui.PopStyleColor(2);
            
            imgui.PushStyleColor(ImGuiCol_PlotHistogram, 0.0, 0.61, 0.61, 0.6);
            imgui.Text('MP:');
            imgui.SameLine();
            imgui.PushStyleColor(ImGuiCol_Text, 1.0, 1.0, 1.0, 1.0);
            imgui.ProgressBar(mpp / 100, -1, 14);
            imgui.PopStyleColor(2);
            
            imgui.PushStyleColor(ImGuiCol_PlotHistogram, 0.4, 1.0, 0.4, 0.6);
            imgui.Text('TP:');
            imgui.SameLine();
            imgui.PushStyleColor(ImGuiCol_Text, 1.0, 1.0, 1.0, 1.0);
            imgui.ProgressBar(tp / 3000, -1, 14, tostring(tp));
            imgui.PopStyleColor(2);
        end
    end
    
    imgui.End();
end);