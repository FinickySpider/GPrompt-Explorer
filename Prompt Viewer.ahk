; Script Information ===========================================================
; Name:        Prompt Explorer
; Description: A Prompt Viewer/Explorer for ChatGPT prompts.
; AHK Version: AHK 1.1.33.02 (Unicode 64-bit)
; OS Version:  Windows 10
; Language:    English (United States)
; Author:      Gatorchopps FinickySpider@gmail.com
; Filename:    New AutoHotkey Prompt Viewer.ahk
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

; ====== Set Error Handling and Debug ==========================================

OnExit("OnUnload") ; Run a subroutine or function when exiting the script


; ====== Define Variable =======================================================

Global LogFile := "MyLog.txt"	; Set the name of the Log/Debug File
Global Application := {}       ; Create Application Object to store data about script
Application.Name := "Prompt Viewer"
Application.Version := "0.1"


; ====== Automatic Execution ===================================================

 #Include %A_ScriptDir%\AutoXYWH.ahk

folder = %A_WorkingDir%\Prompts

txtArray := []
maxtxt = 0
pngArray := []
maxpng = 0
LVArray := []
TotalItems := ""



Gui Font, q5 s9, Segoe UI Emoji
Gui Add, ListView,-Multi SortDesc hWndhListIndex x24 y16 w303 h729 +LV0x4000 vMyListViewV gMyListView, Prompt|Tier
Gui Add, Picture, hWndhPicIndex x368 y16 w400 h400 +Border +0x1000 +0x40000 vMyPic, %A_ScriptDir%\default.png
Gui Add, Edit, hWndheditIndex x368 y472 w784 h273 +Multi vpromptContent,
Gui Add, GroupBox, x802 y16 w343 h393, Controls & Settings
Gui Add, Button, x1016 y760 w120 h44, Clipboard
Gui Add, Button, x848 y120 w268 h23, Folder
Gui, Add, Text, ,Search:
Gui, Add, Edit, x848 y170 w290 vSearchTerm gSearch
Gui Font
Gui Font, Bold
Gui Add, Text, x368 y440 w93 h23 +0x200, Selected Prompt:
Gui Font
Gui Font, q5 s9, Segoe UI Emoji
Gui Add, Text, vMyLabel x472 y440 w680 h23 +0x200 +0x1000, [Prompt Name]
;Gui Add, Button, x144 y760 w48 h45, Refresh
;Gui Add, Button, x384 y760 w120 h44, Clear
Gui Add, Text, x832 y56 w97 h23 +0x200, Prompt Folder Dir
Gui Add, Edit, x832 y88 w301 h21 vfolderDir, %folder%
Gui, Add, StatusBar, , % "   " . TotalItems . " of " . TotalItems . " Items"
Gui Show, w1160 h813, Prompt Explorer


; Load all prompts into arrays
if InStr(FileExist(folder), "D")
{
    goto, ReadFiles
}

return ;===== End automatic execution ==========================================






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





;Pretty sure this is not used
If InStr(FileName, "|0")
     {
        StringTrimRight, Prmpt, FileName, 6
        msgbox % Prmpt
     
     }

;Search Function
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
      
      
      If InStr(FileName, "|00")
     {
        StringTrimRight, Prmpt, FileName, 7
        LV_Add("", Prmpt, 00)
     
     }
      
      If InStr(FileName, "|0")
     {
         if InStr(FileName, "|00")
         {
         }
         else
         {
        StringTrimRight, Prmpt, FileName, 6
        LV_Add("", Prmpt, 0)
         }
     
     }
      If InStr(FileName, "|1")
     {
        StringTrimRight, Prmpt, FileName, 6
        LV_Add("", Prmpt, 1)
     
     }
      If InStr(FileName, "|2")
     {
        StringTrimRight, Prmpt, FileName, 6
        LV_Add("", Prmpt, 2)
     
     }
      If InStr(FileName, "|3")
     {
        StringTrimRight, Prmpt, FileName, 6
        LV_Add("", Prmpt, 3)
     
     }
      
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





ButtonFolder:
FileSelectFolder, folder, *%A_WorkingDir%\Prompts\
if (folder = "") {
    MsgBox, No folder selected.
    Return
}
gosub, ReadFiles
Return

ReadFiles:
;msgbox, readfiles
PromptArrayT00 := []
PromptArrayT0 := []
PromptArrayT1 := []
PromptArrayT2 := []
PromptArrayT3 := []
LVArray := []



Loop, Files, %folder%\Tier 00\*.png
{
    LVArray.Push(A_LoopFileName . "|00")
    PromptArrayT00.Push(A_LoopFileName)
}

Loop, Files, %folder%\Tier 0\*.png
{
    LVArray.Push(A_LoopFileName . "|0")
    PromptArrayT0.Push(A_LoopFileName)
}

Loop, Files, %folder%\Tier 1\*.png
{
    LVArray.Push(A_LoopFileName . "|1")
    PromptArrayT1.Push(A_LoopFileName)
}

Loop, Files, %folder%\Tier 2\*.png
{
    LVArray.Push(A_LoopFileName . "|2")
    PromptArrayT2.Push(A_LoopFileName)
}

Loop, Files, %folder%\Tier 3\*.png
{
    LVArray.Push(A_LoopFileName . "|3")
    PromptArrayT3.Push(A_LoopFileName)
}
    
;GuiControl,, MyLabel, % txtArray[1]

gosub, PopulateListView
Return


PopulateListView:
GuiControl, -Redraw, MyListViewV


Loop, % PromptArrayT00.Length()
{
    cur := PromptArrayT00[A_Index]
    FullFileName = %folder%\Tier 00\%cur%
    SplitPath, FullFileName, fname, dir, ext, name_no_ext, drive 
    LV_Add("",  name_no_ext, 00)
}

Loop, % PromptArrayT0.Length()
{
    cur := PromptArrayT0[A_Index]
    FullFileName = %folder%\Tier 0\%cur%
    SplitPath, FullFileName, fname, dir, ext, name_no_ext, drive 
    LV_Add("",  name_no_ext, 0)
}

Loop, % PromptArrayT1.Length()
{
    cur := PromptArrayT1[A_Index]
    FullFileName = %folder%\Tier 1\%cur%
    SplitPath, FullFileName, fname, dir, ext, name_no_ext, drive 
    LV_Add("",  name_no_ext, 1)
}

Loop, % PromptArrayT2.Length()
{
    cur := PromptArrayT2[A_Index]
    FullFileName = %folder%\Tier 2\%cur%
    SplitPath, FullFileName, fname, dir, ext, name_no_ext, drive 
    LV_Add("",  name_no_ext, 2)
}

Loop, % PromptArrayT3.Length()
{
    cur := PromptArrayT3[A_Index]
    FullFileName = %folder%\Tier 3\%cur%
    SplitPath, FullFileName, fname, dir, ext, name_no_ext, drive 
    LV_Add("",  name_no_ext, 3)
}
    
    
    
    
LV_ModifyCol(1, "250")  ; Auto-size each column to fit its contents.
LV_ModifyCol(2, "AutoHdr Integer")  ; For sorting purposes, indicate that column 2 is an integer.
GuiControl, +Redraw, MyListViewV
Return




MyListView:

if (A_GuiEvent = "DoubleClick")
{
    LV_GetText(RowText, A_EventInfo, 1)  ; Get the text from the row's first field.
    LV_GetText(RowTier, A_EventInfo, 2)  ; Get the text from the row's first field.
    ;ToolTip You double-clicked row number %A_EventInfo%. Text: "%RowText%"
    ;SetTimer, RemoveToolTip, -1500
        if (RowText != "Prompt")
    MyListViewV := RowText
}
Gui, Submit, NoHide


cur := MyListViewV
FullFileName = %folder%\Tier %RowTier%\%cur%
SplitPath, FullFileName, fname, dir, ext, name_no_ext, drive 
GuiControl,, MyPic, *w400 *h400 %folder%\Tier %RowTier%\%RowText%.png
GuiControl,, MyLabel, % name_no_ext
FileRead, p, %folder%\Tier %RowTier%\%RowText%.txt
GuiControl,, promptContent, % p
Return




ButtonClipboard:
Gui, Submit, NoHide
Clipboard := promptContent
    ToolTip You copied the prompt to the clipboard!
    SetTimer, RemoveToolTip, -2500
return



RemoveToolTip:
ToolTip
return


GuiClose:
ExitApp

