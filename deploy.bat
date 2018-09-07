@echo off

rem Generator
set genApp="C:\Program Files (x86)\nexacro\14\nexacrogenerator.exe"
rem Compressor
set cmpApp="C:\Program Files (x86)\nexacro\14\nexacrocompressor.exe"

rem Workspace Home
set wsHome=D:\BRM_Studio\workspace

rem Project Name
set prjName=builderbrm
rem Project Home
set prjHome=%wsHome%\B2B_BRM\web.war\un

rem Source Path
set srcPath=%prjHome%\%prjName%_src
rem Generate Path
set genPath=%prjHome%\%prjName%_gen
rem Deploy Path
set depPath=%prjHome%\%prjName%

rem Library Folder Name
set libName=nexacro14lib
rem Library Path
set libPath=%srcPath%\%libName%

rem ADL File
set adlPath=%srcPath%\%prjName%.xadl
rem File List
set listFile=deployFileList.txt

if not exist %listFile% (
	(
		echo #\builderbrm.xadl
		echo #\default_typedef.xml
		echo #\globalvars.xml
		echo #\Common.xtheme
		echo #\common\frame\frm_login.xfdl
		echo #\nexacro14lib\component\builderbrmLib\builderbrmComCode.js
		echo #\nexacro14lib\framework\BasicObjs.js
		echo #\images\btn_del.png
	) > %listFile%
)

FOR /F %%i IN (%listFile%) DO (

	for /f "tokens=1,2,3 delims=\" %%a in ("%%i") do (

		for /f "tokens=1 delims=\" %%a in ("%%i") do (
			if %%a==# (
				rem Continue
			) else (

				echo #############################################################################################
				echo # Source File : %%i
				echo #############################################################################################

				rem echo %%a
				rem echo %%b
				rem echo %%c

				echo.
				echo   ===============================
				echo   = 1. Generate
				echo   ===============================
				
				rem xadl
				if %%~xi==.xadl (
					if not defined bAdlGen (
						set bAdlGen=1
						%genApp% -A %adlPath% -O %genPath% -P %prjName% -B %libPath% -M -AO
					) else (
						echo Skip...
					)
				) else (
				rem xadl
				if %%a==default_typedef.xml (
					if not defined bAdlGen (
						set bAdlGen=1
						%genApp% -A %adlPath% -O %genPath% -P %prjName% -B %libPath% -M -AO
					) else (
						echo Skip...
					)
				) else (
				rem xadl
				if %%a==globalvars.xml (
					if not defined bAdlGen (
						set bAdlGen=1
						%genApp% -A %adlPath% -O %genPath% -P %prjName% -B %libPath% -M -AO
					) else (
						echo Skip...
					)
				) else (
				rem theme
				if %%~xi==.xtheme (
					%genApp% -A %adlPath% -O %genPath% -P %prjName% -B %libPath% -M -T %%i
				rem file
				) else (
					%genApp% -A %adlPath% -O %genPath% -P %prjName% -B %libPath% -M -F %srcPath%%%i
					if %%a==%libName% (
						if not defined bModGen (
							set bModGen=1
							%genApp% -A %adlPath% -O %genPath% -P %prjName% -B %libPath% -M -MO
						) else (
							echo Skip Module...
						)
					)
				)
				)
				)
				)
				
				echo.
				echo.
				echo   ===============================
				echo   = 2. Deploy
				echo   ===============================

				rem xadl
				if %%~xi==.xadl (
					%cmpApp% -F %genPath%\%prjName%%%i.js -O %depPath%%%i.js -Shrink
					%cmpApp% -F %genPath%\%prjName%%%i.quickview.js -O %depPath%%%i.quickview.js -Shrink
					%cmpApp% -F %genPath%\%prjName%\index.html -O %depPath%\index.html -Shrink
					%cmpApp% -F %genPath%\%prjName%\popup.html -O %depPath%\popup.html -Shrink
					%cmpApp% -F %genPath%\%prjName%\QuickView.html -O %depPath%\QuickView.html -Shrink
					%cmpApp% -F %genPath%\%prjName%\start.json -O %depPath%\start.json -Shrink
					%cmpApp% -P %genPath%\%prjName%\css -O %depPath%\css -Shrink
				) else (
				rem xadl
				if %%a==default_typedef.xml (
					echo Skip...
				) else (
				rem xadl
				if %%a==globalvars.xml (
					echo Skip...
				) else (
				rem xfdl
				if %%~xi==.xfdl (
					%cmpApp% -F %genPath%\%prjName%%%i.js -O %depPath%%%i.js -Shrink
				) else (
				rem xtheme
				if %%~xi==.xtheme (
					%cmpApp% -P %genPath%\%prjName%\_theme_\%%~ni -O %depPath%\_theme_\%%~ni -Shrink
				) else (
				rem js
				if %%~xi==.js (
					rem module
					if %%a==%libName% (
						rem framework
						if %%b==framework (
							%cmpApp% -F %genPath%\%prjName%\%%a\%%b\%%b.js -O %depPath%\%%a\%%b\%%b.js -Shrink
						rem component
						) else (
							%cmpApp% -F %genPath%\%prjName%\%%a\%%b\%%c.js -O %depPath%\%%a\%%b\%%c.js -Shrink
						)
					rem etc js
					) else (
						%cmpApp% -F %genPath%\%prjName%%%i -O %depPath%%%i -Shrink
					)
				) else (
					echo Copy %%i
					%cmpApp% -F %genPath%\%prjName%%%i -O %depPath%%%i -Shrink
				)
				)
				)
				)
				)
				)
				echo.
				echo.
				echo.
			)
		)
	)
)
