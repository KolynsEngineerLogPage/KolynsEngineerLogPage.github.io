---
author: Kolyn090
banner: /static/img/1-default/not-found.jpg
categories: Tutorial
custom_class: custom-page-content
date: 2025-01-10 17:00:00 -0500
layout: post
permalink: /software-cyber-spatula/
title: Create a website like Cyber Spatula, as an Absolute Beginner.
---


**This article, completely original, is copyrighted by its author, me. Please do not reproduce it.**


**本文为原创作品，作者 Kolyn090 拥有其著作权，受法律保护。严禁复制、转载、仿冒或以任何形式使用。**


Category: Tutorial

Prerequisite: Know how to use a computer and perform online searches


<br>
<br>
Hello, there. Ever wondered how to build a blogging website like the one you are seeing now? If so, you have came to the right place! Let me tell you a secret: <u>it only took me two days from zero knowledge about web hosting to keep it running.</u> Wanna know how to do that? Keep reading and learn!


## The first thing
This site uses GitHub Pages. You should be aware that GitHub Pages are mainly used for writing blogs or project wikis. These pages are static, meaning they display the same content to every user. If your goal is to build a dynamic page website (content change based on user actions or data retrieval from database), you will need to avoid using GitHub Pages. 

## Use other tools as guidance
Let's face it, you are going to encounter many problems and so did I when I first started this project. That's why I highly recommend using AI tools like [ChatGPT](https://chatgpt.com/) to suggest possible fixes for you. In this article I will be teaching you what I know about GitHub websites. 

## Getting the website running
# Step 1
In this tutorial I am going to assume you have no background knowledge regarding programming. So the first step will be <u>downloading an IDE</u> so that you can view the files better. IDE stands for **Integrated Development Environment**. It's a software that has tools needed for software development in one place. It's OK if you don't understand what I am saying. You'll do better once you try it out yourself. Different programmers might have different IDE preferences. I, for one, use [Visual Studio Code](https://code.visualstudio.com/) the most often. It is also currently what I'm using to write this article. 

If you don't have a specific preference, go ahead and download [Visual Studio Code](https://code.visualstudio.com/).

---

After you have successfully install an IDE, open it. I will use vscode (Visual Studio Code) as example. 


Here is the welcome page of vscode. This is Windows system, if you are using a different operating system like MacOS the page layout might be slightly different.


![welcome-vscode](/static/img/2-softwares/cyber-spatula/welcome-vscode.png)


# Step 2
Wouldn't it be so much better if you could get familiar with GitHub Pages while learning how to use an IDE?


Now I will be using this project as an example. First, create a new folder somewhere in your computer. Next, you will want to open this folder in vscode.


Open vscode, go to Settings, select File -> Open Folder... If you don't know how to do this, you can try the hot-key instead: `Ctrl + K, Ctrl + O`. That will also do Open Folder for you. Next, locate your folder and open it.

---

After you have done that, you will be prompted with a greeting window like below.


![open-folder](/static/img/2-softwares/cyber-spatula/open-folder.png)


Click 'Yes, I trust the authors' to continue. 

---

Next I want you to open a **terminal** within vscode. Go to Settings, select Terminal -> New Terminal. Its hotkey is <code>Ctrl + Shift + `</code>. The last key is called a [backtick](https://en.wikipedia.org/wiki/Backtick). 


You should see something like this


![terminal](/static/img/2-softwares/cyber-spatula/terminal.png)

---

Within this panel, you can enter commands and the computer will do some works based on the command you typed in. Now we will want to [clone a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository). This essentially means that you will download a folder from the internet. In this case, we want to clone [this repository](https://github.com/cyberspatula/cyberspatula.github.io.git) and we can achieve this through the terminal.


In the terminal, type this and hit enter
{% highlight shell %}
git clone https://github.com/cyberspatula/cyberspatula.github.io.git
{% endhighlight %}


![git-command](/static/img/2-softwares/cyber-spatula/git-command.png)


You should see a new folder being created in the folder you created.


![git-command2](/static/img/2-softwares/cyber-spatula/git-command2.png)


📍 Troubleshoot: If you see errors like git has not been installed in your computer, you should go to [the official git website](https://git-scm.com/) and download git from there. Follow the instructions and you should be good. 

---

Now check the files in `cyberspatula.github.io`, see if you can make sense what each of them is supposed to be doing. The files are located on the left side of the window of vscode. You can expand a folder by clicking on it. Click a file to view it in vscode.


👨‍🔬 Challenge: try if you can find the file that contains contents in this page. (Hint: use 'file search' in vscode)

---

I have already filled `cyberspatula.github.io` with a lot of things. You should be able to use it by **running a local server**. It essentially means that you will be able to open a website and your computer is going to be its server. Other people won't be able to see this website.


You will have to type in several commands this time. If you are on Mac, you might need to do some extra works in order to use [ruby](https://www.ruby-lang.org/en/). It's the programming language that [Jekyll](https://jekyllrb.com/) uses, and we will be using Jekyll to format our website.


