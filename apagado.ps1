# ============================================================
#  Programar Apagado
#  Autor: Jose Biojo Tenorio
#  Copyright (c) 2026 Jose Biojo Tenorio - Todos los derechos reservados
#  https://github.com/tu-usuario/programar-apagado
# ============================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-Menu {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Programar Apagado"
    $form.Size = New-Object System.Drawing.Size(400, 510)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(18, 18, 28)
    $form.ForeColor = [System.Drawing.Color]::White
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

    # Titulo
    $lblTitulo = New-Object System.Windows.Forms.Label
    $lblTitulo.Text = "Programar Apagado"
    $lblTitulo.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $lblTitulo.ForeColor = [System.Drawing.Color]::FromArgb(100, 180, 255)
    $lblTitulo.Location = New-Object System.Drawing.Point(20, 20)
    $lblTitulo.Size = New-Object System.Drawing.Size(360, 35)
    $form.Controls.Add($lblTitulo)

    # Subtitulo
    $lblSub = New-Object System.Windows.Forms.Label
    $lblSub.Text = "Selecciona el tiempo para apagar el equipo"
    $lblSub.ForeColor = [System.Drawing.Color]::FromArgb(140, 140, 165)
    $lblSub.Location = New-Object System.Drawing.Point(20, 58)
    $lblSub.Size = New-Object System.Drawing.Size(360, 22)
    $form.Controls.Add($lblSub)

    # Botones rapidos
    $opciones = @(
        [PSCustomObject]@{ Texto = "15 minutos";  Segundos = 900   },
        [PSCustomObject]@{ Texto = "30 minutos";  Segundos = 1800  },
        [PSCustomObject]@{ Texto = "1 hora";      Segundos = 3600  },
        [PSCustomObject]@{ Texto = "2 horas";     Segundos = 7200  },
        [PSCustomObject]@{ Texto = "4 horas";     Segundos = 14400 }
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
        $btn.Cursor = "Hand"

        $segundos = $op.Segundos
        $texto    = $op.Texto

        $btn.Add_Click({
            shutdown /s /t $segundos
            [System.Windows.Forms.MessageBox]::Show(
                "El equipo se apagara en $texto.`n`nPara cancelarlo usa el boton rojo.",
                "Apagado programado",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information
            ) | Out-Null
            $form.Close()
        }.GetNewClosure())

        $form.Controls.Add($btn)
        $y += 44
    }

    # Separador
    $sep = New-Object System.Windows.Forms.Label
    $sep.BorderStyle = "Fixed3D"
    $sep.Location = New-Object System.Drawing.Point(20, $y)
    $sep.Size = New-Object System.Drawing.Size(340, 2)
    $form.Controls.Add($sep)
    $y += 14

    # Label tiempo personalizado
    $lblCustom = New-Object System.Windows.Forms.Label
    $lblCustom.Text = "Tiempo personalizado (minutos):"
    $lblCustom.ForeColor = [System.Drawing.Color]::FromArgb(170, 170, 195)
    $lblCustom.Location = New-Object System.Drawing.Point(20, $y)
    $lblCustom.Size = New-Object System.Drawing.Size(260, 22)
    $form.Controls.Add($lblCustom)
    $y += 28

    # Input numerico
    $numInput = New-Object System.Windows.Forms.NumericUpDown
    $numInput.Minimum = 1
    $numInput.Maximum = 1440
    $numInput.Value = 60
    $numInput.Location = New-Object System.Drawing.Point(20, $y)
    $numInput.Size = New-Object System.Drawing.Size(110, 30)
    $numInput.BackColor = [System.Drawing.Color]::FromArgb(32, 32, 50)
    $numInput.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($numInput)

    # Boton programar personalizado
    $btnCustom = New-Object System.Windows.Forms.Button
    $btnCustom.Text = "Programar"
    $btnCustom.Location = New-Object System.Drawing.Point(140, $y)
    $btnCustom.Size = New-Object System.Drawing.Size(110, 30)
    $btnCustom.BackColor = [System.Drawing.Color]::FromArgb(35, 95, 200)
    $btnCustom.ForeColor = [System.Drawing.Color]::White
    $btnCustom.FlatStyle = "Flat"
    $btnCustom.FlatAppearance.BorderSize = 0
    $btnCustom.Cursor = "Hand"
    $btnCustom.Add_Click({
        $mins = [int]$numInput.Value
        $segs = $mins * 60
        shutdown /s /t $segs
        [System.Windows.Forms.MessageBox]::Show(
            "El equipo se apagara en $mins minutos.",
            "Apagado programado",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        ) | Out-Null
        $form.Close()
    }.GetNewClosure())
    $form.Controls.Add($btnCustom)
    $y += 46

    # Boton cancelar
    $btnCancelar = New-Object System.Windows.Forms.Button
    $btnCancelar.Text = "Cancelar apagado programado"
    $btnCancelar.Location = New-Object System.Drawing.Point(20, $y)
    $btnCancelar.Size = New-Object System.Drawing.Size(340, 36)
    $btnCancelar.BackColor = [System.Drawing.Color]::FromArgb(155, 35, 35)
    $btnCancelar.ForeColor = [System.Drawing.Color]::White
    $btnCancelar.FlatStyle = "Flat"
    $btnCancelar.FlatAppearance.BorderSize = 0
    $btnCancelar.Cursor = "Hand"
    $btnCancelar.Add_Click({
        shutdown /a
        [System.Windows.Forms.MessageBox]::Show(
            "El apagado programado ha sido cancelado.",
            "Cancelado",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        ) | Out-Null
        $form.Close()
    }.GetNewClosure())
    $form.Controls.Add($btnCancelar)

    # Credito autor
    $y += 46
    $lblCredito = New-Object System.Windows.Forms.Label
    $lblCredito.Text = "Creado por Jose Biojo Tenorio"
    $lblCredito.ForeColor = [System.Drawing.Color]::FromArgb(80, 80, 105)
    $lblCredito.Font = New-Object System.Drawing.Font("Segoe UI", 8)
    $lblCredito.Location = New-Object System.Drawing.Point(20, $y)
    $lblCredito.Size = New-Object System.Drawing.Size(340, 18)
    $lblCredito.TextAlign = "MiddleCenter"
    $form.Controls.Add($lblCredito)

    $form.ShowDialog() | Out-Null
}

Show-Menu
