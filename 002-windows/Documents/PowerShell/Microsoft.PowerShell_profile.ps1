& ([ScriptBlock]::Create((oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\tokyonight_storm.omp.json" --print) -join "`n"))

# scoop search hook
Invoke-Expression (&scoop-search --hook)

# escape windows terminal starting directory prompt
# [ref](https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory)
function prompt {
  $loc = $executionContext.SessionState.Path.CurrentLocation;

  $out = "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
  if ($loc.Provider.Name -eq "FileSystem") {
    $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
  }
  return $out
}


# powershell proxy {{{1
# 调用方法，注意使用 dot-sourcing, 否则函数不会导入当前会话
# . .\proxy.ps1
# proxy_on
# proxy_status
# proxy_off
#
# 其中 gemini 可以使用官方的Proxy参数【gemini --proxy http://127.0.0.1:7893】
function proxy_on {
    $proxy = "http://127.0.0.1:7893"
    $noProxy = "localhost,127.0.0.1,::1"

    $env:HTTP_PROXY = $proxy
    $env:HTTPS_PROXY = $proxy
    $env:ALL_PROXY = $proxy
    $env:NO_PROXY = $noProxy

    Write-Host "[proxy_on] Proxy enabled: $proxy"
    Write-Host "HTTP_PROXY  = $env:HTTP_PROXY"
    Write-Host "HTTPS_PROXY = $env:HTTPS_PROXY"
    Write-Host "ALL_PROXY   = $env:ALL_PROXY"
    Write-Host "NO_PROXY    = $env:NO_PROXY"
}

function proxy_off {
    Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
    Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue
    Remove-Item Env:ALL_PROXY -ErrorAction SilentlyContinue
    Remove-Item Env:NO_PROXY -ErrorAction SilentlyContinue

    Write-Host "[proxy_off] Proxy disabled."
}

function proxy_status {
    Write-Host "HTTP_PROXY  = $env:HTTP_PROXY"
    Write-Host "HTTPS_PROXY = $env:HTTPS_PROXY"
    Write-Host "ALL_PROXY   = $env:ALL_PROXY"
    Write-Host "NO_PROXY    = $env:NO_PROXY"
}
# }}}
