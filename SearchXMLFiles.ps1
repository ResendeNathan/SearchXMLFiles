Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Cria a janela do formulário
$form = New-Object System.Windows.Forms.Form
$form.Text = "Pesquisa em Arquivos XML"
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::LightSteelBlue

# Adiciona um título
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Pesquisa em Arquivos XML"
$titleLabel.Font = New-Object System.Drawing.Font("Arial", 20, [System.Drawing.FontStyle]::Bold)
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point((($form.ClientSize.Width - $titleLabel.Width) / 2), 20)
$titleLabel.Anchor = [System.Windows.Forms.AnchorStyles]::Top
$form.Controls.Add($titleLabel)

# Cria o campo de texto para inserir o texto a ser pesquisado
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(50, 80)
$textBox.Size = New-Object System.Drawing.Size(700, 350) # Aumenta a largura do campo
$textBox.Font = New-Object System.Drawing.Font("Arial", 12) # Ajusta a fonte para 12
$textBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top
$form.Controls.Add($textBox)

# Cria o botão para iniciar a pesquisa
$button = New-Object System.Windows.Forms.Button
$button.Text = "Pesquisar"
$button.Location = New-Object System.Drawing.Point(50, 140)
$button.Size = New-Object System.Drawing.Size(100, 40)
$button.BackColor = [System.Drawing.Color]::CornflowerBlue
$button.ForeColor = [System.Drawing.Color]::White
$button.Anchor = [System.Windows.Forms.AnchorStyles]::Top
$form.Controls.Add($button)

# Cria o botão para limpar a pesquisa
$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Text = "Limpar Pesquisa"
$clearButton.Location = New-Object System.Drawing.Point(200, 140)
$clearButton.Size = New-Object System.Drawing.Size(100, 40)
$clearButton.BackColor = [System.Drawing.Color]::LightCoral
$clearButton.ForeColor = [System.Drawing.Color]::White
$clearButton.Anchor = [System.Windows.Forms.AnchorStyles]::Top
$form.Controls.Add($clearButton)

# Cria a área de texto para exibir os resultados
$resultsBox = New-Object System.Windows.Forms.RichTextBox
$resultsBox.Location = New-Object System.Drawing.Point(50, 210)
$resultsBox.Size = New-Object System.Drawing.Size(700, 200)
$resultsBox.Multiline = $true
$resultsBox.ScrollBars = "Vertical"
$resultsBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top
$form.Controls.Add($resultsBox)

# Adiciona uma imagem de logo
$logo = New-Object System.Windows.Forms.PictureBox
$logo.Image = [System.Drawing.Image]::FromFile("C:\SearchXML\LOGO.png")
$logo.SizeMode = "StretchImage"
$logo.Size = New-Object System.Drawing.Size(300, 130)
$logo.Location = New-Object System.Drawing.Point((($form.ClientSize.Width - $logo.Width) / 2), 30)
$logo.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom
$form.Controls.Add($logo)

#Define a ação do botão Pesquisar
$button.Add_Click({
    $searchText = $textBox.Text
    $xmlFilesPath = "C:\Caminho dos Arquivos XML\*.xml"
    $xmlFiles = Get-ChildItem -Path $xmlFilesPath
    $filesWithText = @()

    foreach ($file in $xmlFiles) {
        $xmlContent = Get-Content -Path $file.FullName -Encoding UTF8
        if ($xmlContent -match $searchText) {
            $filesWithText += $file.Name
        }
    }

    $resultsBox.Clear()
    if ($filesWithText.Count -gt 0) {
        $resultsBox.SelectionFont = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
        $resultsBox.AppendText("Os seguintes arquivos possuem o texto '$searchText':" + [Environment]::NewLine + [Environment]::NewLine)
        $resultsBox.SelectionFont = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
        $resultsBox.AppendText(($filesWithText -join [Environment]::NewLine))
    } else {
        $resultsBox.SelectionFont = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
        $resultsBox.AppendText("Nenhum arquivo possui o texto '$searchText'.")
    }
})

# Define a ação do botão de limpar
$clearButton.Add_Click({
    $textBox.Clear()
    $resultsBox.Clear()
})

# Centraliza o título e o logo ao redimensionar a janela
$form.Add_Shown({
    $titleLabel.Location = New-Object System.Drawing.Point((($form.ClientSize.Width - $titleLabel.Width) / 2), 20)
    $logo.Location = New-Object System.Drawing.Point((($form.ClientSize.Width - $logo.Width) / 2), 430)
})

$form.Add_Resize({
    $titleLabel.Location = New-Object System.Drawing.Point((($form.ClientSize.Width - $titleLabel.Width) / 2), 20)
    $logo.Location = New-Object System.Drawing.Point((($form.ClientSize.Width - $logo.Width) / 2), 430)
})

# Exibe o formulário
$form.ShowDialog()