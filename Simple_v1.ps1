$subnet = "192.168.15"
$ports = 80,443,8443,444,8080,3389,389,22,21,5900,5060
$timeout = 200

$results = @()

for ($i=1; $i -le 254; $i++) {

    $ip = "$subnet.$i"

    foreach ($port in $ports) {

        $tcp = New-Object System.Net.Sockets.TcpClient
        $connection = $tcp.BeginConnect($ip,$port,$null,$null)

        $wait = $connection.AsyncWaitHandle.WaitOne($timeout,$false)

        if ($wait -and $tcp.Connected) {
            $tcp.EndConnect($connection)

            $results += [PSCustomObject]@{
                IP   = $ip
                Port = $port
                Status = "Open"
            }

            Write-Host "$ip : $port OPEN" -ForegroundColor Green
        }

        $tcp.Close()
    }
}

$results | Format-Table
