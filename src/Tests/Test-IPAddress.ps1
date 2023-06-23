# Returns true, when the given string is valid IP-Address, otherwise returns false.
function Test-IPAddress($IP){
	if($null -eq $IP){
		$Result = $false
	} else {
		$Result = [bool]($IP -as [ipaddress])
	}
	return $Result
}
