﻿; Script Information ===========================================================
; Name:        Prompt Explorer
; Description: A Prompt Viewer/Explorer for ChatGPT prompts.
; AHK Version: AHK 1.1.33.02 (Unicode 64-bit)
; OS Version:  Windows 10
; Language:    English (United States)
; Author:      Gatorchopps FinickySpider@gmail.com
; Filename:    Prompt Viewer.ahk
; ==============================================================================

; Revision History =============================================================
; Revision 1 (2023-07-18)
; * Alpha Release
; ==============================================================================


; TODO =========================================================================
; 1. ------------------
; 2. ------------------
; 3. ------------------
; 4. ------------------
; ==============================================================================


; Special notes ; ==============================================================
; 1. ------------------
; 2. ------------------
; 3. ------------------
; 4. ------------------
; ==============================================================================


; ==============================================================================
; ====== Default Script Settings ===============================================

if not A_IsAdmin                ; Run as Admin just in case
    {	
    
        DllCall("Wow64DisableWow64FsRedirection", "uint*", OldValue)
        Run *RunAs "%A_ScriptFullPath%" 		
        DllCall("Wow64RevertWow64FsRedirection", "uint", OldValue)  
    }
    #SingleInstance, Force         ; Allow only one running instance of script
    #Persistent                    ; Keep the script permanently running until terminated
    #NoEnv                         ; Avoid checking empty variables for environment variables
    ;#Warn                         ; Enable warnings to assist with detecting common errors
    ;#NoTrayIcon                   ; Disable the tray icon of the script
    SetWorkingDir, % A_ScriptDir   ; Set the working directory of the script
    SetBatchLines, -1              ; The speed at which the lines of the script are executed
    SendMode, Input                ; The method for sending keystrokes and mouse clicks
    ;DetectHiddenWindows, On       ; The visibility of hidden windows by the script
    ;SetWinDelay, -1               ; The delay to occur after modifying a window
    ;SetControlDelay, -1           ; The delay to occur after modifying a control
    ;SetKeyDelay, 90               ;Any number you want (milliseconds)
    ;CoordMode,Mouse,Screen         ;Initial state is Relative
    ;CoordMode,Pixel,Screen         ;Initial state is Relative. Frustration awaits if you set Mouse to Screen and then use GetPixelColor because you forgot this line. There are separate ones for: Mouse, Pixel, ToolTip, Menu, Caret
    FileEncoding , CP65001
    
    
    
    
    
    
    
    
    
    
    
    ; CONSTANTS =====================================================================
    ;   -For UI Control Styles
    ;global SS_BLACKRECT   := 0x4       ; displays a frame around the control and fills the control with a solid color that is the same color as the Window Frame (COLOR_WINDOWFRAME).
    ;global SS_GRAYRECT    := 0x5       ; displays a frame around the control and fills the control with a solid color that is the same color as the Desktop (COLOR_BACKGROUND).
    ;global SS_WHITERECT   := 0x6       ; displays a frame around the control and fills the control with a solid color that is the same color as the Window (COLOR_WINDOW).
    ;global SS_BLACKFRAME  := 0x7       ; displays a frame around the control that is the same color as the Window Frame (COLOR_WINDOWFRAME).
    ;global SS_GRAYFRAME   := 0x8       ; displays a frame around the control that is the same color as the Desktop, the screen background (COLOR_BACKGROUND).
    ;global SS_WHITEFRAME  := 0x9       ; displays a frame around the control that is the same color as the Window (COLOR_WINDOW).
    ;global SS_ETCHEDHORZ  := 0x10      ; Draws the top and bottom edges of the static control using the EDGE_ETCHED edge style.
    ;global SS_ETCHEDVERT  := 0x11      ; Draws the left and right edges of the static control using the EDGE_ETCHED edge style.
    ;global SS_ETCHEDFRAME := 0x12      ; Draws the frame of the static control using the EDGE_ETCHED edge style.
    ;global SS_SUNKEN      := 0x1000    ; Draws a half-sunken border around a static control.
    ;
    ;
    ;   - Custom ToolBar Styles
    ; TBSTYLE_FLAT      := 0x0800 - Shows separators as bars.
    ; TBSTYLE_LIST      := 0x1000 - Shows buttons text on their side.
    ; TBSTYLE_TOOLTIPS  := 0x0100 - Shows buttons text as tooltips.
    ; CCS_ADJUSTABLE    := 0x0020 - Allows customization by double-click and shift-drag.
    ; CCS_NODIVIDER     := 0x0040 - Removes the separator line above the toolbar.
    ; CCS_NOPARENTALIGN := 0x0008 - Allows positioning and moving toolbars.
    ; CCS_NORESIZE      := 0x0004 - Allows resizing toolbars.
    ; CCS_VERT          := 0x0080 - Creates a vertical toolbar (add WRAP to button options).
    ;
    ;
    ; 
    ; 
    ; 
    ; =============================================================================
    
    
    
    
    
    ; ====== Automatic Execution ===================================================
    
     #Include %A_ScriptDir%\Lib\AutoXYWH.ahk
     #Include %A_ScriptDir%\Lib\JSON.ahk
     #Include %A_ScriptDir%\Lib\Class_Toolbar.ahk
     #Include %A_ScriptDir%\Lib\jxon.ahk
     #Include %A_ScriptDir%\Functions.ahk

     
     
     
     ; Create 2 Default ImageLists for the first Toolbar (small and large).
    
        IML := IL_Create(1, 1, 1)
        IL_Add(IML, "Img\Exit.png" ,0x00FFFFFF , 1)
        
        IML2 := IL_Create(2, 2, 1)
        IL_Add(IML2, "Img\Warning_Black.png" ,0x00FFFFFF , 1)
        IL_Add(IML2, "Img\RedRight.png" ,0x00FFFFFF , 1)
    
    GUITitle := "PromptlyExplore - Prompt Explorer"
    Width := 1160
     
     
    Global _ImagePath := A_ScriptDir . "\Img\"
    Global _LogPath := A_ScriptDir . "\Logs\"
     
     LoadSettingsIni()
    
    ;folder = %A_WorkingDir%\Prompts
    
    txtArray := []
    maxtxt = 0
    pngArray := []
    maxpng = 0
    LVArray := []
    TotalItems := ""
    
    Gui, +HwndUI_HWND +LastFound
    Gui, Margin, 0, 0
    Gui, -Caption ;+0x800000
    Gui, Add, Progress, % "x-1 y-1 w" (Width+2) " h31 Background404040 Disabled hwndHPROG"
    
    Control, ExStyle, -0x20000, , ahk_id %HPROG% ; propably only needed on Win XP
    
    
    Gui, Add, Text, % "x0 y0 w" Width " h30 BackgroundTrans Center 0x200 gGuiMove vCaption1", %GUITitle%
    
    Gui, Add, Custom, ClassToolbarWindow32 hwndControl x1115 y32  vwControl 0x0800 0x0100 0x0008 0x0080 0x0040 
    
    ;Gui, Add, Custom, ClassToolbarWindow32 hwndT_Exit x20 y595 vttest 0x0800 0x0100 0x0008 0x0040
    
    
    Gui Font, q5 s9, Segoe UI Emoji
    Gui Add, ListView,-Multi SortDesc hWndhListIndex x24 y66 w303 h749 +LV0x4000 vMyListViewV gMyListView, Prompt
    Gui Add, Picture, hWndhPicIndex x368 y66 w400 h400 +Border +0x1000 +0x40000 vMyPic, %A_ScriptDir%\Img\default.png
    Gui Add, Edit, hWndheditIndex x368 y522 w784 h273 +Multi vpromptContent,
    Gui Add, GroupBox, x802 y66 w343 h393, Controls & Settings
    Gui Add, Button, x1016 y810 w120 h44, Clipboard
    Gui Add, Button, x891 y810 w120 h44, Estimate
    Gui Add, Button, x848 y170 w268 h23, Folder
    Gui, Add, Text, ,Search:
    Gui, Add, Edit, x848 y220 w290 vSearchTerm gSearch
    Gui Font
    Gui Font, Bold
    Gui Add, Text, x368 y490 w93 h23 +0x200, Selected Prompt:
    Gui Font
    Gui Font, q5 s9, Segoe UI Emoji
    Gui Add, Text, vMyLabel x472 y490 w680 h23 +0x200 +0x1000, [Prompt Name]
    Gui Add, Text, x832 y106 w97 h23 +0x200, Prompt Folder Dir
    Gui Add, Edit, x832 y138 w301 h21 vfolderDir, %folder%
    Gui, Add, StatusBar, , % "   " . TotalItems . " of " . TotalItems . " Items"
    
    
    SB_SetParts(600, 248)
    SB_SetIcon(A_ScriptDir . "\Img\GreyDot.ico", 1, 1)
    Gui, Add, Text, x5 y881+10 w1160 h5 vP, -
    GuiControlGet, P, Pos
    H := PY + PH
    WinSet, Region, 0-0 w%Width% h%H% r6-6
    Gui, Color, C0C0C0
    
    
    Gui Show, w1160 h881, %GUITitle%
    
    
    TB1 := New Toolbar(Control)
    TB1.SetIndent(0)
    TB1.SetPadding(0, 0)
    TB1.ToggleStyle(0x800)
    TB1.SetImageList(IML)
    TB1.Add("Enabled Wrap", "PExit=Exit:1")
    ; Removes text labels and show them as tooltips.
    TB1.SetMaxTextRows(0)
    
    
    TB2 := New Toolbar(T_Exit)
    ;TB2.SetIndent(0)
    TB2.SetPadding(6, 0)
    ;TB2.ToggleStyle(0x800)
    TB2.SetImageList(IML2)
    TB2.Add("", "T_ExitWarn=Toggle Warning prompt before exiting:1", "T_AutoNext=Toggle automaticly switching to the next image when a caption is saved:2")
    ; Removes text labels and show them as tooltips.
    TB2.SetMaxTextRows(0)
    
    
    
    ; Set a function to monitor the Toolbar's messages.
    WM_COMMAND := 0x111
    OnMessage(WM_COMMAND, "TB_Messages")
    
    ; Set a function to monitor notifications.
    WM_NOTIFY := 0x4E
    OnMessage(WM_NOTIFY, "TB_Notify")
    
    
    
    ; Load all prompts into arrays
    if InStr(FileExist(folder), "D")
    {
        goto, ReadFiles
    }

    return ;===== End automatic execution ==========================================
    

    
    
    ; GuiSize:
    ; This function is triggered when the size of the GUI changes. It checks if the event is triggered by a minimize action, and if not, it calls the AutoXYWH function to adjust the size of the picture control.
        GuiSize:
            If (A_EventInfo == 1) {
                Return
            }
            AutoXYWH("wh", hPicIndex)
        Return
    
    
    
    
    
    f5::
    Refresh:
    LV_Delete()
    gosub, PopulateListView
    Return
    
    
    
    
    
    ; This function is triggered when the user types in the search box and presses enter or clicks out of the search box. 
    ; It searches through the LVArray for filenames that contain the search term and populates the ListView with the matching filenames.
    ; If the search box is empty, it refreshes the ListView to show all filenames.
    ; It also updates the status bar to show the number of items displayed in the ListView.
    Search:
    Empty = false
    Index := 1  ; Initialize the counter
    GuiControlGet, SearchTerm
    GuiControl, -Redraw, MyListViewV
    LV_Delete()
    For Each, FileName In LVArray
    {
       If (SearchTerm != "")
       {
          If InStr(FileName, SearchTerm) ; for overall matching
          {
          
            SplitPath, FileName, fname, dir, ext, name_no_ext, drive 
            ;StringTrimRight, Prmpt, FileName, 4
            LV_Add("", name_no_ext)
         
          
          
          }
          ; If (InStr(FileName, SearchTerm) = 1) ; for matching at the start
          ; If InStr(FileName, SearchTerm) ; for overall matching
                    
       }
       Else
       {
          Empty = true
       }
    }
    
    if Empty = True
        gosub, Refresh
    Items := LV_GetCount()
    SB_SetText("   " . Items . " of " . TotalItems . " Items")
    GuiControl, +Redraw, MyListViewV
    Return
    
    
    
    
    ; BUTTONFOLDER: This function prompts the user to select a folder containing prompt images.
    ButtonFolder:
    FileSelectFolder, folder, *%A_WorkingDir%\Prompts\
    if (folder = "") {
        MsgBox, No folder selected.
        Return
    }
    SetSettingIni(folder, "PromptDir" )
    gosub, ReadFiles
    Return
    
    
    ; Reads the prompt images from the specified folder and populates the list view with the prompt names and their corresponding tiers.
    ReadFiles:

        LVArray := []
        
        Loop, Files, %folder%\*.txt, R
        {
            LVArray.Push(A_LoopFileLongPath)
        }
    
        gosub, PopulateListView
    Return
    
    
    /*
    PopulateListView:
    Populates the list view with the prompt names and their corresponding tiers.
    */
    PopulateListView:
    GuiControl, -Redraw, MyListViewV
    
    Loop, % LVArray.Length()
    {
        FullFileName := LVArray[A_Index]
        
        SplitPath, FullFileName, fname, dir, ext, name_no_ext, drive 
        LV_Add("",  name_no_ext)
    }
    
        
        
    LV_ModifyCol(1, "250")  ; Auto-size each column to fit its contents.
    ;LV_ModifyCol(2, "AutoHdr Integer")  ; For sorting purposes, indicate that column 2 is an integer.
    GuiControl, +Redraw, MyListViewV
    Return
    
    
    
    
    /*
    MyListView:
    Handles the double-click event on the list view control. 
    Displays the selected prompt's image and text content in the GUI.
    */
    MyListView:
    if (A_GuiEvent = "DoubleClick")
    {
        LV_GetText(RowText, A_EventInfo, 1)  ; Get the text from the row's first field.
        ;LV_GetText(RowTier, A_EventInfo, 2)  ; Get the text from the row's first field.
        ;ToolTip You double-clicked row number %A_EventInfo%. Text: "%RowText%"
        ;SetTimer, RemoveToolTip, -1500
            if (RowText != "Prompt")
        MyListViewV := RowText
    }
    Gui, Submit, NoHide
    
    Selection := MyListViewV
    ;MsgBox % Selection
    AIndex := FindIndex(LVArray,Selection)
    ;MsgBox % AIndex
    FullFileName := LVArray[AIndex]
    ;MsgBox % FullFileName
    SplitPath, FullFileName, fname, dir, ext, name_no_ext, drive 
    GuiControl,, MyPic, *w400 *h400 %dir%\%RowText%.png
    GuiControl,, MyLabel, % name_no_ext
    FileRead, p, %dir%\%RowText%.txt
    GuiControl,, promptContent, % p
    Return
    

    
    
    /*
    ButtonClipboard:
    Handles the click event on the "Copy to Clipboard" button.
    Copies the prompt content to the clipboard and displays a tooltip to confirm.
    */
    ButtonClipboard:
    Gui, Submit, NoHide
    Clipboard := promptContent
        ToolTip You copied the prompt to the clipboard!
        SetTimer, RemoveToolTip, -2500
    return
    
    
    
    ;Removes tool tip. Currently not used
    RemoveToolTip:
    ToolTip
    return
    
    ;if gui is closed, exit app
    CloseTool:
    GuiClose:
    ExitApp
    
    
    
    
    
    
    
    
    GuiMove: ; Fake Taskbar function to allow you to drag the ui
       PostMessage, 0xA1, 2
    return
    
    PExit: ; The exit button was pressed
    if ToggleExitWarning = 1
    {
        MsgBox 0x24, Wait!, You're about to exit and lose you're session. Did you mean to do that?
        IfMsgBox Yes, {
        goto, CloseTool
        } Else IfMsgBox No, {
        return
        }
    }
    goto, CloseTool
    return
    
    
    
    
    
    
    
    

    
    
    
    EstimatorGuiClose:
    
    Gui, Estimator:Destroy
    return
    
    F3::MsgBox % getSelected()
    
    

    
    ButtonEstimate:
    gui submit, nohide
    SB_SetIcon(A_ScriptDir . "\Img\RedDotAlt.ico", 1, 1)
    val := RegExReplace(promptContent, "\R", "``n")
    ;msgbox % val
    if (val!= "")
    {
     n :=  chr(34)  
     StringReplace, val, val, %n% , ▒, All
     rJson :=  GetTokenEstimate(val)
     PopUpGUI(rJson)
     
    }
    Else
    {
    SB_SetIcon(A_ScriptDir . "\Img\RedDot.ico", 1, 1)
    }
    
    
    ;GuiControl,, MyEdit, New text line 1.`nNew text line 2.
    
    return
    
    
    
    