# Fireside Feelings - Turkce Yama Kurucu
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$patchRoot = Split-Path -Parent $PSScriptRoot
$patchFilesDir = Join-Path $patchRoot "patch_files"
$toolsDir = Join-Path $patchRoot "tools"
$key = "7668142F3ED337054E855159EB29497B19309B8F3730F9D95409103DB394C62B"

Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "         Fireside Feelings - Turkce Yama Kurucu          " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Yamayi Kur"
Write-Host "2. Yamayi Kaldir (Orijinale Don)"
Write-Host "3. Cikis"
Write-Host ""
$choice = Read-Host "Seciminiz (1/2/3)"

if ($choice -eq "3") {
    exit
}

# Find game executable
$gameExe = ""

# Check parent directory (if repo is placed inside game folder)
$parentExe = Join-Path (Split-Path -Parent $patchRoot) "FiresideFeelings.exe"
if (Test-Path $parentExe) {
    $gameExe = $parentExe
}

# Auto-detect common Steam paths
if (-not $gameExe) {
    $drives = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root
    foreach ($d in $drives) {
        $candidate1 = Join-Path $d "Steam\steamapps\common\FiresideFeelings\FiresideFeelings.exe"
        $candidate2 = Join-Path $d "SteamLibrary\steamapps\common\FiresideFeelings\FiresideFeelings.exe"
        $candidate3 = Join-Path $d "Program Files (x86)\Steam\steamapps\common\FiresideFeelings\FiresideFeelings.exe"
        $candidate4 = Join-Path $d "Program Files\Steam\steamapps\common\FiresideFeelings\FiresideFeelings.exe"

        foreach ($c in @($candidate1, $candidate2, $candidate3, $candidate4)) {
            if (Test-Path $c) {
                $gameExe = $c
                break
            }
        }
        if ($gameExe) { break }
    }
}

if ($gameExe) {
    Write-Host "`nOyun konumu otomatik bulundu:" -ForegroundColor Green
    Write-Host "  $gameExe" -ForegroundColor Gray
    $confirm = Read-Host "Bu konumu kullanmak istiyor musunuz? (E/H)"
    if ($confirm.Trim().ToUpper() -ne "E" -and $confirm.Trim().ToUpper() -ne "Y" -and $confirm.Trim() -ne "") {
        $gameExe = ""
    }
}

while (-not $gameExe -or -not (Test-Path $gameExe)) {
    Write-Host ""
    $inputPath = Read-Host "Lutfen FiresideFeelings.exe dosyasinin tam yolunu surukleyip birakin veya yazin"
    $cleanPath = $inputPath.Trim().Trim('"').Trim("'")
    if (Test-Path $cleanPath) {
        if ((Split-Path -Leaf $cleanPath) -eq "FiresideFeelings.exe") {
            $gameExe = $cleanPath
        } else {
            $testExe = Join-Path $cleanPath "FiresideFeelings.exe"
            if (Test-Path $testExe) {
                $gameExe = $testExe
            }
        }
    }
    if (-not $gameExe -or -not (Test-Path $gameExe)) {
        Write-Host "Gecersiz dosya yolu! FiresideFeelings.exe bulunamadi." -ForegroundColor Red
    }
}

$gameDir = Split-Path -Parent $gameExe
$bakExe = Join-Path $gameDir "FiresideFeelings.exe.bak"

# UNINSTALL OPTION
if ($choice -eq "2") {
    Write-Host "`nYama kaldiriliyor..." -ForegroundColor Yellow
    if (Test-Path $bakExe) {
        Copy-Item $bakExe $gameExe -Force
        Write-Host "Yedek basariyla geri yuklendi! Oyun orijinal haline dondu." -ForegroundColor Green
    } else {
        Write-Host "Yedek dosya (FiresideFeelings.exe.bak) bulunamadi!" -ForegroundColor Red
    }
    Write-Host "`nKapatmak icin herhangi bir tusa basin..."
    [void][Console]::ReadKey($true)
    exit
}

# INSTALL OPTION
Write-Host "`nYama kurulumu hazirlaniyor..." -ForegroundColor Cyan

# Backup if not already backed up
if (-not (Test-Path $bakExe)) {
    Write-Host "Orijinal oyunun yedegi aliniyor: FiresideFeelings.exe.bak" -ForegroundColor Gray
    Copy-Item $gameExe $bakExe -Force
} else {
    Write-Host "Mevcut yedek korundu: FiresideFeelings.exe.bak" -ForegroundColor Gray
}

# Ensure tools
New-Item -ItemType Directory -Force -Path $toolsDir | Out-Null
$gdreExe = Join-Path $toolsDir "gdre_tools.exe"

if (-not (Test-Path $gdreExe)) {
    Write-Host "`nGDRE Tools araci indiriliyor (sadece ilk seferde gerekir)..." -ForegroundColor Yellow
    $zipPath = Join-Path $toolsDir "gdre.zip"
    $downloadUrl = "https://github.com/GDRETools/gdsdecomp/releases/download/v2.7.4/GDRE_Tools-v2.7.4-windows.zip"
    
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing
        Expand-Archive -Path $zipPath -DestinationPath $toolsDir -Force
        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue

        # Find gdre binary in extracted files
        $found = Get-ChildItem -Path $toolsDir -Recurse -Filter "GDRE_Tools*.exe" | Select-Object -First 1
        if ($found) {
            Move-Item $found.FullName $gdreExe -Force
        }
    } catch {
        Write-Host "Otomatik indirme basarisiz oldu: $_" -ForegroundColor Red
        Write-Host "Lutfen GDRE Tools aracini indirip 'tools/gdre_tools.exe' olarak yerlestirin." -ForegroundColor Yellow
        [void][Console]::ReadKey($true)
        exit
    }
}

if (-not (Test-Path $gdreExe)) {
    Write-Host "gdre_tools.exe bulunamadi!" -ForegroundColor Red
    [void][Console]::ReadKey($true)
    exit
}

# Build patch list
$patchFiles = @()
$patchFiles += "$patchFilesDir\project.binary=res://project.binary"
$patchFiles += "$patchFilesDir\Project_Data.gdc=res://Scripts/AutoLoad/Project_Data.gdc"
$patchFiles += "$patchFilesDir\Dialogue_Manager.gdc=res://Scripts/Dialogue/Dialogue_Manager.gdc"
$patchFiles += "$patchFilesDir\Tr_Localisation_Data.res=res://Assets/ScriptableDatas/Localisation_Data/Tr_Localisation_Data.res"
$patchFiles += "$patchFilesDir\Tr_Localisation_Data.tres.remap=res://Assets/ScriptableDatas/Localisation_Data/Tr_Localisation_Data.tres.remap"
$patchFiles += "$patchFilesDir\Tr_Localisation_Data.tres=res://Assets/ScriptableDatas/Localisation_Data/Tr_Localisation_Data.tres"

$trFiles = Get-ChildItem (Join-Path $patchFilesDir "translations") -Filter "*.tr.translation"
foreach ($f in $trFiles) {
    $patchFiles += "$($f.FullName)=res://Assets/Localisation/$($f.Name)"
}

Write-Host "`nYamalanacak dosya sayisi: $($patchFiles.Count)" -ForegroundColor Cyan
Write-Host "Oyun dosyalari yamalaniyor, lutfen bekleyin..." -ForegroundColor Yellow

$tempOut = Join-Path $toolsDir "temp_patched.exe"
if (Test-Path $tempOut) { Remove-Item $tempOut -Force }

$argsList = @(
    "--headless",
    "--pck-patch=$gameExe",
    "--key=$key",
    "--embed=$gameExe",
    "--output=$tempOut"
)

foreach ($pf in $patchFiles) {
    $argsList += "--patch-file=$pf"
}

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $gdreExe
$psi.Arguments = ($argsList | ForEach-Object { if ($_ -match ' ') { "`"$_`"" } else { $_ } }) -join " "
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true

$proc = [System.Diagnostics.Process]::Start($psi)
$stdout = $proc.StandardOutput.ReadToEnd()
$stderr = $proc.StandardError.ReadToEnd()
$proc.WaitForExit()

if ($proc.ExitCode -eq 0 -and (Test-Path $tempOut)) {
    Copy-Item $tempOut $gameExe -Force
    Remove-Item $tempOut -Force -ErrorAction SilentlyContinue

    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "        TURKCE YAMA BASARIYLA KURULDU!                    " -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Oyunu baslatin ve Ayarlar (Options) menusunden" -ForegroundColor Cyan
    Write-Host "'Turkce' dil secenegini secin." -ForegroundColor Cyan
    Write-Host "Iyi oyunlar!" -ForegroundColor Yellow
} else {
    Write-Host "`nYama kurulumu sirasinda bir hata olustu!" -ForegroundColor Red
    if ($stderr) { Write-Host "Hata detayi: $stderr" -ForegroundColor Red }
}

Write-Host "`nCikmak icin herhangi bir tusa basin..."
[void][Console]::ReadKey($true)
