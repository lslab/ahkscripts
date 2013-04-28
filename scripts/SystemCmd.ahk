^!h::shutdown,8

^!k::
inputbox,minutes,auto shutdown,please input number of minutes
if ErrorLevel
{
    return
}
else
{
    millisecs := minutes * 60 * 1000
    msgbox,%millisecs%
    sleep,%millisecs%
    shutdown,8
    return
}
