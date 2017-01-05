# Python for Data Science

![alt text](static/python-logo.png "Python")

## Index
  * [Load data](#load_data)
  * [Work with data](#work_data)
    * [Numpy](#numpy)
    * [SciPy](#scipy)
    * [pandas](#pandas)
  * [Visualization](#visualization)
  * [Machine Learning](machine_learning)
    * [scikit-learn](#scikit-learn)


### Load data

#### Pandas

Pandas library is the most extended one for analytics in python. It uses numpy on the background, what makes it very fast.

##### Input types

In order to read files, the best way is to use pandas's predefined functions. It allows to load the following type of files into a panda object:
- csv
- Excel
- hdf
- sql
- json
- msgpack
- html
- gbq
- stata
- sas
- pickle

It also allows you to read text from your clipboard.

The use is as below:

````python
import pandas as pd
df = pd.read_csv('datos.csv')
````

##### Loading json

Due to the wide use of json, it is important to know how pandas can help to load information with that format.

The method json_normalize can convert a json file into a pandas dataframe.

````python
data = [{'state': 'Florida',
          'shortname': 'FL',
         'info': {
               'governor': 'Rick Scott'
          },
          'counties': [{'name': 'Dade', 'population': 12345},
                      {'name': 'Broward', 'population': 40000},
                      {'name': 'Palm Beach', 'population': 60000}]},
         {'state': 'Ohio',
          'shortname': 'OH',
          'info': {
               'governor': 'John Kasich'
          },
          'counties': [{'name': 'Summit', 'population': 1234},
                       {'name': 'Cuyahoga', 'population': 1337}]}]
from pandas.io.json import json_normalize
result = json_normalize(data, 'counties', ['state', 'shortname',
                                          ['info', 'governor']])
````                                        

The ouput would be like:

|index|name| population | info.governor | state | shortname
|---|---|---|---|---|---|
|0|Dade|12345|Rick Scott|  Florida| FL|
|1| Broward| 40000| Rick Scott|Florida| FL
|2| Palm Beach| 60000|Rick Scott|Florida| FL
|3| Summit| 1234|John Kasich| Ohio| OH
|4| Cuyahoga|1337| John Kasich|Ohio| OH

Example taken from [pandas doc](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.io.json.json_normalize.html)

It still have problems by loading nested objects, but nothing that cannot be solved with some
additional operations.

##### Separators and performance

To read files containing a dataset in which values are separated by any characters different than the well known commas or tabs, you must use the parameter sep or delimiter (both are valid) to indicate it.

It must be taken into account that the use of custom delimiters might force to change from C's engine to python's engine. **C is always faster** but it only allows some delimiters. **Python's engine is slower but lets you choose even regular expressions as delimiter**.

````python
    import pandas as pd
    df = pd.read_csv('datos.csv', sep='::', engine='python') # Setting the engine removes warning message.
````

#### Loading process information

In order to get visualize a loading bar when you are iterating over any dataset information,
**tqdm** library is a good choice.

Suppose you want to modify something in your input dataset, which is very big. You can check if the process is running or blocked with:

````python
for elem in tqdm(np.nditer(elements), total=elements.shape[0]):
  do_something()
````

The output would be something like:

76%|████████████████████████████        | 7568/10000 [00:33<00:10, 229.00it/s]

### Work with data

#### Numpy

Numpy library is an extension for Python which provides mathematical functions for problems where arrays and matrix computations are required. For **Matlab software** users, Numpy library could be a great substitute. Numpy has also the advantage that was part of python from the beginning and it has a lot of developments. Next piece of code could be used in order to load this library:

````python
    import numpy as np
````
The main characteristic of Numpy is array object class. It is quite similar to lists in Python, except one condition: **In a numpy array all the elements must be of the same type** (ex. float, int, str ...). It is used to make mathematical operations **faster and more efficient than using lists**.

For example, using the next code a Numpy array (2 rows and 3 columns) is created. The function `np.shape()` is used to check the dimension, and it is useful in case of array multiplication errors.

````python
    X = np.array( [ [1,2,3], [4,5,6]])
    np.shape(X)
````
**How to index and slice a numpy array?**

This could be one of the first questions when a person starts with this kind of numerical libraries. Using previous X array, the way to access to first element in the first row and its last element is shown in the next code. Unlike Matlab (or R) Numpy uses zero-based indexing, i.e. the first element is indexed with 0 and not with 1.

````python
    first = X[0][0]
    last = X[0][-1]
````
As in Matlab the `eye()`function is helpful when you want to create a 2D array with ones on the diagonal and zeros elsewhere. It can be used to reduce computational cost in many optimization algorithms...

Numpy library has a lot of useful functions when you need to work with random numbers. These functions can be imported using `numpy.random`. Notice that you must set a certain `seed()` before using these functions in order to get **reproducible results**.
````python
    np.random.seed(32) # example seed is set to 32
````    
Some functions from `numpy.random`are: `randn()` which generates a 'standard normal' distribution; `randint` which returns random integers from a low to a high input values; `shuffle()`	is useful to modify an input sequence by shuffling its contents; `permutation()` randomly permutes a sequence...


### Scipy
SciPy (Scientific Python) is a Python library which is often mentioned in the same way as NumPy. SciPy extends the capabilities of NumPy with further useful functions for minimization, regression, Fourier-transformation and many others.


### pandas
This part gives a brief introduction to pandas data structures and some advices. Pandas is a Python library for data analysis which has many functions for using DataFrame structures. A DataFrame structure called `df` is used for clarify all the examples contained in this part. The next code allows to import the library and to create an empty dataframe.

````python
    import pandas as pd
    df = pd.DataFrame()
````

An easy way to start with pandas library is loading a dataset from a csv file, returning a DataFrame structure. Next code shows how.

````python
    df= pd.read_csv('../datos.csv').fillna(" ")
````

In order to introduce this library some tipical questions are answered.

**How to get information from a DataFrame structure?**

It is useful to extract and get some information from your DataFrame, for example with the functions `df.info` and `df.describe`. The second one also provides a brief statistical description about your dataset, for example the mean, standard deviation, maximum values and percentiles…

A really good function in order to check all the types which compose your DataFrame structure is `df.dtypes`.

A quickly way to see the first and the last records is to use `df.head(N)` and `df.tail(N)` respectively, where N is the number of records that you want to check.

**How to select a certain field or slicing a DataFrame structure?**

The easy way to select a column or field in a DataFrame is using the notation `df[‘name’]`. A great thing is to use the previous functions in order to get information just for this column. For example: `df[‘name’].describe()` or `df[‘name’].dtypes`. Several columns can be selected with an additional bracket as `df[[‘name1’, ‘name2’]]`.

**How to join, combine and group several DataFrame structures?**

In almost every analysis, we need to merge and join datasets, usually with a specific order and relational way. To resolve this issue pandas library contains at least 3 great functions; `groupby()`, `merge()` and `concat()`.

Groupby function is used basically to compute an aggregation (ex. Sum, mean…), split into slices or groups and perform a transformation. It returns an object called GroupBy which allows other great funcionalities. Also, it provides the ability to group by multiple columns. An example could be, grouping by columns named A and B, compute its mean value (by group):

````python
Group = df.groupby('A','B']).mean()
````
Also useful if you want to apply multiple functions to a group and collect results. And again, `describe()`function is so useful after group and apply functions because it gives a lot of information about the output. pandas-groupby functionality is great, it performs some operation on each of the pieces and it is similar as `plyr` and `dplyr` packages in R language.

For SQL programmers, `merge()`function provides two DataFrames to be joined on one or more keys, using common syntax (on, left, right, inner, outer...). For example:   

````python
    pd.merge(df1,df2, on ='key', how= 'outer')
````

This library also provides `concat()`as a way to combine DataFrame structures. It is similar to `UNION` function in SQL language. So useful when a different approach and model provides a part of the final result and you just want to combine.

````python
    pd.concat([df1, df2])
````

### Visualization
Matplotlib, seaborn and Bokeh libraries are used for plotting and visualization.
````python
    import matplotlib as mp
    import seaborn as sn
    import bokeh as bk
````

### scikit-learn
The main python library for Machine Learning is [scikit-learn](http://scikit-learn.org/). It is built on top of Numpy, Scipy and Matplotlib. And it's well documented.
````python
    # k nearest neighbours
    from sklearn.neighbors import KNeighborsClassifier
    # Random Forest
    from sklearn.ensemble import RandomForestClassifier
````
