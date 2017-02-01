#!/bin/bash

#Assumption: Language is en
#Assumption: 24 frames per second for "EditRate". I don't really know what this field is though
#Assumes that you want an Arial font (same as the one that's in the repository). I think that's reasonable

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
    echo "Input parameters are " \
         "1. Title" \
         "2. Annotation Text" \
         "3. Reel Number" >&2
    exit 1
fi

TITLE=$1
ANNOTATION_TEXT=$2
REEL_NUMBER=$3

echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<dcst:SubtitleReel xmlns:dcst="http://www.smpte-ra.org/schemas/428-7/2007/DCST">'
echo '<Id>'`uuidgen`'</Id>'
echo '<ContentTitleText>'$TITLE'</ContentTitleText>'
echo '<AnnotationText>'$ANNOTATION_TEXT'</AnnotationText>'
echo '<IssueDate>'`date +%Y-%m-%dT%H:%M:%S.000-00:00`'</IssueDate>'
echo '<ReelNumber>'$REEL_NUMBER'</ReelNumber>'
echo '<Language>en</Language>' #Assumption
echo '<EditRate>24 1</EditRate>' #Assumption. Don't understand what this is
echo '<dcst:TimeCodeRate>24</dcst:TimeCodeRate>' #Don't understand what this is either
echo '<StartTime>00:00:00:00</StartTime>'
#echo '<LoadFont ID="Arial">urn:uuid:3dec6dc0-39d0-498d-97d0-928d2eb78391</LoadFont>'
echo '<SubtitleList>'
#echo -e '\t<Font ID="Arial" Color="FFFFFFFF" Weight="normal" Size="40">'
#Write a single empty subtitle out at 00:00:00 for SMPTE needs
echo -e '\t\t<Subtitle SpotNumber="0" TimeIn="00:00:00:00" TimeOut="00:00:00:00">'
echo -e '\t\t\t<Text Valign="bottom" Vposition="10.00"></Text>'
echo -e '\t\t</Subtitle>'
#Start processing incoming subtitles
while read SPOT_NUMBER
do
    #Read the SRT format
    read IN_TIME ARROW OUT_TIME
    IN_TIME_CONVERTED=${IN_TIME/,???/:00}
    OUT_TIME_CONVERTED=${OUT_TIME/,???/:00}
    read NEXT_LINE
    while [ ! -z "$NEXT_LINE" ]
    do
        SUBTITLES="$SUBTITLES $NEXT_LINE"
        read NEXT_LINE
    done

    #Now print out the information
    echo -e '\t\t<Subtitle SpotNumber="'$SPOT_NUMBER'" TimeIn="'$IN_TIME_CONVERTED'" TimeOut="'$OUT_TIME_CONVERTED'">'
    echo -e '\t\t\t<Text Valign="bottom" Vposition="10.00">'$SUBTITLES'</Text>'
    echo -e '\t\t</Subtitle>'
    SUBTITLES=
done
#echo -e '\t</Font>'
echo '</SubtitleList>'
echo '</dcst:SubtitleReel>'
