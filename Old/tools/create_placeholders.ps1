Add-Type -AssemblyName System.Drawing

$assets = @(
    @{ Name = "trickbot_architecture.png"; Title = "TrickBot Architecture"; Detail = "Replace with an original modular execution-chain diagram." },
    @{ Name = "cve_nvd_registry.png"; Title = "CVE-2024-3400 Registry"; Detail = "Replace with a full, readable NVD or vendor-advisory screenshot." },
    @{ Name = "leaked_source_repo.png"; Title = "Conti Repository Structure"; Detail = "Replace with a readable repository-tree screenshot." },
    @{ Name = "source_code_snippet.png"; Title = "Conti Functional Module"; Detail = "Replace with a safe, annotated source-structure screenshot." },
    @{ Name = "ai_interaction_proof.png"; Title = "AI Interaction Evidence"; Detail = "Replace with the full Codex prompt and response history screenshot." }
)

$outputDir = Join-Path $PSScriptRoot "..\images"

foreach ($asset in $assets) {
    $bitmap = New-Object System.Drawing.Bitmap 1600, 900
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.Clear([System.Drawing.Color]::FromArgb(246, 248, 251))

    $borderPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(38, 78, 112)), 6
    $graphics.DrawRectangle($borderPen, 70, 70, 1460, 760)

    $titleFont = New-Object System.Drawing.Font "Arial", 48, ([System.Drawing.FontStyle]::Bold)
    $bodyFont = New-Object System.Drawing.Font "Arial", 26
    $smallFont = New-Object System.Drawing.Font "Arial", 20
    $titleBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(26, 62, 91))
    $bodyBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(55, 65, 75))

    $graphics.DrawString($asset.Title, $titleFont, $titleBrush, 130, 240)
    $graphics.DrawString("VISUAL PLACEHOLDER", $smallFont, $titleBrush, 135, 180)
    $graphics.DrawString($asset.Detail, $bodyFont, $bodyBrush, 135, 360)
    $graphics.DrawString("Required by the Reverse Engineering course report.", $smallFont, $bodyBrush, 135, 700)

    $path = Join-Path $outputDir $asset.Name
    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)

    $borderPen.Dispose()
    $titleFont.Dispose()
    $bodyFont.Dispose()
    $smallFont.Dispose()
    $titleBrush.Dispose()
    $bodyBrush.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
}
