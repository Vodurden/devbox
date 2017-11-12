import XMonad
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run

xmonadConfig = desktopConfig {
  borderWidth = 1,
  normalBorderColor = "#586e75",
  focusedBorderColor = "#839496",
  terminal = "termite",
  layoutHook = desktopLayoutModifiers $ smartBorders $ smartSpacingWithEdge 3 $ Tall 1 (3/100) (1/2)
}

main = do
  unsafeSpawn "feh --bg-tile ~/.xmonad/wallpapers/black_squares_tileable.png"
  xmobarProc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ xmonadConfig {
    logHook = do
        dynamicLogWithPP xmobarPP {
          ppOutput = hPutStrLn xmobarProc
        }
        logHook desktopConfig
  }
