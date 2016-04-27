function getWhoNeedsAnzu()
  local afectedByPhantasmalWinds = {}
  local countPhantasmalWinds = 0
  local afectedByPhantasmalWounds = {}
  local countPhantasmalWounds = 0
  local afectedByFelBomb = {}
  local countFelBomb = 0
  local afectedByPhantasmalCorruption = {}
  local countPhantasmalCorruption = 0
  local firstHealer = nil
  local _, _, _, playerClassIndex = pcall(UnitClass, "player") -- [1-11|0]
  local _, playerSpec = pcall(UnitGroupRolesAssigned, "player")
  local _, raidIndex = pcall(UnitInRaid, "player") -- [1-40|nil]
  
  local enumClasses = {
    none = 0,
    warrior = 1,
    paladin = 2,
    hunter = 3,
    rogue = 4,
    priest = 5,
    deathKnight = 6,
    shaman = 7,
    mage = 8,
    warlock = 9,
    monk = 10,
    druid = 11
  }

  local enumIskarBuffs = {
    phantasmalWinds = GetSpellInfo(181957), -- Vientos Fantasmales/Phantasmal Winds
    phantasmalWounds = GetSpellInfo(182325), -- Heridas Fantasmales/Phantasmal Wounds
    felBomb = GetSpellInfo(181753), -- Bomba vil/Fel Bomb
    phantasmalCorruption = GetSpellInfo(181824), -- Corrupción fantasmal/Phantasmal Corruption
    eyeOfAnzu = GetSpellInfo(179202) -- Ojo de Anzu/Eye of Anzu
  }

  for i = 1, GetNumGroupMembers() do
    print("entro>" .. i)
    local _, aura_spell0 = pcall(UnitDebuff, "raid" .. i, enumIskarBuffs.phantasmalWinds)
    print("phantasmalWinds>" .. aura_spell0)
    local _, aura_spell1 = pcall(UnitDebuff, "raid" .. i, enumIskarBuffs.phantasmalWounds)
    print("phantasmalWounds>" .. aura_spell1)
    local _, aura_spell2 = pcall(UnitDebuff, "raid" .. i, enumIskarBuffs.felBomb)
    print("felBomb>" .. aura_spell2)
    local _, aura_spell3 = pcall(UnitDebuff, "raid" .. i, enumIskarBuffs.phantasmalCorruption)
    print("phantasmalCorruption>" .. aura_spell3)
    local _, role = pcall(UnitGroupRolesAssigned, "raid" .. i)
    if aura_spell0 ~= nil then
      print("<phantasmalWinds")
      if raidIndex == i then
        table.insert(afectedByPhantasmalWinds, "player")
      else
        table.insert(afectedByPhantasmalWinds, "raid" .. i)
      end
      countPhantasmalWinds = countPhantasmalWinds + 1
    end
    if aura_spell1 ~= nil then
      print("<phantasmalWounds")
      if raidIndex == i then
        table.insert(afectedByPhantasmalWounds, "player")
      else
        table.insert(afectedByPhantasmalWounds, "raid" .. i)
      end
      countPhantasmalWounds = countPhantasmalWounds + 1
    end
    if aura_spell2 ~= nil then
      print("<felBomb")
      if raidIndex == i then
        table.insert(afectedByFelBomb, "player")
      else
        table.insert(afectedByFelBomb, "raid" .. i)
      end
      countFelBomb = countFelBomb + 1
    end
    if aura_spell3 ~= nil and role == "TANK" then
      print("<phantasmalCorruption")
      if raidIndex == i then
        table.insert(afectedByPhantasmalCorruption, "player")
      else
        table.insert(afectedByPhantasmalCorruption, "raid" .. i)
      end
      countPhantasmalCorruption = countPhantasmalCorruption + 1
    end
    if firstHealer == nil then
      if role == "HEALER" then
        if raidIndex == i then
          firstHealer = "player"
        else
          firstHealer = "raid" .. i
        end
      end
    end
  end
  print("Pre-retorno de valores")
  if countFelBomb >= 1 then
    print("<countFelBomb")
    local _, anzuAuraName = pcall(UnitAura, "player", enumIskarBuffs.eyeOfAnzu, nil)
    if anzuAuraName ~= nil then
      if playerSpec == "HEALER" then
        if playerClassIndex == enumClasses.druid then
          return afectedByFelBomb[1], enumIskarBuffs.felBomb, "HEALER", 88423
        elseif playerClassIndex == enumClasses.priest then
          return afectedByFelBomb[1], enumIskarBuffs.felBomb, "HEALER", 527
        elseif playerClassIndex == enumClasses.paladin then
          return afectedByFelBomb[1], enumIskarBuffs.felBomb, "HEALER", 4987
        elseif playerClassIndex == enumClasses.shaman then
          return afectedByFelBomb[1], enumIskarBuffs.felBomb, "HEALER", 77130
        elseif playerClassIndex == enumClasses.monk then
          return afectedByFelBomb[1], enumIskarBuffs.felBomb, "HEALER", 115450
        end
      end
    else
      for key, value in ipairs(afectedByFelBomb) do
        local _, vR = pcall(UnitGroupRolesAssigned, "raid" .. i)
        if vR == "HEALER" then
          if value ~= "player" then
            return value, enumIskarBuffs.felBomb, "ANY", nil
          end
        end
      end
    end
    return firstHealer, enumIskarBuffs.felBomb, "ANY", nil
  end
  if countPhantasmalCorruption >= 1 then
    print("<countPhantasmalCorruption")
    return afectedByPhantasmalCorruption[1], enumIskarBuffs.phantasmalCorruption, "TANK", nil
  end
  if countPhantasmalWounds >= 1 then
    print("<countPhantasmalWounds")
    return afectedByPhantasmalWounds[1], enumIskarBuffs.phantasmalWounds, "ANY", nil
  end
  if countPhantasmalWinds >= 1 then
    print("<countPhantasmalWinds")
    return afectedByPhantasmalWinds[1], enumIskarBuffs.phantasmalWinds, "ANY", nil
  end
    print("<default return")
  return "player", nil, "ANY", nil
end

local btn = CreateFrame("Button", "AnzuButton", UIParent, "SecureActionButtonTemplate,SecureHandlerStateTemplate,SecureHandlerAttributeTemplate")

  local anzu_name, _, anzu_icon = GetSpellInfo(179202) -- obtener el nombre del hechizo de ojo de anzu
  btn:SetMovable(true)
  btn:SetSize(30,30)
  btn:RegisterForDrag("LeftButton")
  --btn:SetScale(ExtraActionButton1:GetScale())
  btn:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  btn:SetHighlightTexture("Interface\Buttons\ButtonHilight-Square")
  btn:SetNormalTexture(anzu_icon)
  btn:Show()
  
  btn:SetScript("OnDragStart", function(self, button)
    self:StartMoving()
  end)
  btn:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
  end)
  
  btn:RegisterEvent("PLAYER_LOGIN")
  btn:RegisterEvent('UNIT_AURA')
  
  btn:SetScript('OnEvent', function(self, event, ...)
    if(self[event]) then
      self[event](self, event, ...)
    end
  end)

  function btn:UNIT_AURA(event, unit)
    if unit == "player" then
      local enumIskarBuffs = {
        phantasmalWinds = GetSpellInfo(181957), -- Vientos Fantasmales/Phantasmal Winds
        phantasmalWounds = GetSpellInfo(182325), -- Heridas Fantasmales/Phantasmal Wounds
        felBomb = GetSpellInfo(181753), -- Bomba vil/Fel Bomb
        phantasmalCorruption = GetSpellInfo(181824), -- Corrupción fantasmal/Phantasmal Corruption
        eyeOfAnzu = GetSpellInfo(179202) -- Ojo de Anzu/Eye of Anzu
      }
      local _, aura_name = pcall(UnitAura, "player", enumIskarBuffs.eyeOfAnzu, nil)
      if aura_name ~= nil then
        print("tengo el ojo")
        local target, iskarSpell, role, dispellID = getWhoNeedsAnzu()
        local targetName = UnitName(target)
        print("El objetivo es " .. target .. " con el bufo " .. iskarSpell)
        if iskarSpell == enumIskarBuffs.felBomb and role == "HEALER" then
          local dispellName, _, dispellIcon = GetSpellInfo(dispellID)
          self:SetNormalTexture(dispellIcon)
          self:SetAttribute("type", "spell")
          self:SetAttribute("spell", dispellName, target)
        elseif target ~= "player" then
          self:SetAttribute("type", "macro")
          self:SetAttribute("macrotext", string.format("/targetexact %s\n/click ExtraActionButton1\n/targetlasttarget", targetName))
        end
      else
        self:SetNormalTexture(anzu_icon)
        self:SetAttribute("type", nil)
        self:SetAttribute("spell", nil, nil)
        self:SetAttribute("macrotext", nil)
      end
    end
  end
