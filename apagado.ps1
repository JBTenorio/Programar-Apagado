# ============================================================
#  Programar Apagado
#  Autor: Jose Biojo Tenorio
#  Copyright (c) 2026 Jose Biojo Tenorio - Todos los derechos reservados
# ============================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Activar estilos visuales modernos
[System.Windows.Forms.Application]::EnableVisualStyles()

function Show-Menu {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Programar Apagado"
    # Tamaño aumentado a 600 para que quepan todos los botones bien
    $form.Size = New-Object System.Drawing.Size(400, 600) 
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(18, 18, 28)
    $form.ForeColor = [System.Drawing.Color]::White
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    # Centrar el texto de los controles por defecto

    # Titulo y Subtitulo
    $lblTitulo = New-Object System.Windows.Forms.Label
    $lblTitulo.Text = "Programar Apagado"
    $lblTitulo.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $lblTitulo.ForeColor = [System.Drawing.Color]::FromArgb(100, 180, 255)
    $lblTitulo.Location = New-Object System.Drawing.Point(20, 20)
    $lblTitulo.Size = New-Object System.Drawing.Size(360, 35)
    $lblTitulo.TextAlign = "MiddleCenter"
    $form.Controls.Add($lblTitulo)

    $lblSub = New-Object System.Windows.Forms.Label
    $lblSub.Text = "Selecciona el tiempo para apagar el equipo"
    $lblSub.ForeColor = [System.Drawing.Color]::FromArgb(140, 140, 165)
    $lblSub.Location = New-Object System.Drawing.Point(20, 58)
    $lblSub.Size = New-Object System.Drawing.Size(360, 22)
    $lblSub.TextAlign = "MiddleCenter"
    $form.Controls.Add($lblSub)

    # Botones rapidos
    $opciones = @(
        [PSCustomObject]@{ Texto = "15 minutos"; Segundos = 900 },
        [PSCustomObject]@{ Texto = "30 minutos"; Segundos = 1800 },
        [PSCustomObject]@{ Texto = "1 hora"; Segundos = 3600 },
        [PSCustomObject]@{ Texto = "2 horas"; Segundos = 7200 },
        [PSCustomObject]@{ Texto = "4 horas"; Segundos = 14400 }
    )

    $y = 92
    foreach ($op in $opciones) {
        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = $op.Texto
        $btn.Location = New-Object System.Drawing.Point(20, $y)
        $btn.Size = New-Object System.Drawing.Size(340, 38)
        $btn.BackColor = [System.Drawing.Color]::FromArgb(32, 32, 50)
        $btn.ForeColor = [System.Drawing.Color]::White
        $btn.FlatStyle = "Flat"
        $btn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(55, 55, 85)
        $btn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(45, 95, 175)
        $btn.TextAlign = "MiddleCenter"
        $btn.Cursor = "Hand"
        $segundos = $op.Segundos
        $btn.Add_Click({ shutdown /s /t $segundos; $form.Close() }.GetNewClosure())
        $form.Controls.Add($btn)
        $y += 44
    }

    # Separador, Input y Botones de control
    $sep = New-Object System.Windows.Forms.Label
    $sep.BorderStyle = "Fixed3D"
    $sep.Location = New-Object System.Drawing.Point(20, $y)
    $sep.Size = New-Object System.Drawing.Size(340, 2)
    $form.Controls.Add($sep)
    $y += 14

    $lblCustom = New-Object System.Windows.Forms.Label
    $lblCustom.Text = "Tiempo personalizado (minutos):"
    $lblCustom.Location = New-Object System.Drawing.Point(20, $y)
    $lblCustom.Size = New-Object System.Drawing.Size(360, 22)
    $lblCustom.TextAlign = "MiddleCenter"
    $form.Controls.Add($lblCustom)
    $y += 28

    $numInput = New-Object System.Windows.Forms.NumericUpDown
    $numInput.Location = New-Object System.Drawing.Point(20, $y)
    $numInput.Size = New-Object System.Drawing.Size(110, 30)
    $form.Controls.Add($numInput)

    $btnCustom = New-Object System.Windows.Forms.Button
    $btnCustom.Text = "Programar"
    $btnCustom.Location = New-Object System.Drawing.Point(140, $y)
    $btnCustom.Size = New-Object System.Drawing.Size(110, 30)
    $btnCustom.BackColor = [System.Drawing.Color]::FromArgb(35, 95, 200)
    $btnCustom.TextAlign = "MiddleCenter"
    $btnCustom.Add_Click({ shutdown /s /t ([int]$numInput.Value * 60); $form.Close() }.GetNewClosure())
    $form.Controls.Add($btnCustom)
    $y += 46

    $btnCancelar = New-Object System.Windows.Forms.Button
    $btnCancelar.Text = "Cancelar apagado programado"
    $btnCancelar.Location = New-Object System.Drawing.Point(20, $y)
    $btnCancelar.Size = New-Object System.Drawing.Size(340, 36)
    $btnCancelar.BackColor = [System.Drawing.Color]::FromArgb(155, 35, 35)
    $btnCancelar.TextAlign = "MiddleCenter"
    $btnCancelar.Add_Click({ shutdown /a; $form.Close() }.GetNewClosure())
    $form.Controls.Add($btnCancelar)
    $y += 46

    # ==========================================
    # NUEVO BOTÓN INTELIGENTE
    # ==========================================
    $regProvider = "Registry::HKEY_CLASSES_ROOT"
    $regPath = "$regProvider\DesktopBackground\Shell\ProgramarApagado"
    
    $btnInstalar = New-Object System.Windows.Forms.Button
    $btnInstalar.Location = New-Object System.Drawing.Point(20, $y)
    $btnInstalar.Size = New-Object System.Drawing.Size(340, 36)
    $btnInstalar.FlatStyle = "Flat"
    $btnInstalar.TextAlign = "MiddleCenter"
    $btnInstalar.ForeColor = [System.Drawing.Color]::White
    $btnInstalar.Cursor = "Hand"

    function Update-Button {
        if (Test-Path $regPath) {
            $btnInstalar.Text = "Desinstalar del menu"
            $btnInstalar.BackColor = [System.Drawing.Color]::FromArgb(155, 35, 35)
        } else {
            $btnInstalar.Text = "Agregar al menu (Clic Derecho)"
            $btnInstalar.BackColor = [System.Drawing.Color]::FromArgb(45, 125, 75)
        }
    }
    Update-Button

    $btnInstalar.Add_Click({
        try {
            $scriptPath = $PSCommandPath
            $powershellExe = "powershell.exe"
            if (Test-Path $regPath) {
                Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\DesktopBackground\Shell\ProgramarApagado" -Recurse -Force
                Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\Shell\ProgramarApagado" -Recurse -Force
                [System.Windows.Forms.MessageBox]::Show("Desinstalado del menu.") | Out-Null
            } else {
                foreach ($p in @("Registry::HKEY_CLASSES_ROOT\DesktopBackground\Shell\ProgramarApagado", "Registry::HKEY_CLASSES_ROOT\Directory\Background\Shell\ProgramarApagado")) {
                    New-Item -Path $p -Force | Out-Null
                    Set-ItemProperty -Path $p -Name "MUIVerb" -Value "Programar Apagado"
                    Set-ItemProperty -Path $p -Name "Icon" -Value "shell32.dll,27"
                    New-Item -Path "$p\command" -Force | Out-Null
                    $commandLine = "`"$powershellExe`" -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
                    Set-ItemProperty -Path "$p\command" -Name "(default)" -Value $commandLine
                }
                [System.Windows.Forms.MessageBox]::Show("Agregado exitosamente.") | Out-Null
            }
            Update-Button
        } catch { [System.Windows.Forms.MessageBox]::Show("Error: $_") | Out-Null }
    })
    $form.Controls.Add($btnInstalar)
    $y += 46

    # Credito
    $lblCredito = New-Object System.Windows.Forms.Label
    $lblCredito.Text = "Creado por Jose Biojo Tenorio"
    $lblCredito.ForeColor = [System.Drawing.Color]::FromArgb(80, 80, 105)
    $lblCredito.TextAlign = "MiddleCenter"
    $lblCredito.Location = New-Object System.Drawing.Point(20, $y)
    $lblCredito.Size = New-Object System.Drawing.Size(340, 20)
    $form.Controls.Add($lblCredito)

    $form.ShowDialog() | Out-Null
}

Show-Menu