do {
	[int]$xMenuChoiceA = 0
	while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 5 )
	{		Write-host "1. Connect to Azure Portal via Powershell"
			Write-host "2. Check Which region you wish to use ( some regions may not have the resources you require ! )" 
			Write-Host "3. Create ARM Resource Group in the region you have selected ( to group all your resources together )"
			Write-host "4. Create the virtual network for the resource group in task 3 ( best to use CIDR /16 so that this can be subnetted )"
			Write-host "5. Quit and Exit"
  			[Int]$xMenuChoiceA = read-host "Please enter an option 1 to 5..."
	}	

	Switch( $xMenuChoiceA ){
	
		1{Write-Host "Connecting to Azure Portal" -Foreground "yellow"
			
			$LoadedModules = Get-Module -ListAvailable -Name AzureRM
            if (!$LoadedModules -eq "AzureRM") {

            Write-Warning "The module needs to be installed .. "
            Write-Warning "Please answer 'Yes' to NuGet Provider"
            Write-Warning "Please answer 'Yes to All' for Untrusted repository"
            
            Install-module -name AzureRM
            Import-Module -Name AzureRM 
                                                }
            Login-AzureRmAccount

		 }

	
	
		2{Write-Host "Checking the regions available" -Foreground "yellow"

			((Get-AzureRmResourceProvider -ProviderNamespace "Microsoft.Network").ResourceTypes | `
            Where-Object {$_.ResourceTypeName -eq "virtualNetworks"}).Locations | sort	

            $Region = read-host "Enter the region you wish to use, e.g.Australia East .. please write as seen on screen"

				 
	     }
	
	
	
		3{Write-Host "Creating ARM Resource Group in the region you have selected checked in task number 2" -Foreground "yellow"
  
            $resourceGroupName = read-host "Enter the resource group name you wish to use, e.g. blueResourceGroup"
				
            $resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location $region -Verbose -Force
		 }




		4{Write-Host "Creating the virtual network for the resource group in task number 3" -Foreground "yellow"

				$NameNet = read-host "Enter the name you wish to give it, e.g. blueVNet"
                $NameNetIP = read-host "Enter the network address plus CIDR you wish to use, e.g. 172.16.0.0/16 "
		        $vNet = New-AzureRmVirtualNetwork `
                        -ResourceGroupName $resourceGroup.ResourceGroupName `
                        -Location $resourceGroup.Location `
                        -Name $NameNet `
                        -AddressPrefix $NameNetIP
		 }
	}
} while ( $xMenuChoiceA -ne 5 )
