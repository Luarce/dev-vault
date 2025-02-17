# 管理者権限で実行されているか確認
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # 管理者権限で再実行
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Set-ExecutionPolicyを変更（スクリプト実行を許可）
Set-ExecutionPolicy Bypass -Scope Process -Force


# インストーラー zip の URL（Installer 版）
$zipUrl = "https://github.com/sakura-editor/sakura/releases/download/v2.4.2/sakura-tag-v2.4.2-build4203-a3e63915b-Win32-Release-Installer.zip"

# 一時ファイル・フォルダのパス設定
$tempZip = "$env:TEMP\sakura_installer.zip"
$tempExtractDir = "$env:TEMP\sakura_installer_extracted"

Write-Output "sakura editor Installer の zip をダウンロード中..."
Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip

Write-Output "ダウンロード完了。zip を展開します…"
# 一時展開用フォルダ作成
if (-Not (Test-Path $tempExtractDir)) {
    New-Item -Path $tempExtractDir -ItemType Directory | Out-Null
}

# zip ファイルの展開（上書きモード）
Expand-Archive -Path $tempZip -DestinationPath $tempExtractDir -Force

# 展開されたフォルダ内からインストーラー実行ファイルを検索（例： "sakura_install*.exe"）
$installerExe = Get-ChildItem -Path $tempExtractDir -Recurse -Filter "sakura_install*.exe" | Select-Object -First 1

if (-Not $installerExe) {
    Write-Error "インストーラー実行ファイルが見つかりません。"
    exit 1
}

Write-Output "インストーラー実行ファイルを発見: $($installerExe.FullName)"
Write-Output "サイレントインストールを開始します…"
# インストーラーをサイレントモードで実行（NSISの場合は /S オプション）
Start-Process -FilePath $installerExe.FullName -ArgumentList "/VERYSILENT", "/SP-" -Wait

Write-Output "インストール完了。後処理を実行します…"
# 一時ファイル・フォルダのクリーンアップ
Remove-Item $tempZip -Force
Remove-Item $tempExtractDir -Recurse -Force

Write-Output "sakura editor のインストールが完了しました。"
