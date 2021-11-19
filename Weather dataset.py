#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[3]:


data= pd.read_csv(r"H:\\shreyas\\DS\\portfol\\DS lovers\\WeatherData.csv")
data


# In[ ]:





# # Analyze dataset

# In[4]:


data.head()


# In[6]:


data.shape


# In[7]:


data.index


# In[8]:


data.columns


# In[9]:


data.dtypes


# In[12]:


data['Weather'].unique()


# In[13]:


data.nunique()


# In[ ]:





# ##count shows total no. of no null values in each column

# In[15]:


data.count()


# ## .value count shows count of unique values in each column 

# In[17]:


data['Weather'].value_counts()


# In[18]:


data.info()


# In[ ]:





# # 1) Unique windspeed values in data

# In[22]:


data['Wind Speed_km/h'].unique()


# In[ ]:





# # 2) No. of times weather is exactly clear

# In[29]:


data['Weather'].value_counts()


# In[44]:


# filtering
data[data.Weather == 'Clear']


# In[42]:


#group by
data.groupby('Weather').get_group('Clear')


# In[ ]:





# # 3) No. of times windspeed was exactly 4kmph

# In[30]:


data.head(2)


# In[32]:


data['Wind Speed_km/h'].value_counts()


# In[51]:


#filtering
data[data['Wind Speed_km/h']== 4]


# In[ ]:





# # 4) Find out all the null values in the data

# In[54]:


data[data.isnull()].count()


# In[52]:


data.isnull().sum()


# In[55]:


data[data.notnull()].count()


# In[ ]:





# # 5) Rename cloumn name from Weather to Weather condition

# In[59]:


data.rename(columns ={'Weather': 'Weather condition'}, inplace=True)


# In[60]:


data.head(2)


# In[ ]:





# In[ ]:





# # 6) what is mean visibility

# In[61]:


data['Visibility_km'].mean()


# In[ ]:





# # 7) what is std dev. of pressure colmn

# In[62]:


data['Press_kPa'].std()


# In[ ]:





# # 8) what is variance of 'rel. humidity'

# In[63]:


data['Rel Hum_%'].var()


# In[ ]:





# # 9) all instances when snow was recorded

# In[65]:


data.head(1)


# In[67]:


data[data['Weather condition']== 'Snow']


# In[70]:


# str.contains
data[data['Weather condition'].str.contains('Snow')]


# In[ ]:





# # 10) all instances when windspeed is abv 24 & visibility is 25

# In[79]:


data[(data['Wind Speed_km/h']>24) & (data['Visibility_km']==25)]


# In[ ]:





# # 11) Mean value of each colmn against weather cond.)

# In[81]:


data.groupby('Weather condition').mean()


# In[ ]:





# # 12) Min & Max value against weather condn

# In[82]:


data.groupby('Weather condition').min()


# In[83]:


data.groupby('Weather condition').max()


# In[ ]:





# # 13) all records where weather cond is 'fog'

# In[87]:


data[data['Weather condition'].str.contains('Fog')]


# In[ ]:





# # 14) all cond where weather is 'clear 'or visib is 'abv 40'

# In[94]:


data[(data['Weather condition']=='Clear') | (data['Visibility_km']>40)]


# In[ ]:





# # 15) all cond where weather is 'clear ' & rel humd. is abv '50' or visib is 'abv 40'

# In[96]:


data[((data['Weather condition']=='Clear') & (data['Rel Hum_%']>50)) | (data['Visibility_km']>40)]. head(50)


# In[ ]:




