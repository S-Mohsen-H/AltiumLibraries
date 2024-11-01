@REM // git add .
@REM // {
@REM // // Fri 11/01/2024
@REM // // set backupFilename=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
@REM // 01/11/2024
@REM // set DD=%DATE:~0,2%
@REM // set MM=%DATE:~3,2%
@REM // set YYYY=%DATE:~6,4%
@REM // echo %MM%
@REM // echo %backupFilename%
@REM // 20241101

@REM int main()
@REM {
@REM 	// int gy = g_y - 1600;
@REM 	// int gm = g_m - 1;
@REM 	// int gd = g_d - 1;
@REM 	static int gregorian_days_in_month[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
@REM 	static int jalali_days_in_month[] = {31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29};
@REM 	int gy = YYYY - 1600;
@REM 	int gm = MM - 1;
@REM 	int gd = DD - 1;

@REM 	int i;

@REM 	int g_day_no = 365 * gy + _div(gy + 3, 4) - _div(gy + 99, 100) + _div(gy + 399, 400);

@REM 	for (i = 0; i < gm; ++i)
@REM 	{
@REM 		g_day_no += gregorian_days_in_month[i];
@REM 	}

@REM 	if (gm > 1 && ((gy % 4 == 0 && gy % 100 != 0) || (gy % 400 == 0)))
@REM 	{
@REM 		g_day_no++;
@REM 	}

@REM 	g_day_no += gd;

@REM 	int j_day_no = g_day_no - 79;

@REM 	int j_np = _div(j_day_no, 12053);
@REM 	j_day_no = j_day_no % 12053;

@REM 	int jy = 979 + 33 * j_np + 4 * _div(j_day_no, 1461);

@REM 	j_day_no %= 1461;

@REM 	if (j_day_no >= 366)
@REM 	{
@REM 		jy += _div(j_day_no - 1, 365);
@REM 		j_day_no = (j_day_no - 1) % 365;
@REM 	}

@REM 	for (i = 0; i < 11 && j_day_no >= jalali_days_in_month[i]; ++i)
@REM 	{
@REM 		j_day_no -= jalali_days_in_month[i];
@REM 	}

@REM 	int jm = i + 1;
@REM 	int jd = j_day_no + 1;

@REM 	int YEAR = _inttostr(jy);
@REM 	int MONTH = _inttostr(jm);
@REM 	int DAY = _inttostr(jd);
@REM }
@REM // }


@REM @echo off
setlocal enabledelayedexpansion

@REM set DD=%DATE:~0,2%
@REM set MM=%DATE:~3,2%
@REM set YYYY=%DATE:~6,4%

:: Set days in months for Gregorian and Jalali calendars
set gregorian_days_in_month=31 28 31 30 31 30 31 31 30 31 30 31
set jalali_days_in_month=31 31 31 31 31 31 30 30 30 30 30 29

:: Input year, month, and day (assumed to be set)
set /a gy=%DATE:~0,2%-1600
set /a gm=%DATE:~3,2%-1
set /a gd=%DATE:~6,4%-1

:: Calculate total days in Gregorian calendar
set /a g_day_no=365*gy+(gy+3)/4-(gy+99)/100+(gy+399)/400

for /l %%i in (0,1,%gm%) do (
    for %%j in (!gregorian_days_in_month!) do (
        set /a g_day_no+=%%j
        set /a gm-=1
        if !gm! lss 0 (
            goto endloop
        )
    )
)
:endloop

if %gm% gtr 1 (
    set /a leap_check=(gy %% 4 == 0 && gy %% 100 != 0) || (gy %% 400 == 0)
    if !leap_check! equ 1 (
        set /a g_day_no+=1
    )
)

set /a g_day_no+=gd
set /a j_day_no=g_day_no-79

set /a j_np=j_day_no/12053
set /a j_day_no=j_day_no%%12053

set /a jy=979+33*j_np+4*(j_day_no/1461)
set /a j_day_no=j_day_no%%1461

if !j_day_no! geq 366 (
    set /a jy+=j_day_no/365
    set /a j_day_no=j_day_no-1
    set /a j_day_no=j_day_no%%365
    @REM set /a j_day_no=(j_day_no-1)%365
)

:: Calculate month and day in Jalali calendar
set i=0
for %%k in (%jalali_days_in_month%) do (
    if !j_day_no! geq %%k (
        set /a j_day_no-=%%k
        set /a i+=1
    ) else (
        goto endmonthloop
    )
)
:endmonthloop

set /a jm=i+1
set /a jd=j_day_no+1

:: Output results
echo YEAR: !jy!
echo MONTH: !jm!
echo DAY: !jd!

endlocal
