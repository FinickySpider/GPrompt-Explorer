; ----------------------------------------------------------------------------------------------------------------------
; Advanced Library for ListViews
; by Dadepp
; Version 1.1 (minor bugfixes)
; Version 1.1b (minor bugfixes, Unicode and 64bit compatible, requires AHK 1.1+) by toralf and just me
; http://www.autohotkey.com/forum/viewtopic.php?t=43242
; http://www.autohotkey.com/board/topic/39778-lva-color-individual-cells-of-a-listview-and-more/
; ----------------------------------------------------------------------------------------------------------------------
;
; Warning:    This uses the OnNotify Message handler. If you already have an
;             OnNotify handler please merge these two lines into your script:
;
;  If LVA_HwndInfo(NumGet(lParam + 0),2)
;    return LVA_OnNotifyProg(wParam, lParam, msg, hwnd)
;
;             If this is not done, the coloring can not take place!
;             If there is NO OnNotify handler in the script, please set one by using:
;
;  OnMessage("0x4E", "LVA_OnNotify")
;
; ----------------------------------------------------------------------------------------------------------------------
; Notes:
;             A Color Reference inside these functions are the same as with AHK itself:
;             Either the name of one of the 16 Standart Colors
;             (http://www.autohotkey.com/docs/commands/Progress.htm#colors)
;             or an RGB color reference such as 0x0000FF (the 0x is optional).
;             So if a color reference is to be used these are all equal:
;             red = rEd = Red = 0xFF0000 = 0xfF0000 = FF0000 = ff0000 = fF0000
;
;             All row and column numbers are 1-Based indexes !!
; ----------------------------------------------------------------------------------------------------------------------
;
; List of functions the User may call:
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_OnNotify(wParam, lParam, msg, hwnd)
;
; The OnNotify handler that can be used, if no OnNotify handler is already in place
; Please dont use otherwise! Only for use with "OnMessage("0x4E", "LVA_OnNotify")"
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_ListViewAdd(LVvar, Options="")
;
; Makes it possible to color Cells/Rows/Columns/etc... inside the ListView.
; If this is NOT used, every other functions wont work!
; Params:
; LVvar       The associated control Variable (the name of the variable,
;             NOT the handle to the control!). Must be inside Quotationmarks ""
;
; Options     A Space delimited list of one or more of the following:
;             "AR"/"+AR"  Sets the Alternating Row Coloring to active
;             "-AR"       Removes the Alternating Row Coloring
;             "RB"        Followed by a Color Reference to set the Background Color
;                         for the alternating rows!
;             "RF"        Same as "RB" except that it controls the Text Color
;             "AC"/"+AC"  Sets the Alternating Column Coloring to active
;             "-AC"       Removes the Alternating Column Coloring
;             "CB"        Followed by a Color Reference to set the Background Color
;                         for the alternating Columns!
;             "CF"        Same as "CB" except that it controls the Text Color
;             The standard values are:
;             "-AR RB0xEFEFEF RF0x000000 -AC CB0xEFEFEF CF0x000000"
;
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_ListViewModify(LVvar, Options)
;
; A way to modify the Options set with LVA_ListViewAdd().
; Params:
; LVvar       The name of the associated control's variable.
;
; Options     The same as in LVA_ListViewAdd()
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_Refresh(LVvar)
;
; A helper function to force a ListView to ReDraw itself
; (Works only with ListViews Specified with LVA_ListViewAdd() !)
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_SetProgressBar(LVvar, Row, Col, cInfo="")
;
; Allows the use of a ProgressBar inside a specific Cell.
; Call without the cInfo param to remove a ProgressBar from the ListView
; Params:
; LVvar       The name of the associated control's variable.
;
; Row         The number of the row to be used
;
; Col         The number of the column to be used
;
; cInfo       A Space delimited list of one or more of the following:
;             "R"       Followed by a number sets the range of the ProgressBar
;             "B"       Followed by a Color Reference to set the Background Color
;             "S"       Followed by a Color Reference to set the Starting Color
;             "E"       Followed by a Color Reference to set the Ending Color
;                       (if not used the Ending Color will be the same as the
;                       Starting Color)
;             "Smooth"  Use this Option to create a different acting ProgressBar
;             The standard values are: "R100 B0xFFFFFF S0x000080"
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_Progress(Name, Row, Col, pProgress)
;
; If a ProgressBar has been set with LVA_SetProgressBar() then this sets the
; current value of this specific ProgressBar. (This repaints the ProgressBar,
; and ONLY the ProgressBar!)
; Params:
; LVvar       The name of the associated control's variable.
;
; Row         The number of the row to be used
;
; Col         The number of the column to be used
;
; cProgress   The new value. If it exceeds the Range set for this ProgressBar,
;             the maximum allowed Range is used instead!
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_SetCell(Name, Row, Col, cBGCol="", cFGCol="")
;
; Sets the Color to a specific Cell. To remove a Color, use the function
; without the "cBGCol" and "cFGCol" params! If one param is empty then
; the other one will be automaticly filled with the standard values for this
; specific ListView (these infos will be determined internally!)
; Params:
; LVvar       The name of the associated control's variable.
;
; Row         The number of the row to be used
;
; Col         The number of the column to be used
;
; cBGCol      The Color Reference for the Cells BackGround
;
; cFGCol      The Color Reference for the Cells Text
;
; Note:       Setting Row or Col to 0 will affect the whole Row/Column.
;             The order of priority for the cells color goes:
;             if specific the use this
;             else if column has color
;             else if row has color
;             else if is an alternating column and bool is set
;             else if is an alternating row and bool is set
;             else standard colors
;
; ----------------------------------------------------------------------------------------------------------------------
; LVA_EraseAllCells(Name)
;
; Resets ALL Color/ProgressBar Informations, for the complete ListView
; (Use with caution!)
;
; LVvar       The name of the associated control's variable.
;
; ----------------------------------------------------------------------------------------------------------------------
;
; The Following Functions CAN BE USED even on ListViews not specified with
; LVA_ListViewAdd()
;
; ----------------------------------------------------------------------------------------------------------------------
; LVA_GetCellNum(Switch=0, LVvar="")
;
; A function to retrieve Cell-Information (Row/Column) from the cell under
; the Mouse Pointer!
; Params:
;
; Switch      If set to 0 and LVvar set to the ListView in question, it
;             retrieves the informations and stores the internally!
;             Afterwards the LVvar param is no longer needed, and these
;             infos can be requested with the following:
;             (Note: These values will still hold the values from when it was
;             used with Switch set to 0 even if the MousePosition changed!)
;             1  or "Row"     Returns the row-number
;             2  or "Col"     Returns the Column-number
;             -1 or "Row-1"   Returns the row-number (0-Based Index)
;             -2 or "Row-2"   Returns the Column-number (0-Based Index)
;             "Rows"          Returns the total number of Rows
;             "Cols"          Returns the total number of Columns
;
;             The following values for Switch are special, since with them
;             the Cell-Information wont be evaluated (and changed !!).
;             But the LVvar param is needed again !!
;             "GetRows"       Returns the total number of Rows
;             "GetCols"       Returns the total number of Columns
;
; LVvar       The name of the associated control's variable.
;             Can also be a Handle !!
;
; ----------------------------------------------------------------------------------------------------------------------
;
; LVA_SetSubItemImage(LVvar, Row, Col, iNum)
;
; A helper function to set an Image to any Cell. An ImageList MUST be
; associated with that ListView, and the ListView MUST have "+LV0x2" set inside
; its Style Options.
; (Note: Using a number < 1 for Row is the Same as using 1.
;        Using 1 for Col , is the same as using: LV_Modify(Row, "Icon" . iNum) !)
; Params:
; LVvar       The name of the associated control's variable.
;
; Row         The number of the row to be used
;
; Col         The number of the column to be used
;
; iNum        The number of the ImageList-Icon to be used
;
; ======================================================================================================================
; Public functions, for use look at the docu above!
; ======================================================================================================================
LVA_OnNotify(wParam, lParam, msg, hwnd) {
    Critical, 500
    If LVA_HwndInfo(NumGet(lParam + 0, "Ptr"), 2)
      Return LVA_OnNotifyProg(wParam, lParam, msg, hwnd)
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_ListViewAdd(LVvar, Options:= "") {
    tmp := LVA_HwndInfo(LVvar, 1)
    tmp2 :=LVA_HwndInfo(0, -2, tmp)
    LVA_Info("SetARowBool", LVvar,0,0,false)
    LVA_Info("SetARowColB", LVvar,0,0,"0xEFEFEF")
    LVA_Info("SetARowColF", LVvar,0,0,"0x000000")
    LVA_Info("SetAColBool", LVvar,0,0,false)
    LVA_Info("SetAColColB", LVvar,0,0,"0xEFEFEF")
    LVA_Info("SetAColColF", LVvar,0,0,"0x000000")
    SendMessage, 4096,0,0,, ahk_id %tmp2%
    LVA_Info("SetStdColorBG", LVvar,0,0,ErrorLevel)
    SendMessage, 4131,0,0,, ahk_id %tmp2%
    LVA_Info("SetStdColorFG", LVvar,0,0,ErrorLevel)
    LVA_ListViewModify(LVvar, Options)
    LVA_Refresh(LVvar)
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_ListViewModify(LVvar, Options)
  {
    Loop, Parse, Options, %A_Space%
    {
      If (A_LoopField = "+AR")||(A_LoopField = "AR")
        LVA_Info("SetARowBool", LVvar,0,0,true)
      If (A_LoopField = "-AR")
        LVA_Info("SetARowBool", LVvar,0,0,false)
      If (A_LoopField = "+AC")||(A_LoopField = "AC")
        LVA_Info("SetAColBool", LVvar,0,0,true)
      If (A_LoopField = "-AC")
        LVA_Info("SetAColBool", LVvar,0,0,false)
      cmd := SubStr(A_LoopField,1,2)
      If (cmd = "RB")
        LVA_Info("SetARowColB", LVvar,0,0, LVA_VerifyColor(SubStr(A_LoopField, 3)))
      If (cmd = "RF")
        LVA_Info("SetARowColF", LVvar,0,0, LVA_VerifyColor(SubStr(A_LoopField, 3)))
      If (cmd = "CB")
        LVA_Info("SetAColColB", LVvar,0,0, LVA_VerifyColor(SubStr(A_LoopField, 3)))
      If (cmd = "CF")
        LVA_Info("SetAColColF", LVvar,0,0, LVA_VerifyColor(SubStr(A_LoopField, 3)))
    }
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_Refresh(LVvar)
  {
    tmp := LVA_HwndInfo(LVvar,0,2)
    WinSet, Redraw,, ahk_id %tmp%
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_SetProgressBar(LVvar, Row, Col, cInfo := "")
  {
    If (cInfo = "")
    {
      LVA_Info("SetPB", LVvar, Row, Col, false)
      lva_Refresh(LVvar)
      Return
    }
    LVA_Info("SetPB", LVvar, Row, Col, true)
    LVA_Info("SetProgress", LVvar, Row, Col, 0)
    LVA_Info("SetPBR", LVvar, Row, Col, 100)
    LVA_Info("SetPCB", LVvar, Row, Col, "0x00FFFFFF")
    LVA_Info("SetPCS", LVvar, Row, Col, "0x000080")
    Loop, Parse, cInfo, %A_Space%
    {
      cmd := SubStr(A_LoopField,1,1)
      If (A_LoopField = "Smooth")
        LVA_Info("SetPB", LVvar, Row, Col, 2)
      Else If (cmd = "R")
        LVA_Info("SetPBR", LVvar, Row, Col, SubStr(A_LoopField, 2))
      Else If (cmd = "B")
        LVA_Info("SetPCB", LVvar, Row, Col, LVA_VerifyColor(SubStr(A_LoopField, 2),1))
      Else If (cmd = "S")
        LVA_Info("SetPCS", LVvar, Row, Col, LVA_VerifyColor(SubStr(A_LoopField, 2), 2))
      Else If (cmd = "E")
        LVA_Info("SetPCE", LVvar, Row, Col, LVA_VerifyColor(SubStr(A_LoopField, 2), 2))
    }
    If (LVA_Info("GetPCE", LVvar, Row, Col) = "")
      LVA_Info("SetPCE", LVvar, Row, Col, LVA_Info("GetPCS", LVvar, Row, Col))
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_Progress(Name, Row, Col, pProgress)
  {
    LVA_Info("SetProgress", LVA_HwndInfo(Name), Row, Col, pProgress)
    LVA_DrawProgress(Row, Col, LVA_HwndInfo(Name,0,2))
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_SetCell(Name, Row, Col, cBGCol := "", cFGCol := "")
  {
    If ((cBGCol = "")&&(cFGCol = ""))
    {
      LVA_Info("SetCol", Name, Row, Col, false)
      Return
    }
    If (cBGCol <> "")
      LVA_Info("SetCellColorBG", Name, Row, Col, LVA_VerifyColor(cBGCol))
    If (cFGCol <> "")
      LVA_Info("SetCellColorFG", Name, Row, Col, LVA_VerifyColor(cFGCol))
    If (cFont <> "")
      LVA_Info("SetCellFont", Name, Row, Col, cFont)
    LVA_Info("SetCol", Name, Row, Col, true)
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_EraseAllCells(Name)
  {
    LVA_Info(0, Name)
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_GetCellNum(Switch=0, LVvar := "")
  {
    Static LastResR, LastResC, LastColCount, LastRowCount, LastLVvar
    If ((Switch = 1)||(Switch = "Row"))
      Return LastResR
    Else If ((Switch = 2)||(Switch = "Col"))
      Return LastResC
    Else If ((Switch = -1)||(Switch = "Row-1"))
      Return LastResR-1
    Else If ((Switch = -2)||(Switch = "Col-1"))
      Return LastResC-1
    Else If (Switch = "Rows")
      Return LastRowCount
    Else If (Switch = "Cols")
      Return LastColCount
    If (LVvar = "")
      LVvar := LastLVvar
    Else
      LastLVvar := LVvar
    If LVvar is not Integer
      GuiControlGet, hLV, Hwnd, %LVvar%
    Else
      hLV := LVvar
    SendMessage, 4100,0,0,, ahk_id %hLV%
    RowCount := ErrorLevel
    If (Switch = "GetRows")
      Return RowCount
    SendMessage, 4127,0,0,, ahk_id %hLV%
    hHeader := ErrorLevel
    SendMessage, 4608,0,0,, ahk_id %hHeader%
    ColCount := ErrorLevel
    If (Switch = "GetCols")
      Return ColCount
    LastRowCount := RowCount
    LastColCount := ColCount
    VarSetCapacity(spt, 8, 0)
    VarSetCapacity(pt, 8, 0)
    DllCall("GetCursorPos", "Ptr", &spt)
    NumPut(NumGet(spt, 0, "Int"), pt, 0, "Int")
    NumPut(NumGet(spt, 4, "Int"), pt, 4, "Int")
    DllCall("ScreenToClient", "Ptr", hLV, "Ptr", &pt)
    VarSetCapacity(LVHitTest, 24, 0)
    NumPut(NumGet(pt, 0, "Int"), LVHitTest, 0)
    NumPut(NumGet(pt, 4, "Int"), LVHitTest, 4)
    SendMessage, 4153, 0, &LVHitTest,, ahk_id %hLV%
    LastResR := NumGet(LVHitTest, 12, "Int")+1
    If (LastResR > RowCount)
      LastResR := 0
    LastResC := NumGet(LVHitTest, 16, "Int")+1
    If ((LastResC > ColCount)||(LastResR = 0))
      LastResC := 0
    Return
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_SetSubItemImage(LVvar, Row, Col, iNum)
  { ; modified by toralf
    Static LVM_SETITEM := A_IsUnicode ? 0x104C : 0x1006 ; LVM_SETITEMW : LVM_SETITEMA
    Static LVITEMSize := 48 + (A_PtrSize * 3)
    Static OffImage := 20 + (A_PtrSize * 2)
    GuiControlGet, hLV, Hwnd, %LVvar%
    VarSetCapacity(LVItem, LVITEMSize, 0)
    Row := (Row < 1) ? 1 : Row
    Col := (Col < 1) ? 1 : Col
    NumPut(2, LVItem, 0, "UInt")
    NumPut(Row-1, LVItem, 4, "Int")
    NumPut(Col-1, LVItem, 8, "Int")
    NumPut(iNum-1, LVItem, OffImage, "Int")
    SendMessage, % LVM_SETITEM, 0, &LVItem,, ahk_id %hLV%
  }
  ; ======================================================================================================================
  ; Private Functions! Please use only If u know what your doing
  ; ======================================================================================================================
  LVA_VerifyColor(cColor, Switch := 0)
  {
    If cColor is not Integer
    {
      If (cColor = "Black")
        cColor := (Switch = 1) ? "FFFFFF" : "010101"
      Else If (cColor = "White")
        cColor := (Switch = 1) ? "010101" : "FFFFFF"
      Else If (cColor = "Silver")
        cColor := "C0C0C0"
      Else If (cColor = "Gray")
        cColor := "808080"
      Else If (cColor = "Maroon")
        cColor := "800000"
      Else If (cColor = "Red")
        cColor := "FF0000"
      Else If (cColor = "Purple")
        cColor := "800080"
      Else If (cColor = "Fuchsia")
        cColor := "FF00FF"
      Else If (cColor = "Green")
        cColor := "008000"
      Else If (cColor = "Lime")
        cColor := "00FF00"
      Else If (cColor = "Olive")
        cColor := "808000"
      Else If (cColor = "Yellow")
        cColor := "FFFF00"
      Else If (cColor = "Navy")
        cColor := "000080"
      Else If (cColor = "Blue")
        cColor := "0000FF"
      Else If (cColor = "Teal")
        cColor := "008080"
      Else If (cColor = "Aqua")
        cColor := "00FFFF"
    }
    If (SubStr(cColor,1,2) = "0x")
      cColor := SubStr(cColor, 3)
    If ((Switch = 1)&&(SubStr(cColor,1,2) = "00"))
      cColor := SubStr(cColor, 3)
    If (StrLen(cColor) <> 6)
      Return "0xFFFFFF"
    If (Switch = 1)
      Return "0x00" . SubStr(cColor,5,2) . SubStr(cColor,3,2) . SubStr(cColor,1,2)
    If (Switch = 0)
      Return "0x" . SubStr(cColor,5,2) . SubStr(cColor,3,2) . SubStr(cColor,1,2)
    Else
      Return "0x" . cColor
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_DrawProgressGetStatus(Switch, Row := 0, Col := 0, Name := "")
  {
    Static BGCol, SColR, SColG, SColB, EColR, EColG, EColB, pProgressMax, pProgress, pProgressType
    If !Switch
    {
      BGCol := LVA_Info("GetPCB", Name, Row, Col)
      SCol := LVA_Info("GetPCS", Name, Row, Col)
      ECol := LVA_Info("GetPCE", Name, Row, Col)
      pProgressMax := LVA_Info("GetPBR", Name, Row, Col)
      pProgress := LVA_Info("GetProgress", Name, Row, Col)
      SColR := "0x" . SubStr(SCol, 3, 2) . "00"
      SColG := "0x" . SubStr(SCol, 5, 2) . "00"
      SColB := "0x" . SubStr(SCol, 7, 2) . "00"
      EColR := "0x" . SubStr(ECol, 3, 2) . "00"
      EColG := "0x" . SubStr(ECol, 5, 2) . "00"
      EColB := "0x" . SubStr(ECol, 7, 2) . "00"
      pProgressType := LVA_Info("GetPB", Name, Row, Col)
    }
    If (Switch = 1)
      Return BGCol
    Else If (Switch = 2)
      Return SColR
    Else If (Switch = 3)
      Return SColG
    Else If (Switch = 4)
      Return SColB
    Else If (Switch = 5)
      Return EColR
    Else If (Switch = 6)
      Return EColG
    Else If (Switch = 7)
      Return EColB
    Else If (Switch = 8)
    {
      max := col-row
      If (pProgress > pProgressMax)
        Return max
      res := Ceil((max / 100) * (Round(pProgress / (pProgressMax / 100))))
      If res > max
        Return max
      Else
        Return res
    }
    Else If (Switch = 9)
      Return pProgressType
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_GetStatusColor(Switch, Row := 0, Col := 0, LVvar := 0)
  {
    Static cFGCol, cBGCol
    If (Switch = -1)
    {
      Return cFGCol
    }
    Else If (Switch = -2)
    {
      Return cBGCol
    }
    Else If (switch = 0)
    {
      If LVA_Info("GetCol", LVvar, 0, Col)
      {
        cBGCol := LVA_Info("GetCellColorBG", LVvar, 0, Col)
        If !cBGCol
          cBGCol := LVA_Info("GetStdColorBG", LVvar)
        cFGCol := LVA_Info("GetCellColorFG", LVvar, 0, Col)
        If !cFGCol
          cFGCol := LVA_Info("GetStdColorFG", LVvar)
      }
      Else If LVA_Info("GetCol", LVvar, Row)
      {
        cBGCol := LVA_Info("GetCellColorBG", LVvar, Row)
        If !cBGCol
          cBGCol := LVA_Info("GetStdColorBG", LVvar)
        cFGCol := LVA_Info("GetCellColorFG", LVvar, Row)
        If !cFGCol
          cFGCol := LVA_Info("GetStdColorFG", LVvar)
      }
      Else If (LVA_Info("GetAColBool", LVvar))&&(mod(Col, 2) = 0)
      {
        cBGCol := LVA_Info("GetAColColB", LVvar)
        cFGCol := LVA_Info("GetAColColF", LVvar)
      }
      Else If (LVA_Info("GetARowBool", LVvar))&&(mod(Row, 2) = 0)
      {
        cBGCol := LVA_Info("GetARowColB", LVvar)
        cFGCol := LVA_Info("GetARowColF", LVvar)
      }
      Else
      {
        cBGCol := LVA_Info("GetStdColorBG", LVvar)
        cFGCol := LVA_Info("GetStdColorFG", LVvar)
      }
    }
    Else If (switch = 1)
    {
      cBGCol := LVA_Info("GetCellColorBG", LVvar, Row, Col)
      If !cBGCol
        If (LVA_Info("GetAColBool", LVvar))&&(mod(Col, 2) = 0)
          cBGCol := LVA_Info("GetAColColB", LVvar)
        Else If (LVA_Info("GetARowBool", LVvar))&&(mod(Row, 2) = 0)
          cBGCol := LVA_Info("GetARowColB", LVvar)
        Else
          cBGCol := LVA_Info("GetStdColorBG", LVvar)
      cFGCol := LVA_Info("GetCellColorFG", LVvar, Row, Col)
      If !cFGCol
        If (LVA_Info("GetAColBool", LVvar))&&(mod(Col, 2) = 0)
          cFGCol := LVA_Info("GetAColColF", LVvar)
        Else If (LVA_Info("GetARowBool", LVvar))&&(mod(Row, 2) = 0)
          cFGCol := LVA_Info("GetARowColF", LVvar)
        Else
          cFGCol := LVA_Info("GetStdColorFG", LVvar)
    }
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_HwndInfo(hwnd, switch := 0, data := 1)
  {
    Static
    Local tmp, found
    If ((switch = 0)||(switch = 2))
    {
      If hwnd is Integer
        hwnd := hwnd+0
  
      found := false
      Loop, %LVCount%
      {
        tmp := A_Index
        Loop, 3
        {
          If (LVA_hWndInfo_%tmp%_%A_Index% = hwnd)
          {
            found := true
            break
          }
        }
        If found
          break
      }
      If !found
        Return ""
      Else
      {
        If (switch = 0)
          Return LVA_hWndInfo_%tmp%_%data%
        Else If (switch = 2)
          Return true
      }
    }
    Else If (switch = -1)
      Return LVA_hWndInfo_%data%_1
    Else If (switch = -2)
      Return LVA_hWndInfo_%data%_2
    Else If (switch = -3)
      Return LVA_hWndInfo_%data%_3
    Else If (switch = 1)
    {
      If !LVCount
        LVCount := 1
      Else
        LVCount++
      LVA_hWndInfo_%LVCount%_1 := hwnd
      GuiControlGet, tmp, Hwnd, %hwnd%
      LVA_hWndInfo_%LVCount%_2 := tmp+0
      SendMessage, 4127,0,0,, ahk_id %tmp%
      LVA_hWndInfo_%LVCount%_3 := ErrorLevel+0
      Return LVCount
    }
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_OnNotifyProg(wParam, lParam, msg, hwnd)
  {
    Critical, 500
    hHandle := NumGet(lParam + 0, "Ptr")
    NotifyMsg := NumGet(lParam + 0, A_PtrSize * 2, "Int")
    If ((NotifyMsg == -307)||(NotifyMsg == -327))
      LVA_Refresh(hHandle)
    Else If (NotifyMsg == -12)
    {
      Row := NumGet(lParam + 16, A_PtrSize * 5, "UPtr") +1
      Col := NumGet(lParam + 24, A_PtrSize * 8, "Int") +1
      st := NumGet(lParam + 0, A_PtrSize * 3, "UInt")
      If st = 1
        Return, 0x20
      Else If (st == 0x10001)
        Return, 0x20
      Else If (st == 0x30001)
      {
        LVvar := LVA_HwndInfo(hHandle)
        CellType := LVA_Info("GetCellType", LVvar, Row, Col)
        If (CellType = 0)
        {
          LVA_GetStatusColor(0, Row, Col, LVvar)
          NumPut(LVA_GetStatusColor(-1), lParam + 16, A_PtrSize * 8, "UInt")
          NumPut(LVA_GetStatusColor(-2), lParam + 20, A_PtrSize * 8, "UInt")
        }
        Else If (CellType = 1)
        {
          LVA_GetStatusColor(1, Row, Col, LVvar)
          NumPut(LVA_GetStatusColor(-1), lParam + 16, A_PtrSize * 8, "UInt")
          NumPut(LVA_GetStatusColor(-2), lParam + 20, A_PtrSize * 8, "UInt")
        }
        Else If (CellType = 2)
        {
          LVA_DrawProgress(Row, Col, hHandle)
          Return 0x4
        }
        Else If (CellType = 3)
        {
  ;        lva_DrawMultiImage(Row, Col, hHandle)
          Return 0x4
        }
      }
    }
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_DrawProgress(Row, Col, hHandle)
  {
    If !LVA_Info("GetPB", LVA_HwndInfo(hHandle,0,1), Row, Col)
      Return
    VarSetCapacity(pRect, 16, 0)
    NumPut(0, pRect, 0, "UInt")
    NumPut(Col-1, pRect, 4, "UInt")
    SendMessage, 4152, Row-1, &pRect,, ahk_id %hHandle%
    pLeft := NumGet(pRect, 0, "UInt") > 0x7FFFFFFF ? -(~NumGet(pRect, 0, "UInt")) - 1 : NumGet(pRect, 0, "UInt")
    pTop := NumGet(pRect, 4, "UInt") > 0x7FFFFFFF ? -(~NumGet(pRect, 4, "UInt")) - 1 : NumGet(pRect, 4, "UInt")
    pRight := NumGet(pRect, 8, "UInt") > 0x7FFFFFFF ? -(~NumGet(pRect, 8, "UInt")) - 1 : NumGet(pRect, 8, "UInt")
    pBottom := NumGet(pRect, 12, "UInt") > 0x7FFFFFFF ? -(~NumGet(pRect, 12, "UInt")) - 1 : NumGet(pRect, 12, "UInt")
    If ((pRight < 0)||(pBottom < 0))
      Return
    VarSetCapacity(pRect2, 16, 0)
    SendMessage, 4135,0,0,, ahk_id %hHandle%
    SendMessage, 4152, ErrorLevel, &pRect2,, ahk_id %hHandle%
    If (pTop < NumGet(pRect2, 4, "UInt"))
      Return
    LVA_DrawProgressGetStatus(0, Row, Col, LVA_HwndInfo(hHandle))
    hDC := DllCall("GetDC", "Ptr", hHandle, "UPtr")
    If (pLeft < 0)
      pWidth := NumGet(pRect, 8, "UInt") + -pLeft-3
    Else
      pWidth := NumGet(pRect, 8, "UInt") - NumGet(pRect, 0, "UInt")-3
    pHeight := NumGet(pRect, 12, "UInt") - NumGet(pRect, 4, "UInt")-3
    mDC := DllCall("CreateCompatibleDC", "Ptr", hDC, "UPtr")
    mBitmap := DllCall("CreateCompatibleBitmap", "Ptr", hDC, "Int", pWidth, "Int", pHeight, "UPtr")
    DllCall("SelectObject", "Ptr", mDC, "Ptr", mBitmap)
    VarSetCapacity(pVertex, 32, 0)
    NumPut(1, pVertex, 0, "Int")
    NumPut(1, pVertex, 4, "Int")
    NumPut(LVA_DrawProgressGetStatus(2), pVertex, 8, "Ushort")
    NumPut(LVA_DrawProgressGetStatus(3), pVertex, 10, "Ushort")
    NumPut(LVA_DrawProgressGetStatus(4), pVertex, 12, "Ushort")
    NumPut(0x0000, pVertex, 14, "Ushort")
    ProgLen := LVA_DrawProgressGetStatus(8, 1, pWidth-1)
    If (LVA_DrawProgressGetStatus(9) = 1)
      NumPut(1+ProgLen, pVertex, 16, "Int")
    Else
      NumPut(pWidth-1, pVertex, 16, "Int")
    NumPut(pHeight-1, pVertex, 20, "Int")
    NumPut(LVA_DrawProgressGetStatus(5), pVertex, 24, "Ushort")
    NumPut(LVA_DrawProgressGetStatus(6), pVertex, 26, "Ushort")
    NumPut(LVA_DrawProgressGetStatus(7), pVertex, 28, "Ushort")
    NumPut(0x0000, pVertex, 30, "Ushort")
    VarSetCapacity(gRect, 8, 0)
    NumPut(0, gRect, 0, "UInt")
    NumPut(1, gRect, 4, "UInt")
    DllCall("msimg32\GradientFill", "Ptr", mDC, "Ptr", &pVertex, "Int", 2, "Ptr", &gRect, "Int", 1, "UInt", 0x0)
    NumPut(ProgLen+1, pRect2, 0, "UInt")
    NumPut(1, pRect2, 4, "UInt")
    NumPut(pWidth-1, pRect2, 8, "UInt")
    NumPut(pHeight-1, pRect2, 12, "UInt")
    hBrush := DllCall("Gdi32\CreateSolidBrush", "UInt", LVA_DrawProgressGetStatus(1), "UPtr")
    DllCall("FillRect", "Ptr", mDC, "Ptr", &pRect2, "Ptr", hBrush)
    DllCall("Gdi32\DeleteObject", "Ptr", hBrush)
    If (pLeft < 0)
      DllCall("Gdi32\BitBlt", "Ptr",  hDC
                            , "UInt", NumGet(pRect, 0, "UInt")-pLeft-1
                            , "UInt", NumGet(pRect, 4, "UInt")+1
                            , "UInt", NumGet(pRect, 8, "UInt")
                            , "UInt", NumGet(pRect, 12, "UInt")-1
                            , "Ptr",  mDC
                            , "UInt", -pLeft-3
                            , "UInt", 0
                            , "UInt", 0xCC0020)
    Else
      DllCall("Gdi32\BitBlt", "Ptr",  hDC
                            , "UInt", NumGet(pRect, 0, "UInt")+2
                            , "UInt", NumGet(pRect, 4, "UInt")+1
                            , "UInt", NumGet(pRect, 8, "UInt")
                            , "UInt", NumGet(pRect, 12, "UInt")-1
                            , "Ptr",  mDC
                            , "UInt", 0
                            , "UInt", 0
                            , "UInt", 0xCC0020)
    DllCall("DeleteDC", "Ptr", mDC)
    DllCall("ReleaseDC", "Ptr", hHandle, "Ptr", hDC)
  }
  ; ----------------------------------------------------------------------------------------------------------------------
  LVA_Info(Switch, Name, Row := 0, Col := 0, Data := 0)
  {
    Static
    If (Switch = 0)
    {
      Loop, % LVA_GetCellNum("GetRows", Name)
      {
        lRow := A_Index
        If LVA_InfoArray_%Name%_%lRow%_0_HasCellColor
          LVA_InfoArray_%Name%_%lRow%_0_HasCellColor := ""
        Loop, % LVA_GetCellNum("GetCols", Name)
        {
          If LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasProgressBar
            LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasProgressBar := ""
          If LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasMultiImage
            LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasMultiImage := ""
          If LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasCellColor
            LVA_InfoArray_%Name%_%lRow%_%A_Index%_HasCellColor := ""
          If LVA_InfoArray_%Name%_0_%A_Index%_HasCellColor
            LVA_InfoArray_%Name%_0_%A_Index%_HasCellColor := ""
        }
      }
      Return
    }
    Else If (Switch = "GetStdColorBG")
      Return LVA_InfoArray_%Name%_BGColor
    Else If (Switch = "GetStdColorFG")
      Return LVA_InfoArray_%Name%_FGColor
    Else If (Switch = "GetCellColorBG")
      Return LVA_InfoArray_%Name%_%Row%_%Col%_BGColor
    Else If (Switch = "GetCellColorFG")
      Return LVA_InfoArray_%Name%_%Row%_%Col%_FGColor
    Else If (Switch = "GetCellType")
    {
      If LVA_InfoArray_%Name%_%Row%_%Col%_HasCellColor
        Return 1
      Else If LVA_InfoArray_%Name%_%Row%_%Col%_HasProgressBar
        Return 2
      Else If LVA_InfoArray_%Name%_%Row%_%Col%_HasMultiImage
        Return 3
      Else
        Return 0
    }
    Else If (Switch = "GetPB")
      Return LVA_InfoArray_%Name%_%Row%_%Col%_HasProgressBar
    Else If (Switch = "GetProgress")
      Return LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarProgress
    Else If (Switch = "GetPBR")
      Return LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarRange
    Else If (Switch = "GetPCB")
      Return LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarBckCol
    Else If (Switch = "GetPCS")
      Return LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarSCol
    Else If (Switch = "GetPCE")
      Return LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarECol
    Else If (Switch = "GetMI")
      Return LVA_InfoArray_%Name%_%Row%_%Col%_HasMultiImage
    Else If (Switch = "GetCol")
      Return LVA_InfoArray_%Name%_%Row%_%Col%_HasCellColor
    Else If (Switch = "GetARowBool")
      Return LVA_InfoArray_%Name%_ARowColor_Alternate
    Else If (Switch = "GetARowColB")
      Return LVA_InfoArray_%Name%_ARowColor_BColor
    Else If (Switch = "GetARowColF")
      Return LVA_InfoArray_%Name%_ARowColor_FColor
    Else If (Switch = "GetAColBool")
      Return LVA_InfoArray_%Name%_AColColor_Alternate
    Else If (Switch = "GetAColColB")
      Return LVA_InfoArray_%Name%_AColColor_BColor
    Else If (Switch = "GetAColColF")
      Return LVA_InfoArray_%Name%_AColColor_FColor
    Else If (Switch = "SetStdColorBG")
      LVA_InfoArray_%Name%_BGColor := Data
    Else If (Switch = "SetStdColorFG")
      LVA_InfoArray_%Name%_FGColor := Data
    Else If (Switch = "SetCellColorBG")
      LVA_InfoArray_%Name%_%Row%_%Col%_BGColor := Data
    Else If (Switch = "SetCellColorFG")
      LVA_InfoArray_%Name%_%Row%_%Col%_FGColor := Data
    Else If (Switch = "SetPB")
      LVA_InfoArray_%Name%_%Row%_%Col%_HasProgressBar := Data
    Else If (Switch = "SetProgress")
      LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarProgress := Data
    Else If (Switch = "SetPBR")
      LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarRange := Data
    Else If (Switch = "SetPCB")
      LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarBckCol := Data
    Else If (Switch = "SetPCS")
      LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarSCol := Data
    Else If (Switch = "SetPCE")
      LVA_InfoArray_%Name%_%Row%_%Col%_ProgressBarECol := Data
    Else If (Switch = "SetMI")
      LVA_InfoArray_%Name%_%Row%_%Col%_HasMultiImage := Data
    Else If (Switch = "SetCol")
      LVA_InfoArray_%Name%_%Row%_%Col%_HasCellColor := Data
    Else If (Switch = "SetARowBool")
      LVA_InfoArray_%Name%_ARowColor_Alternate := Data
    Else If (Switch = "SetARowColB")
      LVA_InfoArray_%Name%_ARowColor_BColor := Data
    Else If (Switch = "SetARowColF")
      LVA_InfoArray_%Name%_ARowColor_FColor := Data
    Else If (Switch = "SetAColBool")
      LVA_InfoArray_%Name%_AColColor_Alternate := Data
    Else If (Switch = "SetAColColB")
      LVA_InfoArray_%Name%_AColColor_BColor := Data
    Else If (Switch = "SetAColColF")
      LVA_InfoArray_%Name%_AColColor_FColor := Data
  }