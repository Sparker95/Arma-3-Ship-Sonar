Push-Location

$armaToolsFolder = "C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools"

$pboFileName = "ship_sonar"

$modBuildPath = "_build\@$pboFileName"

"Ensure directories, clear temp folder..`n"
New-Item "_build" -ItemType Directory -Force > $null
forEach ($folder in (Get-Childitem -directory -name "_build")) {
    Remove-Item "_build\$folder" -Recurse -Force
}
New-Item "_build\temp" -ItemType Directory -Force > $null
New-Item $modBuildPath -ItemType Directory -Force > $null
New-Item "$modBuildPath\addons" -ItemType Directory -Force > $null
New-Item "$modBuildPath\keys" -ItemType Directory -Force > $null

"Copy extra files..`n"
Copy-Item "mod.cpp" $modBuildPath > $null

"Copy addons..`n"
Copy-Item "ship_sonar" "$modBuildPath\addons" -Recurse > $null

"Build pbos...`n"

& "$armaToolsFolder\AddonBuilder\AddonBuilder.exe" "$PSScriptRoot\$modBuildPath\addons\$pboFileName" "$PSScriptRoot\$modBuildPath\addons" -packonly -prefix="$pboFileName" -temp="$PSScriptRoot\_build\temp"


"Delete unpacked addon folder..`n"
Remove-Item "$modBuildPath\addons\$pboFileName" -Recurse -Force

"`nCreate key..."
Push-Location
Set-Location "_build"
& "$armaToolsFolder\DSSignFile\DSCreateKey" "$pboFileName"
Copy-Item "$pboFileName.bikey" "@$pboFileName\keys" -Force

"`nSign PBO files..."
Set-Location "@$pboFileName\addons"
$pboFiles = Get-ChildItem -Name "*.pbo"
forEach ($file in $pboFiles) {
    "Signing file $file ..."
    & "$armaToolsFolder\DSSignFile\DSSignFile" "..\..\$pboFileName.biprivatekey" $file
}

Pop-Location

"`n`nDone!"

pause