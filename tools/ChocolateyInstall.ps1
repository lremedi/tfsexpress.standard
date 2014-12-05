try {
	$anySqlServer = (get-itemproperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server' -erroraction silentlycontinue).InstalledInstances.Count
	if ($anySqlServer -eq $null)
	{
		Write-Host "SQL Server is not installed and it's required"
		Return
	}

    Write-Host "Installing MS TFS Express"
	Install-ChocolateyPackage 'VisualStudioTFSExpress2013' 'exe' "/Quiet" 'http://download.microsoft.com/download/D/F/C/DFCAAA9B-7902-4445-A746-0EFD0E09AC2D/tfs_express.exe'
	
	Write-Host "Getting TFSConfig full path"
	$path = (Get-ChildItem -path $env:systemdrive\ -filter "tfsconfig.exe" -erroraction silentlycontinue  -recurse)[0].FullName

	Write-Host "Configuring TFS standard" do
	& $path unattend /configure /type:standard

	$iisVersion = (get-itemproperty HKLM:\SOFTWARE\Microsoft\InetStp\ -erroraction silentlycontinue | select MajorVersion).MajorVersion

	If($iisVersion -lt 6){
		Write-Host "IIS is not installed and it's required"
		Return
	}

    if ($lastExitCode -and ($lastExitCode -ne 0)) { throw "Install MS TFS Express failed." }    
} catch { 
    Write-ChocolateyFailure 'VisualStudioTFSExpress2012' "$($_.Exception.Message)"
}