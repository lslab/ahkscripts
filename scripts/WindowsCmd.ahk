^+1::WinSet, Transparent, 15,A
^+2::WinSet, Transparent, 40,A
^+3::WinSet, Transparent, 75,A
^+4::WinSet, Transparent, 100,A
^+5::WinSet, Transparent, 125,A
^+6::WinSet, Transparent, 150,A
^+7::WinSet, Transparent, 175,A
^+8::WinSet, Transparent, 200,A
^+9::WinSet, Transparent, 225,A
^+0::WinSet, Transparent, 255,A
^+t::WinSet, AlwaysOnTop, toggle, A
^+l::WinMove, A,,0, 0
^+r::
WinGetPos,,, Width, Height, A
WinMove, A,,A_ScreenWidth-Width, A_ScreenHeight-Height
return
^+]::
WinGetPos,,, Width, Height, A
WinMove, A,,A_ScreenWidth-Width, 0
return
^+[::
WinGetPos,,, Width, Height, A
WinMove, A,,0, A_ScreenHeight-Height
return
^+c::
WinGetPos,,, Width, Height, A
WinMove, A,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
return
;windows7已经实现此功能
;#UP:: WinMaximize,A
;#Down::WinMinimize,A
;#x::WinClose,A

;双击esc，关闭窗口
~Esc::
Keywait, Escape, , t0.5
if errorlevel = 1
return
else
Keywait, Escape, d, t0.1
if errorlevel = 0
{
WinGetActiveTitle, Title
WinClose, %Title%
return
}
return 
~LButton & Del::
WinGetActiveTitle, Title
WinClose, %Title%
return 

;左右鼠标键同时按住，关闭窗口
/*此功能关闭，影响totalcmd的使用鼠标移动功能
~LButton & RButton::
WinGetActiveTitle, Title
WinClose, %Title%
return 
*/

/*
; Press Win+T to make the color under the mouse cursor invisible.
^+!t::	
MouseGetPos, MouseX, MouseY, MouseWin
PixelGetColor, MouseRGB, %MouseX%, %MouseY%, RGB
; In seems necessary to turn off any existing transparency first:
WinSet, TransColor, Off, ahk_id %MouseWin%
WinSet, TransColor, %MouseRGB% 220, ahk_id %MouseWin%
return

; Press Win+O to turn off transparency for the window under the mouse.
^+!o::  
MouseGetPos,,, MouseWin
WinSet, TransColor, Off, ahk_id %MouseWin%
return

; Press Win+G to show the current settings of the window under the mouse.
^+!g::  
MouseGetPos,,, MouseWin
WinGet, Transparent, Transparent, ahk_id %MouseWin%
WinGet, TransColor, TransColor, ahk_id %MouseWin%
ToolTip Translucency:`t%Transparent%`nTransColor:`t%TransColor%
return
*/
^!r::Reload

/*
^!s::Suspend
^!i::
FileSetAttrib, ^H, %A_Desktop%\*,1
FileSetAttrib, ^H, %A_DesktopCommon%\*,1
return
^!d::
SendMessage, 0x111, 29698,,, ahk_class Progman
return
^!p::
inputbox inputTime,打印延时时长,请输入打印延时时长（单位：秒）
if ErrorLevel
    return
else
{    
	sleep 500
	x=%inputTime%
	if x is integer
	{
		x*=1000
		;msgbox %x%
		send ^p
		sleep %x%
		send {Enter}
		return		
	}
	else
		return
}

;from NiftyWindows
#WheelUp::
#+WheelUp::
#WheelDown::
#+WheelDown::
	Gosub, TRA_CheckWinIDs
	SetWinDelay, -1
	IfWinActive, A
	{
		WinGet, TRA_WinID, ID
		If ( !TRA_WinID )
			Return
		WinGetClass, TRA_WinClass, ahk_id %TRA_WinID%
		If ( TRA_WinClass = "Progman" )
			Return
		
		IfNotInString, TRA_WinIDs, |%TRA_WinID%
			TRA_WinIDs = %TRA_WinIDs%|%TRA_WinID%
		TRA_WinAlpha := TRA_WinAlpha%TRA_WinID%
		TRA_PixelColor := TRA_PixelColor%TRA_WinID%
		
		IfInString, A_ThisHotkey, +
			TRA_WinAlphaStep := 255 * 0.01 ; 1 percent steps
		Else
			TRA_WinAlphaStep := 255 * 0.1 ; 10 percent steps

		If ( TRA_WinAlpha = "" )
			TRA_WinAlpha = 255

		IfInString, A_ThisHotkey, WheelDown
			TRA_WinAlpha -= TRA_WinAlphaStep
		Else
			TRA_WinAlpha += TRA_WinAlphaStep

		If ( TRA_WinAlpha > 255 )
			TRA_WinAlpha = 255
		Else
			If ( TRA_WinAlpha < 0 )
				TRA_WinAlpha = 0

		If ( !TRA_PixelColor and (TRA_WinAlpha = 255) )
		{
			Gosub, TRA_TransparencyOff
			SYS_ToolTipText = Transparency: OFF
		}
		Else
		{
			TRA_WinAlpha%TRA_WinID% = %TRA_WinAlpha%

			If ( TRA_PixelColor )
				WinSet, TransColor, %TRA_PixelColor% %TRA_WinAlpha%, ahk_id %TRA_WinID%
			Else
				WinSet, Transparent, %TRA_WinAlpha%, ahk_id %TRA_WinID%

			TRA_ToolTipAlpha := TRA_WinAlpha * 100 / 255
			Transform, TRA_ToolTipAlpha, Round, %TRA_ToolTipAlpha%
			SYS_ToolTipText = Transparency: %TRA_ToolTipAlpha% `%
		}		
	}
Return

TRA_CheckWinIDs:
	DetectHiddenWindows, On
	Loop, Parse, TRA_WinIDs, |
		If ( A_LoopField )
			IfWinNotExist, ahk_id %A_LoopField%
			{
				StringReplace, TRA_WinIDs, TRA_WinIDs, |%A_LoopField%, , All
				TRA_WinAlpha%A_LoopField% =
				TRA_PixelColor%A_LoopField% =
			}
Return

TRA_TransparencyOff:
	Gosub, TRA_CheckWinIDs
	SetWinDelay, -1
	If ( !TRA_WinID )
		Return
	IfNotInString, TRA_WinIDs, |%TRA_WinID%
		Return
	StringReplace, TRA_WinIDs, TRA_WinIDs, |%TRA_WinID%, , All
	TRA_WinAlpha%TRA_WinID% =
	TRA_PixelColor%TRA_WinID% =
	; TODO : must be set to 255 first to avoid the black-colored-window problem
	WinSet, Transparent, 255, ahk_id %TRA_WinID%
	WinSet, TransColor, OFF, ahk_id %TRA_WinID%
	WinSet, Transparent, OFF, ahk_id %TRA_WinID%
	WinSet, Redraw, , ahk_id %TRA_WinID%
Return

TRA_TransparencyAllOff:
	Gosub, TRA_CheckWinIDs
	Loop, Parse, TRA_WinIDs, |
		If ( A_LoopField )
		{
			TRA_WinID = %A_LoopField%
			Gosub, TRA_TransparencyOff
		}
Return





^WheelUp::
^+WheelUp::
^WheelDown::
^+WheelDown::
	; TODO : the following code block is a workaround to handle 
	; virtual ALT calls in WheelDown/Up functions
	
	SetWinDelay, -1
	CoordMode, Mouse, Screen
	IfWinActive, A
	{
		WinGet, SIZ_WinID, ID
		If ( !SIZ_WinID )
			Return
		WinGetClass, SIZ_WinClass, ahk_id %SIZ_WinID%
		If ( SIZ_WinClass = "Progman" )
			Return
		
		GetKeyState, SIZ_CtrlState, Ctrl, P
		WinGet, SIZ_WinMinMax, MinMax, ahk_id %SIZ_WinID%
		WinGet, SIZ_WinStyle, Style, ahk_id %SIZ_WinID%

		; checks wheter the window isn't maximized and has a sizing border (WS_THICKFRAME)
		If ( (SIZ_CtrlState = "D") or ((SIZ_WinMinMax != 1) and (SIZ_WinStyle & 0x40000)) )
		{
			WinGetPos, SIZ_WinX, SIZ_WinY, SIZ_WinW, SIZ_WinH, ahk_id %SIZ_WinID%
			
			If ( SIZ_WinW and SIZ_WinH )
			{
				SIZ_AspectRatio := SIZ_WinW / SIZ_WinH

				IfInString, A_ThisHotkey, WheelDown
					SIZ_Direction = 1
				Else
					SIZ_Direction = -1
				
				IfInString, A_ThisHotkey, +
					SIZ_Factor = 0.01
				Else
					SIZ_Factor = 0.1
				
				SIZ_WinNewW := SIZ_WinW + SIZ_Direction * SIZ_WinW * SIZ_Factor
				SIZ_WinNewH := SIZ_WinH + SIZ_Direction * SIZ_WinH * SIZ_Factor
				
				IfInString, A_ThisHotkey, #
				{
					SIZ_WinNewX := SIZ_WinX + (SIZ_WinW - SIZ_WinNewW) / 2
					SIZ_WinNewY := SIZ_WinY + (SIZ_WinH - SIZ_WinNewH) / 2
				}
				Else
				{
					SIZ_WinNewX := SIZ_WinX
					SIZ_WinNewY := SIZ_WinY
				}
				
				If ( SIZ_WinNewW > A_ScreenWidth )
				{
					SIZ_WinNewW := A_ScreenWidth
					SIZ_WinNewH := SIZ_WinNewW / SIZ_AspectRatio
				}
				If ( SIZ_WinNewH > A_ScreenHeight )
				{
					SIZ_WinNewH := A_ScreenHeight
					SIZ_WinNewW := SIZ_WinNewH * SIZ_AspectRatio
				}				
				Transform, SIZ_WinNewX, Round, %SIZ_WinNewX%
				Transform, SIZ_WinNewY, Round, %SIZ_WinNewY%
				Transform, SIZ_WinNewW, Round, %SIZ_WinNewW%
				Transform, SIZ_WinNewH, Round, %SIZ_WinNewH%				
				WinMove, ahk_id %SIZ_WinID%, , SIZ_WinNewX, SIZ_WinNewY, SIZ_WinNewW, SIZ_WinNewH			
				
			}
		}
	}
Return

!LButton::
MouseGetPos,oldmx,oldmy,mwin,mctrl
Loop
{
  GetKeyState,lbutton,LButton,P
  GetKeyState,alt,Alt,P
  If (lbutton="U" Or alt="U")
    Break
  MouseGetPos,mx,my
  WinGetPos,wx,wy,ww,wh,ahk_id %mwin%
  wx:=wx+mx-oldmx
  wy:=wy+my-oldmy
  WinMove,ahk_id %mwin%,,%wx%,%wy%
  oldmx:=mx
  oldmy:=my
}
Return

*/

;Total Commander scripts

; Ctrl-#-Alt-G (Total Commander: splitter menu)
!#^s::
	if not WinActive( "ahk_class TTOTAL_CMD" )
		Return

	WinGet sf_aControls, ControlList
	Loop Parse, sf_aControls, `n
	{
		StringLeft sf_sTemp, A_LoopField, 6
		if (sf_sTemp = "TPanel")
		{
			ControlGetPos Cx,Cy,Cw,Ch, %A_LoopField%
			if (Cw < 16)
			{
				ControlClick %A_LoopField%, A,,RIGHT
				Break
			}
		}
	}
	Return
;get mouse point color
!#^c::
MouseGetPos, mousex, mousey
PixelGetColor, color, %mousex%, %mousey%
StringRight, color, color, 6
;Clipboard = %color%
ToolTip, %color%
Sleep, 2000
ToolTip, 
return

!#^d::
wday = %A_WDay%
;获取当前星期
if (wday = 1)
    wday = 星期日
if (wday = 2)
    wday = 星期一
if (wday = 3)
    wday = 星期二
if (wday = 4)
    wday = 星期三
if (wday = 5)
    wday = 星期四
if (wday = 6)
    wday = 星期五
if (wday = 7)
    wday = 星期六
;获取的是1-7的数字, 要转化为中文
StringRight, yweek, A_YWeek, 2
ToolTip, %A_YYYY%年%A_MM%月%A_DD%日 %wday% %A_Hour%:%A_Min%:%A_Sec%`n第%yweek%星期 第%A_YDay%天
;格式化显示日期
Sleep, 3000
ToolTip, 
;3秒钟后提示消失
return


