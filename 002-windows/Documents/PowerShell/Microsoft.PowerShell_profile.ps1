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
