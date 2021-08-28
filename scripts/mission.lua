rIADS = nil
TSAM = {}
TSAM.ActiveSite = {}


function TSAM.RedIADS(samType, withPointDefence)

  local samSite = "rSAM-" .. samType

  if rIADS == nil then
    env.info("rIADS == nil")
    if TSAM.ActiveSite.SAM == nil then
      env.info("TSAM.ActiveSite.SAM == nil")
      TSAM.ActiveSite.SAM = SPAWN:New(samSite):Spawn()
      if withPointDefence then
        TSAM.ActiveSite.PD = SPAWN:New("rSAM-SA-15"):Spawn()
      end
    end
    
    rIADS = SkynetIADS:create('Training SAM')
    rIADS:setUpdateInterval(5)
    rIADS:addEarlyWarningRadarsByPrefix('rEWR')
    rIADS:addSAMSitesByPrefix('rSAM')
    rIADS:getSAMSitesByNatoName(samSite):setGoLiveRangeInPercent(80)
    
    if samSite == "SA-10" then
      rIADS:getSAMSitesByNatoName(samSite):setActAsEW(true)
    end
      
    if  withPointDefence then
      local sa15 = rIADS:getSAMSitesByNatoName('SA-15')
      sa15:setGoLiveRangeInPercent(100)
      rIADS:getSAMSitesByNatoName(samSite):addPointDefence(sa15)
    end
      
    rIADS:addRadioMenu()
    rIADS:activate()   
       
  else
    _msg = "IADS is already active. Restart mission to reset."
    MESSAGE:New(_msg):ToAll()
  end
  
end

--TSAM.Menu = MENU_COALITION:New(coalition.side.BLUE,"Activate SAM System")
TSAM.MenuCommandSA10 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"SA-10",nil,TSAM.RedIADS,"SA-10", false)  
TSAM.MenuCommandSA10PD = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"SA-10 & SA15",nil,TSAM.RedIADS,"SA-10", true)
TSAM.MenuCommandSA11 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"SA-11",nil,TSAM.RedIADS,"SA-11", false)  
TSAM.MenuCommandSA11PD = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"SA-11 & SA15",nil,TSAM.RedIADS,"SA-11", true)
  




