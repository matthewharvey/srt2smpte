This is an incredibly naive script to convert from srt (matroska) style subtitles to SMPTE subtitles used in digital cinema packages. This script is extremely static, and doesn't even begin to explore the more advanced features of either the SMPTE subtitle standard or, I suspect, the srt subtitle format, but it worked for me and here's hoping it will be useful for others as well.

Example invocation:
./srt2smpte.sh "Title" File1.mkv 1 > subtitles_Title.xml
