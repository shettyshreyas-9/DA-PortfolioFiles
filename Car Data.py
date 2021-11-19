#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[8]:


car = pd.read_csv(r"H:\\shreyas\\DS\\portfol\\DS lovers\\CarsData.csv")
car


# In[ ]:





# # Analysis

# In[17]:


car.head()


# In[19]:


car.shape


# In[20]:


car.index


# In[10]:


car.columns


# In[24]:


car.nunique()


# In[26]:


car.count()


# In[ ]:





# In[ ]:





# In[53]:


car['Make'].value_counts()


# In[48]:


car.info()


# In[ ]:





# # Cleaning -find null values

# In[52]:


car.isnull().sum()


# In[50]:


car.fillna(car.mean(), inplace =True)


# In[ ]:





# # Region specific details

# In[61]:


car.head(2)


# In[73]:


car[car['Origin'].isin(['Asia','Europe'])]


# In[ ]:





# # Removing data( cars with weight abv. 4000)

# In[102]:


car= car[~(car['Weight'] > 4000)]
car


# In[103]:


car.shape


# In[ ]:





# # Modification in column (add 3 more to entire column of MPG_City)

# In[109]:


#Using apply function
car['MPG_City'] = car['MPG_City'].apply(lambda x:x+3)


# In[111]:


car.head(5)


# In[ ]:




