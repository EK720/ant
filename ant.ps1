#program by Fuzion
#This program simulates "Langton's Ant"
#parameters are "-Delay", delay between moves in milliseconds, and "-Facing", the initial direction the ant is facing.

#created: 2020-07-15
#edited: 2020-07-15

param(
    [Parameter(Position=1)]
    [int]$Delay=125,
    [Parameter(Position=2)]
    [alias("Facing","Direction")]
    [int]$InitialDirection=0
)

function fieldReplace {
    param(
        [Parameter(Position=1)]
        [int]$x,
        [Parameter(Position=2)]
        [int]$y,
        [Parameter(Position=3)]
        [string]$char
    )
    $field[$y]=$field[$y].remove($x,1).insert($x,$char)
}

function ClearLines {
    Param (

	    [Parameter(Position=1)]
	    [int32]$Count=1

    )

    $CurrentLine  = $Host.UI.RawUI.CursorPosition.Y
    $ConsoleWidth = $Host.UI.RawUI.BufferSize.Width

    $i = 1
    for ($i; $i -le $Count; $i++) {
	
	    [Console]::SetCursorPosition(0,($CurrentLine - $i))
	    [Console]::Write("{0,-$ConsoleWidth}" -f " ")

    }

    [Console]::SetCursorPosition(0,($CurrentLine - $Count))
}

function moveAnt {
    switch($ant.facing%4){
        0{
            if($field[$ant.posY][$ant.posX] -eq $aChars[0]){
                fieldReplace $ant.posX $ant.posY $fChars[1]
            } else {
                fieldReplace $ant.posX $ant.posY $fChars[0]
            }
            if($field[$ant.posY-1] -eq $null){$ant.posY--;return}
            if($field[$ant.posY-1][$ant.posX] -eq $fChars[0]){
                fieldReplace $ant.posX ($ant.posY-1) $aChars[0]
                $ant.facing=1
            } else {
                fieldReplace $ant.posX ($ant.posY-1) $aChars[1]
                $ant.facing=3
            }
            $ant.posY--
        }
        1{
            if($field[$ant.posY][$ant.posX] -eq $aChars[0]){
                fieldReplace $ant.posX $ant.posY $fChars[1]
            } else {
                fieldReplace $ant.posX $ant.posY $fChars[0]
            }
            if($field[$ant.posY][$ant.posX+1] -eq $null){$ant.posX++;return}
            if($field[$ant.posY][$ant.posX+1] -eq $fChars[0]){
                fieldReplace ($ant.posX+1) $ant.posY $aChars[0]
                $ant.facing=2
            } else {
                fieldReplace ($ant.posX+1) $ant.posY $aChars[1]
                $ant.facing=0
            }
            $ant.posX++
        }
        2{
            if($field[$ant.posY][$ant.posX] -eq $aChars[0]){
                fieldReplace $ant.posX $ant.posY $fChars[1]
            } else {
                fieldReplace $ant.posX $ant.posY $fChars[0]
            }
            if($field[$ant.posY+1] -eq $null){$ant.posY++;return}
            if($field[$ant.posY+1][$ant.posX] -eq $fChars[0]){
                fieldReplace $ant.posX ($ant.posY+1) $aChars[0]
                $ant.facing=3
            } else {
                fieldReplace $ant.posX ($ant.posY+1) $aChars[1]
                $ant.facing=1
            }
            $ant.posY++
        }
        3{
            if($field[$ant.posY][$ant.posX] -eq $aChars[0]){
                fieldReplace $ant.posX $ant.posY $fChars[1]
            } else {
                fieldReplace $ant.posX $ant.posY $fChars[0]
            }
            if($field[$ant.posY][$ant.posX-1] -eq $null){$ant.posX--;return}
            if($field[$ant.posY][$ant.posX-1] -eq $fChars[0]){
                fieldReplace ($ant.posX-1) $ant.posY $aChars[0]
                $ant.facing=0
            } else {
                fieldReplace ($ant.posX-1) $ant.posY $aChars[1]
                $ant.facing=2
            }
            $ant.posX--
        }
    }
}

function updateDisplay {
    ClearLines ($height-$ant.posY)
    Write-Host $field[($ant.posY-1)..$field.Count] -NoNewline -Separator "`n"
}


$width=$host.ui.rawui.windowSize.width
$height=$host.ui.rawui.windowSize.height
$centerX=[int]($width/2)
$centerY=[int]($height/2)
$ant=@{posX=$centerX-1;posY=$centerY-1;facing=$InitialDirection}
$fChars="█ "
$aChars="◙◦"

$blankLine=""
for($i=0;$i -lt $width;$i++){
    $blankLine+=$fChars[0]
}
$field=@($blankLine)
for($i=1;$i -lt $height;$i++){
    $field+=$blankLine
}

fieldReplace $ant.posX $ant.posY $aChars[0]
Write-Host $field -NoNewline -Separator "`n"
Start-Sleep -Milliseconds $Delay
while($ant.posX -ge 0 -and $ant.posX -lt $width -and $ant.posY -ge 0 -and $ant.posY -lt $height){
    moveAnt
    updateDisplay
    Start-Sleep -Milliseconds $Delay
}