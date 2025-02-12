# サクラエディタのインストーラーURL
$installerUrl = "https://github.com/sakura-editor/sakura/releases/download/v2.4.2/sakura-tag-v2.4.2-build4203-a3e63915b-Win32-Release-Installer.zip"

# インストーラーの保存先パス
$installerPath = "$env:USERPROFILE\Downloads\sakura-editor-setup.zip"

# インストーラーをダウンロード
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# ZIPファイルを解凍
Expand-Archive -Path $installerPath -DestinationPath "$env:USERPROFILE\Downloads\sakura-editor"

# 解凍されたフォルダーをエクスプローラーで開く
Invoke-Item -Path "$env:USERPROFILE\Downloads\sakura-editor"

# インストーラーの実行ファイルパスを確認
$installerExePath = Get-ChildItem -Path "$env:USERPROFILE\Downloads\sakura-editor" -Filter "*.exe" | Select-Object -First 1

if ($installerExePath) {
    # インストーラーを実行
    Start-Process -FilePath $installerExePath.FullName -ArgumentList "/S" -Wait

    # インストーラーを削除
    Remove-Item -Path $installerPath
    Remove-Item -Path "$env:USERPROFILE\Downloads\sakura-editor" -Recurse
} else {
    Write-Error "インストーラーの実行ファイルが見つかりませんでした。"
}