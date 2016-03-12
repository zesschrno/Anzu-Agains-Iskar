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
  local _, _, playerClassIndex = UnitClass("player")
  local playerSpec = GetSpecializationRoleByID(GetInspectSpecialization("player"))
  print("log1")
  local s0 = GetSpellInfo(181957)
  local s1 = GetSpellInfo(182325)
  local s2 = GetSpellInfo(181753)
  local s3 = GetSpellInfo(181824)
  local s4 = GetSpellInfo(179202)
  local enumIskarBuffs = {
    phantasmalWinds = s0, -- Vientos Fantasmales/Phantasmal Winds
    phantasmalWounds = s1, -- Heridas Fantasmales/Phantasmal Wounds
    felBomb = s2, -- Bomba vil/Fel Bomb
    phantasmalCorruption = s3, -- Corrupción fantasmal/Phantasmal Corruption
    eyeOfAnzu = s4 -- Ojo de Anzu/Eye of Anzu
  }
  print("log2")
  
  
  
  local raidIndex = UnitInRaid("player") -- [1-40|nil]
  local _, _, classIndex = UnitClass("player") -- [1-11|0]
  print("log3")
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
  print("log4")
  for i = 1, GetNumGroupMembers() do
    local aura_spell0, _, _, _, _, _, _, _, _, _, aura_spellID0 = UnitAura("raid" .. i, enumIskarBuffs.phantasmalWinds, nil)
    print("phantasmalWinds" .. aura_spellID0)
    local aura_spell1, _, _, _, _, _, _, _, _, _, aura_spellID1 = UnitAura("raid" .. i, enumIskarBuffs.phantasmalWounds, nil)
    print("phantasmalWounds" .. aura_spellID1)
    local aura_spell2, _, _, _, _, _, _, _, _, _, aura_spellID2 = UnitAura("raid" .. i, enumIskarBuffs.felBomb, nil)
    print("felBomb" .. aura_spellID2)
    local aura_spell3, _, _, _, _, _, _, _, _, _, aura_spellID3 = UnitAura("raid" .. i, enumIskarBuffs.phantasmalCorruption, nil)
    print("phantasmalCorruption" .. aura_spellID3)
    local role = GetSpecializationRoleByID(GetInspectSpecialization('raid' .. i))
    if aura_spell0 == enumIskarBuffs.phantasmalWinds then
      print("phantasmalWinds")
      if raidIndex == i then
        table.insert(afectedByPhantasmalWinds, "player")
      else
        table.insert(afectedByPhantasmalWinds, "raid" .. i)
      end
      countPhantasmalWinds = countPhantasmalWinds + 1
    end
    if aura_spell1 == enumIskarBuffs.phantasmalWounds then
      print("phantasmalWounds")
      if raidIndex == i then
        table.insert(afectedByPhantasmalWounds, "player")
      else
        table.insert(afectedByPhantasmalWounds, "raid" .. i)
      end
      countPhantasmalWounds = countPhantasmalWounds + 1
    end
    if aura_spell2 == enumIskarBuffs.felBomb then
      print("felBomb")
      if raidIndex == i then
        table.insert(afectedByFelBomb, "player")
      else
        table.insert(afectedByFelBomb, "raid" .. i)
      end
      countFelBomb = countFelBomb + 1
    end
    if aura_spell3 == enumIskarBuffs.phantasmalCorruption and role == "TANK" then
      print("phantasmalCorruption")
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
    print("countFelBomb")
    local anzuAuraName = UnitAura("player", enumIskarBuffs.eyeOfAnzu, nil)
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
      for key, value in pairs(afectedByFelBomb) do
        if GetSpecializationRoleByID(GetInspectSpecialization(value)) == "HEALER" then
          if value ~= "player" then
            return value, enumIskarBuffs.felBomb, "ANY", nil
          end
        end
      end
    end
    return firstHealer, enumIskarBuffs.felBomb, "ANY", nil
  end
  if countPhantasmalCorruption >= 1 then
    print("countPhantasmalCorruption")
    return afectedByPhantasmalCorruption[1], enumIskarBuffs.phantasmalCorruption, "TANK", nil
  end
  if countPhantasmalWounds >= 1 then
    print("countPhantasmalWounds")
    return afectedByPhantasmalWounds[1], enumIskarBuffs.phantasmalWounds, "ANY", nil
  end
  if countPhantasmalWinds >= 1 then
    print("countPhantasmalWinds")
    return afectedByPhantasmalWinds[1], enumIskarBuffs.phantasmalWinds, "ANY", nil
  end
    print("default return")
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
  
  btn:SetScript('OnLoad', function(self)
    print('Me estoy cargando')
  end)
  btn:SetScript('OnShow', function(self)
    print('Me estoy mostrando')
  end)
  btn:SetScript("OnDragStart", function(self)
    self.StartMoving()
  end)
  btn:SetScript("OnDragStop", function(self)
    self.StopMovingOrSizing()
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
      local s0 = GetSpellInfo(181957)
      local s1 = GetSpellInfo(182325)
      local s2 = GetSpellInfo(181753)
      local s3 = GetSpellInfo(181824)
      local s4 = GetSpellInfo(179202)
      local enumIskarBuffs = {
        phantasmalWinds = s0, -- Vientos Fantasmales/Phantasmal Winds
        phantasmalWounds = s1, -- Heridas Fantasmales/Phantasmal Wounds
        felBomb = s2, -- Bomba vil/Fel Bomb
        phantasmalCorruption = s3, -- Corrupción fantasmal/Phantasmal Corruption
        eyeOfAnzu = s4 -- Ojo de Anzu/Eye of Anzu
      }
      local aura_name, _, _, _, _, _, _, _, _, _, aura_spellID = UnitAura("player", enumIskarBuffs.eyeOfAnzu, nil)
      if aura_name ~= nil then
        print("tengo el ojo")
        local target, iskarSpell, role, dispellID = getWhoNeedsAnzu()
        print("El objetivo es " .. target .. " con el bufo " .. iskarSpell)
        if iskarSpell == enumIskarBuffs.felBomb and role == "HEALER" then
          local dispellName, _, dispellIcon = GetSpellInfo(dispellID)
          self:SetAttribute("type", "spell")
          self:SetNormalTexture(dispellIcon)
          self:SetAttribute("spell", dispellName, target)
          self:SetAttribute("type", nil)
          self:SetAttribute("spell", nil, nil)
          self:SetNormalTexture(anzu_icon)
        elseif target ~= "player" then
          TargetUnit(target)
          self:SetAttribute("target", target)
          self:SetAttribute("type", "click")
          self:SetAttribute("click", "ExtraActionButton1")
          self:SetAttribute("target", nil)
          self:SetAttribute("type", nil)
          self:SetAttribute("click", nil)
        end
      end
    end
  end
