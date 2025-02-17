# 管理者権限で実行されているか確認
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # 管理者権限で再実行
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Set-ExecutionPolicyを変更（スクリプト実行を許可）
Set-ExecutionPolicy Bypass -Scope Process -Force

# Chocolatey（パッケージ管理ツール）をインストール
If (!(Test-Path "C:\ProgramData\chocolatey")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# 必要なソフトウェアをインストール
choco install -y 7zip vscode googlechrome sakuraeditor

# 設定関連
# タスクバーを左揃えに設定するレジストリキーを変更
if (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced") {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0
}

# タスクバーの検索を非表示にする
if (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search") {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0
}

# タスクビューをオフにする
if (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced") {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0
}

# ウィジェットをオフにする
# windows sandbox環境ではそもそもウィジェットが無い
if (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced") {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0
}

# エクスプローラーを再起動して変更を反映
Stop-Process -Name "explorer" -Force
Start-Process "explorer"