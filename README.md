# INFO 201 BC Project Proposal
Group Members: Emily Zhang, Kelly Chhor, Luoan Tang
## Project Description
- The dataset we will be working with is one about all the movies contained in **The Movie DB**. The data was collected by users that started in 2008 and is still being contributed now. We can access the dataset via its homepage ([The Movie Database (TMDb)](https://www.themoviedb.org/)). All of these data are collected upon every movie’s release and it is for the users to correct and adjust the information in the dataset to the most accurate possible.

- Our target audience are:
  - *movie sponsors* who want to know budget and revenue trends to figure out what and who to invest in.
  - *movie producers* who want to know the budget and revenue patterns to figure out what their movie will have.

- We want our audience to learn (based on movies from 20 years ago and present):
  - How do actresses/actors affect the revenue and budget for movies?
  - What genres have the highest overall budgets?
  - What are the most profitable movies in 20 years, and which genres were they?
  - Does budget predict how long a movie’s runtime should be?
  - How much do some movie companies spend and get back from the movies they created, and the what are the difference between companies?
  - Is there a relationship between high revenue and ratings?
  - What kind of trend is there between popular movies and their budget?

## Technical Description
- We will be reading our data through **the Movie DB API** and saving
to .csv files
- We will need to reshape our data by filtering by types of movies and when the movies were released. Then we can extract the specific data we want through `dplyr` methods.
- We will be using `shiny` for creating interaction with our project and `ggplot2` to create our movie data API graphs.
- Some major challenges we anticipate are getting the specific data that we want to measure, working with the Movie API gathering the data, and making visual representations (i.e. graphs, tables) from the data that we gathered.
