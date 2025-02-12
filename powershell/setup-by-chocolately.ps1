# Set-ExecutionPolicyを変更（スクリプト実行を許可）
Set-ExecutionPolicy Bypass -Scope Process -Force

# Chocolatey（パッケージ管理ツール）をインストール
If (!(Test-Path "C:\ProgramData\chocolatey")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# 必要なソフトウェアをインストール
choco install -y 7zip git vscode googlechrome sakura-editor



