# IT HELP DESK TOOLKIT
# MSSA PowerShell Project
# ==========================================

# Function 1: Get Computer Information
function Get-SystemInfo {
    Write-Host "`n===== COMPUTER INFORMATION =====" -ForegroundColor Cyan

    Get-ComputerInfo |
        Select-Object CsName, WindowsProductName, OsArchitecture,
                      CsTotalPhysicalMemory |
        Format-List
}

# Function 2: Test Internet Connection
function Test-Internet {
    Write-Host "`n===== INTERNET CONNECTION =====" -ForegroundColor Cyan

    Write-Host "Testing connection to google.com..."

    if (Test-Connection -ComputerName "google.com" -Count 2 -Quiet) {
        Write-Host "Connection successful!" -ForegroundColor Green
    }
    else {
        Write-Host "Connection test failed." -ForegroundColor Red
        Write-Host "The host may be unreachable or blocking ping."
    }
}

# Function 3: Check Disk Space
function Get-DiskSpace {
    Write-Host "`n===== DISK SPACE =====" -ForegroundColor Cyan

    Get-PSDrive -PSProvider FileSystem |
        Select-Object Name,
            @{Name="UsedGB";Expression={[math]::Round($_.Used / 1GB, 2)}},
            @{Name="FreeGB";Expression={[math]::Round($_.Free / 1GB, 2)}} |
        Format-Table -AutoSize
}

# Function 4: Show Running Services
function Get-RunningServices {
    Write-Host "`n===== RUNNING SERVICES =====" -ForegroundColor Cyan

    Get-Service |
        Where-Object {$_.Status -eq "Running"} |
        Select-Object -First 10 Name, DisplayName, Status |
        Format-Table -AutoSize
}

# Main Menu
do {
    Clear-Host

    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "       IT HELP DESK TOOLKIT       " -ForegroundColor Cyan
    Write-Host "=================================" -ForegroundColor Cyan

    Write-Host "1. View Computer Information"
    Write-Host "2. Test Internet Connection"
    Write-Host "3. Check Disk Space"
    Write-Host "4. View Running Services"
    Write-Host "5. Exit"

    $choice = Read-Host "`nEnter your choice (1-5)"

    switch ($choice) {
        "1" { Get-SystemInfo }
        "2" { Test-Internet }
        "3" { Get-DiskSpace }
        "4" { Get-RunningServices }
        "5" { Write-Host "`nGoodbye!" -ForegroundColor Green }
        default {
            Write-Host "`nInvalid selection. Try again." -ForegroundColor Red
        }
    }

    if ($choice -ne "5") {
        Read-Host "`nPress Enter to return to the menu"
    }

} while ($choice -ne "5")
