import XMonad
import XMonad.Core
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run

import System.IO
import Control.Monad

import qualified XMonad.StackSet as S

green = "#859900"     -- Solarized green
yellow = "#b58900"    -- Solarized yellow
blue = "#268bd2"      -- Solarized blue
red = "#dc322f"       -- Solarized red

xmonadConfig = desktopConfig {
    borderWidth = 1
  , normalBorderColor = "#586e75"
  , focusedBorderColor = "#839496"
  , terminal = "termite"

  , workspaces = ["1:code", "2:term", "3:web"] ++ map show [4..9]
}

xmobarLogHook :: Handle -> X ()
xmobarLogHook xmobarHandle = dynamicLogWithPP def {
    ppOutput = hPutStrLn xmobarHandle
  , ppSep = " | "
  , ppOrder = \(workspaces:_:title:_) -> [workspaces, title]

  , ppCurrent = xmobarColor blue "" . wrap "[" "]"
  , ppVisible = wrap "(" ")"
  , ppHidden = id
  , ppHiddenNoWindows = xmobarColor "#586e75" ""
  , ppUrgent = xmobarColor red yellow

  , ppTitle = xmobarColor green "" . shorten 50
}

-- Shift specified programs to the correct workspace when started
defaultAppWorkspaceManageHook :: ManageHook
defaultAppWorkspaceManageHook = composeAll
  [ className =? "Emacs"   --> viewShift "1:code"
  , className =? "Termite" --> viewShift "2:term"
  , className =? "Firefox" --> viewShift "3:web"
  ]
  where viewShift = doF . liftM2 (.) S.greedyView S.shift

main = do
  unsafeSpawn "feh --bg-tile ~/.xmonad/wallpapers/solarized_squares.png"
  xmobarHandle <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ xmonadConfig {
      logHook = do
        xmobarLogHook xmobarHandle
        logHook desktopConfig

    , manageHook = composeAll
        [ defaultAppWorkspaceManageHook
        , manageHook desktopConfig
        ]


    , layoutHook = desktopLayoutModifiers $ smartBorders $ smartSpacingWithEdge 3 $ Tall 1 (3/100) (1/2)
  }
