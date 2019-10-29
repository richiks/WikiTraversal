# WikiTraversal

An interesting Wikipedia fact: Clicking on the first non-parenthesized, 
non-italicized link in the main text of a Wikipedia article, and then 
repeating the process for subsequent articles, would eventually lead to
the Philosophy article.

Considering all the articles as nodes and Wikipedia as a graph, the project
performs Depth First Search (DFS) to navigate from the article of user’s choice
to the Wikipedia article on Philosophy. The project shows the number of clicks 
as well as the intermediate articles that were achieved to reach the article on
Philosophy. It uses web scraping techniques through a urlstream library to 
retrieve data from Wikipedia.
