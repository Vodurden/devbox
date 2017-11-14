import XMonad
import XMonad.Core
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run

import System.IO

green = "#859900"     -- Solarized green
yellow = "#b58900"    -- Solarized yellow
blue = "#268bd2"      -- Solarized blue
red = "#dc322f"       -- Solarized red

xmonadConfig = desktopConfig {
  borderWidth = 1,
  normalBorderColor = "#586e75",
  focusedBorderColor = "#839496",
  terminal = "termite",
  layoutHook = desktopLayoutModifiers $ smartBorders $ smartSpacingWithEdge 3 $ Tall 1 (3/100) (1/2)
}

xmobarLogHook :: Handle -> X ()
xmobarLogHook xmobarHandle = dynamicLogWithPP def {
    ppOutput = hPutStrLn xmobarHandle
  , ppSep = " | "
  , ppOrder = \(workspaces:_:title:_) -> [workspaces, title]

  , ppCurrent = xmobarColor blue "" . wrap "[" "]"
  , ppVisible = wrap "(" ")"
  , ppUrgent = xmobarColor red yellow

  , ppTitle = xmobarColor green "" . shorten 50
}

main = do
  unsafeSpawn "feh --bg-tile ~/.xmonad/wallpapers/solarized_squares.png"
  xmobarHandle <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ xmonadConfig {
    logHook = do
      xmobarLogHook xmobarHandle
      logHook desktopConfig
  }
