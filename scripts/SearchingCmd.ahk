;;;;;;;;;;;;;;;;;;
;
; Title: SearchInterfaceV3.ahk
; Author:    V3 modified by  David Lv      DAT 05-12-2008
; Usage : just copy this file and AltTab.ahk to where AutoHotKey is installed ( default to C:\Program Files\AutoHotkey)
; AutoHotkey Version: 1.0.47.05
; Language:       English
; Platform:       Win9x/NT
; 

; modified by liangsl at 2012-08-23 15:38:11
; deleting msdn searching etc.

;; google search by Win + a, search everything by Win + z
;; for easely using left mouse, adding RControl shortcut 

#a:: Gosub ,  GoogleSelectedText
RControl & .:: Gosub ,  GoogleSelectedText
#z:: Gosub ,  SearchEverything
RControl & /:: Gosub ,  SearchEverything
RControl & ':: Gosub ,  BaiduSelectedText
RControl & ]:: Gosub ,  YoudaoSelectedWord
RControl & [:: Gosub ,  ICibaSelectedWord



GoogleSelectedText:   ; Search Internet for selected text using Google
SearchTerm := Get_Selected_Text()
If SearchTerm is space
{
   Run , http://www.google.com/
   Return      
}
;;MsgBox %SearchTerm%
;; Run , http://www.google.com/search?q=%SearchTerm%&ie=utf-8&oe=utf-8
Run ,  http://www.google.com/search?q=%SearchTerm%&ie=utf-8&oe=utf-8
Return


BaiduSelectedText:   ; Search Internet for selected text using Baidu
SearchWord := Get_Selected_Text()
If SearchWord is space
{
   Run , http://www.baidu.com/
   Return      
}
Run ,  http://www.baidu.com/s?wd=%SearchWord%
Return


YoudaoSelectedWord:   ; Search Internet for selected text using youdao dict
SearchWord := Get_Selected_Text()
If SearchWord is space
{
   Run , http://dict.youdao.com/
   Return      
}
Run ,  http://dict.youdao.com/search?q=%SearchWord%
Return

ICibaSelectedWord:   ; Search Internet for selected text using iciba dict
SearchWord := Get_Selected_Text()
If SearchWord is space
{
   Run , http://www.iciba.com
   Return      
}
Run ,  http://www.iciba.com/%SearchWord%
Return


;;;;;;;;;;;;;;;;;;;;;;;
; Opens Everything with highlighted text in search box. If Everything is running already,
; and no change to highlighted text, Everything toggles between minimises and restored.
;
; The logic is a bit counterintuitive because of the way the search box entry gets
; highlighted by Everything when it launches.

SearchEverything:   
EverythingPath := "d:\tools\freetools\everything\Everything.exe"
SearchE := Get_Selected_Text()
StringLeft , SearchE , SearchE , 100 ; reduce to <= 100 characters
If  SearchE      ; Do this if text exists
{
   Gosub , RunE
   Return
}
Else          ; Do this if no text exists
{
   IfWinExist , ahk_class EVERYTHING
      WinClose, ahk_class EVERYTHING
   Else
   Gosub , RunE
}
Return

RunE:
Run , %EverythingPath% -search "%SearchE%", d:\tools\freetools\everything\
Return
;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;
; Stores the selected text into a variable: eg Text := Get_Selected_Text()

Get_Selected_Text() 
{
   WinGetActiveTitle, OutputVar
   If OutputVar is space   
   {
      Sterm =
      Goto , End
   }
   ClipSaved := ClipboardAll   ; Save clipboard content for later restore
   sleep , 100      ; Delays required else it can be unreliable
   Clipboard =      ; Flush clipboard
   Sleep, 100
   SendEvent, ^c   ; Save highlighted text to clipboard.
   sleep , 100
   STerm := Clipboard
   Sleep, 100
   Clipboard := ClipSaved   ; Restore Clipboard content 
   ClipSaved =            ; and free the memory
   End:
   Return , STerm      ; Search term now stored and ready
}
