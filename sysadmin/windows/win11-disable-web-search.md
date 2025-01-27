# Disable Online / Web Search in Search Bar Results

By default you may have experienced the Windows 11 search box lagging or almost freezing the system as it searches your input online. The best option is to disable web searching for the Search Box. To do this you simply -

1) Open regedit
2) Navigate to Computer\HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows
3) Right click on "Windows", Select New, Select Key. Name it Explorer
4) Right click on Explorer, Select New, Select DWORD (32-bit), Name it DisableSearchBoxSuggestions
5) Double click DisableSearchBoxSuggestions, change the value data to 1, click OK
6) Restart the PC

This should greatly speed up your searches utilizing the taskbar Search Box.
