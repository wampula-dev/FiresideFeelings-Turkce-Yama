@echo off
title Fireside Feelings - Turkce Yama Kurucu
chcp 65001 >nul

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\installer.ps1"
