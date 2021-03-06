-- Fire Beetle
-----------------------------------------------------------------
local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

XRL0302 = Class(CWalkingLandUnit) {


    Weapons = {        
        Suicide = Class(CMobileKamikazeBombWeapon) {},
    },
    
    OnKilled = function(self, instigator, type, overkillRatio)
        self.FxDeath = EffectTemplate.CMobileKamikazeBombExplosion --adding the weapon explosion to death.
    
        local army = self:GetArmy() --if its weapon goes off it overlays twice. oh well. it doesnt look retarded anyway.
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self,-2,army,v)
        end
        
        CWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
    

    -- Allow the trigger button to blow the weapon, resulting in OnKilled instigator 'nil'
    OnProductionPaused = function(self)
        self:GetWeaponByLabel('Suicide'):FireWeapon()
    end,
    
    OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_CloakToggle', true)
        self:RequestRefreshUI()
    end
}

TypeClass = XRL0302