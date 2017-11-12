Config {
  -- appearance
  font = "xft:Hack-Bold:size=9:antialias=true",
  additionalFonts = [],
  bgColor = "#002b36",
  fgColor = "#839496",
  position = Top,
  border = BottomB,
  borderColor = "#586e75",

  -- general behavior
  lowerOnStart = True,   -- send to bottom of window stack on start
  hideOnStart = False,  -- start with window unmapped (hidden)
  allDesktops = True,   -- show on all desktops
  overrideRedirect = True,   -- set the Override Redirect flag (Xlib)
  pickBroadest = False,  -- choose widest display (multi-monitor)
  persistent = True,   -- enable/disable hiding (True = disabled)

  -- layout
  sepChar = "%",  -- delineator between plugin names and straight text
  alignSep = "}{", -- separator between left-right alignment
  template =  "%StdinReader% }{ | %battery% | %multicpu% | %coretemp% | %memory% | %dynnetwork% | %date%",

   -- plugins
  commands = [
    Run StdinReader

    -- battery monitor
    , Run Battery [
        "--template" , "Batt: <acstatus>"
      , "--Low"      , "10"        -- units: %
      , "--High"     , "80"        -- units: %
      , "--low"      , "#dc322f"    -- Solarized red
      , "--normal"   , "#cb4b16"    -- Solarized orange
      , "--high"     , "#859900"    -- Solarized green

      , "--"                                    -- battery specific options
      , "-o"	, "<left>% (<timeleft>)"        -- discharging status
      , "-O"	, "<fc=#268bd2>Charging</fc>"   -- AC "on" status
      , "-i"	, "<fc=#859900>Charged</fc>"    -- charged status
    ] 50
        -- cpu activity monitor
    , Run MultiCpu [
        "--template" , "Cpu: <total0>%/<total1>%"
      , "--Low"      , "50"         -- units: %
      , "--High"     , "85"         -- units: %
      , "--low"      , "#859900"    -- Solarized green
      , "--normal"   , "#cb4b16"    -- Solarized orange
      , "--high"     , "#dc322f"    -- Solarized red
    ] 10

    -- cpu core temperature monitor
    , Run CoreTemp [
        "--template" , "Temp: <core0>°C/<core1>°C"
      , "--Low"      , "70"        -- units: °C
      , "--High"     , "80"        -- units: °C
      , "--low"      , "#859900"    -- Solarized green
      , "--normal"   , "#cb4b16"    -- Solarized orange
      , "--high"     , "#dc322f"    -- Solarized red
    ] 50

        -- memory usage monitor
    , Run Memory [
        "--template" ,"Mem: <usedratio>%"
      , "--Low"      , "20"        -- units: %
      , "--High"     , "90"        -- units: %
      , "--low"      , "#859900"    -- Solarized green
      , "--normal"   , "#cb4b16"    -- Solarized orange
      , "--high"     , "#dc322f"    -- Solarized red
    ] 10

    -- network activity monitor (dynamic interface resolution)
    , Run DynNetwork [
        "--template" , "<dev>: <tx>kB/s/<rx>kB/s"
      , "--Low"      , "1000"      -- units: B/s
      , "--High"     , "5000"      -- units: B/s
      , "--low"      , "#859900"    -- Solarized green
      , "--normal"   , "#cb4b16"    -- Solarized orange
      , "--high"     , "#dc322f"    -- Solarized red
    ] 10

    , Run Date "%-I:%M %P. %F (%a)" "date" 10
  ]
}
