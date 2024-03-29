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

function TSAM.RestartMission()
  trigger.action.setUserFlag(9999, 1) 
end

MENU_COALITION_COMMAND:New(coalition.side.BLUE,"SA-10",nil,TSAM.RedIADS,"SA-10", false)  
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"SA-10 & SA15",nil,TSAM.RedIADS,"SA-10", true)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"SA-11",nil,TSAM.RedIADS,"SA-11", false)  
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"SA-11 & SA15",nil,TSAM.RedIADS,"SA-11", true)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Restart Mission",nil,TSAM.RestartMission)
  




