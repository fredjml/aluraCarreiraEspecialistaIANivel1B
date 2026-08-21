Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Drawing

$root = $PSScriptRoot
$evidenceDirectory = Join-Path -Path $root -ChildPath 'evidencias'
$outputPath = Join-Path -Path $root -ChildPath 'Evidencias_Projeto_Hermex_Log.docx'

function Escape-Xml {
    param([string]$Value)

    return [System.Security.SecurityElement]::Escape($Value)
}

function New-RunXml {
    param(
        [string]$Text,
        [switch]$Bold
    )

    $properties = if ($Bold) { '<w:rPr><w:b/></w:rPr>' } else { '' }
    return "<w:r>$properties<w:t xml:space=`"preserve`">$(Escape-Xml $Text)</w:t></w:r>"
}

function New-ParagraphXml {
    param(
        [string]$Text,
        [string]$Style = 'Normal',
        [string]$Alignment = 'left',
        [int]$SpaceAfter = 0,
        [switch]$Bold
    )

    $paragraphProperties = '<w:pPr>'
    if ($Style) {
        $paragraphProperties += "<w:pStyle w:val=`"$Style`"/>"
    }
    if ($Alignment -ne 'left') {
        $paragraphProperties += "<w:jc w:val=`"$Alignment`"/>"
    }
    if ($SpaceAfter -gt 0) {
        $paragraphProperties += "<w:spacing w:after=`"$SpaceAfter`"/>"
    }
    $paragraphProperties += '</w:pPr>'

    return "<w:p>$paragraphProperties$(New-RunXml -Text $Text -Bold:$Bold)</w:p>"
}

function New-ImageParagraphXml {
    param(
        [string]$RelationshipId,
        [int]$DrawingId,
        [string]$Name,
        [long]$Width,
        [long]$Height
    )

    $escapedName = Escape-Xml $Name
    return @"
<w:p>
  <w:pPr><w:jc w:val="center"/></w:pPr>
  <w:r>
    <w:drawing>
      <wp:inline distT="0" distB="0" distL="0" distR="0">
        <wp:extent cx="$Width" cy="$Height"/>
        <wp:effectExtent l="0" t="0" r="0" b="0"/>
        <wp:docPr id="$DrawingId" name="$escapedName" descr="$escapedName"/>
        <wp:cNvGraphicFramePr><a:graphicFrameLocks noChangeAspect="1"/></wp:cNvGraphicFramePr>
        <a:graphic>
          <a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture">
            <pic:pic>
              <pic:nvPicPr>
                <pic:cNvPr id="$DrawingId" name="$escapedName"/>
                <pic:cNvPicPr/>
              </pic:nvPicPr>
              <pic:blipFill>
                <a:blip r:embed="$RelationshipId"/>
                <a:stretch><a:fillRect/></a:stretch>
              </pic:blipFill>
              <pic:spPr>
                <a:xfrm><a:off x="0" y="0"/><a:ext cx="$Width" cy="$Height"/></a:xfrm>
                <a:prstGeom prst="rect"><a:avLst/></a:prstGeom>
              </pic:spPr>
            </pic:pic>
          </a:graphicData>
        </a:graphic>
      </wp:inline>
    </w:drawing>
  </w:r>
</w:p>
"@
}

function Add-ZipText {
    param(
        [System.IO.Compression.ZipArchive]$Archive,
        [string]$EntryName,
        [string]$Content
    )

    $entry = $Archive.CreateEntry($EntryName)
    $writer = [System.IO.StreamWriter]::new(
        $entry.Open(),
        [System.Text.UTF8Encoding]::new($false)
    )
    try {
        $writer.Write($Content)
    }
    finally {
        $writer.Dispose()
    }
}

function Add-ZipFile {
    param(
        [System.IO.Compression.ZipArchive]$Archive,
        [string]$EntryName,
        [string]$SourcePath
    )

    $entry = $Archive.CreateEntry($EntryName)
    $input = [System.IO.File]::OpenRead($SourcePath)
    $output = $entry.Open()
    try {
        $input.CopyTo($output)
    }
    finally {
        $output.Dispose()
        $input.Dispose()
    }
}

$evidences = @(
    [PSCustomObject]@{
        Number = '01'
        Title = 'Assistente personalizado: instruções'
        Summary = 'Configuração do assistente Hermex Prazos, com instruções e critérios de atendimento visíveis.'
        File = '01_gpt_instrucoes.png'
        Caption = 'Configuração do GPT Hermex Prazos.'
    },
    [PSCustomObject]@{
        Number = '02'
        Title = 'Assistente personalizado: testes por UF'
        Summary = 'Testes do assistente para os estados de São Paulo, Bahia e Amazonas.'
        File = '02_gpt_testes_sp_ba_am.png'
        Caption = 'Testes do GPT com consultas de prazo por UF.'
    },
    [PSCustomObject]@{
        Number = '03'
        Title = 'Fluxograma do processo de pós-venda'
        Summary = 'Fluxo com início, decisão de entrega confirmada, automações e retorno para acompanhamento quando necessário.'
        File = '03_miro_fluxograma.png'
        Caption = 'Fluxograma do Miro com pontos de automação n8n.'
    },
    [PSCustomObject]@{
        Number = '04'
        Title = 'Matriz RACI'
        Summary = 'Distribuição de responsabilidades entre Vendas, Pós-Vendas, N8N, Correios e Liderança.'
        File = '04_sheets_matriz_raci.png'
        Caption = 'Aba Matriz RACI no Google Sheets.'
    },
    [PSCustomObject]@{
        Number = '05'
        Title = 'Pesquisa de satisfação'
        Summary = 'Formulário de NPS com identificação do pedido, nota e comentário do cliente.'
        File = '05_forms_nps.png'
        Caption = 'Google Forms da Pesquisa de Satisfação Hermex Log.'
    },
    [PSCustomObject]@{
        Number = '06'
        Title = 'Automação n8n: caminho de detrator'
        Summary = 'Execução de teste com nota inferior a 6, direcionada para classificação e preparação do alerta.'
        File = '06_n8n_detrator.png'
        Caption = 'Execução do caminho de detrator no n8n.'
    },
    [PSCustomObject]@{
        Number = '07'
        Title = 'Automação n8n: caminho de promotor'
        Summary = 'Execução de teste com nota promotora, direcionada para preparação da mensagem de agradecimento.'
        File = '07_n8n_promotor.png'
        Caption = 'Execução do caminho de promotor no n8n.'
    },
    [PSCustomObject]@{
        Number = '08'
        Title = 'E-mail de teste'
        Summary = 'Recebimento de alerta automatizado de detrator em conta de teste, com conteúdo de NPS e categoria.'
        File = '08_gmail_emails_teste.png'
        Caption = 'Mensagem de alerta de detrator enviada pelo fluxo de teste.'
    },
    [PSCustomObject]@{
        Number = '09a'
        Title = 'Dashboard Looker Studio: visão geral'
        Summary = 'Indicadores de NPS geral, promotores e detratores, além do mapa do Brasil por estado.'
        File = '09_looker_dashboard_1.png'
        Caption = 'Visão geral do Dashboard NPS Hermex Log.'
    },
    [PSCustomObject]@{
        Number = '09b'
        Title = 'Dashboard Looker Studio: análise por estado'
        Summary = 'Gráfico e tabela por estado, com nota NPS média e quantidade de registros.'
        File = '09_looker_dashboard_2.png'
        Caption = 'Análise por estado no Dashboard NPS Hermex Log.'
    },
    [PSCustomObject]@{
        Number = '10a'
        Title = 'Base de conhecimento no Notion'
        Summary = 'Página Processos Hermex Log com Política de Devolução, Processo de Reembolso e SLA de Entrega.'
        File = '10_notion_baseB.png'
        Caption = 'Base Processos Hermex Log no Notion.'
    },
    [PSCustomObject]@{
        Number = '10b'
        Title = 'SLA de Entrega'
        Summary = 'Página de SLA com a definição explícita de cinco dias corridos para as regiões brasileiras.'
        File = '10_notion_base.png'
        Caption = 'SLA de Entrega no Notion: cinco dias corridos.'
    }
)

foreach ($evidence in $evidences) {
    $filePath = Join-Path -Path $evidenceDirectory -ChildPath $evidence.File
    if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
        throw "Evidência não encontrada: $filePath"
    }
}

$pageBreak = '<w:p><w:r><w:br w:type="page"/></w:r></w:p>'
$body = [System.Collections.Generic.List[string]]::new()
$body.Add((New-ParagraphXml -Text 'Evidências Visuais' -Style 'Title' -Alignment 'center' -SpaceAfter 160))
$body.Add((New-ParagraphXml -Text 'Projeto Hermex Log' -Style 'Subtitle' -Alignment 'center' -SpaceAfter 80))
$body.Add((New-ParagraphXml -Text 'Consolidação das capturas de tela das configurações, testes e artefatos do projeto.' -Style 'Normal' -Alignment 'center' -SpaceAfter 80))
$body.Add((New-ParagraphXml -Text 'Gerado em 21/08/2026.' -Style 'Caption' -Alignment 'center'))
$body.Add($pageBreak)

$body.Add((New-ParagraphXml -Text 'Relação de evidências' -Style 'Heading1' -SpaceAfter 120))
foreach ($evidence in $evidences) {
    $body.Add((New-ParagraphXml -Text "$($evidence.Number) - $($evidence.Title) ($($evidence.File))" -Style 'ListBullet' -SpaceAfter 45))
}
$body.Add($pageBreak)

$imageEntries = [System.Collections.Generic.List[object]]::new()
$drawingId = 1
$relationshipNumber = 2
$mediaNumber = 1
$maxWidth = [long](7.1 * 914400)
$maxHeight = [long](8.55 * 914400)

for ($index = 0; $index -lt $evidences.Count; $index++) {
    $evidence = $evidences[$index]
    $path = Join-Path -Path $evidenceDirectory -ChildPath $evidence.File
    $image = [System.Drawing.Image]::FromFile($path)
    try {
        $sourceWidth = [double]$image.Width
        $sourceHeight = [double]$image.Height
    }
    finally {
        $image.Dispose()
    }

    $targetWidth = [double]$maxWidth
    $targetHeight = $targetWidth * $sourceHeight / $sourceWidth
    if ($targetHeight -gt $maxHeight) {
        $targetHeight = [double]$maxHeight
        $targetWidth = $targetHeight * $sourceWidth / $sourceHeight
    }

    $relationshipId = "rId$relationshipNumber"
    $mediaName = "image$mediaNumber.png"
    $imageEntries.Add([PSCustomObject]@{
        RelationshipId = $relationshipId
        MediaName = $mediaName
        SourcePath = $path
    })

    $body.Add((New-ParagraphXml -Text "Evidência $($evidence.Number) - $($evidence.Title)" -Style 'Heading1' -SpaceAfter 80))
    $body.Add((New-ParagraphXml -Text $evidence.Summary -Style 'Normal' -SpaceAfter 100))
    $body.Add((New-ImageParagraphXml -RelationshipId $relationshipId -DrawingId $drawingId -Name $evidence.File -Width ([long][Math]::Round($targetWidth)) -Height ([long][Math]::Round($targetHeight))))
    $body.Add((New-ParagraphXml -Text "Figura $($evidence.Number): $($evidence.Caption)" -Style 'Caption' -Alignment 'center' -SpaceAfter 30))

    if ($index -lt ($evidences.Count - 1)) {
        $body.Add($pageBreak)
    }

    $drawingId++
    $relationshipNumber++
    $mediaNumber++
}

$contentTypes = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Default Extension="png" ContentType="image/png"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
</Types>
'@

$rootRelationships = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
'@

$styles = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:docDefaults>
    <w:rPrDefault><w:rPr><w:rFonts w:ascii="Aptos" w:hAnsi="Aptos"/><w:sz w:val="21"/></w:rPr></w:rPrDefault>
  </w:docDefaults>
  <w:style w:type="paragraph" w:default="1" w:styleId="Normal"><w:name w:val="Normal"/><w:rPr><w:rFonts w:ascii="Aptos" w:hAnsi="Aptos"/><w:sz w:val="21"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Title"><w:name w:val="Title"/><w:basedOn w:val="Normal"/><w:rPr><w:b/><w:sz w:val="42"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Subtitle"><w:name w:val="Subtitle"/><w:basedOn w:val="Normal"/><w:rPr><w:sz w:val="28"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Heading1"><w:name w:val="Heading 1"/><w:basedOn w:val="Normal"/><w:next w:val="Normal"/><w:rPr><w:b/><w:sz w:val="30"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Caption"><w:name w:val="Caption"/><w:basedOn w:val="Normal"/><w:rPr><w:i/><w:color w:val="555555"/><w:sz w:val="18"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="ListBullet"><w:name w:val="List Bullet"/><w:basedOn w:val="Normal"/><w:pPr><w:ind w:left="360" w:hanging="180"/></w:pPr></w:style>
</w:styles>
'@

$relationshipXml = [System.Text.StringBuilder]::new()
[void]$relationshipXml.Append('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
[void]$relationshipXml.Append('<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">')
[void]$relationshipXml.Append('<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>')
foreach ($entry in $imageEntries) {
    [void]$relationshipXml.Append("<Relationship Id=`"$($entry.RelationshipId)`" Type=`"http://schemas.openxmlformats.org/officeDocument/2006/relationships/image`" Target=`"media/$($entry.MediaName)`"/>")
}
[void]$relationshipXml.Append('</Relationships>')

$document = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture">
  <w:body>
    $($body -join "`n")
    <w:sectPr>
      <w:pgSz w:w="11906" w:h="16838"/>
      <w:pgMar w:top="720" w:right="720" w:bottom="720" w:left="720" w:header="360" w:footer="360" w:gutter="0"/>
    </w:sectPr>
  </w:body>
</w:document>
"@

if (Test-Path -LiteralPath $outputPath) {
    Remove-Item -LiteralPath $outputPath -Force
}

$archive = [System.IO.Compression.ZipFile]::Open($outputPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    Add-ZipText -Archive $archive -EntryName '[Content_Types].xml' -Content $contentTypes
    Add-ZipText -Archive $archive -EntryName '_rels/.rels' -Content $rootRelationships
    Add-ZipText -Archive $archive -EntryName 'word/document.xml' -Content $document
    Add-ZipText -Archive $archive -EntryName 'word/styles.xml' -Content $styles
    Add-ZipText -Archive $archive -EntryName 'word/_rels/document.xml.rels' -Content $relationshipXml.ToString()
    foreach ($entry in $imageEntries) {
        Add-ZipFile -Archive $archive -EntryName "word/media/$($entry.MediaName)" -SourcePath $entry.SourcePath
    }
}
finally {
    $archive.Dispose()
}

Write-Output "Documento criado: $outputPath"
