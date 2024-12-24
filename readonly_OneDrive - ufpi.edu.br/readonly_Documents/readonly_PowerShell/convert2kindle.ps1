# Unalias 'gs' if it exists
if (Get-Alias gs -ErrorAction SilentlyContinue) {
    Remove-Item Alias:gs
}

# Check if the correct number of arguments are passed
if ($args.Count -ne 2) {
    Write-Host "Usage: ConvertPDFToKindle.ps1 input.pdf output.pdf"
    exit 1
}

# Assign arguments to variables
$InputFile = $args[0]
$OutputFile = $args[1]

# Number of rendering threads to use
$NumThreads = 8

# Get the number of pages in the input PDF
$NumPages = (pdfinfo $InputFile | Select-String "Pages:" | ForEach-Object { $_ -replace "Pages:\s+", "" }).Trim()

# Define pages per chunk (adjust as needed)
$PagesPerChunk = 100

# Calculate the number of chunks
$NumChunks = [math]::Ceiling($NumPages / $PagesPerChunk)

# Process each chunk in parallel
for ($chunk = 0; $chunk -lt $NumChunks; $chunk++) {
    $StartPage = ($chunk * $PagesPerChunk) + 1
    $EndPage = [math]::Min($StartPage + $PagesPerChunk - 1, $NumPages)

    Start-Process -NoNewWindow -FilePath "gs" -ArgumentList @(
        "-sDEVICE=pdfwrite",
        "-dPDFSETTINGS=/ebook",
        "-dNumRenderingThreads=$NumThreads",
        "-sColorConversionStrategy=Gray",
        "-dProcessColorModel=/DeviceGray",
        "-dNOPAUSE",
        "-dBATCH",
        "-sOutputFile=chunk_$chunk.pdf",
        "-dFirstPage=$StartPage",
        "-dLastPage=$EndPage",
        $InputFile
    ) -Wait
}

# Expand wildcard to get all chunk files
$chunkFiles = Get-ChildItem -Filter "chunk_*.pdf" | ForEach-Object { $_.FullName }

if ($chunkFiles.Count -eq 0) {
    Write-Host "Error: No chunk files were generated!"
    exit 1
}

# Merge all the output chunks into one PDF by expanding the array
$gsArgs = @(
    "-q",
    "-dNOPAUSE",
    "-dBATCH",
    "-sDEVICE=pdfwrite",
    "-sOutputFile=$OutputFile"
) + $chunkFiles

Start-Process -NoNewWindow -FilePath "gs" -ArgumentList $gsArgs -Wait

# Clean up intermediate files
Remove-Item "chunk_*.pdf"

