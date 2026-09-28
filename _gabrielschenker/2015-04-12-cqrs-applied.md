---
wordpress_id: 919
title: CQRS applied
date: 2015-04-12T15:51:30+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: https://lostechies.com/gabrielschenker/?p=919
dsq_thread_id:
  - "3676256066"
categories:
  - Architecture
  - commands
  - CQRS
  - Design
  - queries
  - Read model
  - REST
---
In [this post](https://lostechies.com/gabrielschenker/2015/04/07/cqrs-revisited/ "CQRS revisited") I have discussed CQRS, an architectural pattern from a high level perspective. CQRS is one of my favorite patterns when it comes to complex line of business applications. Let&#8217;s discuss CQRS on a specific sample. Imagine we had to build a mini version of the Amazon shopping site. For simplicity we only discuss a very simplified version of the application.

## High level description  of the application

A user can navigate to our web site and browse through a catalog of **products**. We offer the user a drop down box where she can select a **product category** and a text field where she can enter **search terms**. Finally there is a **Go** button next to the text field to trigger the search.

The result of a product search is a list of matching products that are displayed on the screen. For each product we display the name, the category, a photo and the unit price. Also with each product we display an **Add** button to add one instance of the specific product to our **shopping cart**.

Somewhere on the screen we also display a **Shopping Cart** button which if clicked will lead us to a different view displaying the current contents of our shopping cart. On this view the quantity per product is editable and we can remove individual products from the shopping cart.

## Implementation details

### The product catalog

The view where the user can browse the product catalog is a good sample to discuss queries. In this specific context we have a query that we can call e.g. **SearchProducts**. This name gives us the context and if chosen wisely there is no guessing what exactly the meaning or goal of the query is. Of course we also need to provide additional data to the back-end where the search will happen. First of all we know that the user can select a product category on the screen. This will probably give us a unique CategoryID (or CategoryCode). This CategoryID will be part of the payload of the query. The user can also enter a free form text in the search text box. Let&#8217;s call this the QueryText. Consequently our query object that we send from the UI to the back-end will look like this

{% gist 3cba675b1849167d2a32 %}

which is a JSON formatted object that we e.g. send to an end-point of a REST-ful API. Let&#8217;s just assume it is a POST request to &#8230;/api/Products/Search

> Why am I using a POST request for a query and why do I define the query parameters in the body of the request instead as parameters in the URI? Well, that&#8217;s a good question. In this particular scenario the query text can be quite long and as we all know the length of a URI is limited whilst the size of the request body is not. But unfortunately although the HTML standard does not forbid to provide a body in a GET request most of today&#8217;s infrastructure does not support a body in a GET request. Thus we just use the &#8220;next best&#8221; verb which is POST

On the back-end we consequently have a query object like this

{% gist a3d711093db0df05075a %}

Since this is a query we do not funnel this request through our domain model but rather go straight to the data store to retrieve the data and return it as a collection of data transfer objects (DTOs).

How can we fulfill the request? Well, let&#8217;s for a moment forget that only relational databases exist to store data. Unfortunately we have been brain washed throughout our whole career that all business applications always have to use relational databases to store the data. But let&#8217;s free ourselves from these limitations for a moment.

Whenever we are searching something then an index comes to mind. Indices are and have always been one of the fastest ways to get to a result. If we have key words we are looking for in e.g. a book then we consult the index&#8230; Let&#8217;s just do that. Here the added complexity is that the user of our application can enter free form text as search criteria. Hmmm, that&#8217;s a problem&#8230; or not&#8230;? No, it&#8217;s not a problem if we make the following assumptions

  * we can split the query text along the white spaces into a list of **terms **
  * we define that each term must occur somewhere in the product that matches. It can be in the product name, category, size, color, etc.
  * we can use a powerful full text indexing engine like Elastic Search or Solr (which are backed by Lucene)

<span style="font-size: 16px; line-height: 24px;">Let&#8217;s assume we define our index using <a href="https://www.elastic.co/">Elastic Search</a> then we can define say an index having the following list of fields: ProductId, CategoryId, SearchTerm</span>

and our query will be somewhat similar to this (note that the first part is only to be included if the user has selected a product category)

[CategoryId: xyz] AND SearchTerm:term1 AND SearchTerm:term2 AND &#8230;

The above query is formulated using the Lucene [query syntax](https://lucene.apache.org/core/2_9_4/queryparsersyntax.html). ElasticSearch provides a REST API that we can use and will return us the list of matching index entries. We can then take the list of distinct ProductIDs from these index entries and retrieve the full details of the corresponding products from say a document database (e.g. Mongo DB or Raven DB) where we have stored our full product catalog. We then return this list to the UI as a collection of DTOs. Once again it is important to notice that the domain (model) was at no time involved in this process of querying the product catalog.

### The shopping cart

Once the list of products that the user was searching for is displayed on the screen she can select certain products and add them to her shopping cart by clicking of the respective **Add** button next to the individual product(s). Each time the user clicks an Add button a command is sent to the back-end. To make things unambiguous we call this command **AddProductToCart**. Once again it is very important to select a meaningful name that immediately reveals what&#8217;s going on and that can be understood by domain experts that are have no IT background. The payload of the command will be the unique **ProductID**. We need nothing more since by definition we add **one** instance of the product to the shopping cart. Furthermore the shopping cart is identified by the **session ID** that the user has associated (remember, up to now the user is still anonymous to the application). But the session ID will be provided to us by the (Web) infrastructure and thus doesn&#8217;t need to be included in the command. So we have a POST request to e.g. the endpoint &#8230;/api/ShoppingCart/AddProduct and this is the body

{% gist 6d95e159a01430a1077f %}

and on the server we have the following corresponding command object

{% gist c94e9940215896018cff %}

This command will now be handled by our domain. If we&#8217;re using DDD then we might have e.g. a **ShoppingCart** aggregate which will handle this command. It is important to note that a command always has exactly one target, not zero and not more than one but exactly one. So the code will look like this

{% gist f539848c6767bf8220bb %}

Note that the method **AddProduct** does not return anything. The method either succeeds or fails, that are the only possible outcomes. Usually I just throw an exception in the aggregate if the aggregate cannot execute the command due to maybe a violation of a business rule.

> You might now ask yourself how this is going to work if we just throw exceptions when a business rule in the aggregate is violated. Shouldn&#8217;t we choose a more &#8220;friendly&#8221; way of telling that something went wrong? Well, this is a valid question and it only really makes sense to be so rigid if we have another boundary condition fulfilled: &#8220;&#8230;**always make sure that a command is highly likely to succeed before sending it on its way**&#8230;&#8221;. If this pre-condition is given then a violation of a business rule is truly an excepting and thus we can treat it as such an throw.

If the command succeeds then we can just return a status code 200 (=OK) to the UI and we know that the shopping cart has been updated. There is no need to refresh/reload the data of the shopping cart from a UI&#8217;s perspective since we already have all information on the screen.

In a similar manner we can treat the two possible commands that the user can trigger on the shopping cart view &#8211; adjust the number of items of a certain product and remove product from shopping cart. Here is the corresponding code snippet

{% gist d5a122a68cab468d570e %}

Again, the corresponding methods do not return any data and can either succeed (highly likely) or fail (a true exception). If the respective operation/command succeeds we also return a status code 200 (=OK) to the UI and the UI can update the visual display of the shopping cart.

### Conclusion

In this post we have discussed a somewhat real world sample and have applied the CQRS pattern to the implementation. The important thing is to realize that we treat queries completely different from commands. Queries are used purely to retrieve data whilst commands are exclusively used to change the state of our domain model. Queries never are handled by the domain (model) but go rather straight to the source of data. Commands are always handled by the domain model. When implementing an application that uses CQRS it helps enormously to use the language (nouns and verbs) that domain experts use, thus avoiding generic terms like Save, Update, Delete, Get, etc. and rather use SearchProducts, AddProductToCart, IncreaseProductCount, RemoveProductFromCart, Checkout, etc. If we do that the we are using the so called **ubiquitous language**.