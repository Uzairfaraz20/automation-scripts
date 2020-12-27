##### server_specs.ps1 #####
# Lists a few server specifications such as drive space #
# cores, RAM, and a server status check                 #
# Assumes C, D, E drives currently#



Write-Host "`n"
Write-Host "Server Name:" $env:COMPUTERNAME -ForegroundColor Magenta


Function Calculate_Drive_Space($drive){
    
    Write-Host "--- $drive Drive Space Check ---" -ForegroundColor Yellow

    $path = $drive + ":"
    
    if((Test-Path $path) -eq $true){
    
        $driveUsed = (Get-PSDrive $drive | Select-Object -ExpandProperty Used) 
        $driveFree = (Get-PSDrive $drive | Select-Object -ExpandProperty free)

        $usedTemp = [math]::Round($driveUsed/ 1gb,2)
        $freeTemp = [math]::Round($driveFree / 1gb,2)

        $totalSpace = [math]::Round(($driveUsed + $driveFree)/1gb,2)

        Write-Host "Free:      ${freeTemp}gb - $drive drive" -ForegroundColor Green
        Write-Host "Used:      ${usedTemp}gb - $drive drive" -ForegroundColor Green
        Write-Host "Remaining: ${usedTemp}gb / ${totalSpace}gb`n" -ForegroundColor Green

        $percent = $usedTemp / $totalSpace

        if($percent -ge 0.90){
            Write-Host "Warning: 90%+ Used`n" -ForegroundColor Red
        } elseif($percent -ge 0.75){
            Write-Host "Warning: 75%+ Used`n" -ForegroundColor Red
        } elseif($percent -ge 0.50){
            Write-Host "Warning: 50%+ Used`n" -ForegroundColor Red
        }


    
    } else{
    
        Write-Host "Waring: $drive Drive not found `n" -ForegroundColor Red
    }
}

Function Calculate_RAM(){
    $ram = ((Get-CimInstance -ClassName 'Cim_PhysicalMemory' | Measure-Object -Property Capacity -Sum).Sum / 1gb)
    
    Write-Host "--- RAM Space Check ---" -ForegroundColor Yellow
    Write-Host "RAM Space: $ram `n" -ForegroundColor Green

}

Function Calculate_VCPU(){
    
     Write-Host "---vCPU Cores Check---" -ForegroundColor Yellow
    
    $temp = (Get-CimInstance win32_processor | Measure-Object -Property NumberOfCores -Sum | Select-Object -ExpandProperty Sum)
    $cores = [math]::Round($temp)

    Write-Host "vCPUs: $cores `n" -ForegroundColor Green
    


}

Function GetMachineInfo(){

   $info = Get-CimInstance win32_processor | Select-Object -ExpandProperty Name
   $class =  Get-CimInstance win32_processor | Select-Object -ExpandProperty SystemCreationClassName

   Write-Host "Machine Name: $info" -ForegroundColor Magenta
   Write-Host "Creation Class: $class `n" -ForegroundColor Magenta


}

Function StatusCheck(){
    
    Write-Host "---Status Check---" -ForegroundColor Yellow
    
    $status = Get-CimInstance win32_processor | Select-Object -ExpandProperty Status

    if($status -eq "OK"){
        Write-Host "Server status: $status `n" -ForegroundColor Green
    } else{
    
        Write-Host "Error: Server status: $status `n" -ForegroundColor Red
    
    }

}

###########################################################################



Function Check_Specs(){
    
    # Server info
    GetMachineInfo

    #memory calcs
    Calculate_VCPU
    Calculate_RAM
    
    #drive memory calcs
    Calculate_Drive_Space("C")
    Calculate_Drive_Space("D")
    Calculate_Drive_Space("E")

    #server status check
    StatusCheck
      
}

Function Main(){
    
    #disable function verbose logging
    $global:VerbosePreference = 'SilentlyContinue'; 
    
    Check_Specs

}

Main