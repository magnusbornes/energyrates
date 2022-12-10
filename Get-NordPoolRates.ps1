<#
    .SYNOPSIS
    Retrives hourly energy rates from NordPool.
    Returns 24 hours of rates.

    .DESCRIPTION
    Script to get hourly energy rates from NordPool.

    Written by: Magnus Børnes
    https://github.com/magnusbornes

        DISCLAIMER:

    NordPool's terms of service states the following:
    "Nord Pool does not permit automatic extraction of data or other usage that reduces the performance of the website. Any such extraction or usage will lead to the user being blocked from the website without further notice."
    Read the Terms and Conditions here: https://www.nordpoolgroup.com/en/About-us/Terms-and-conditions-for-use/

    Use at your own risk.

    .PARAMETER Date
    Specifies the date to be requested.
    Function returns 24 hours.
    You can use (Get-Date).AddDays(1) to get tomorrow's rates.
    Day ahead rates are usually published around 13:15 (1:15 PM).
    All hours in output are in CET/CEST (+1:00/+2:00)

    .PARAMETER Currency
    Specifies the Currency.
    Allowed Currencies includes EUR, DKK, SEK and NOK.
    Note: EUR must be used to retrive rates from areas AT, BE, DE-LU, FR and NL.

    .PARAMETER IncludeStats
    Switch parameter
    Use to include values for Max, Min, Peak (08:00-20:00), Offpeak 1 (00:00-08:00) and Offpeak 2 (20:00-00:00).

    .PARAMETER IncludeStatsOnly
    Switch parameter
    Use to include stats values for Max, Min, Peak (08:00-20:00), Offpeak 1 (00:00-08:00) and Offpeak 2 (20:00-00:00).
    And exclude hourly rates.

    .PARAMETER kWh
    Converts Output from MWh til kWh.

    .INPUTS
    None. You cannot pipe objects to this function

    .OUTPUTS
    PSCustomObject. 
    Script returns a object with 24 objects (23/25 if daylight savings time removed/added).
    All hours in output are in CET/CEST (+1:00/+2:00)

    .EXAMPLE
    ./Get-NordPoolRates.ps1 -Date (Get-Date).AddDays(1) -Currency NOK -kWh
    
    StartTime              EndTime                Unit    Name        SYS     SE1     SE2 AT BE DE-LU FR NL
    ---------              -------                ----    ----        ---     ---     --- -- -- ----- -- --
    12/10/2022 12:00:00 AM 12/10/2022 1:00:00 AM  NOK/kWh 00 - 01  3.1445 2.69017 2.69017 -  -  -     -  -
    12/10/2022 1:00:00 AM  12/10/2022 2:00:00 AM  NOK/kWh 01 - 02 3.03469 2.63431 2.63431 -  -  -     -  -
    12/10/2022 2:00:00 AM  12/10/2022 3:00:00 AM  NOK/kWh 02 - 03 2.89852 2.62715 2.62715 -  -  -     -  -
    12/10/2022 3:00:00 AM  12/10/2022 4:00:00 AM  NOK/kWh 03 - 04 2.83582 2.50289 2.50289 -  -  -     -  -
    [...]

    .EXAMPLE
    ./Get-NordPoolRates.ps1 -Date (Get-Date).AddDays(1) -Currency NOK -IncludeStatsOnly -kWh
        
    StartTime              EndTime                Unit    Name           SYS     SE1     SE2 AT BE DE-LU FR NL
    ---------              -------                ----    ----           ---     ---     --- -- -- ----- -- --
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM NOK/kWh Min        2.83266 2.21244 2.21244 -  -  -     -  -
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM NOK/kWh Max        3.85746 2.77764 2.77764 -  -  -     -  -
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM NOK/kWh Average    3.34953   2.486   2.486 -  -  -     -  -
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM NOK/kWh Peak       3.70201  2.4058  2.4058 -  -  -     -  -
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM NOK/kWh Off-peak 1 2.93102 2.52889 2.52889 -  -  -     -  -
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM NOK/kWh Off-peak 2 3.12909 2.64079 2.64079 -  -  -     -  -
    [...]

    .EXAMPLE
    ./Get-NordPoolRates.ps1 -Date 2022-12-10 -Currency EUR -IncludeStats
    
    StartTime              EndTime                Unit    Name       SYS    SE1    SE2    AT     BE     DE-LU  FR     NL
    ---------              -------                ----    ----       ---    ---    ---    --     --     -----  --     --
    12/10/2022 12:00:00 AM 12/10/2022 1:00:00 AM  EUR/MWh 00 - 01    298.37 255.26 255.26 307.89 328.80 312.48 336.74 312.80
    [...]
    12/10/2022 11:00:00 PM 12/11/2022 12:00:00 AM EUR/MWh 23 - 00    275.03 251.90 251.90 277.87 328.76 288.27 354.92 294.71
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM EUR/MWh Min        268.78 209.93 209.93 277.87 290.54 284.90 293.35 284.90
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM EUR/MWh Max        366.02 263.56 263.56 449.92 449.92 449.92 451.10 449.92
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM EUR/MWh Average    317.82 235.89 235.89 352.31 364.38 354.64 370.20 355.66
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM EUR/MWh Peak       351.27 228.28 228.28 404.27 406.17 404.41 407.27 404.66
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM EUR/MWh Off-peak 1 278.11 239.96 239.96 292.76 311.87 297.19 320.02 298.09
    12/10/2022 12:00:00 AM 12/11/2022 12:00:00 AM EUR/MWh Off-peak 2 296.91 250.58 250.58 315.51 344.05 320.24 359.38 323.80

    .LINK
    NordPool's Online version: https://www.nordpoolgroup.com/en/Market-data1/Dayahead/Area-Rates/ALL1/Hourly/?view=table
    
    .LINK
    GitHub: https://github.com/magnusbornes

    .LINK
    NordPool Terms and Conditions: https://www.nordpoolgroup.com/en/About-us/Terms-and-conditions-for-use/
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)][datetime]$Date,
    [Parameter(Mandatory)][string]$Currency,    # To get rates from areas AT, BE, DE-LU, FR and NL, "EUR" must be used...
    [Parameter()][switch]$IncludeStats,         # Output will include values for Max, Min, Peak (08:00-20:00), Offpeak 1 (00-08) and Offpeak 2 (20-00).
    [Parameter()][switch]$IncludeStatsOnly,     # Include only the values mentioned above.
    [Parameter()][switch]$kWh                   # Convert MWh til kWh.
)

# Validate Currency input.
if ("EUR DKK SEK NOK" -notmatch $Currency) {Write-Error "Unknown Currency ""$Currency"". Allowed currencies: EUR, DKK, NOK and SEK"; Break}

# Define defaults.
$MarketDataPage = 10 # Default page size for the "All"-tab on the NordPool Market data website is 10 as of 2022-12-09.
$ExpectedRowCount = 30

$dateString = Get-Date $date -Format "dd-MM-yyyy"

# REST request to NordPool.
$uri = [System.Web.HttpUtility]::UrlDecode("https://www.nordpoolgroup.com/api/marketdata/page/$MarketDataPage%3fcurrency=$currency&endDate=$dateString")
Write-Verbose "GET: ""$Uri"""
$response = Invoke-WebRequest -Uri $uri

# Validate response and date.
if($response.StatusDescription -ne "OK"){Write-Error "Request failed."; Break}
$response = ($response.Content | ConvertFrom-Json)
if((Get-Date $($response.data.DataStartdate) -Format "dd-MM-yyyy") -ne $dateString){Write-Error "No match for requested date. Day ahead rates normally updates around 1:15 PM."; Break}

# Check row count and if daylight saving time was added/removed.
$rowCount = $response.data.rows.count 
switch ($rowCount) {
    29 {Write-Warning "Row count is 29, and indicates that daylight savings time was removed (-1 hr)."}
    30 {Write-Verbose "Row count validated as 30."}
    31 {Write-Warning "Row count is 31, and indicates that daylight savings time was added (+1 hr)."}
    Default {Write-Error "Row count is $([int]$response.data.rows.count), but expected count was $ExpectedRowCount rows."; Break}
}

# Define selection – include or exclude stats.
$selection = $response.data.rows[0..($rowCount-7)]
if ($IncludeStats) {
    $selection = $response.data.rows
}
if ($IncludeStatsOnly) {
    $selection = $response.data.rows[($rowCount-6)..($rowCount-1)]
}

# Rename Unit to kWh.
$unit = $response.data.Units[0]
if ($kWh) {
    $unit = $unit.Replace('MWh','kWh')
}

# Start building table. 1 row per hour, 1 column per rate area + startDate, endDate and currency.
$rates = foreach($row in $selection){
    $object = [PSCustomObject]@{
        StartTime = $row.StartTime
        EndTime = $row.EndTime
        Unit = $unit
        Name = $row.Name.Replace('&nbsp;',' ')
    }
    foreach($column in $row.columns){
        $value = ($column.Value).replace(',','.').replace(' ','')
        # Convert to kWh from MHw
        if ($kWh) {
            try {
                $value = $value/1000
            }catch{}
        }
        Add-Member -InputObject $object -MemberType NoteProperty -Name $($column.Name) -Value $value
        
        # Counters
        $valueCount += 1
        if ($value -eq "-") {
            $noDataCount += 1
        }
    }
    # Break if all values were Null.
    if ($valueCount -eq $noDataCount) {
        Write-Error "No data found. Day ahead rates are normally published around 13:00 (1:00 PM)"
        Break
    }
    $object
}

#Return object
$rates