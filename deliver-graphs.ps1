$FileName = 'test_script.py'
$Command = $PSScriptRoot+'\'+$FileName

Start-Process -FilePath $Command