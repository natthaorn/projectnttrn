#!/usr/bin/env python
# coding: utf-8

# # Workshop

# In[13]:


## we are createing the task to make the computer learn world's capital name 
## we start with create 'worldcapital.txt' to be the example 
## e.g.Thailand/Bangkok

## so, when the program know the country >> output capital 
## if not, we will write add new world capital instead in the file 


# create function to read the file worldcapital.txt 
import sys
from tkinter import Tk, simpledialog, messagebox

def read_from_file():
    with open('worldcapital.txt',"r") as file:
        for line in file:
            line = line.rstrip('\n') ## rstrip() set new line by \n
            country,capital = line.split('/')
            country = country.capitalize() #set capitalize
            capital = capital.capitalize()  #set capitalize
            world_capital[country] = capital #dict_name[key]=value
            
def write_to_file(country_name,capital_name):
    with open('worldcapital.txt',"a") as file:
        file.write('\n') # set newline
        file.write(country_name + '/' + capital_name) # write format
        file.close() # save changed
        
## create inteface to interact with user
## python have 'tkinter' module >> interface to the Tcl/Tk GUI toolkit.
# import sys
# from tkinter import Tk, simpledialog, messagebox

root = Tk()
root.withdraw() #withdraw GUI window
world_capital = {} # set empty dict 

while True:
    read_from_file()
    simpledialog.askstring
    query_country = '' # create vairable to receive input
    query_country = simpledialog.askstring('Country','Type the name of a country: ')
    query_country = query_country.capitalize()
    if query_country in world_capital:
        result = world_capital[query_country]
        messagebox.showinfo('Answer','The capital city of ' + query_country + ' is ' + result + '!')
    else:
        new_capital = simpledialog.askstring('Teach me', 'I don\'t know the answer. Please teach me. What is the capital city of '+ query_country + '?:')
        messagebox.showinfo('Thanks','Thank you for teaching me. I will definitely know it next time!')
        new_capital = new_capital.capitalize()
        write_to_file(query_country,new_capital)
    answer = simpledialog.askstring('Continue', 'Do you want to try again? y/n: ')
    if answer == 'n':
        messagebox.showinfo('Thanks','Thank you for playing!')
        root.destroy()
        sys.exit()


# In[14]:


print('a','b','c','d',sep='#')


# In[15]:


print('haPpY birthDaY to you'.title())


# In[19]:


myList = [1,3,5,2,4,6]
myList.insert(0,0)
myList[0:3]  = [0,1,2]
myList.pop(4)
print(myList)


# In[21]:


def myfunc(x):
    x = x.split()
    print(x)
x = input('Enter input: ')
myfunc(x)


# In[24]:


foo = 'hello'
def title():
    a = foo.title()
    return a 
def upper():
#     global foo
    a = foo.upper()
    return a 
a = title()
a = upper()
print(a)


# In[28]:


class Student:
    studentStatus = 'Active'
    
    def __init__(self,name,year):
        self.name = name
        self.year = year
student1 = Student('CheeZe',4)


# In[35]:


print(student1.studentStatus)


# In[ ]:




