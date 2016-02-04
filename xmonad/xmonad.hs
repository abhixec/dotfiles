-- 
-- xmonad example config file.  
-- 
-- A template showing all available configuration hooks, 
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
import Control.Monad (liftM2)
import System.IO
import System.Exit

import XMonad
-- Window Arranger
--import XMonad.Layout.WindowArranger
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.CycleWS 
import XMonad.Layout.TrackFloating
import XMonad.Actions.Warp
import XMonad.Actions.WorkspaceNames
import XMonad.Layout.Minimize
import XMonad.Layout.Maximize
import XMonad.Layout.StackTile
import XMonad.Hooks.DynamicLog
--import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Named
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Window
import XMonad.Prompt.AppendFile
import XMonad.Util.Run
import Data.Monoid
import Data.List
import qualified XMonad.Layout.Fullscreen as FS
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps 
import XMonad.Layout.NoBorders 
import XMonad.Hooks.SetWMName 
import XMonad.Layout.ResizableTile
import XMonad.Util.EZConfig
import XMonad.Layout.PerWorkspace
import XMonad.Actions.UpdatePointer
import Graphics.X11.ExtraTypes.XF86
import XMonad.Layout.BoringWindows
---- Simple Float
--import XMonad.Layout.SimpleFloat 
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "urxvtc"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1
-- XMonad.Prompt Appearance
myXPConfig = defaultXPConfig {
   font = "xft:Envy Code R:pixelsize=14",
    fgHLight = "#FFCC00",
    bgHLight = "#000000",
    bgColor = "#000000",
    borderColor = "#222222",
    height = 24,

    historyFilter = deleteConsecutive
}



-- XMonad.Layout.Tabbed appearance
myTabTheme = defaultTheme {
    fontName = "xft:Envy Code R:pixelsize=12",
    inactiveColor = "#333333",
    activeColor = "#00CCFF",
    activeTextColor = "#000000", inactiveTextColor = "#BDBDBD" 
}

-- XMobar pretty printing configuration
myXMobarLogger handle = workspaceNamesPP defaultPP {
    ppOutput    = hPutStrLn handle,
    ppCurrent   = \wsID -> "<fc=#FFAF00>[" ++ wsID ++ "]</fc>",
    ppUrgent    = \wsID -> "<fc=#FF0000>" ++ wsID ++ "</fc>",
    ppSep       = " | ",
    ppTitle     = \wTitle -> "<fc=#92FF00>" ++ wTitle ++ "</fc>"
} >>= dynamicLogWithPP
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#0000ff"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm , xK_c), spawn $ XMonad.terminal conf)
   -- [((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal xconfig)

    -- Goto Window
    , ((modm .|. shiftMask, xK_g     ), windowPromptGoto $ defaultXPConfig {searchPredicate =isInfixOf})
    , ((modm .|. shiftMask, xK_b     ), windowPromptBring defaultXPConfig)
    -- , ((modm .|. shiftMask, xK_g     ), windowPromptGoto defaultXPConfig { autoComplete = Just 500000 } )
    -- close focused window
    , ((modm , xK_x     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    --, ((modm,               xK_Tab   ), windows W.focusDown)
    --, ((modm .|. shiftMask,               xK_Tab   ), windows W.focusUp)

    -- Move focus to the next window
    , ((modm,               xK_j     ), focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), focusUp  )

    -- Move focus to the master window
    , ((modm .|. shiftMask,  xK_Return    ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    ,((modm, xK_backslash), withFocused $ sendMessage . maximizeRestore) 
    -- Minimize
    , ((modm,               xK_m     ),withFocused minimizeWindow  )
    , ((modm .|. shiftMask, xK_m     ), sendMessage RestoreNextMinimizedWin)
    , ((modm .|. shiftMask, xK_n     ), clearBoring)
    , ((modm , xK_n     ), markBoring)
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- dEIncrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Mouse Management.
    , ((modm, xK_b), warpToWindow 0.98 0.98) -- Banish mouse to the lower right corner of the screen.

    -- Printscreen
    ,((0, xK_Print), spawn "scrot")


    -- Resize the tiles vertically
    , ((modm,               xK_a     ), sendMessage MirrorShrink)
    , ((modm,               xK_z     ), sendMessage MirrorExpand)
    -- Multimedia bindings
    -- 
    , ((0,  xF86XK_MonBrightnessDown  ), spawn "xbacklight -dec 5")
    , ((0,  xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 5")
    , ((0,  xF86XK_AudioRaiseVolume  ), spawn "amixer  set Master 3%+")
    , ((0,  xF86XK_AudioLowerVolume  ), spawn "amixer  set Master 3%-")
    , ((0,  xF86XK_AudioMute         ), spawn "amixer  set Master toggle")
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
     , ((modm              , xK_v     ), sendMessage ToggleStruts)

    -- XMonad Prompts.
    , ((modm, xK_semicolon), appendFilePrompt myXPConfig "/home/abhinav/.note")

    --
    , ((modm .|. shiftMask, xK_F11), safeSpawn "slock" [])
    -- Renaming Workspaces
    , ((modm, xK_apostrophe), renameWorkspace myXPConfig)
    --Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    , ((modm .|. controlMask, xK_x), shellPrompt myXPConfig)
    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

   --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    , ((modm, button4), \_ -> prevWS) -- Switch to previous workspace.
    , ((modm, button5), \_ -> nextWS) -- Switch to next workspace.
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout =fullscreenFull $ windowNavigation $ avoidStruts $boringWindows $ maximize  $minimize (tiled ||| Mirror tiled ||| Full ||| mytile ||| Mirror mytile ||| tabbedLayout ||| focused )  
--myLayout =windowNavigation $ avoidStruts  $minimize ( tiled ||| Mirror tiled ||| Full ||| mytile ||| Mirror mytile ||| tabbedLayout |||simpleFloat ||| StackTile 1 (3/100) (1/2))
  where
     -- tabbed layout
     tabbedLayout= named "Tabbed" $ tabbed shrinkText myTabTheme

     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

     -- My tilling config
     mytile = ResizableTall 1 (3/100) (1/2) []
     
     focused = gaps [(L,385), (R,385),(U,0),(D,10)]
                                         $ noBorders (FS.fullscreenFull Full)
------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore  
    , className =? "Galculator"     --> doFloat
    , isFullscreen --> doFullFloat
    ] 

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- myEventHook = mempty 
myEventHook = fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = return ()
-- Command to launch the bar.
--
--myBar="xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
--myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }
--
--- Key binding to toggle the gap for the bar.
--toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
-- Key binding to toggle the gap for the bar.
--toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_v)
------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
-- By default, do nothing.
-- myStartupHook = return ()
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
--main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaults 

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
main = do
--defaults = defaultConfig {

	xmobarPipe <- spawnPipe "xmobar -x 1 ~/.xmobarrc"
	xmonad $ defaultConfig {
        -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      	-- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      	-- hooks, layouts
        layoutHook         = trackFloating (myLayout),
        --layoutHook         = windowArrangeAll myLayout,
        manageHook         = myManageHook,
        --manageHook         = fullscreenManageHook <+> myManageHook,
        -- handleEventHook    = myEventHook,
        handleEventHook    = fullscreenEventHook,
        --logHook            = myLogHook,
        logHook 	   = myXMobarLogger xmobarPipe ,
        --logHook 	   = myXMobarLogger xmobarPipe >> updatePointer (Relative 0.98 0.98),
	--startupHook        = myStartupHook
	startupHook        = setWMName "LG3D"
    }
