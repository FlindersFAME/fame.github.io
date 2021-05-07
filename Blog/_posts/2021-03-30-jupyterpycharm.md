---
layout: single
show_date: true
tags : Jupyter PyCharm
title: Using PyCharm and Jupyter Notebooks
author: Rob Edwards
excerpt: "PyCharm is a terrific Python IDE, and you should use it for code development"
---

### _Series: An Introduction To Using DeepThought For Bioinformatics_

PyCharm is a terrific Python IDE, and you should use it for code development, but often you just need to manipulate a few files or run some simple code, and that's where Jupyter excels. Here is how to do them both at the same time!

1. Install [PyCharm](https://www.jetbrains.com/pycharm/). Note that the community version is just fine, but there is a free license for academics that you can also take advantage of.
2. Create a new project or open a project -- this is wherever you want to do the work
3. Create a virtual environment. 
   i. From the File menu choose Settings.
   ii. In the search box paste `python interpreter`. This will bring you to the interpreter section
   iii. Click on the settings cog on the right, click add and create a new virtual environment within your current project. You should do this for every project anyway so that your modules are specific to this project.
   iv. Once that has been installed, you can add any packages you want. For this, click the + sign and then search for `jupyter`. 
   v. Click install for the `jupyter` package. This will install all the required packages.
4. Create a new Jupyter notebook. Right click on a folder where you want to store the notebook (if you don't have a folder, you can also add one). Choose new jupyet notebook.
5. When you start the notebook, juptyter will run and you will see a dialog (probably in green) with the URL for the jupyter notebook. 

You can also directly start the server by clicking the yellow lightbulb symbol on the top left of the jupyter panel, and choosing `Start Jupyter Server`.

You can run and edit the Jupyter notebook in your pycharm installation, or you can edit the jupyter notebook in your browser as you are used to. **Note**: It is important that you save your work from the correct location, and then it will sync to the other location. For example, if you are working in your browser, click the save button from time-to-time and it will ask you to confirm any overwriting.

