function Get-WebStatus ($URL) {
    $result = $null
    try { 
        $request = Invoke-WebRequest -UseBasicParsing -Uri $url
    } catch [System.Net.WebException] {
        $exception = $_.Exception
        $exception_info = @{
            Status = [System.Net.WebExceptionStatus].GetEnumName($exception.Status)
            ProtocolStatus = @{
                Code=$exception.Response.StatusCode.value__
                Description=$exception.Response.StatusDescription
            }
            Message = $exception.Message
        }
        $result = '['+$exception_info.ProtocolStatus.Code+'] '+$exception_info.Status+'/'+$exception_info.ProtocolStatus.Description+': '+$exception_info.Message
    }
    if($null -eq $result){
        $request_info = @{
            Status = [System.Net.WebExceptionStatus].GetEnumName(0)
            ProtocolStatus = @{
                Code=$request.StatusCode
                Description=$request.StatusDescription
            }
            Message=$request.StatusDescription
        }
        $result = '['+$request_info.ProtocolStatus.Code+'] '+$request_info.Status+'/'+$request_info.ProtocolStatus.Description+': '+$request_info.Message
    }
    return $result
}

Get-WebStatus -URL 'https://google.de'
