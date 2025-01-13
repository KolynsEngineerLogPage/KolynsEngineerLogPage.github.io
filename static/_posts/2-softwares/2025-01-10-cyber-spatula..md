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

If you already know how to use git and GitHub, you can jump to:
- [Create a GitHub Pages repo](#create-a-github-pages-repo)

If you don't have Ruby installed:
- [Install Ruby](#install-ruby)

## Use other tools for more guidance
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


In the terminal, type this and hit enter on your keyboard
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


You will have to type in several commands this time. If you are on Mac, you might need to do some extra works in order to use [Ruby](https://www.ruby-lang.org/en/). It's the programming language that [Jekyll](https://jekyllrb.com/) uses, and we will be using Jekyll to format our website.


You should check if you already have Ruby. Type this command in the terminal and hit enter on your keyboard.
{% highlight shell %}
ruby -v
{% endhighlight %}

<br>
<h1 id="install-ruby">Install Ruby</h1>

On Windows, if you don't have Ruby, you should download it from [here](https://rubyinstaller.org/) and follow the instructions and you should be good.


On Mac, you are guaranteed to have Ruby. BUT, your Ruby version is likely to be old, like 2.6 something. We want it to be at least 3.0 above. This problem cannot be resolved by just updating Ruby because your MacOS is actually relying on it. One way to solve this is by using something called [chruby](https://github.com/postmodern/chruby). 


1 . Install chruby via [Homebrew](https://brew.sh/). That means you should type the following in the terminal and hit enter on your keyboard.
{% highlight shell %}
brew install chruby
{% endhighlight %}

2 . The other way to install it is via the source code. Try this way if the above didn't work. Clone this repository
{% highlight shell %}
git clone https://github.com/postmodern/chruby.git
{% endhighlight %}
- Go to the `chruby` folder by entering
{% highlight shell %}
cd chruby
{% endhighlight %}
🤓 `cd` means change directory.

- Run the installation script
{% highlight shell %}
sudo make install
{% endhighlight %}

3 . Install `ruby-install`. Again, it's possible to install this via Homebrew.
{% highlight shell %}
brew install ruby-install
{% endhighlight %}

4 . Or you can do it manually if the above didn't work.
{% highlight shell %}
git clone https://github.com/postmodern/ruby-install.git
cd ruby-install
sudo make install
{% endhighlight %}

5 . The next step could be a little difficult for you if you have never had programming experience before. In this step you will want to use a text editor like nano or vim. It's not important which one you choose. In this case I will choose vim. You can use them by enter the command and hit enter on your keyboard. This will open a text editor in terminal.
{% highlight shell %}
vim ~./zshrc
{% endhighlight %}
- Replace with nano if you want to use nano. Replace with `~./bashrc` if you are using bash shell.


📍 **It's going to be a little tricky to use vim text editor.** First of all, you need to enter the insertion mode by typing `i` on your keyboard. Then you start typing in the editor. After you are done, hit `Esc` on your keyboard. Then enter `:wq` to save the changes and exit from vim.


6 . Enter the following text via vim, then save and exit from it.
{% highlight shell %}
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
{% endhighlight %}


7 . After you are back in the terminal. Enter the following and hit enter on your keyboard.
{% highlight shell %}
source ~./zshrc
{% endhighlight %}
- Replace with `~./bashrc` if you are using bash shell.


8 . Enter the following and hit enter on your keyboard.
{% highlight shell %}
ruby-install ruby 3.1.1
{% endhighlight %}


9 . Use chruby to switch your current ruby version to 3.1.1
{% highlight shell %}
chruby ruby-3.1.1
{% endhighlight %}


10 . Verify you have successfully switched the Ruby version
{% highlight shell %}
ruby -v
{% endhighlight %}
You should see something like `ruby 3.1.1`. Be sure to perform online searches or inquiry ChatGPT if you encounter any problems not covered here.

---

Now, after you have installed Ruby. I want you to go back to `cyberspatula.github.io`. If you are lost where you are, you can do Open Folder again in vscode. Open the terminal again and enter this command and hit enter on your keyboard.
{% highlight shell %}
bundle install
{% endhighlight %}
This installs all dependencies in `cyberspatula.github.io`. 


Next, run this command to **start the local server**.
{% highlight shell %}
bundle exec jekyll serve
{% endhighlight %}


If the above one didn't work, try this instead
{% highlight shell %}
jekyll serve
{% endhighlight %}


You can check whether it worked or not by typing `http://127.0.0.1:4000/` in a web browser like Safari, Google Chrome...


![cs](/static/img/2-softwares/cyber-spatula/cs.png)


🎉 That wasn't so bad, huh?


# Step 3
In the next step I will be teaching you how to start a fresh new Jekyll setup like the one use in Cyber Spatula. Then I will discuss what each component in Jekyll does, in the manner that assuming you have no programming knowledge.

<br>
# GitHub account
Since we are going to host the web page on GitHub Pages, you are going to need a [GitHub account](https://github.com/). Register one if you don't have it. 


1 . Connect git with your GitHub account. In terminal, set your Git username with
{% highlight shell %}
git config --global user.name "Username"
{% endhighlight %}
📍 Replace "Username" with your username!

- Confirm the Git username has been set correctly.
{% highlight shell %}
git config --global user.name
{% endhighlight %}

- You should see your username being printed.
{% highlight shell %}
Username
{% endhighlight %}

2 . The other thing you will want to do is to set your Git email.
{% highlight shell %}
git config --global user.email "Your email"
{% endhighlight %}

- Confirm the Git email has been set correctly.
{% highlight shell %}
git config --global user.email
{% endhighlight %}

- You should see your email address being printed.
{% highlight shell %}
Your email
{% endhighlight %}

3 . The next thing you will want to do is to set up GitHub Authentication. This step is a little complicated. I recommend you to watch and follow [this video](https://www.youtube.com/watch?v=ePCBuIQJAUc).

---

Now you have set up git and GitHub account, the next thing is to create your own repository (repo). A repository stores your code and assets remotely in GitHub's database. It can either be public or private. A public repository can be seen by all GitHub users while a private one can only be seen by yourself. Other developers can clone or [fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) your public repositories.

<h1 id="create-a-github-pages-repo">Create a GitHub Pages repo</h1>


Assuming this is the first time you are creating a GitHub repository, go to GitHub and follow these steps.


![github1](/static/img/2-softwares/cyber-spatula/github1.png)


![github2](/static/img/2-softwares/cyber-spatula/github2.png)


![github3](/static/img/2-softwares/cyber-spatula/github3.png)


![github4](/static/img/2-softwares/cyber-spatula/github4.png)


📍 Very important: the Repository name must be `yourusername.github.io`. Replace `yourusername` with your actual username and must be lowercased. In a normal repository you don't have to follow the format.


You can also use [GitHub Organizations](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/about-organizations) instead of your own account to create GitHub Pages. Naming follows the same format.

<br>
After you have created the repository, you will go to the page of your repository. Here I am using `cyberspatula.github.io` as example. Click 'Code'.


![github5](/static/img/2-softwares/cyber-spatula/github5.png)


Copy your repository URL.


![github6](/static/img/2-softwares/cyber-spatula/github6.png)


Now the next thing is something you have already done in step 2. Create a new folder on your computer, open it on vscode, and type the following command in terminal and hit enter on your keyboard.


{% highlight shell %}
git clone https://github.com/cyberspatula/cyberspatula.github.io.git
{% endhighlight %}
Remember, you should use your own repository URL here.

---

Used `cd` to change directory to your repository folder.
{% highlight shell %}
cd cyberspatula.github.io.git
{% endhighlight %}
This should be the last part of your repository URL.

<br>
Now enter the following in terminal and hit enter on your keyboard.
{% highlight shell %}
jekyll new . --force
{% endhighlight %}


You should see the following files generated. This is the bare-bone form of Jekyll.


![repo](/static/img/2-softwares/cyber-spatula/repo.png)


Next, run this command in terminal.


{% highlight shell %}
bundle install
{% endhighlight %}

You should see something like
{% highlight shell %}
Bundle complete! 7 Gemfile dependencies, 38 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
{% endhighlight %}

---

Next let's take a look at `_config.yml`, by default it looks like:
{% highlight yaml %}
title: Your awesome title
email: your-email@example.com
description: >- # this means to ignore newlines until "baseurl:"
  Write an awesome description for your new site here. You can edit this
  line in _config.yml. It will appear in your document head meta (for
  Google search results) and in your feed.xml site description.
baseurl: "" # the subpath of your site, e.g. /blog
url: "" # the base hostname & protocol for your site, e.g. http://example.com
twitter_username: jekyllrb
github_username:  jekyll

# Build settings
theme: minima
plugins:
  - jekyll-feed
{% endhighlight %}
You can configure your site's settings in `_config.yml`. Each time you modify this file you will have to open the local server again to apply the changes. To close the local server, press `Ctrl + C` in terminal. To open the local server, type the following and hit enter on your keyboard.
{% highlight shell %}
bundle exec jekyll serve
{% endhighlight %}


Use this instead if the above didn't work.
{% highlight shell %}
jekyll serve
{% endhighlight %}

<br>
Type `http://127.0.0.1:4000/` in a web browser and you will see a greeting page like this.


![jekyll](/static/img/2-softwares/cyber-spatula/jekyll.png)


Open post 'Welcome to Jekyll!'


![jekyll2](/static/img/2-softwares/cyber-spatula/jekyll2.png)


👨‍🔬 Observe `_posts/welcome-to-jekyll.markdown` in your repository folder. See if you can figure out its connections with this page by yourself.

---

Now let's take a look at the files in the hands. 


- `.gitignore`: This file is not jekyll specific and it's for git. File names put inside will be ignored by git commands.

- `404.html`: This is a web page showing that the page is not found.

- `about.markdown`: This is a jekyll post that shows about information.

- `Gemfile`: Manage and specify the dependencies required for the project. Normally you don't modify this.

- `Gemfile.lock`: This file is automatically generated by the system.

- `index.markdown`: This is the home jekyll post. The first thing shown on a jekyll webpage. 

- `_config.yml`: You can configure the site's settings in this file. Each time after you modify this file you need to re-host the local server to apply the changes.

- `_posts`: The place where you store the jekyll posts (`.markdown`). By the way, you can use `.md` extension as well. It is **important** to note that all post names should start with a date. Like `2025-01-12-first-post.md`. You can create folders inside `_posts` and store posts in them. Jekyll will automatically locate them.

- `.jekyll-cache`: Cache folder for jekyll.

---

Next, let's create our first post.


Under `_posts`, create `2025-01-12-first-post.md`. Inside the created file, put
{% highlight markdown %}
---
layout: post
title:  "Our first post"
date:   2025-01-12 12:00:00 -0500
categories: log
---
{% endhighlight %}


Load the webpage, you should see a new post added.


![jekyll3](/static/img/2-softwares/cyber-spatula/jekyll3.png)


You can as an author for the post, like this:
{% highlight markdown %}
---
author: Your Name
layout: post
title:  "Our first post"
date:   2025-01-12 12:00:00 -0500
categories: log
---
{% endhighlight %}


You should also add a link for your post so that you can reference it in other posts.
{% highlight markdown %}
---
author: Your Name
layout: post
title:  "Our first post"
date:   2025-01-12 12:00:00 -0500
categories: log
permalink: /my-first-post/
---
{% endhighlight %}


Refresh the webpage, you should see your name next to the date and the website link becomes `127.0.0.1:4000/my-first-post/`. 


# Edit jekyll posts
There is a lot you can do in a jekyll post. The most basic text is like this one you are seeing right now. Change your post to and refresh the webpage.
{% highlight markdown %}
---
author: Your Name
layout: post
title:  "Our first post"
date:   2025-01-12 12:00:00 -0500
categories: log
permalink: /my-first-post/
---


This is basic text.
{% endhighlight %}


![jekyll4](/static/img/2-softwares/cyber-spatula/jekyll4.png)


---

You can also add titles by adding the pound sign before the text. Here is the effect:
{% highlight markdown %}
#### Big

### Big

## Big

# Big
{% endhighlight %}


![jekyll5](/static/img/2-softwares/cyber-spatula/jekyll5.png)


---

You can also **bold** the text by adding double asterisk symbols around it.
{% highlight markdown %}
**Important**
{% endhighlight %}


![jekyll6](/static/img/2-softwares/cyber-spatula/jekyll6.png)


---

You can underscore the text by doing
{% highlight markdown %}
<u>This is underscored text.</u>
{% endhighlight %}


![jekyll7](/static/img/2-softwares/cyber-spatula/jekyll7.png)


---

You can add a new line by writing this between lines

{% highlight markdown %}
<br>
{% endhighlight %}


![jekyll8](/static/img/2-softwares/cyber-spatula/jekyll8.png)


---

You can list things out by doing

{% highlight markdown %}
Things to buy:
- potato
- milk
- banana
- avocado
{% endhighlight %}


![jekyll9](/static/img/2-softwares/cyber-spatula/jekyll9.png)


Numbered version
{% highlight markdown %}
Things to prepare in order:
1. potato
2. milk
3. banana
4. avocado
{% endhighlight %}

Alphabetic version
{% highlight markdown %}
Which is the best among them?
a. potato
b. milk
c. banana
d. avocado
{% endhighlight %}

However, sometimes I prefer this instead when the layout is broken.
{% highlight markdown %}
Things to prepare in order:
1 . potato
2 . milk
3 . banana
4 . avocado
{% endhighlight %}


---


You can also add hyperlinks by doing

{% highlight markdown %}
[Visit my blogging website](https://cyberspatula.github.io)
{% endhighlight %}


You can also add link to your posts
{% highlight markdown %}
[See my post](/my-first-post/)
{% endhighlight %}


You can also add link to assets in this project. Make sure the file exists in the path.
{% highlight markdown %}
![Red Bean Soup!](/static/img/sweet-red-bean-soup.png)
{% endhighlight %}

---

You can add break lines by doing

{% highlight markdown %}
---
{% endhighlight %}

---

For programmers,

Use backtick to indicate code.
{% highlight markdown %}
`int foo = 0`
{% endhighlight %}


Add block of code
```
{% raw %}
{% highlight java %}
public static int addNumbers(int a, int b) {
    return a + b;
}
{% endhighlight %}
{% endraw %}
```
<br>

These are the most common ways of writing I do in jekyll posts. But you can almost apply any [markdown rules](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) in jekyll. If you are happy with the current situation. You can skip Step 4.

# Step 4
To enable customizations, you will have to learn how to write [html](https://en.wikipedia.org/wiki/HTML) and [css](https://en.wikipedia.org/wiki/CSS). You can learn both of them through the help of ChatGPT. 


There are some files you will have to add to your project. You can either copy the modified versions from `cyberspatula.github.io` or start out fresh by running this in terminal
{% highlight shell %}
jekyll new-theme minima
{% endhighlight %}

You should see a new folder called `minima`. This means that you are using [this theme](https://github.com/jekyll/minima). There are other themes you can use as well. Here is a [website](https://jekyllthemes.io/free) for jekyll themes.


Now I will be proceeding using the modified version approach. You can still continue reading even if you have chosen to start out fresh. 


<br>

From `cyberspatula.github.io`, copy the following folders to your project.
- _includes
- _layouts
- _sass
- assets

Next, create the following folders.
- _pages
- _plugins
- static

Now inside `static`, do
- Move `_posts` to `static`
- Create a folder `img`

---

