@echo off
rem make script for ReactOS Noble theme
rem ------------------------------------------------------

setlocal EnableDelayedExpansion
set _dir=%cd%
set _prefix=bin

if not [%~1] == [] (
	set _prefix=%~1
)

call :main
endlocal
exit /B 0

:main (
	call :mk_bin
	call :mk_theme
	exit /B 0
)

:mk_bin (
	echo [+] creating theme directory tree..
    mkdir "%_prefix%"
    mkdir "%_prefix%\media"
    mkdir "%_prefix%\media\themes"
    mkdir "%_prefix%\media\themes\noble.msstyles"
	mkdir "%_prefix%\media\themes\noble.msstyles\lang"
	mkdir "%_prefix%\media\themes\noble.msstyles\textfiles"
	mkdir "%_prefix%\media\themes\noble.msstyles\bitmaps"
	mkdir "%_prefix%\media\themes\noble.msstyles\bitmaps\Light"
	mkdir "%_prefix%\media\themes\noble.msstyles\bitmaps\Dark"
   
    exit /B 0
)

:mk_theme (
	call :mk_bitmaps_light
	call :mk_bitmaps_dark
	call :mk_lang
	call :mk_theme_textfiles	

	echo [+] copying LICENSE for theme....
	copy "%_dir%\src\themes\noble.msstyles\LICENSE" ^
	"%_prefix%\media\themes\noble.msstyles\LICENSE"
	
	echo [+] copying theme CMakeLists.txt....
	copy "%_dir%\src\themes\noble.msstyles\CMakeLists.txt" ^
	"%_prefix%\media\themes\noble.msstyles\CMakeLists.txt"
	
	echo [+] copying theme rc....
	copy "%_dir%\src\themes\noble.msstyles\noble.rc" ^
	"%_prefix%\media\themes\noble.msstyles\noble.rc"
	
	echo [+] updating reactos theme CMake....
	type "%_dir%\src\wallpapers\CMakeLists.txt" ^
	>> "%_prefix%\modules\wallpapers\CMakeLists.txt"
	
	exit /B 0
)

:mk_bitmaps_light (
	set /p response="[+] build Light theme bitmaps? (Y/N): "
	for %%q in ("Y" "y") do (
		if "%response%"==%%q (
			echo [+] building Light theme bitmaps....
			call "%_dir%\scripts\tif2bmp.cmd" ^
			"%_dir%\src\themes\noble.msstyles\bitmaps\Light\" ^
			"%_prefix%\media\themes\noble.msstyles\bitmaps\Light\"
			exit /B 0
		)
	)
	for %%q in ("n" "y") do (
		if "%response%"==%%q (
			echo [x] skipped building Light theme bitmaps....
			exit /B 0
		)
	)
	goto :mk_bitmaps_light
)

:mk_bitmaps_dark (
	set /p response="[+] build Dark theme bitmaps? (Y/N): "
	for %%q in ("Y" "y") do (
		if "%response%"==%%q (
			echo [+] building Dark theme bitmaps....
			call "%_dir%\scripts\tif2bmp.cmd" ^
			"%_dir%\src\themes\noble.msstyles\bitmaps\Dark\" ^
			"%_prefix%\media\themes\noble.msstyles\bitmaps\Dark\"
			exit /B 0
		)
	)
	for %%q in ("n" "y") do (
		if "%response%"==%%q (
			echo [x] skipped building Dark theme bitmaps....
			exit /B 0
		)
	)
	goto :mk_bitmaps_dark
)

:mk_lang (
	echo [+] copying theme language files..
	xcopy "%_dir%\src\themes\noble.msstyles\lang\*" ^
	"%_prefix%\media\themes\noble.msstyles\lang\"
	exit /B 0
)

:mk_theme_textfiles (
	echo [+] copying theme textfiles....
	xcopy "%_dir%\src\themes\noble.msstyles\textfiles\*" ^
	"%_prefix%\media\themes\noble.msstyles\textfiles\*" /s
	exit /B 0
)
