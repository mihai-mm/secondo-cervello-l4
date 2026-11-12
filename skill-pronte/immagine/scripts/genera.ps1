# Genera immagini con OpenRouter oppure con OpenAI (versione Windows).
# Usa solo PowerShell 5.1 e curl.exe, già presenti in Windows 10 e 11: non c'è nulla da installare.
# La chiave sta in %USERPROFILE%\.config\immagini\.env (fuori dal vault) e non viene mai stampata.
#
# Uso (da PowerShell, dalla cartella del vault):
#   powershell -NoProfile -ExecutionPolicy Bypass -File .claude\skills\immagine\scripts\genera.ps1 -FileRichiesta richiesta.txt -Proporzione 4:5 -Varianti 3
#   ... -Rif foto.png            (più riferimenti: -Rif foto1.png,foto2.png  senza spazi dopo la virgola)
#
# Opzioni (le stesse della versione Mac, con il trattino singolo):
#   -Richiesta "testo"      cosa deve vedersi (oppure -FileRichiesta file.txt)
#   -Rif file               immagini di riferimento, fino a 14
#   -Proporzione 4:5        1:1, 4:5, 3:2, 16:9, 9:16... (predefinita 1:1)
#   -Varianti 3             quante immagini (predefinito 1, massimo 10)
#   -Modello nome           facoltativo; sceglie lo strumento in automatico
#   -Uscita cartella        predefinita: _attachments\immagini
#   -Nome prefisso          prefisso del nome file (predefinito: immagine)
#   -Servizio openrouter|openai   solo se nel .env ci sono entrambe le chiavi
#   -Risoluzione 1K         1K (predefinita), 2K o 4K: più grande costa di più
#   -Prova                  immagine piccola e quasi gratis, per controllare che tutto funzioni
#   -SoloGalleria           non genera: riscrive soltanto la galleria (galleria.html nella cartella di uscita)
#   -ControllaChiave        scrive 1 se nel file della chiave c'è una chiave, 0 se no (senza mostrarla)
#   -CreaFileChiave         crea il file della chiave con la riga vuota, se non c'è
#   -ApriFileChiave         apre il file della chiave nel Blocco note, per incollarla
# Questi tre si lanciano sempre con -File, anche da Bash: non hanno apici da avvolgere.
#   -CartellaPrompt dir     dove stanno i prompt salvati (predefinita: 3-Resources\Prompt immagini)
#
# Galleria: dopo ogni generazione lo strumento riscrive galleria.html nella cartella di uscita, partendo da
# galleria-modello.html della skill, con dentro le ricette delle immagini (.json) e i prompt salvati (.md).
param(
    [string]$Richiesta,
    [string]$FileRichiesta,
    [string[]]$Rif = @(),
    [string]$Proporzione = '1:1',
    [int]$Varianti = 1,
    [string]$Modello,
    [string]$Uscita = '_attachments\immagini',
    [string]$Nome = 'immagine',
    [string]$Servizio,
    [string]$Risoluzione,
    [switch]$Prova,
    [switch]$SoloGalleria,
    [switch]$ControllaChiave,
    [switch]$CreaFileChiave,
    [switch]$ApriFileChiave,
    [string]$CartellaPrompt = '3-Resources\Prompt immagini'
)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false) } catch {}
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Fine([string]$msg) {
    [Console]::Error.WriteLine("ERRORE: $msg")
    exit 1
}

function Percorso-Assoluto([string]$p) {
    if ([IO.Path]::IsPathRooted($p)) { return $p }
    return [IO.Path]::GetFullPath((Join-Path $PWD.Path $p))
}

# Riscrive galleria.html nella cartella delle immagini: il modello della skill con dentro le ricette delle immagini e i
# prompt salvati. Restituisce il percorso, oppure '' se il modello manca.
function Aggiorna-Galleria([string]$dir, [string]$dirPrompt) {
    $modello = Join-Path (Split-Path -Parent $PSScriptRoot) 'galleria-modello.html'
    if (-not (Test-Path -LiteralPath $modello)) { return '' }
    $immagini = New-Object System.Collections.ArrayList
    foreach ($f in @(Get-ChildItem -LiteralPath $dir -Filter '*.json' -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike '_*' } | Sort-Object Name)) {
        try { $m = [IO.File]::ReadAllText($f.FullName, $utf8) | ConvertFrom-Json } catch { continue }
        if (-not $m -or -not $m.file -or $null -eq $m.richiesta) { continue }
        if (-not (Test-Path -LiteralPath (Join-Path $dir $m.file))) { continue }
        $voce = [ordered]@{}
        foreach ($pr in $m.PSObject.Properties) { $voce[$pr.Name] = $pr.Value }
        $voce['riferimenti'] = @($m.riferimenti | Where-Object { $_ })
        [void]$immagini.Add($voce)
    }
    $prompt = New-Object System.Collections.ArrayList
    $dpAbs = Percorso-Assoluto $dirPrompt
    if (Test-Path -LiteralPath $dpAbs) {
        foreach ($f in @(Get-ChildItem -LiteralPath $dpAbs -Filter '*.md' -File | Where-Object { $_.Name -notmatch '^[_.]' } | Sort-Object Name)) {
            [void]$prompt.Add([ordered]@{ file = $f.Name; testo = [IO.File]::ReadAllText($f.FullName, $utf8); modificato = $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', [Globalization.CultureInfo]::InvariantCulture) })
        }
    }
    $dati = [ordered]@{ aggiornata = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', [Globalization.CultureInfo]::InvariantCulture); cartella_prompt = ($dirPrompt -replace '\\', '/'); immagini = @($immagini.ToArray()); prompt = @($prompt.ToArray()) }
    $json = ConvertTo-Json -InputObject $dati -Depth 6 -Compress
    $json = $json.Replace('<', '\u003c')    # nessun «<» dentro lo script: la pagina non si può rompere
    $html = [IO.File]::ReadAllText($modello, $utf8)
    $apri = '<script id="dati" type="application/json">'
    $a = $html.IndexOf($apri)
    if ($a -lt 0) { return '' }
    $b = $html.IndexOf('</script>', $a)
    if ($b -lt 0) { return '' }
    $html = $html.Substring(0, $a + $apri.Length) + $json + $html.Substring($b)
    $dest = Join-Path $dir 'galleria.html'
    [IO.File]::WriteAllText($dest, $html, $utf8)
    return $dest
}

# --- il file della chiave: controllo, creazione, apertura (la chiave non viene mai letta né mostrata) ---
$fileChiave = $env:IMMAGINI_ENV
if (-not $fileChiave) { $fileChiave = Join-Path $env:USERPROFILE '.config\immagini\.env' }
if ($ControllaChiave) {
    $n = 0
    if (Test-Path -LiteralPath $fileChiave) { $n = @(Select-String -LiteralPath $fileChiave -Pattern '^[A-Z_]*API_KEY=.').Count }
    Write-Output $n
    exit 0
}
if ($CreaFileChiave) {
    $cart = Split-Path -Parent $fileChiave
    if (-not (Test-Path -LiteralPath $cart)) { New-Item -ItemType Directory -Path $cart -Force | Out-Null }
    if (-not (Test-Path -LiteralPath $fileChiave)) { [IO.File]::WriteAllText($fileChiave, "OPENROUTER_API_KEY=`r`n", (New-Object System.Text.ASCIIEncoding)) }
    Write-Output 'fatto'
    exit 0
}
if ($ApriFileChiave) {
    if (-not (Test-Path -LiteralPath $fileChiave)) { Fine "Il file della chiave non c'è ancora: prima -CreaFileChiave." }
    Start-Process notepad.exe -ArgumentList ('"' + $fileChiave + '"')
    Write-Output 'aperto'
    exit 0
}

# --- solo la galleria, senza generare ---
if ($SoloGalleria) {
    $uA = Percorso-Assoluto $Uscita
    if (-not (Test-Path -LiteralPath $uA)) { New-Item -ItemType Directory -Path $uA -Force | Out-Null }
    $g = Aggiorna-Galleria $uA $CartellaPrompt
    if (-not $g) { Fine "Non riesco a scrivere la galleria in $Uscita (manca galleria-modello.html nella skill?)." }
    Write-Output "Galleria aggiornata: $g"
    exit 0
}

# --- richiesta ---
if ($FileRichiesta) {
    $fr = Percorso-Assoluto $FileRichiesta
    if (-not (Test-Path -LiteralPath $fr)) { Fine "Non riesco a leggere il file della richiesta: $FileRichiesta" }
    $Richiesta = [IO.File]::ReadAllText($fr, $utf8)
}
if (-not $Richiesta -or $Richiesta.Trim() -eq '') {
    Fine "Manca la richiesta. Scrivi cosa deve vedersi nell'immagine (-Richiesta ""..."" oppure -FileRichiesta file.txt)."
}
if ($Proporzione -notmatch '^\d+(\.\d+)?:\d+(\.\d+)?$') { Fine "Le proporzioni vanno scritte così: 1:1, 4:5, 3:2, 16:9, 9:16." }
if ($Varianti -lt 1) { $Varianti = 1 }
if ($Varianti -gt 10) { Fine "Al massimo 10 varianti per volta." }
# con -File le liste arrivano come un solo testo separato da virgole
$Rif = @($Rif | ForEach-Object { $_ -split ',' } | Where-Object { $_ -and $_.Trim() -ne '' } | ForEach-Object { $_.Trim() })
if ($Rif.Count -gt 14) { Fine "Al massimo 14 immagini di riferimento." }
$rifAssoluti = @()
foreach ($r in $Rif) {
    $ra = Percorso-Assoluto $r
    if (-not (Test-Path -LiteralPath $ra -PathType Leaf)) { Fine "Non trovo l'immagine di riferimento: $r" }
    $rifAssoluti += $ra
}

# --- chiave ---
$envPath = $env:IMMAGINI_ENV
if (-not $envPath) { $envPath = Join-Path $env:USERPROFILE '.config\immagini\.env' }
$chiavi = @{}
if (Test-Path -LiteralPath $envPath) {
    foreach ($riga in [IO.File]::ReadAllLines($envPath)) {
        $riga = $riga.TrimStart([char]0xFEFF)
        if ($riga -match '^\s*#') { continue }
        if ($riga -match '^\s*(?:export\s+)?([A-Za-z0-9_]+)\s*=\s*(.*?)\s*$') {
            $k = $Matches[1]; $v = $Matches[2]
            if ($v -match '^(["''])(.*)\1$') { $v = $Matches[2] }
            if ($v -eq '' -or $v -match '^(?i)(incolla|\.\.\.|xxx)') { continue }
            $chiavi[$k] = $v
        }
    }
}
$haOr = $chiavi.ContainsKey('OPENROUTER_API_KEY')
$haOa = $chiavi.ContainsKey('OPENAI_API_KEY')
if (-not $haOr -and -not $haOa) {
    Fine ("Non trovo la chiave per generare le immagini.`n" +
          "Serve il file $envPath con una riga OPENROUTER_API_KEY=... oppure OPENAI_API_KEY=...`n" +
          "Segui la preparazione guidata (file PREPARA.md della skill).")
}
if ($Servizio) {
    $Servizio = $Servizio.ToLower()
    if ($Servizio -ne 'openrouter' -and $Servizio -ne 'openai') { Fine "Il servizio può essere solo openrouter oppure openai." }
    if (($Servizio -eq 'openrouter' -and -not $haOr) -or ($Servizio -eq 'openai' -and -not $haOa)) { Fine "Nel file .env non c'è la chiave di $Servizio." }
} else {
    if ($haOr) { $Servizio = 'openrouter' } else { $Servizio = 'openai' }
}
if ($Servizio -eq 'openrouter') { $chiave = $chiavi['OPENROUTER_API_KEY'] } else { $chiave = $chiavi['OPENAI_API_KEY'] }
if (-not $Modello) {
    if ($Servizio -eq 'openrouter') { $Modello = 'google/gemini-3.1-flash-image' } else { $Modello = 'gpt-image-2.6-flare' }
}
$nomeServizio = if ($Servizio -eq 'openrouter') { 'OpenRouter' } else { 'OpenAI' }

# --- cartella di uscita ---
$uscitaAbs = Percorso-Assoluto $Uscita
if (-not (Test-Path -LiteralPath $uscitaAbs)) { New-Item -ItemType Directory -Path $uscitaAbs -Force | Out-Null }
if (-not (Test-Path -LiteralPath $uscitaAbs)) { Fine "Non riesco a creare la cartella $Uscita" }

function Mime-Da-Byte([byte[]]$b) {
    if ($b.Length -ge 4 -and $b[0] -eq 0x89 -and $b[1] -eq 0x50 -and $b[2] -eq 0x4E -and $b[3] -eq 0x47) { return 'image/png' }
    if ($b.Length -ge 3 -and $b[0] -eq 0xFF -and $b[1] -eq 0xD8 -and $b[2] -eq 0xFF) { return 'image/jpeg' }
    if ($b.Length -ge 12 -and $b[8] -eq 0x57 -and $b[9] -eq 0x45 -and $b[10] -eq 0x42 -and $b[11] -eq 0x50) { return 'image/webp' }
    return 'image/png'
}

# Dimensioni in pixel (multipli di 16, circa 1 megapixel) per OpenAI.
function Dimensioni([string]$prop) {
    $p = $prop.Split(':')
    $w = [double]$p[0]; $h = [double]$p[1]
    $s = [Math]::Sqrt(1048576 / ($w * $h))
    $W = [int]([Math]::Floor($w * $s / 16 + 0.5)) * 16
    $H = [int]([Math]::Floor($h * $s / 16 + 0.5)) * 16
    if ($W -gt 1536) { $W = 1536 }
    if ($H -gt 1536) { $H = 1536 }
    return "${W}x${H}"
}

# Lavoriamo in una cartella temporanea con nomi semplici (rif1.png, ...): niente problemi con spazi e accenti nei percorsi.
$tmp = Join-Path ([IO.Path]::GetTempPath()) ('immagini-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp | Out-Null
$rifInfo = @()
$i = 0
foreach ($ra in $rifAssoluti) {
    $i++
    $bytes = [IO.File]::ReadAllBytes($ra)
    $mime = Mime-Da-Byte $bytes
    $ext = switch ($mime) { 'image/jpeg' { 'jpg' } 'image/webp' { 'webp' } default { 'png' } }
    $nomeTmp = "rif$i.$ext"
    [IO.File]::WriteAllBytes((Join-Path $tmp $nomeTmp), $bytes)
    # le foto di partenza che stanno fuori dalla cartella delle immagini si copiano in riferimenti\, così la galleria
    # le mostra accanto al risultato; nella ricetta resta il nome con cui la galleria le trova
    $nomeRif = [IO.Path]::GetFileName($ra)
    if ([IO.Path]::GetDirectoryName($ra).TrimEnd('\') -ne $uscitaAbs.TrimEnd('\')) {
        $cartRif = Join-Path $uscitaAbs 'riferimenti'
        if (-not (Test-Path -LiteralPath $cartRif)) { New-Item -ItemType Directory -Path $cartRif -Force | Out-Null }
        $radice = [IO.Path]::GetFileNameWithoutExtension($nomeRif); $estRif = [IO.Path]::GetExtension($nomeRif)
        $cand = $nomeRif; $k = 2
        while ((Test-Path -LiteralPath (Join-Path $cartRif $cand)) -and ((Get-Item -LiteralPath (Join-Path $cartRif $cand)).Length -ne $bytes.Length)) {
            $cand = "$radice-$k$estRif"; $k++
        }
        if (-not (Test-Path -LiteralPath (Join-Path $cartRif $cand))) { [IO.File]::WriteAllBytes((Join-Path $cartRif $cand), $bytes) }
        $nomeRif = "riferimenti/$cand"
    }
    $rifInfo += @{ tmp = $nomeTmp; mime = $mime; nome = $nomeRif; b64 = [Convert]::ToBase64String($bytes) }
}

function Spiega-Errore([int]$codice, [string]$resp, [string[]]$salvate) {
    $msg = ''
    try {
        $j = $resp | ConvertFrom-Json
        if ($j.error) { if ($j.error.message) { $msg = [string]$j.error.message } else { $msg = [string]$j.error } }
    } catch { $msg = $resp }
    $msg = ($msg -replace '\s+', ' ')
    if ($msg.Length -gt 250) { $msg = $msg.Substring(0, 250) }
    $dett = if ($msg) { " Dettaglio del servizio: $msg" } else { '' }
    $gia = if ($salvate.Count -gt 0) { "`nImmagini già salvate: " + ($salvate -join ', ') } else { '' }
    if ($codice -eq 401) {
        Fine "La chiave non è valida (errore 401). Controlla di averla incollata per intero nel file .env, senza spazi né virgolette, e che su $nomeServizio non sia stata disattivata.$gia"
    }
    if ($codice -eq 402 -or ($codice -eq 429 -and $msg -match '(?i)quota|billing|credit|insufficient')) {
        Fine "Il credito è finito (errore $codice). Su $nomeServizio va ricaricato il credito, oppure il tetto di spesa della chiave è stato raggiunto.$dett$gia"
    }
    if ($codice -eq 404 -or ($codice -eq 400 -and $msg -match '(?i)model' -and $msg -match '(?i)(valid|exist|found|support|access|unknown)')) {
        Fine "Il modello «$Modello» non esiste o non è disponibile con questa chiave. Togli l'opzione -Modello per usare quello predefinito.$dett$gia"
    }
    if ($codice -eq 429) { Fine "Troppe richieste in poco tempo (errore 429). Aspetta un minuto e riprova.$gia" }
    if ($codice -ge 500) { Fine "Il servizio $nomeServizio ha un problema momentaneo (errore $codice). Riprova fra qualche minuto.$dett$gia" }
    if ($codice -eq 0) { Fine "Nessuna risposta dal servizio. Controlla la connessione e riprova.$gia" }
    Fine "La richiesta non è stata accettata (errore $codice).$dett$gia"
}

$salvate = @()
$costoTot = 0.0
$costoNoto = $false
$dataTag = Get-Date -Format 'yyyyMMdd-HHmmss'

try {
    Push-Location $tmp
    [IO.File]::WriteAllText((Join-Path $tmp 'h.txt'), ("Authorization: Bearer $chiave`n" + $(if ($Servizio -eq 'openrouter') { "X-Title: Secondo Cervello - immagini`n" } else { '' })), (New-Object System.Text.ASCIIEncoding))
    [IO.File]::WriteAllText((Join-Path $tmp 'prompt.txt'), $Richiesta, $utf8)

    for ($n = 1; $n -le $Varianti; $n++) {
        $t0 = Get-Date
        $ca = @('-s', '-X', 'POST', '--connect-timeout', '20', '--max-time', '300', '-H', '@h.txt', '-o', 'resp.json', '-w', '%{http_code}')
        if ($Servizio -eq 'openrouter') {
            $url = 'https://openrouter.ai/api/v1/images'
            $body = [ordered]@{ model = $Modello; prompt = $Richiesta; aspect_ratio = $Proporzione; n = 1 }
            if ($Modello -match 'gpt-image') { $body['quality'] = $(if ($Prova) { 'low' } else { 'medium' }) }
            if ($Modello -like 'google/gemini*') { $body['resolution'] = $(if ($Prova) { '512' } elseif ($Risoluzione) { $Risoluzione } else { '1K' }) }
            elseif ($Risoluzione) { $body['resolution'] = $Risoluzione }
            if ($rifInfo.Count -gt 0) {
                $refs = @()
                foreach ($r in $rifInfo) { $refs += @{ type = 'image_url'; image_url = @{ url = ("data:" + $r.mime + ";base64," + $r.b64) } } }
                $body['input_references'] = $refs
            }
            [IO.File]::WriteAllText((Join-Path $tmp 'body.json'), ($body | ConvertTo-Json -Depth 8 -Compress), $utf8)
            $ca += @('-H', 'Content-Type: application/json', '--data-binary', '@body.json', $url)
        } else {
            $size = if ($Prova) { '1024x1024' } else { Dimensioni $Proporzione }
            $qual = if ($Prova) { 'low' } else { 'medium' }
            if ($rifInfo.Count -gt 0) {
                $url = 'https://api.openai.com/v1/images/edits'
                $ca += @('-F', "model=$Modello", '-F', 'prompt=<prompt.txt', '-F', "size=$size", '-F', "quality=$qual", '-F', 'n=1')
                foreach ($r in $rifInfo) { $ca += @('-F', ('image[]=@' + $r.tmp + ';type=' + $r.mime)) }
                $ca += $url
            } else {
                $url = 'https://api.openai.com/v1/images/generations'
                $body = [ordered]@{ model = $Modello; prompt = $Richiesta; size = $size; quality = $qual; n = 1 }
                [IO.File]::WriteAllText((Join-Path $tmp 'body.json'), ($body | ConvertTo-Json -Compress), $utf8)
                $ca += @('-H', 'Content-Type: application/json', '--data-binary', '@body.json', $url)
            }
        }

        $codice = 0; $esito = 0
        for ($tent = 1; $tent -le 2; $tent++) {
            if (Test-Path resp.json) { Remove-Item resp.json -Force }
            $out = & curl.exe @ca
            $esito = $LASTEXITCODE
            $codice = 0
            if ($out) { [void][int]::TryParse(([string]($out | Select-Object -Last 1)).Trim(), [ref]$codice) }
            if ($esito -ne 0) { break }
            if (-not (($codice -eq 429 -or $codice -ge 500) -and $tent -eq 1)) { break }
            Start-Sleep -Seconds 8
        }
        if ($esito -ne 0) {
            $gia = if ($salvate.Count -gt 0) { "`nImmagini già salvate: " + ($salvate -join ', ') } else { '' }
            Fine "Non riesco a collegarmi a internet (curl, codice $esito). Controlla la connessione e riprova.$gia"
        }
        $resp = ''
        if (Test-Path resp.json) { $resp = [IO.File]::ReadAllText((Join-Path $tmp 'resp.json'), $utf8) }
        if ($codice -ne 200) { Spiega-Errore $codice $resp $salvate }

        $b64 = $null; $costo = $null
        if ($resp -match '"b64_json"\s*:\s*"([^"]+)"') { $b64 = $Matches[1] }
        elseif ($resp -match '"url"\s*:\s*"data:[^;]+;base64,([^"]+)"') { $b64 = $Matches[1] }
        if ($resp -match '"cost"\s*:\s*([0-9.]+(?:[eE][-+]?[0-9]+)?)') { $costo = [double]::Parse($Matches[1], [Globalization.CultureInfo]::InvariantCulture) }
        if (-not $b64) {
            $gia = if ($salvate.Count -gt 0) { "`nImmagini già salvate: " + ($salvate -join ', ') } else { '' }
            Fine "Il servizio non ha restituito nessuna immagine.`nProva a riscrivere la richiesta in modo diverso.$gia"
        }
        $raw = [Convert]::FromBase64String($b64)
        $ext = switch (Mime-Da-Byte $raw) { 'image/jpeg' { 'jpg' } 'image/webp' { 'webp' } default { 'png' } }
        $base = "{0}-{1}-{2}" -f $Nome, $dataTag, $n
        $file = Join-Path $uscitaAbs "$base.$ext"
        [IO.File]::WriteAllBytes($file, $raw)

        $meta = [ordered]@{
            richiesta   = $Richiesta
            modello     = $Modello
            servizio    = $Servizio
            riferimenti = @($rifInfo | ForEach-Object { $_.nome })
            proporzione = $Proporzione
            data        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            secondi     = [int]((Get-Date) - $t0).TotalSeconds
            costo_usd   = $costo
            file        = "$base.$ext"
        }
        [IO.File]::WriteAllText((Join-Path $uscitaAbs "$base.json"), ($meta | ConvertTo-Json -Depth 4), $utf8)

        $ci = [Globalization.CultureInfo]::InvariantCulture
        if ($null -ne $costo) { $costoTot += $costo; $costoNoto = $true }
        $salvate += $file
        if ($null -ne $costo) { Write-Output ("Salvata: $file (costo " + $costo.ToString('0.000', $ci) + " `$)") } else { Write-Output "Salvata: $file" }
    }
} finally {
    Pop-Location
    Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
if ($costoNoto) {
    Write-Output ("Fatto: " + $salvate.Count + " immagine/i in $uscitaAbs, costo totale circa " + $costoTot.ToString('0.000', [Globalization.CultureInfo]::InvariantCulture) + " `$.")
} else {
    Write-Output ("Fatto: " + $salvate.Count + " immagine/i in $uscitaAbs, costo non comunicato dal servizio.")
}
$galleria = Aggiorna-Galleria $uscitaAbs $CartellaPrompt
if ($galleria) { Write-Output "Galleria aggiornata: $galleria (si apre con un doppio clic)" }
exit 0
