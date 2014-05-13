import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Spiral
import qualified XMonad.StackSet as W
import qualified Data.Map        as M


myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Tkzgram"      --> doZephyr
    ]

--doZephyr = ask >>= \w -> doF . W.float w . snd =<< liftX (floatLocation w)
doZephyr = do
	    w <- ask
	    (_, x) <- liftX (floatLocation w)
	    doF $ W.focusDown . W.float w x


main = do
    xmproc <- spawnPipe "/contrib/projects/xmobar/xmobar-0.9.2.bin /home/oolivo/.xmobarrc"
    xmonad $ defaultConfig
        {terminal           = "gnome-terminal"
	, manageHook = manageDocks <+> manageHook defaultConfig <+> myManageHook
	,layoutHook = avoidStruts $ layoutHook defaultConfig
	, logHook = dynamicLogWithPP $ xmobarPP
			{ppOutput = hPutStrLn xmproc
			 , ppTitle = xmobarColor "green" "" . shorten 50
			}
        } `additionalKeys`
        [
	((mod1Mask .|. controlMask, xK_l), spawn "xlock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        ]
