local TimeUtil = {}

-- -- 将一个时间数转换成"00:00:00"格式
function TimeUtil:getTimeString1(timeInt)
    if (tonumber(timeInt) <= 0) then
        return "00:00:00"
    else
        return string.format("%02d:%02d:%02d", math.floor(timeInt/(60*60)), math.floor((timeInt/60)%60), timeInt%60)
    end
end

-- 将一个时间数转换成"00:00"格式
function TimeUtil:getTimeString(timeInt)
    if (tonumber(timeInt) <= 0) then
        return "00:00"
    else
        return string.format("%02d:%02d", math.floor((timeInt/60)%60), timeInt%60)
    end
end

-- 将一个时间数转换成"00"分格式
function TimeUtil:getTimeMinuteString(timeInt)
    if (tonumber(timeInt) <= 0) then
        return "00"
    else
        return string.format("%02d", math.floor((timeInt/60)%60))
    end
end

-- 将一个时间数转换成"00“秒格式
function TimeUtil:getTimeSecondString(timeInt)
    if (tonumber(timeInt) <= 0) then
        return "00"
    else
        return string.format("%02d", timeInt%60)
    end
end

-- 将一个时间戳转换
function TimeUtil:getTimeStampString(time,splitStr,haveSec)
    if not time then
        return ""
    end
    time = tonumber(time)
    if time<0 then
        return ""
    end
    if not splitStr then splitStr="_" end
    local date = os.date("*t",time)
    local year = date.year
    local month = date.month
    if tonumber(month)<10 then
        month = "0"..month
    end
    local day = date.day
    if tonumber(day)<10 then
        day = "0"..day
    end
    local hour = date.hour
    if tonumber(hour)<10 then
        hour = "0"..hour
    end
    local min = date.min
    if tonumber(min)<10 then
        min = "0"..min
    end
    if haveSec==true then
        local sec = date.sec
        if tonumber(sec)<10 then
            sec = "0"..sec
        end
        return date.year..splitStr..month..splitStr..day.."  "..hour..":"..min.."  "..sec
    end
    return date.year..splitStr..month..splitStr..day.."  "..hour..":"..min
end

function TimeUtil:getTimeSimpleString(time,splitStr,ishaveYear, isnohaveTime)
    if not time then
        return ""
    end
    time = tonumber(time)
    if time<0 then
        return ""
    end

    if not splitStr then splitStr="_" end
    local date = os.date("*t",time)
    local year = date.year
    local month = date.month
    if tonumber(month)<10 then
        month = "0"..month
    end
    local day = date.day
    if tonumber(day)<10 then
        day = "0"..day
    end
    local hour = date.hour
    if tonumber(hour)<10 then
        hour = "0"..hour
    end
    local min = date.min
    if tonumber(min)<10 then
        min = "0"..min
    end
    -- 
    if ishaveYear then
        if isnohaveTime then
            return year..splitStr..month..splitStr..day
        else
            return year..splitStr..month..splitStr..day.."  "..hour..":"..min
        end
    else
        return month..splitStr..day.."  "..hour..":"..min
    end
end

-- Author: KevinYu
-- Date: 2015-11-12 11:44:29
-- 扩展功能

--[[
os.date("*t", time) 返回的table
time = {
    "day"   = 12 日
    "hour"  = 15 时
    "isdst" = false 是否夏令时
    "min"   = 7 分
    "month" = 11 月
    "sec"   = 12 秒
    "wday"  = 5 星期几(星期天为1)
    "yday"  = 316 一年中的第几天
    "year"  = 2015 年
 }]]

--获取本月相关数据
function TimeUtil:getMonthData(time)
    local data = {}
    data.firstDayWeek = self:getWeekOfMonthFirstDay(time)
    data.year = self:getYear(time)
    data.month = self:getMonth(time)
    data.day = self:getDay(time)
    data.monthDays = self:getMonthDays_(data.year, data.month)

    return data
end

--获取本月一号是星期几
function TimeUtil:getWeekOfMonthFirstDay(time)
    time = tonumber(time)
    local tab = os.date("*t", time)
    local year, month, day, wday = tab.year, tab.month, tab.day, tab.wday
    local f_wday = 1
    day = day % 7 --转换到1-7号对应的第几天  星期天为第1天
    if day == 0 then
        f_wday = wday + 1
    else
        if day > wday then
            f_wday = wday - day + 8
        else
            f_wday = wday - day + 1
        end
    end

    return f_wday - 1  --返回0 - 6 对应星期天-星期六
end

--判断是否为闰年
function TimeUtil:isLeapYear(year)
    if (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0) then
        return true
    end

    return false
end

--每个月对应的天数
local months = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

function TimeUtil:getMonthDays_(year, month)
    if month == 2 then
        if self:isLeapYear(year) then
            return 29
        else
            return 28
        end
    else
        return months[month]
    end
end

function TimeUtil:getMonthDays(time)
    local tab = os.date("*t", time)
    return self:getMonthDays_(tab.year, tab.month)
end

--年
function TimeUtil:getYear(time)
    return tonumber(os.date("%Y", time))
end

--月
function TimeUtil:getMonth(time)
    return tonumber(os.date("%m", time))
end

--日
function TimeUtil:getDay(time)
    return tonumber(os.date("%d", time))
end

--时
function TimeUtil:getHour(time)
    return tonumber(os.date("%H", time))
end

--分
function TimeUtil:getMinutes(time)
    return tonumber(os.date("%M", time))
end

--秒
function TimeUtil:getSeconds(time)
    return tonumber(os.date("%S", time))
end

--星期中的第几天，星期天为 0  与wday属性不一样
function TimeUtil:getWeekDay(time)
    return tonumber(os.date("%w", time))
end

--足球比赛时间格式
function TimeUtil:getFootballMathTime(time, separator)
    separator = separator or " "
    local date = os.date("*t", time)
    local dayStr = string.format("%02d/%02d", date.month, date.day)
    local timeStr = string.format("%02d:%02d", date.hour, date.min)

    return dayStr .. separator .. timeStr
end

return ConstClass("TimeUtil", TimeUtil)
