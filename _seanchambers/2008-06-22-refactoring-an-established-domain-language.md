---
id: 3179
title: Refactoring an established Domain Model
date: 2008-06-22T12:45:00+00:00
author: Sean Chambers
layout: post
guid: /blogs/sean_chambers/archive/2008/06/22/refactoring-an-established-domain-language.aspx
dsq_thread_id:
  - "268066516"
categories:
  - Uncategorized
---
Writing Domain models is by far one of the most difficult things to do. It takes years of practice, errors and learning to get&nbsp;good at writing&nbsp;halfway decent domain models. This becomes even more difficult when we attempt to add ideas like Domain Driven Design to the mix.&nbsp;I am not proposing I am even remotely good at it, but I have had lots of practice.


  


In the last two weeks my co-worker and I have begun a greenfield project. This project is a complete language re-write&nbsp;due to the fact that the existing technology it is written in, is a dead end. There is no upgrade path and the staff running the software have become more ancy as time has progressed because they knew sooner or later they would have to leave the existing platform behind. The project is greenfield because of no technology constraints, that doesn&#8217;t mean however there isn&#8217;t domain language constraints.


  


The problem with this project is only a handful of people are intimately familiar with the domain. Even then, the few people that were familiar&nbsp;don&#8217;t agree often on how specific aspects should work. This adds an enormous amount of risk to the project as even though there is a functioning domain model, it is one without a solid foundation and thus weak model. 


  


Enter Domain Model Refactoring&#8230;


  


A few words&nbsp;before I begin. This is an extremely risky thing to do when using Agile/DDD concepts. You run the risk of alienating the client from the&nbsp;domain language.&nbsp;Not only are you going out on a limb here, but you are playing with the business language that the client&nbsp;is using. If&nbsp;I wasn&#8217;t&nbsp;comfortable with the client enough to talk to them on a real level (my client is within my staff), then I wouldn&#8217;t attempt to&nbsp;refactor the model for their benefit. Trust&nbsp;is extremely important between the client and developers, as it normally is,&nbsp;but more than usual. Couple that with the fact that in my instance there is no money changing hands, so there is little or no monetary cost involved, that doesn&#8217;t mean however that there isn&#8217;t cost in general involved. Cost in this sense is time and effort, not money, although in some instances, time and effort is proportional to money but not in my case.


  


Usually you are working with a project where you are starting from day one and can work with the client on the domain model. In this instance, they have been using a model for years and I am attempting to change it to make it more effecient for them. Again, proceed with caution.


  


**Step 1. Model the existing Domain**&nbsp;


  


The first step we took is to model out the existing solution with aggregates/entities and value objects. This gives us a good idea of how the model &#8220;would&#8221; be modeled if it was in a pure DDD&nbsp;type model&nbsp;with all the bells and whistles. This allowed us to reveal holes and gaps in the model (and there was a lot of them). When we approached the client about this, they shrugged and claimed they didn&#8217;t know why functionality was like it was, just that it was that way. This allowed us to refactor parts of the model that were superfluous and began to make the model more lean.


  


The existing domain was modeled after the technology it was based on. Because of performance constraints, specific things had to be done in a specific manner in order to salvage performance. After noticing this in the DDD model we created, we refactored the &#8220;performance features&#8221; into more logical operations with extra documentation. The original application was split into seperate databases that were converged on a daily basis in the morning. Because of this, each database was it&#8217;s own seperate bubble of transactions/processing. To minimize collisions when everything was merged together, the model was setup in such a way that extra processing was required on the actual users of the system to resolve these conflicts before they happened. We were able to again make the model more lean by removing these constraints as we were refactoring to a single database approach and could remove these constraints.


  


**Step 2. Refactor to a more&nbsp;logical model**&nbsp;


  


Once we had this step complete we could then begin to refactor the model into a more logical manner. This should be done&nbsp;with baby steps and each change be communicated to the client. As long as you have a good idea of what the model should be, then make appropriate changes to the model. All the while documenting what has been refactored into what. You will need to communicate these changes to the client, otherwise you will be the one translating the old model to the new model. This is to be expected at first, but once the client gets running on their own feet they should be able to do this themselves, if they are not then you need to provide more documentation and explanation as to why a particular portion of the model is setup a specific way. In this case, the client didn&#8217;t actually care what language we changed as long as it still served their purpose and we informed them of any definition changes and provided documentation on why a specific feature was dropped.


  


Before we laid down a single line of code, we spoke with the client explaining exactly what was happening, why it was happening and then received feedback from them. This part is very important as it will uncover MORE gaps in the model as well as gaps in their understanding of the model. Have someone take notes and address the gaps accordingly in your refactored model. We did this step and realized that some of the changes we made didn&#8217;t need to be communicated to the client because they already took this for granted, however, we wouldn&#8217;t have known this unless we spoke with them about it.


  


Looking back in this project, the key was communication and feedback. If you cut this portion out of the loop you increase risk very quickly. Don&#8217;t take anything for granted and leave out assumptions. It is better to ask 10 questions and get 9 dumb answers and one good one than to ask no questions at all.


  


As I said in the beginning of the post, I am no expert on modeling but I have found that this approach has worked well for me and my team. Hopefully you can take something from it.