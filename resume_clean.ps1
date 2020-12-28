# Specify a directory to check (P)
# Within that directory, pecify if we check only it, or its children too (P)
# search for any files with resume in them
# make a copy into the uzair resume folder

# if the files exists, dont replace it

#source: C:\Users\Idrees\Downloads
# C:\Users\Idrees\Desktop\ResumesUzair
#dest: C:\Users\Idrees\Desktop\Uzair_Resume

Param(
    
    [Parameter(Mandatory = $true)][String]$sourceDir,
    [Parameter(Mandatory = $true)][String]$targetDir
    #[Parameter(Mandatory = $true)][ValidateSet(0,1)][int]$mode

)

    
    

    Copy-Item -Path $sourceDir\*resume*.pdf -Destination $targetDir

    
    #Get-ChildItem -Path $sourceDir\* -Include *resume*.pdf | % {
    
    #Copy-Item -Destination $_.FullName -Force
    

    
    #Copy-Item -Path $sourceDir\*resume*.pdf -Destination $targetDir -Recurse
