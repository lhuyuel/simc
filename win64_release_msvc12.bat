:: Necessary Qt dlls are packaged with every release.
:: These dlls are not included in GIT.
:: They need to be copied into the dev area from the Qt install.
:: Qt-Framework is simply the Qt runtime dlls built against the MSVC 2013 compiler
:: It can be found at: http://qt-project.org/downloads
:: As of this writing, the default locations from which to gather the dlls are:
:: Qt-Framework: C:\Qt\Qt5.4.0\

:: Update the qt_dir as necessary
set qt_dir=C:\Qt\Qt5.4.0\5.4\msvc2013_64
set redist="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\redist\x64\Microsoft.VC120.CRT"

:: IMPORTANT NOTE FOR DEBUGGING
:: This script will ONLY copy the optimized Qt dlls
:: The simcqt_vs2013.vcproj file is setup to use optimized dlls for both Debug/Release builds
:: This script needs to be smarter if you wish to use the interactive debugger in the Qt SDK
:: The debug Qt dlls are named: Qt___d5.dll

rd %install% /s /q

for /f "skip=2 tokens=2,*" %%A in ('reg.exe query "HKLM\SOFTWARE\Microsoft\MSBuild\ToolsVersions\12.0" /v MSBuildToolsPath') do SET MSBUILDDIR=%%B

"%MSBUILDDIR%msbuild.exe" E:\simulationcraft\simc_vs2013.sln /p:configuration=pgo /p:platform=x64 /nr:true

forfiles -s -m generate_????.simc -c "cmd /c echo Running @path && %~dp0simc64.exe @file"

robocopy %redist%\ %install%\ msvcp120.dll msvcr120.dll vccorlib120.dll
robocoby locale\ %install%\locale sc_de.qm sc_zh.qm
robocopy %qt_dir%\bin\ %install%\ Qt5Core.dll Qt5Quick.dll Qt5PrintSupport.dll Qt5Qml.dll Qt5Svg.dll Qt5Gui.dll Qt5Widgets.dll Qt5Network.dll Qt5WebEngineCore.dll Qt5WebEngine.dll Qt5WebEngineWidgets.dll libGLESv2.dll icudt53.dll icuin53.dll icuuc53.dll libEGL.dll D3DCompiler_47.dll opengl32sw.dll QtWebEngineProcess.exe
robocoby vs\ %install%\ qt.conf
robocopy %qt_dir%\ %install%\ icudtl.dat qtwebengine_resources.pak
robocopy %qt_dir%\plugins\platforms %install%\platforms\ qwindows.dll
robocopy %qt_dir%\plugins\audio %install%\audio qtaudio_windows.dll
robocopy %qt_dir%\plugins\bearer %install%\bearer qgenericbearer.dll qnativewifibearer.dll
robocopy %qt_dir%\plugins\iconengines %install%\iconengines qsvgicon.dll
robocopy %qt_dir%\plugins\imageformats %install%\imageformats qdds.dll qgif.dll qicns.dll qico.dll qjp2.dll qjpeg.dll qmng.dll qsvg.dll qtga.dll qtiff.dll qwbmp.dll qwebp.dll
robocopy %qt_dir%\plugins\mediaserver %install%\mediaserver dsengine.dll qtmedia_audioengine.dll wmfengine.dll 
robocopy %qt_dir%\plugins\playlistformats %install%\playlistformats qtmultimedia_m3u.dll
robocopy %qt_dir%\plugins\position %install%\position qtposition_positionpoll.dll
robocopy %qt_dir%\plugins\printsupport %install%\printsupport windowsprintersupport.dll
robocopy %qt_dir%\plugins\sensorgestures %install%\sensorgestures qtsensorgestures_plugin.dll qtsensorgestures_shakeplugin.dll
robocopy %qt_dir%\plugins\sensors %install%\sensors qtsensors_dummy.dll qtsensors_generic.dll
robocopy %qt_dir%\plugins\sqldrivers %install%\sqldrivers qsqlite.dll qsqlmysql.dll qsqlodbc.dll qsqlpsql.dll
robocopy . %install%\ Welcome.html Welcome.png Simulationcraft64.exe simc64.exe readme.txt Error.html COPYING
robocopy C:\OpenSSL-Win64\bin %install%\ libeay32.dll ssleay32.dll 
robocopy Profiles\ %install%\profiles\ *.* /S