function getListAnzuPriority()
  local memberNeedAnzu = {};
  local afectedByPhantasmalWinds = {};
  local afectedByPhantasmalWounds = {};
  local afectedByFelBomb = {};
  local afectedByPhantasmalCorruption = {};
  local memberHasAnzu = nil;
  local anzuAuraPosition = nil;
  for i = 1, GetNumGroupMembers() do 
    for b = 1, 40 do 
      local _, _, _, _, _, _, _, _, _, _, aura_spellID = UnitAura("raid" .. i, b);
      local specID = GetInspectSpecialization('raid' .. i);
      local role = GetSpecializationRoleByID(specID);
      if aura_spellID == 181957 then -- Vientos Fantasmales/Phantasmal Winds
        memberNeedAnzu["raid" .. i] = 181957;
        break;
      elseif aura_spellID == 182325 then -- Heridas Fantasmales/Phantasmal Wounds
        memberNeedAnzu["raid" .. i] = 182325;
        break;
      elseif aura_spellID == 181753 && role == "HEALER" then -- Bomba vil/Fel Bomb
        memberNeedAnzu["raid" .. i] = 181753;
        break;
      end;
      elseif aura_spellID == 181824 && role == "TANK" then -- Corrupción fantasmal/Phantasmal Corruption
        memberNeedAnzu["raid" .. i] = 181824;
        break;
      elseif aura_spellID == 179202 then -- Ojo de Anzu/Eye of Anzu
        memberHasAnzu = "raid" .. i;
        anzuAuraPosition = b;
        break;
      end;
    end;
  end;
end;

local anzu_name, _, anzu_icon = GetSpellInfo(179202); -- obtener el nombre del hechizo de ojo de anzu

local btn = CreateFrame("Button", "AnzuButton", UIParent, "SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate"));
  btn:SetAttribute("target", "spell");
  btn:SetAttribute("type", "spell");
  btn:SetAttribute("spell", anzu_name);
  btn:SetSize(ExtraActionButton1:GetSize());
	btn:SetScale(ExtraActionButton1:GetScale());
	btn:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]]);
	
	local ntex = btn:CreateTexture();
	  ntex:SetTexture(anzu_icon);
  btn:SetNormalTexture(ntex);
  
  

--SendChatMessage("Help - Need ANZU", "YELL", nil, nil);
