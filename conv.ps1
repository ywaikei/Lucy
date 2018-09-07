# Converter
$convApp = "D:\BRM_Studio\conv\Xml2BinEx.exe"

# Workspace Home
$wsHome = "D:\BRM_Studio\workspace"

# Project Name
$prjName = "b2bgerp"
# Project Home
$prjHome = "\B2B_BRM\web.war\ux"

# Binary Path
$binPath = $wsHome + $prjHome + "\" + $prjName
# Source Path
$srcPath = $binPath + "_src"

# File List
$listFile = "convFileList.txt"

# Working Directory
$workPath = "D:\BRM_Studio\conv"

# 작업폴더 정리
Remove-Item -Path ($workPath + "\src\*") -Recurse
Remove-Item -Path ($workPath + "\bin\*") -Recurse

# 작업대상파일 목록
$binFileArr = New-Object System.Collections.ArrayList
$workBinFileArr = New-Object System.Collections.ArrayList
$fileList = Get-Content -Path ($workPath + "\" + $listFile)
$cnt = $fileList.Length
for ( $i=0; $i -lt $cnt; $i++ ) {

    # 소스파일명
    $fileName = $fileList[$i].Replace("/","\")

    # 처리대상 제외 - 주석처리
    if ( $fileName.StartsWith("#") )  {
#        Write-Host "remark"
    }
    # 소스파일을 작업폴더에 복사
    else {
        $srcFile = $wsHome + $fileName
        $shortName = $srcFile.Replace($srcPath, "")
        $binFile = $binPath + $shortName
        $binFileArr.Add($binFile) | Out-Null

        $workSrcFile = $workPath + "\src" + $shortName
        $workBinFile = $workPath + "\bin" + $shortName
        $workBinFileArr.Add($workBinFile) | Out-Null

        $workDir = Split-Path -Path $workSrcFile
        New-Item -Path $workDir -ItemType Directory -Force | Out-Null
        Copy-Item $srcFile $workSrcFile -Force | Out-Null
    }
}

# 바이너리 변환
#Start-Process "Xml2BinEx.exe" -ArgumentList "D:\BRM_Studio\conv\src D:\BRM_Studio\conv\bin" -Wait
./Xml2BinEx.exe $workPath\src $workPath\bin

# 바이너리 파일 배포
$cnt = $workBinFileArr.Count;
for ( $i=0; $i -lt $cnt; $i++ ) {
    # 변환된 바이너리 파일을 배포경로에 복사
    $workDir = Split-Path -Path $binFileArr[$i]
    New-Item -Path $workDir -ItemType Directory -Force | Out-Null
    Copy-Item $workBinFileArr[$i] $binFileArr[$i] -Force | Out-Null
}

# 작업폴더 정리
Remove-Item -Path ($workPath + "\src\*") -Recurse
Remove-Item -Path ($workPath + "\bin\*") -Recurse
