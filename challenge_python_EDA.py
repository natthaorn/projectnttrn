#!/usr/bin/env python
# coding: utf-8

# In[1]:


# import library
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt


# In[2]:


df = pd.read_csv('C:/Users/natth/downloads/sales_data.csv')
df.head()


# In[3]:


#check missing value 
df.info()


# In[4]:


df.isnull().sum()


# In[5]:


#create the crosstab 
country_avg_price = pd.crosstab(df.Country,df.Price.mean())
country_avg_price


# In[6]:


df.groupby(['Country']).value_counts()


# In[7]:


#show statistical numeric
df.describe()


# In[8]:


#find mode of Price
df.Price.mode()


# In[9]:


#set style and figure 
sns.set_style("darkgrid")
plt.figure(figsize=[10,6])
#histogram of Price
sns.histplot(x='Price',data=df)
plt.title("Price Distribution")
plt.show()


# In[10]:


#set style and figure 
sns.set_style("darkgrid")
plt.figure(figsize=[10,6])
#histogram of Quantity
sns.histplot(df.Quantity,color='g')
plt.title("Quantity Distribution")
plt.show()


# In[11]:


sns.set_style("darkgrid")
plt.figure(figsize=[10,6])
sns.boxplot(df.Price)
plt.title("Boxplot of Price")
plt.show()


# In[12]:


plt.figure(figsize=[10,6])
sns.countplot(x='Country',data=df)
plt.title("Count of Country")
plt.xlabel("Country")
plt.xticks(rotation = 25)
plt.show()


# In[13]:


#create pairplot 
sns.pairplot(df)


# In[14]:


# Scatter plot of Price and Quantity
plt.figure(figsize=[10,6])
sns.scatterplot(x="Price",y='Quantity',color='b',data=df)
plt.title("Price and Quantity")
plt.xlabel("Price")
plt.ylabel("Quantity")
plt.show()


# In[15]:


#convert Date Object to datetime format 
df['Date'] = pd.to_datetime(df['Date'])


# In[16]:


#check result (datatype)
df.info()


# In[17]:


#extract year to add a new column in df
year_sale = df.Date.dt.year
print(year_sale)


# In[18]:


df['year_sale'] = year_sale
df.head()


# In[19]:


df['year_sale'].value_counts()


# In[20]:


#calculate sale by multiply quantity with price 
total_sale = df.Quantity * df.Price
df['total_sale'] = total_sale
df.head()


# In[21]:


#find avg of sale
avg_sale_2023 = df.total_sale[df['year_sale'] == 2023].mean()
avg_sale_2024 = df.total_sale[df['year_sale'] == 2024].mean()


# In[22]:


print("average sale in 2023 :",avg_sale_2023)
print("average sale in 2024 :",avg_sale_2024)


# In[23]:


sns.histplot(x=df.total_sale[df['year_sale'] == 2023])
plt.show()


# In[24]:


sns.histplot(x=df.total_sale[df['year_sale'] == 2024])
plt.show()


# In[26]:


sum_of_quan_2023 = df.Quantity[df['year_sale'] == 2023].sum()
sum_of_quan_2024 = df.Quantity[df['year_sale'] == 2024].sum()


# In[28]:


print("sum of Quantity sold in 2023: ",sum_of_quan_2023)
print("sum of Quantity sold in 2024: ",sum_of_quan_2024)


# In[36]:


df.ProductID.unique()


# In[38]:


# Create the plot
plt.plot(df['Date'], df['total_sale'], linestyle = 'dotted')

# Add title and axis labels
plt.title('Line Chart Total Sale')
plt.xlabel('Date')
plt.ylabel('Total Sale')
plt.xticks(rotation=45)
plt.show()


# In[ ]:




