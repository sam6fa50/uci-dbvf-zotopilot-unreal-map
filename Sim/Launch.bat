@echo off
rem Launches the sim with the settings.json shipped next to it.
"%~dp0UCI_DBVF_2627_AirSim.exe" -settings="%~dp0settings.json" -windowed -ResX=1280 -ResY=720 %*
