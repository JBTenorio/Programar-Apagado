# ============================================================
#  Programar Apagado
#  Autor: Jose Biojo Tenorio
#  Copyright (c) 2026 Jose Biojo Tenorio - Todos los derechos reservados
# ============================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Ruta real del proceso actual (funciona en .ps1 Y en .exe compilado)
$ExePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName

# Detectar si corremos como .exe compilado o como .ps1
$EsExe = $ExePath -notmatch 'powershell(\.exe)?$' -and $ExePath -notmatch 'pwsh(\.exe)?$'

# Rutas de instalacion en Program Files
$InstallDir = Join-Path $env:ProgramFiles "ProgramarApagado"
$InstallExe = Join-Path $InstallDir "ProgramarApagado.exe"

# Claves de registro
$RegDesk   = "Registry::HKEY_CLASSES_ROOT\DesktopBackground\Shell\ProgramarApagado"
$RegFolder = "Registry::HKEY_CLASSES_ROOT\Directory\Background\Shell\ProgramarApagado"

function Test-IsAdmin {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($user)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-Installed {
    return (Test-Path $RegDesk -ErrorAction SilentlyContinue)
}

function Install-ContextMenu {
    try {
        # Crear carpeta de instalacion
        if (-not (Test-Path $InstallDir)) {
            New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
        }

        # Copiar el .exe a Program Files (solo si no estamos ejecutando desde alli)
        if ($ExePath -ne $InstallExe) {
            Copy-Item -Path $ExePath -Destination $InstallExe -Force
        }

        # El comando del menu apunta directo al .exe instalado
        $comando = "`"$InstallExe`""

        foreach ($reg in @($RegDesk, $RegFolder)) {
            New-Item -Path $reg -Force | Out-Null
            Set-Item -Path $reg -Value "Programar Apagado"
            Set-ItemProperty -Path $reg -Name "Icon"      -Value "shell32.dll,27"
            New-Item -Path "$reg\command" -Force | Out-Null
            Set-Item -Path "$reg\command" -Value $comando
        }
        return $true
    } catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Error al instalar:`n$($_.Exception.Message)",
            "Error", "OK", "Error") | Out-Null
        return $false
    }
}

function Uninstall-ContextMenu {
    try {
        Remove-Item -Path $RegDesk   -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $RegFolder -Recurse -Force -ErrorAction SilentlyContinue
        # Borrar carpeta solo si no estamos corriendo desde ahi
        if ((Test-Path $InstallDir) -and ($ExePath -notlike "$InstallDir*")) {
            Remove-Item -Path $InstallDir -Recurse -Force -ErrorAction SilentlyContinue
        }
        return $true
    } catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Error al desinstalar:`n$($_.Exception.Message)",
            "Error", "OK", "Error") | Out-Null
        return $false
    }
}

function Show-Menu {
    $form = New-Object System.Windows.Forms.Form
    $form.Text            = "Programar Apagado"
    $form.Size            = New-Object System.Drawing.Size(400, 600)
    $form.StartPosition   = "CenterScreen"
    $form.BackColor       = [System.Drawing.Color]::FromArgb(18, 18, 28)
    $form.ForeColor       = [System.Drawing.Color]::White
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox     = $false
    $form.MinimizeBox     = $false
    $form.Font            = New-Object System.Drawing.Font("Segoe UI", 10)

    $lblTitulo           = New-Object System.Windows.Forms.Label
    $lblTitulo.Text      = "Programar Apagado"
    $lblTitulo.Font      = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $lblTitulo.ForeColor = [System.Drawing.Color]::FromArgb(100, 180, 255)
    $lblTitulo.Location  = New-Object System.Drawing.Point(20, 20)
    $lblTitulo.Size      = New-Object System.Drawing.Size(360, 35)
    $lblTitulo.TextAlign = "MiddleCenter"
    $form.Controls.Add($lblTitulo)

    $lblSub           = New-Object System.Windows.Forms.Label
    $lblSub.Text      = "Selecciona el tiempo para apagar el equipo"
    $lblSub.ForeColor = [System.Drawing.Color]::FromArgb(140, 140, 165)
    $lblSub.Location  = New-Object System.Drawing.Point(20, 58)
    $lblSub.Size      = New-Object System.Drawing.Size(360, 22)
    $lblSub.TextAlign = "MiddleCenter"
    $form.Controls.Add($lblSub)

    # Botones rapidos
    $opciones = @(
        [PSCustomObject]@{ Texto = "15 minutos"; Segundos = 900   },
        [PSCustomObject]@{ Texto = "30 minutos"; Segundos = 1800  },
        [PSCustomObject]@{ Texto = "1 hora";     Segundos = 3600  },
        [PSCustomObject]@{ Texto = "2 horas";    Segundos = 7200  },
        [PSCustomObject]@{ Texto = "4 horas";    Segundos = 14400 }
    )

    $y = 92
    foreach ($op in $opciones) {
        $btn = New-Object System.Windows.Forms.Button
        $btn.Text      = $op.Texto
        $btn.Location  = New-Object System.Drawing.Point(20, $y)
        $btn.Size      = New-Object System.Drawing.Size(340, 38)
        $btn.BackColor = [System.Drawing.Color]::FromArgb(32, 32, 50)
        $btn.ForeColor = [System.Drawing.Color]::White
        $btn.FlatStyle = "Flat"
        $btn.FlatAppearance.BorderColor        = [System.Drawing.Color]::FromArgb(55, 55, 85)
        $btn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(45, 95, 175)
        $btn.TextAlign = "MiddleCenter"
        $btn.Cursor    = "Hand"

        $seg = $op.Segundos
        $txt = $op.Texto
        $btn.Add_Click({
            shutdown /s /t $seg
            [System.Windows.Forms.MessageBox]::Show(
                "El equipo se apagara en $txt.`nUsa el boton rojo para cancelar.",
                "Apagado programado", "OK", "Information") | Out-Null
            $form.Close()
        }.GetNewClosure())

        $form.Controls.Add($btn)
        $y += 44
    }

    $sep             = New-Object System.Windows.Forms.Label
    $sep.BorderStyle = "Fixed3D"
    $sep.Location    = New-Object System.Drawing.Point(20, $y)
    $sep.Size        = New-Object System.Drawing.Size(340, 2)
    $form.Controls.Add($sep)
    $y += 14

    $lblCustom           = New-Object System.Windows.Forms.Label
    $lblCustom.Text      = "Tiempo personalizado (minutos):"
    $lblCustom.ForeColor = [System.Drawing.Color]::FromArgb(170, 170, 195)
    $lblCustom.Location  = New-Object System.Drawing.Point(20, $y)
    $lblCustom.Size      = New-Object System.Drawing.Size(360, 22)
    $lblCustom.TextAlign = "MiddleCenter"
    $form.Controls.Add($lblCustom)
    $y += 28

    $numInput           = New-Object System.Windows.Forms.NumericUpDown
    $numInput.Minimum   = 1
    $numInput.Maximum   = 1440
    $numInput.Value     = 60
    $numInput.Location  = New-Object System.Drawing.Point(20, $y)
    $numInput.Size      = New-Object System.Drawing.Size(110, 30)
    $numInput.BackColor = [System.Drawing.Color]::FromArgb(32, 32, 50)
    $numInput.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($numInput)

    $btnCustom           = New-Object System.Windows.Forms.Button
    $btnCustom.Text      = "Programar"
    $btnCustom.Location  = New-Object System.Drawing.Point(140, $y)
    $btnCustom.Size      = New-Object System.Drawing.Size(110, 30)
    $btnCustom.BackColor = [System.Drawing.Color]::FromArgb(35, 95, 200)
    $btnCustom.ForeColor = [System.Drawing.Color]::White
    $btnCustom.FlatStyle = "Flat"
    $btnCustom.FlatAppearance.BorderSize = 0
    $btnCustom.TextAlign = "MiddleCenter"
    $btnCustom.Cursor    = "Hand"
    $btnCustom.Add_Click({
        $mins = [int]$numInput.Value
        shutdown /s /t ($mins * 60)
        [System.Windows.Forms.MessageBox]::Show(
            "El equipo se apagara en $mins minutos.",
            "Apagado programado", "OK", "Information") | Out-Null
        $form.Close()
    }.GetNewClosure())
    $form.Controls.Add($btnCustom)
    $y += 46

    $btnCancelar           = New-Object System.Windows.Forms.Button
    $btnCancelar.Text      = "Cancelar apagado programado"
    $btnCancelar.Location  = New-Object System.Drawing.Point(20, $y)
    $btnCancelar.Size      = New-Object System.Drawing.Size(340, 36)
    $btnCancelar.BackColor = [System.Drawing.Color]::FromArgb(155, 35, 35)
    $btnCancelar.ForeColor = [System.Drawing.Color]::White
    $btnCancelar.FlatStyle = "Flat"
    $btnCancelar.FlatAppearance.BorderSize = 0
    $btnCancelar.TextAlign = "MiddleCenter"
    $btnCancelar.Cursor    = "Hand"
    $btnCancelar.Add_Click({
        $result = & shutdown /a 2>&1
        if ($LASTEXITCODE -eq 0) {
            [System.Windows.Forms.MessageBox]::Show(
                "Apagado cancelado correctamente.",
                "Cancelado", "OK", "Information") | Out-Null
        } else {
            [System.Windows.Forms.MessageBox]::Show(
                "No hay ningun apagado programado para cancelar.",
                "Aviso", "OK", "Information") | Out-Null
        }
        $form.Close()
    }.GetNewClosure())
    $form.Controls.Add($btnCancelar)
    $y += 46

    # Boton instalar / desinstalar
    $btnMenu           = New-Object System.Windows.Forms.Button
    $btnMenu.Location  = New-Object System.Drawing.Point(20, $y)
    $btnMenu.Size      = New-Object System.Drawing.Size(340, 36)
    $btnMenu.FlatStyle = "Flat"
    $btnMenu.FlatAppearance.BorderSize = 0
    $btnMenu.ForeColor = [System.Drawing.Color]::White
    $btnMenu.TextAlign = "MiddleCenter"
    $btnMenu.Cursor    = "Hand"

    # Establecer estado inicial del boton directamente
    if (Test-Installed) {
        $btnMenu.Text = "Desinstalar del menu contextual"
        $btnMenu.BackColor = [System.Drawing.Color]::FromArgb(120, 30, 30)
    } else {
        $btnMenu.Text = "Agregar al menu contextual (clic derecho)"
        $btnMenu.BackColor = [System.Drawing.Color]::FromArgb(35, 110, 60)
    }

    $btnMenu.Add_Click({
        # 1. Validar Permisos PRIMERO (Evita los errores por falta de acceso)
        if (-not (Test-IsAdmin)) {
            try {
                Start-Process -FilePath $ExePath -Verb RunAs -ErrorAction Stop
                $form.Close()
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Se requieren permisos de administrador para modificar el menu.", "Aviso", "OK", "Warning") | Out-Null
            }
            return
        }

        # 2. Proceder a Instalar o Desinstalar
        if (Test-Installed) {
            $ok = Uninstall-ContextMenu
            if ($ok) {
                [System.Windows.Forms.MessageBox]::Show(
                    "Eliminado del menu contextual correctamente.",
                    "Desinstalado", "OK", "Information") | Out-Null
            }
        } else {
            $ok = Install-ContextMenu
            if ($ok) {
                [System.Windows.Forms.MessageBox]::Show(
                    "Agregado correctamente.`nHaz clic derecho en el escritorio para verlo.",
                    "Instalado", "OK", "Information") | Out-Null
            }
        }

        # 3. Refrescar colores del boton INMEDIATAMENTE de forma directa
        if (Test-Installed) {
            $btnMenu.Text = "Desinstalar del menu contextual"
            $btnMenu.BackColor = [System.Drawing.Color]::FromArgb(120, 30, 30)
        } else {
            $btnMenu.Text = "Agregar al menu contextual (clic derecho)"
            $btnMenu.BackColor = [System.Drawing.Color]::FromArgb(35, 110, 60)
        }
    }.GetNewClosure())

    $form.Controls.Add($btnMenu)
    $y += 46

    $lblCredito           = New-Object System.Windows.Forms.Label
    $lblCredito.Text      = "Creado por Jose Biojo Tenorio"
    $lblCredito.ForeColor = [System.Drawing.Color]::FromArgb(80, 80, 105)
    $lblCredito.Font      = New-Object System.Drawing.Font("Segoe UI", 8)
    $lblCredito.Location  = New-Object System.Drawing.Point(20, $y)
    $lblCredito.Size      = New-Object System.Drawing.Size(340, 20)
    $lblCredito.TextAlign = "MiddleCenter"
    $form.Controls.Add($lblCredito)

    $form.ShowDialog() | Out-Null
}

Show-Menu
