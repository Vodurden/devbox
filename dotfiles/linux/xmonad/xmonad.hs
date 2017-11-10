import XMonad
import XMonad.Layout.NoBorders

main = xmonad $ defaultConfig
    { borderWidth        = 0
    , terminal           = "termite" }
