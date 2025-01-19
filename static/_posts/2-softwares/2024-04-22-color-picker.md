---
author: Kolyn090
banner: /static/img/2-softwares/color-picker/thumb.png
categories: Tutorial
custom_class: custom-page-content
date: 2024-04-22 17:00:00 -0500
layout: post
permalink: /color-picker-showcase/
title: CTKColorPickerAlpha Showcase
---


**This article, completely original, is copyrighted by its author, me. Please do not reproduce it.**


**本文为原创作品，作者 Kolyn090 拥有其著作权，受法律保护。严禁复制、转载、仿冒或以任何形式使用。**


Category: App Showcase


License: CC0 1.0 Universal


[**[source code]**](https://github.com/Kolyn090/CTkColorPickerAlpha.git)

## Introduction
A special color picker that supports picking transparent color (8-digits hex code)

![default](https://github.com/Kolyn090/CTkColorPickerAlpha/blob/main/readme_img/screenshot-ui.png?raw=true)
![colored](https://github.com/Kolyn090/CTkColorPickerAlpha/blob/main/readme_img/screenshot-color.png?raw=true)

## Download

{% highlight shell%}
pip install ctk-color-picker-alpha
{% endhighlight %}

## Requirements
- [customtkinter](https://github.com/TomSchimansky/CustomTkinter)
- [pillow](https://pypi.org/project/Pillow/)
- [numpy](https://numpy.org)

### How to use?

{% highlight python%}
import customtkinter as ctk
from ctk_color_picker_alpha import *


def ask_color():
    pick_color = AskColor()  # open the color picker
    color = pick_color.get()  # get the color string
    print(color)


root = ctk.CTk()

button = ctk.CTkButton(master=root, text="CHOOSE COLOR", text_color="black", command=ask_color)
button.pack(padx=30, pady=20)
root.mainloop()
{% endhighlight %}

## Options
- width: set the overall size of the color picker window, always greater than 300 pixels
- title: change the title of color picker window
- fg_color: change foreground color of the color picker frame
- bg_color: change background color of the color picker frame                                                             
- button_color: change the color of the button and slider
- button_hover_color: change the hover color of the buttons
- text: change the default text of the 'OK' button
- initial_color: set the default color of color picker (currently in beta stage)
- slider_border: change the border width of slider
- corner_radius: change the corner radius of all the widgets inside color picker
- enable_previewer: if True, display the color previewer
- enable_alpha: if True, enable 8-digits hex code and transparency. Otherwise, use 6-digits hex code and disable transparency
- allow_hexcode_modification: if True, enable modifications to hex code textbox
- enable_random_button: if True, display the 'Random' button
- _**other button parameters_: pass other button arguments if required

# ColorPickerWidget
**This is a new color picker widget that can be placed inside a customtkinter frame.**

![widget](https://github.com/Kolyn090/CTkColorPickerAlpha/blob/main/readme_img/screenshot-widget.png?raw=true)

### Usage

{% highlight python%}
from ctk_color_picker_alpha import *
import customtkinter

root = customtkinter.CTk()
colorpicker = CTkColorPicker(master=root)
colorpicker.pack(padx=10, pady=10)
root.mainloop()
{% endhighlight %}

## Options
- master: parent widget
- width: set the overall size of the color picker window, always greater than 300 pixels
- title: change the title of color picker window
- fg_color: change foreground color of the color picker frame
- bg_color: change background color of the color picker frame
- button_color: change the color of the button and slider
- button_hover_color: change the hover color of the buttons
- text: change the default text of the 'OK' button
- initial_color: set the default color of color picker (currently in beta stage)
- slider_border: change the border width of slider
- corner_radius: change the corner radius of all the widgets inside color picker
- enable_previewer: if True, display the color previewer
- enable_alpha: if True, enable 8-digits hex code and transparency. Otherwise, use 6-digits hex code and disable transparency
- allow_hexcode_modification: if True, enable modifications to hex code textbox
- enable_random_button: if True, display the 'Random' button
- _**other button parameters_: pass other button arguments if required


[**Forked from CTKColorPicker**](https://github.com/Akascape/CTkColorPicker)


<br>
<br>
If you liked this showcase, consider giving a Star to [this repository](https://github.com/cyberspatula/cyberspatula.github.io) and [the original repo](https://github.com/Kolyn090/CTkColorPickerAlpha.git).


<br>
<br>
🍯 Happy Coding 🍯


**This article, completely original, is copyrighted by its author, me. Please do not reproduce it.**


**本文为原创作品，作者 Kolyn090 拥有其著作权，受法律保护。严禁复制、转载、仿冒或以任何形式使用。**
