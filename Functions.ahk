/**
 * Lib: Functions.ahk
 *     Common functions for GPrompt Explorer
 */


/**
 *     Load() - see relevant documentation before method definition header
 *     Dump() - see relevant documentation before method definition header
 */
 
 
 
 
 
 getLatestReleaseInfo(owner, repository)
{
	tmpfile := A_Temp . "\gitinfo-ahk"
	UrlDownloadToFile, https://api.github.com/repos/%owner%/%repository%/releases/latest, %tmpfile%
    FileRead, contents, %tmpfile%
    ;msgbox % contents
	obj := Jxon_Load(contents)
	FileDelete, %tmpfile%
	return obj
}


/*

; Get release info for RocketChat/Rocket.Chat.git as AHK Object
releaseInfo := getLatestReleaseInfo("RocketChat", "Rocket.Chat")

; Get release name from tag
releaseTag := releaseInfo.tag_name

; Get release published date (release date)
releaseDate := RegExReplace(releaseInfo.published_At, "[T:\-]", "")


msgbox % "Release Tag: " . releaseTag . "  Release Date: " . releaseInfo.published_At
msgbox % releaseInfo.body
*/



getSelected() 
{
    ControlGetFocus, control, A
    VarSetCapacity(start, 4)
    VarSetCapacity(end, 4)
    SendMessage, 0xB0, &start, &end, %control%, A		;EM_GETSEL
    ControlGetText, string, %control%, A
    ;enc := (RegexMatch(string,"[\x{0100}-\x{FFFF}]")?"cp0":"utf-16") ;detect encoding of string
    string := SubStr(StrGet(&string), pos := NumGet(start) + 1, NumGet(end) - pos + 1)
    return string

}






    ; This function will receive the messages sent by both Toolbar's buttons.
    TB_Messages(wParam, lParam)
    {
        Global ; Function (or at least the Handles) must be global.
        ;msgbox % "WP: " . wParam . " - LP: " . lParam
        
        TB1.OnMessage(wParam) ; Handles messages from TB1
        TB2.OnMessage(wParam) ; Handles messages from TB2
    }
    
    ; This function will receive the notifications.
    TB_Notify(wParam, lParam)
    {
        Global ; Function (or at least the Handles) must be global.
        ;msgbox % "WP: " . wParam . " - LP: " . lParam
        ReturnCode := TB1.OnNotify(lParam) ; Handles notifications.
        If (ReturnCode = "") ; Check if previous return was blank to know if you should call OnNotify for the next.
            ReturnCode := TB2.OnNotify(lParam)                 ; The return value contains the required
        ;If (Label)                                             ; return for the call, so it must be
            ;ShowMenu(Label, MX, MY)                            ; passed as return parameter.
        return ReturnCode
    }
    
    
    
    
    
    ;global numTokens := obj.num_tokens
    ;global success := obj.success
    ;global tokens := obj.tokens[1]
    
    
    PopUpGUI(eJson)
    {
    global
        
        numTokens := eJson.num_tokens
        ;success := eJson.success
        tokens := eJson.tokens
        
        
    
        if numTokens > 0
        {
    
            ; Initialize an empty string to hold the concatenated tokens
            tokenString := ""
    
            ; Loop over the `tokens` array and concatenate each element to `tokenString`
            Loop, % tokens.Length()
            {
                tokenString .= tokens[A_Index] . " "
            }
    
            ; `tokenString` now contains the concatenated tokens
           ; MsgBox % tokenString
    
        }
        else
        {
            Gui, Estimator:Destroy
        }
    
        Gui  Estimator:New, +AlwaysOnTop
        Gui, Estimator:Add, text, x10 y10 w200 h25 , Token Count (Estimate)
        Gui, Estimator:Add, Edit, x10 y25 w200 h25 vTokenCount, %numTokens%
        Gui, Estimator:Add, text, x10 y55 w200 h25 , Individual tokens List
        Gui, Estimator:Add, Edit, x10 y75 w200 r6 vTokenDisplay, %tokenString%
     
        Gui, Show
        
        return
    
    }
    
    
    GetTokenEstimate(string)
    {
        
    
        url := "https://zero-workspace-server.uc.r.appspot.com/tokenizer"
    
        curl := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        curl.Open("POST", url)
        curl.SetRequestHeader("Accept", "application/json")
        curl.SetRequestHeader("Content-Type", "application/json")
        d = "text"
        ;data := "{d:""" . string . """}"
        data :=  "{" . d .  ": " . chr(34) . string . chr(34) . "}" 
        curl.Send(data)
    
        resp := curl.ResponseText
        
        werror := SubStr(resp, 1 , 1)
            if (werror = "<")
            {
                msgbox, Some sort of Bad response from the server. Most likey a strange charactor in the prompt. Error `n`n %resp%
                SB_SetIcon(A_ScriptDir . "\Img\RedDot.ico", 1, 1)
                exit
            }
            
        ;msgbox %  resp
        obj := JSON.Load(resp)
        
        SB_SetIcon(A_ScriptDir . "\Img\GreenDot.ico", 1, 1)
        ; Access the values
        ;numTokens := obj.num_tokens
        ;success := obj.success
        ;tokens := obj.tokens[1]
        
        return obj
        ; Print the values
        ;MsgBox % "num_tokens: " numTokens "`n" "success: " success "`n" "tokens: " tokens
    
    
    }





        ; Function to search through an array and return the index of the first matching item
    FindIndex(arr, str) {
        for index, value in arr {
            ;MsgBox % "Item " index " is '" value "'"
            if (InStr(value, str)){
                return index
            }
        }
        return -1
    }
    
    
    ;folder = %A_WorkingDir%\Prompts
    LoadSettingsIni()
    {
    global
        ; Check if Settings.ini exists
        if (FileExist("Settings.ini"))
        {
            ; If it does, read the settings from it
            IniRead, Folder, %A_ScriptDir%\Settings.ini, General, PromptDir, 
        }
        else
        {
            ; If it doesn't, create it and write the default settings to it
            IniWrite, " ", %A_ScriptDir%\Settings.ini, General, PromptDir
            
        }
    }
    
    SetSettingIni(value, key, isection="General")
    {
    IniWrite, %value%, %A_ScriptDir%\Settings.ini, %isection%, %key%
    
    }



