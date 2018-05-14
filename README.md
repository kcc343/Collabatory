# INFO 201 BC Project Proposal
Group Members: Emily Zhang, Kelly Chhor, Luoan Tang
## Project Description
- The dataset we will be working with is one about all the movies contained in the **The Movie DB**. The data was collected by users that started in 2008 and is still being contributed now.
- Our target audience are:
  - *movie sponsors* who want to know budget and revenue trends to figure out what and who to invest in.
  - *movie producers* who want to know the budget and revenue patterns to figure out what their movie will have.

- We want our audience to learn:
  - How do actresses/actors affect the revenue and budget for movies?
  - What genres have the highest overall budgets?
  - What are the top 100 most profitable movies in 10 years, and which genres were they?
  - Does budget predict how long a movie’s runtime should be?
  - How much do some movie companies spend and get back from the movies they created, and the what are the difference between companies?
  - Is there a relationship between high revenue and ratings?
  - What kind of trend is there between popular movies and their budget?
  - How the country where the movie is made in affect the budget and revenue?

## Technical Description
- We will be reading our data through **the Movie DB API**.
- We will need to reshape our data by filtering by types of movies and when the movies were released. Then we can extract the specific data we want through `dplyr` methods.
- We will be using `shiny` for creating interaction with our project and `ggplot2` to create our movie data API graphs.
- Some major challenges we anticipate are getting the specific data that we want to measure, working with the Movie API gathering the data, and making visual representations (i.e. graphs, tables) from the data that we gathered.
