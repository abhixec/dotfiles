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
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Input
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
import XMonad.Layout.Tabbed 
import XMonad.Layout.ThreeColumns

-- Testing stuff
import XMonad.Layout.Accordion (Accordion(..))
import XMonad.Layout.Reflect (reflectVert)
import XMonad.Layout.TwoPane (TwoPane(..))
import XMonad.Layout.Master (mastered)
import XMonad.Layout.Spacing (Border(..), spacingRaw)
import XMonad.Layout.CenteredMaster
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Grid
import XMonad.Layout.CenteredMaster

-- Actions
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.UpdatePointer
import XMonad.Actions.Minimize
import XMonad.Actions.Warp
import XMonad.Actions.CycleWS

import qualified XMonad.Layout.Spacing as Spacing
import qualified XMonad.Layout.BinarySpacePartition as BSP
import XMonad.Layout.BinarySpacePartition
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
import Data.List
import Data.Char (isSpace)

-- Global Variables
myTerminal           = "urxvtc"
myNormalBorderColor  = "#cccccc"
myFocusedBorderColor = "#0000ff"
myModMask= mod4Mask
myFocusFollowsMouse :: Bool
myFocusFollowsMouse  = False
altMask              = mod1Mask

--Rofi
launcherString = "rofi -combi-modi window,drun,ssh,run -show combi -modi combi -show drun -show-icons -drun-icon-theme -matching fuzzy -theme android_notification"
--Scratchpads
scratchpads = [
               NS "emacs" "emacsclient -nc --frame-parameters='(quote (name . \"floatingemacs\"))'" (title =? "floatingemacs") (customFloating $ W.RationalRect (2/6) (2/6) (1/4) (1/3)),
               NS "terminal" "urxvtc -title 'floatingterm' -e tmux" (title =? "floatingterm") defaultFloating
              ] 

dtXPConfig :: XPConfig
dtXPConfig = def
      { font                = "xft:Iosevka Medium:regular:size=10:antialias=true:hinting=true"
      , bgColor             = "#282c34"
      , fgColor             = "#bbc2cf"
      , bgHLight            = "#c792ea"
      , fgHLight            = "#000000"
      , borderColor         = "#535974"
      , promptBorderWidth   = 0
      , position            = Top
--    , position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 }
      , height              = 20
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      -- , searchPredicate     = isPrefixOf
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Nothing      -- set to Just 5 for 5 rows
      }

dtXPConfig' :: XPConfig
dtXPConfig' = dtXPConfig
      { autoComplete        = Nothing
      }

calcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "qalc" [input] "") >>= calcPrompt c
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace


-- My Key Combination
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ 
       [ ((modm .|. controlMask, xK_x), shellPrompt myXPConfig)
       , ((modm .|. shiftMask, xK_p)  , calcPrompt dtXPConfig' "qalc")
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
       , ((0,  xF86XK_MonBrightnessDown  ), spawn "xbacklight -dec 10")
       , ((0,  xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 10")
       , ((0,  xF86XK_AudioRaiseVolume  ), spawn "amixer  set Master 3%+")
       , ((0,  xF86XK_AudioLowerVolume  ), spawn "amixer  set Master 3%-")
       , ((0,  xF86XK_AudioMute         ), spawn "amixer  set Master toggle")
       , ((0,  xF86XK_AudioMicMute      ), spawn "amixer set Capture toggle")
       , ((modm .|. shiftMask, xK_F11)   , safeSpawn "slock" [])
       , ((modm , xK_backslash)          , withFocused (sendMessage . maximizeRestore ))
       , ((modm,               xK_n     ), sendMessage MirrorShrink)
       , ((modm,               xK_o     ), sendMessage MirrorExpand)
       , ((modm, xK_v                   ), sendMessage $ ToggleStruts)
       , ((modm,               xK_m     ), withFocused minimizeWindow)
       , ((modm .|. shiftMask, xK_m     ), withLastMinimized maximizeWindow)
       , ((modm .|. shiftMask, xK_n     ), clearBoring)
       , ((modm, xK_b     )              , markBoring)
       , ((modm,               xK_e     ), focusDown)
       , ((modm,               xK_i     ), focusUp  )
       , ((modm .|. shiftMask, xK_i     ), windows W.swapUp   )
       , ((modm .|. shiftMask, xK_e     ), windows W.swapDown )
       , ((modm .|. shiftMask, xK_Return), focusMaster)
       , ((modm, xK_grave), toggleWS' ["NSP"])
       , ((modm, xK_slash)          , warpToWindow 0.98 0.98)
       , ((modm, xK_s)              , namedScratchpadAction scratchpads "emacs")
       , ((modm .|. shiftMask, xK_t), namedScratchpadAction scratchpads "terminal")
       -- Use arrows to move to workspaces next and previous
       , ((modm, xK_Right), nextWS)
       , ((modm, xK_Left), prevWS)
       , ((modm .|. shiftMask, xK_o), withFocused centerWindow)
       , ((modm, xK_p), spawn launcherString)
       ]
       ++
        [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_f, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- XMonad.Promp Apperance
myXPConfig = def {
    font = "xft:Envy Code R:pixelsize=14",
    fgHLight = "#FFCC00",
    bgHLight = "#000000",
    bgColor = "#000000",
    borderColor = "#222222",
    height = 24,
    historyFilter = deleteConsecutive,
    searchPredicate = fuzzyMatch
}
-- Center float
centerWindow :: Window -> X ()
centerWindow win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
    return ()

-- If the window is floating then (f), if tiled then (n)
floatOrNot f n = withFocused $ \windowId -> do
                             floats <- gets (W.floating . windowset);
                             if windowId `M.member` floats -- if the current window is floating...
                               then f
                               else n

-- Get the windows in the current workspace
windowCount :: X String
windowCount = gets $ show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

--Float
toggleFloat = floatOrNot (withFocused $ windows . W.sink) (withFocused centerWindow)

-- XMobar Pretty printing configuration
myXMobarLogger handle = do
 winCount <- windowCount
 workspaceNamesPP def {
    ppOutput    = hPutStrLn handle,
    ppCurrent   = \wsID -> "<fc=#FFAF00>[" ++ wsID ++ "](" ++ winCount ++")</fc>",
    ppUrgent    = \wsID -> "<fc=#FF0000>" ++ wsID ++ "</fc>",
    ppSep       = " | ",
    ppTitle     = \wTitle -> "<fc=#9076FF>" ++ wTitle ++ "</fc>"
   } >>= dynamicLogWithPP

-- IntelliJ fix
(~=?) :: Eq a => Query [a] -> [a] -> Query Bool
q ~=? x = fmap (isInfixOf x) q

manageIdeaCompletionWindow = (className =? "jetbrains-studio") <&&> (title ~=? "win") --> doIgnore

-- Manage Hooks
myManageHook = composeAll
    [
    -- className =? "Gimp"          --> doFloat
      resource =? "desktop_window" --> doIgnore
    , isFullscreen                 --> doFullFloat
    , isDialog                     --> doFloat
    , appName =? "galculator"    --> doFloat
    , appName =? "speedcrunch" --> doFloat
    , appName =? "xpad"            --> doFloat
    , stringProperty "_NET_WM_NAME" =? "Emulator" --> doFloat
    ]

-- Layouts
myLayouts = avoidStruts $ maximize $ minimize $ boringWindows $ fullscreenFull ( myTile ||| Mirror myTile ||| Full ||| focused ||| ThreeColMid 1 (3/100) (1/2) ||| simpleTabbed ||| TwoPane(15/100) (55/100) ||| simplestFloat )
  where
     -- uniformBorder n = Border n n n n
     -- spacing = spacingRaw False (uniformBorder 0) False (uniformBorder 10) True
     -- twoCols = spacing $ mastered (1/100) (1/2) Accordion

      myTile = ResizableTall 1 (3/100) (1/2) []
      focused = gaps [(L,385), (R,385),(U,0),(D,10)]
                                         $ noBorders (FS.fullscreenFull Full)


-- Configuration
main = do
     xmobarPipe <- spawnPipe "xmobar -x 1 ~/.xmonad/xmobarrc"     
     xmonad $ ewmh $ withUrgencyHook dzenUrgencyHook { args = ["-bg", "blue", "-xs", "1"] } $ docks def{
       borderWidth        = 2
     , terminal           = myTerminal
     , normalBorderColor  = myNormalBorderColor
     , focusedBorderColor = myFocusedBorderColor
     , modMask            = myModMask
     , keys               = myKeys <+> keys def
     , layoutHook         = trackFloating (myLayouts)
     , focusFollowsMouse  = myFocusFollowsMouse
     , handleEventHook    = handleEventHook def <+> FS.fullscreenEventHook
     , logHook            = myXMobarLogger xmobarPipe
     , manageHook         = (myManageHook) <+> (namedScratchpadManageHook scratchpads) <+> manageIdeaCompletionWindow
     , startupHook        = setWMName "LG3D"
    
}