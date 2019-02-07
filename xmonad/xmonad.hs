import Control.Monad
import System.IO

import XMonad
import XMonad.Util.SpawnOnce
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import XMonad.Prompt.AppendFile
import XMonad.Prompt.Window
import XMonad.Prompt.RunOrRaise
import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86
import XMonad.Util.Run

-- Layout related imports
import qualified XMonad.Layout.Fullscreen as FS
import XMonad.Layout.Maximize
import XMonad.Layout.Grid
import XMonad.Layout.Minimize
import XMonad.Layout.ResizableTile
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.TrackFloating
import XMonad.Layout.BoringWindows

-- Actions
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.UpdatePointer
import XMonad.Actions.Minimize
import XMonad.Actions.Warp

-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops


import qualified XMonad.StackSet as W
import XMonad.Util.NamedWindows
import XMonad.Util.NamedScratchpad
import Data.Time.Format
import Data.Time.LocalTime


-- Global Variables
myTerminal           = "urxvtc"
myNormalBorderColor  = "#cccccc"
myFocusedBorderColor = "#0000ff"
myModMask= mod4Mask
myFocusFollowsMouse :: Bool
myFocusFollowsMouse  = True
altMask              = mod1Mask

--Scratchpads
scratchpads = [
               NS "spad" "emacsclient -nc ~/.notes/scratchpad" (title =? "scratchpad") defaultFloating,
	       NS "terminal" "urxtc" (title =? "urxvt") defaultFloating
              ] 

-- My Key Combination
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList
       [ ((modm .|. controlMask, xK_x), shellPrompt myXPConfig)
       , ((modm, xK_F3               ), xmonadPrompt myXPConfig)
       , ((modm, xK_c                ), spawn $ XMonad.terminal conf)
       , ((0   , xK_Print            ), spawn "scrot")
       , ((modm, xK_semicolon        ), do
                   date <- io $ liftM (formatTime defaultTimeLocale "[%Y-%m-%d %H:%M] ") getZonedTime
                   appendFilePrompt' myXPConfig (date ++) $ "/home/abhinav/.scratch")
       , ((modm, xK_g                ), windowPrompt myXPConfig Goto wsWindows)
       , ((modm .|. shiftMask, xK_g  ), windowPrompt myXPConfig Goto allWindows)
       , ((modm .|. shiftMask, xK_b  ), windowPrompt myXPConfig Bring allWindows)
       , ((modm .|. shiftMask, xK_x  ), runOrRaisePrompt myXPConfig)
       , ((0,  xF86XK_MonBrightnessDown  ), spawn "xbacklight -dec 5")
       , ((0,  xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 5")
       , ((0,  xF86XK_AudioRaiseVolume  ), spawn "amixer  set Master 3%+")
       , ((0,  xF86XK_AudioLowerVolume  ), spawn "amixer  set Master 3%-")
       , ((0,  xF86XK_AudioMute         ), spawn "amixer  set Master toggle")
       , ((modm .|. shiftMask, xK_F11)   , safeSpawn "slock" [])
       , ((modm , xK_backslash)          , withFocused (sendMessage . maximizeRestore ))
       , ((modm,               xK_a     ), sendMessage MirrorShrink)
       , ((modm,               xK_z     ), sendMessage MirrorExpand)
       , ((modm, xK_v                   ), sendMessage $ ToggleStruts)
       , ((modm,               xK_m     ), withFocused minimizeWindow)
       , ((modm .|. shiftMask, xK_m     ), withLastMinimized maximizeWindow)
       , ((modm .|. shiftMask, xK_n     ), clearBoring)
       , ((modm, xK_b     )              , markBoring)
       , ((modm,               xK_j     ), focusDown)
       , ((modm,               xK_k     ), focusUp  )
       , ((modm .|. shiftMask, xK_Return), focusMaster)
       , ((modm, xK_slash)          , warpToWindow 0.98 0.98)
       , ((modm, xK_o)              , namedScratchpadAction scratchpads "spad")
       , ((modm .|. shiftMask, xK_t), namedScratchpadAction scratchpads "terminal")
       ]

-- XMonad.Promp Apperance
myXPConfig = def {
    font = "xft:Envy Code R:pixelsize=14",
    fgHLight = "#FFCC00",
    bgHLight = "#000000",
    bgColor = "#000000",
    borderColor = "#222222",
    height = 24,
    historyFilter = deleteConsecutive
}

-- XMobar Pretty printing configuration
myXMobarLogger handle = workspaceNamesPP def {
     ppOutput    = hPutStrLn handle,
     ppCurrent   = \wsID -> "<fc=#FFAF00>[" ++ wsID ++ "]</fc>",
     ppUrgent    = \wsID -> "<fc=#FF0000>" ++ wsID ++ "</fc>",
     ppSep       = " | ",
     ppTitle     = \wTitle -> "<fc=#92FF00>" ++ wTitle ++ "</fc>"
} >>= dynamicLogWithPP


-- Manage Hooks
myManageHook = composeAll
    [ className =? "Gimp"          --> doFloat
    , resource =? "desktop_window" --> doIgnore
    , isFullscreen                 --> doFullFloat
    ]

-- Layouts
myLayouts = avoidStruts $ maximize $ minimize $ boringWindows $ fullscreenFull ( myTile ||| Mirror myTile ||| Full ||| focused )
  where
      myTile = ResizableTall 1 (3/100) (1/2) []
      focused = gaps [(L,385), (R,385),(U,0),(D,10)]
                                         $ noBorders (FS.fullscreenFull Full)

-- Configuration
main = do
     xmobarPipe <- spawnPipe "xmobar -x 1 ~/.xmonad/xmobarrc"     
     xmonad $ ewmh $ withUrgencyHook dzenUrgencyHook { args = ["-bg", "blue", "-xs", "1"] } $ docks def{
       borderWidth        = 2
     , terminal		  = myTerminal
     , normalBorderColor  = myNormalBorderColor
     , focusedBorderColor = myFocusedBorderColor
     , modMask 		  = myModMask
     , keys 		  = myKeys <+> keys def
     , layoutHook	  = trackFloating (myLayouts)
     , focusFollowsMouse  = myFocusFollowsMouse
     , handleEventHook    = handleEventHook def <+> FS.fullscreenEventHook
     , logHook            = myXMobarLogger xmobarPipe
     , manageHook         = (myManageHook) <+> (namedScratchpadManageHook scratchpads)
     , startupHook        = setWMName "LG3D"
    
}
