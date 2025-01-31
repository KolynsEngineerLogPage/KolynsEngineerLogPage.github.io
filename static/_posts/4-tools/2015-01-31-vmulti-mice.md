---
author: Kolyn090
banner: 
categories: Showcase
custom_class: custom-page-content
date: 2025-01-31 12:00:00 -0500
layout: post
permalink: /vmulti-mice-showcase/
title: Programmatically controls a virtual mouse
---

**This article, completely original, is copyrighted by its author, me. Please do not reproduce it.**


**本文为原创作品，作者 Kolyn090 拥有其著作权，受法律保护。严禁复制、转载、仿冒或以任何形式使用。**


Category: Showcase


Platform: Windows


Prerequisite: Basic Python, Visual Studio


License: MIT License


[**[source code]**](https://github.com/Kolyn090/vmulti-mice.git)


---

This project should work on Windows 7 & above, 32-bit Python.
It's completely free and open-source.

<br>

## Introduction
Are you looking for a programmatically controllable [Mousemux](https://www.mousemux.com/)? Here might be a good place
to start! In this project I have included an example of [Python client code](python_client/mouse.py) that creates a
Mouse class and <u>click given position without moving the system cursor</u>. If you have the vmulti device correctly 
set up, you should be able to use it right away!


# Read This
The project (2025) is using a driver from 2010. Things are not tested and there is **unknown risk** for using.
Please don't put this for production use. The way I achieved virtual mice is also quite hacky! You can read more details
about that in the Python client code annotations.

## Installing the driver
Although this was instructed in [the original repo](https://github.com/djpnewton/vmulti.git), it can be quite difficult
if this is the first time you install a driver to your PC. 

# Step 1
Clone this repo.

# Step 2
Search "Windows Driver Kit 7.1.0" and download it to your PC.
After you installed it, the default location should be something like
`C:\WinDDK\7600.16385.1`. It's also fine if you use versions above it. There will be a slight difference, but I
will explain that later.

# Step 3
Build the project with
```commandline
build -wgc
```
You should see a new folder called `objfre_win7_amd64` under `\sys`.
Yours could be different.

# Step 4
If your PC system is 64-bit, you will need to sign the driver, or
you can enable Test Mode. Here I will teach you how to sign the driver.

1. Locate "Inf2Cat.exe" under `C:\WinDDK\7600.16385.1\`, copy&paste that to
`sys\objfre_win7_amd64\amd64`. 
2. Locate "SignTool.exe" under `C:\WinDDK\7600.16385.1\`, copy&paste that to
`sys\objfre_win7_amd64\amd64`. 
3. Locate "pvk2pfx" under `C:\WinDDK\7600.16385.1\`, copy&paste that to
`sys\objfre_win7_amd64\amd64`.
4. Locate "MakeCert" under `C:\WinDDK\7600.16385.1\`, copy&paste that to
`sys\objfre_win7_amd64\amd64`.

Now cd to `amd64`, run
```commandline
Inf2Cat.exe /driver:. /os:7_X64,10_X64
```
This creates a catalog file called "vmulti.cat". Next, run
```commandline
signtool sign /v /fd SHA256 /f "C:\vmulti.pfx" /p YourPassword /t http://timestamp.digicert.com vmulti.cat
```
Replace `YourPassword` with the password you like. You should see a new file "vmulti.pfx" under "C:" if things go right.
Now find it and double click it. Click *Local Machine* -> *Next* -> *Next* ->
Enter your password -> *Place all certificates in the following store* -> 
*Select Trusted Root Certification Authorities* -> *Next* -> *Finsh*.

Next generate a self-signed certificate by
```commandline
makecert -r -pe -n "CN=VMulti Certificate" -ss My -sr LocalMachine -a sha256 -cy authority -sky signature -sv C:\vmulti.pvk C:\vmulti.cer
```
Lastly, generate a .pfx file for driver signing.
```commandline
pvk2pfx -pvk C:\vmulti.pvk -spc C:\vmulti.cer -pfx C:\vmulti.pfx -po YourPassword
```

# Step 5
1. Locate "devcon.exe" under `C:\WinDDK\7600.16385.1\`, copy&paste that to
`sys\objfre_win7_amd64\amd64`. 
2. Locate "hidkmdf.sys" under `vmulti\hidmapper\objfre_win7_amd64\amd64\`,
copy&paste that to `sys\objfre_win7_amd64\amd64`.
3. Locate "WdfCoInstaller01009.dll" under `C:\WinDDK\7600.16385.1\`, copy&paste that to
`sys\objfre_win7_amd64\amd64`.

Attention: If you are using other versions of Driver Kit, your "WdfCoInstaller" might be in a different version.
In that case, modify "vmulti.inf" under `sys\objfre_win7_amd64\amd64` to match your version.
(Replace WdfCoInstaller01009.dll with things like WdfCoInstaller01011.dll)

After you finished all of the above, run
```commandline
devcon install vmulti.inf djpnewton\vmulti 
```
You should see a pop-up menu saying that you are installing the driver, agree it.


# Step 6
Now verify you have the driver installed. Press Win+X and select Device Manager, scroll down to
"Human Interface Devices", see if you can find "VMulti HID". If you did, the installation was successful.
You see also be expecting two new devices under "Mice and other pointing devices".
Now that you have the driver installed, you should be able to run the Python example.


# Step 7
This step is for development. It will require Visual Studio. I am using Visual Studio 2015 (2017) but you can
try to use your own (reload the solution see what happen). Here is the download link for 2015: 
https://stackoverflow.com/a/44290942

Go to Visual Studio Installer, make sure you have the following components:
1. MSBuild
2. VC++ 2017
3. Windows 10 SDK
4. Visual C++ tools for CMake

Open the project in VS and reload the solutions if needed. By default the configuration type is 
.dll, you can change it to .exe in properties if you wanna do some other kinds of tests. 
For example, from the original repo:
```commandline
Run testvmulti.exe /multitouch to move the cursor via virtual multitouch (only available on Win7 and above)
Run testvmulti.exe /mouse to move the cursor via virtual mouse
Run testvmulti.exe /digitizer to move the cursor via virtual digitizer 
```

If you intend to use Python, ".dll" is more important. After you have modify the code, rebuild the solution and
a new .dll file will be generated under `vmulti\Debug`. Like the one I have attached in `vmulti\DLL`, you can copy&paste
it to your Python project and the `Mouse` class should be able to use it.


## To-Do
Probably won't have time but I will just list them. Free feel to open up a Pull Request if you got any of them 
implemented, I am very looking forward to it.
1. Make more additional mice instead of just one
2. Freely control "Press down" & "Release" mouse
3. Dragging
4. Position


<br>
<br>
If you liked this showcase, consider giving a Star to [this repository](https://github.com/cyberspatula/cyberspatula.github.io) and [the original repo](https://github.com/Kolyn090/vmulti-mice.git).


<br>
<br>
🍯 Happy Coding 🍯


**This article, completely original, is copyrighted by its author, me. Please do not reproduce it.**


**本文为原创作品，作者 Kolyn090 拥有其著作权，受法律保护。严禁复制、转载、仿冒或以任何形式使用。**
