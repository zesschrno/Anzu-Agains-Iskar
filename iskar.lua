function getWhoNeedsAnzu()
  local afectedByPhantasmalWinds = {};
  local countPhantasmalWinds = 0;
  local afectedByPhantasmalWounds = {};
  local countPhantasmalWounds = 0;
  local afectedByFelBomb = {};
  local countFelBomb = 0;
  local afectedByPhantasmalCorruption = {};
  local countPhantasmalCorruption = 0;
  
  local spellName0 = GetSpellInfo(181957); -- Vientos Fantasmales/Phantasmal Winds
  local spellName1 = GetSpellInfo(182325); -- Heridas Fantasmales/Phantasmal Wounds
  local spellName2 = GetSpellInfo(181753); -- Bomba vil/Fel Bomb
  local spellName3 = GetSpellInfo(181824); -- Corrupción fantasmal/Phantasmal Corruption
  
  local firstTank = nil;
  
  for i = 1, GetNumGroupMembers() do 
    local _, _, _, _, _, _, _, _, _, _, aura_spellID0 = UnitAura("raid" .. i, spellName0, nil);
    local _, _, _, _, _, _, _, _, _, _, aura_spellID1 = UnitAura("raid" .. i, spellName1, nil);
    local _, _, _, _, _, _, _, _, _, _, aura_spellID2 = UnitAura("raid" .. i, spellName2, nil);
    local _, _, _, _, _, _, _, _, _, _, aura_spellID3 = UnitAura("raid" .. i, spellName3, nil);
    local specID = GetInspectSpecialization('raid' .. i);
    local role = GetSpecializationRoleByID(specID);
    if aura_spellID0 == 181957 then
      table.insert(afectedByPhantasmalWinds, "raid" .. i);
      countPhantasmalWinds += 1;
    end;
    if aura_spellID1 == 182325 then
      table.insert(afectedByPhantasmalWounds, "raid" .. i);
      countPhantasmalWounds +=1;
    end;
    if aura_spellID2 == 181753 && role == "HEALER" then
      table.insert(afectedByFelBomb, "raid" .. i);
      countFelBomb += 1;
    end;
    if aura_spellID3 == 181824 && role == "TANK" then
      table.insert(afectedByPhantasmalCorruption, "raid" .. i);
      countPhantasmalCorruption += 1;
    end;
    if firstTank == nil && role == "TANK" then
      firstTank = "raid" .. i;
    end;
  end;
  
  if countFelBomb >= 1 then
    return afectedByFelBomb[1], 181753, "HEALER";
  end;
  if countPhantasmalCorruption >= 1 then
    return afectedByPhantasmalCorruption[1], 181824, "TANK";
  end;
  if countPhantasmalWounds >= 1 then
    return afectedByPhantasmalWounds[1], 182325, "ANY";
  end;
  if countPhantasmalWinds >= 1 then
    return afectedByPhantasmalWinds[1], 181957, "ANY";
  end;
  return "player", nil, "ANY";
end;

local anzu_name, _, anzu_icon = GetSpellInfo(179202); -- obtener el nombre del hechizo de ojo de anzu

local btn = CreateFrame("Button", "AnzuButton", UIParent, "SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate"));
  btn:SetMovable(true);
  btn:SetAttribute("type", "spell");
  btn:SetSize(ExtraActionButton1:GetSize());
  btn:SetScale(ExtraActionButton1:GetScale());
  btn:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]]);
  
  local ntex = btn:CreateTexture();
    ntex:SetTexture(anzu_icon);
  btn:SetNormalTexture(ntex);
  
  btn:SetScript('OnEvent', function(self, event, ...)
  	if(self[event]) then
  		self[event](self, event, ...);
  	end;
  end);
  
  btn:RegisterEvent('UNIT_AURA');
  function btn:UNIT_AURA(event, unit)
    if unit == "player" then
      local spell_name = GetSpellInfo(179202);
      local aura_name, _, _, _, _, _, _, _, _, _, aura_spellID = UnitAura("player", spell_name, nil);
      if aura_name ~= nil then
        target, spell, role = getWhoNeedsAnzu();
        if target ~= "player" then
          self:SetAttribute("spell", anzu_name, target);
        end; 
      end;
    end;
  end;
