---
wordpress_id: 13
title: Learning and understanding
date: 2009-02-05T20:48:48+00:00
author: Gabriel Schenker
layout: post
wordpress_guid: /blogs/gabrielschenker/archive/2009/02/05/learning-and-understanding.aspx
dsq_thread_id:
  - "263908813"
categories:
  - didactics
  - learning
  - methodology
redirect_from: "/blogs/gabrielschenker/archive/2009/02/05/learning-and-understanding.aspx/"
---
[<img style="border-right: 0px;border-top: 0px;margin: 0px 10px 0px 0px;border-left: 0px;border-bottom: 0px" height="68" alt="attention" src="http://lostechies.com/content/gabrielschenker/uploads/2011/03/attention_thumb.jpg" width="75" align="left" border="0" />](http://lostechies.com/content/gabrielschenker/uploads/2011/03/attention_2.jpg) **Warning**: This is a special post. It&#8217;s about _learning in action_. In my [introduction](http://www.lostechies.com/blogs/gabrielschenker/archive/2009/01/12/coming-from-place-far-far-away.aspx) I told you that I have a flair for **didactics** and **methodology** and I have worked for quite some time in this field. So, don&#8217;t expect me to show you some new tips and tricks of software development or processes around software development! No, it&#8217;s all about learning and understanding.

As a developer who wants to continuously and steadily improve I have to always learn new stuff. But learning new things is only one side of the coin. How can I assert that I really understand what I have just learned? How can I know whether I&#8217;m able to apply the new knowledge to my day to day work? Will I be able to combine the new knowledge with other things I have learned in the past and finally am I able to judge the stuff I learned for its quality and usefulness?

## Bloom&#8217;s Taxonomy

In the 80s [Benjamin Bloom](http://en.wikipedia.org/wiki/Benjamin_Bloom) published his famous **Taxonomy of Educational Objectives**. The taxonomy relies on the idea that not all learning objectives and outcomes have equal merit. In the absence of a classification system (a taxonomy), teachers and instructional designers may choose, for example, to emphasize memorization of facts (which makes for easier testing) rather than emphasizing other (and likely more important) learned capabilities.

Skills in the **cognitive domain** revolve around knowledge, comprehension, and &#8220;thinking through&#8221; a particular topic. Traditional education tends to emphasize the skills in this domain, particularly the lower-order objectives.

[<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="189" alt="image" src="http://lostechies.com/content/gabrielschenker/uploads/2011/03/image_thumb_1.png" width="207" align="right" border="0" />](http://lostechies.com/content/gabrielschenker/uploads/2011/03/image_4.png)There are six levels in the taxonomy, moving through the lowest order processes to the highest: 

  1. Remember, memorize, recite 
      * Understand, paraphrase 
          * Apply, solve a problem 
              * Analyze 
                  * Create, synthesize, compose 
                      * Evaluate, judge</ol> 
                    With each level the understanding of a certain domain or knowledge deepens. Let&#8217;s now analyze in detail what these different levels of learning and understanding mean. I&#8217;ll try to provide samples for each level that are taken from our domain of software development.
                    
                    ## Level 1: Memorize, Recite
                    
                    [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="181" alt="Firefighter" src="http://lostechies.com/content/gabrielschenker/uploads/2011/03/Firefighter_thumb.jpg" width="182" align="right" border="0" />](http://lostechies.com/content/gabrielschenker/uploads/2011/03/Firefighter_2.jpg) This is the most basic level. Here a student can learn something new and just memorize what she has learned. No reflection about what she learns is needed. People having a photographic memory have a huge advantage over others. Computers are perfect in this area.
                    
                    There are some areas where nothing more than this level of learning is needed or desired. In theses areas it does not make sense or is event contra productive to try to understand or question things.
                    
                      * learning new words in a foreign language 
                      * prepare for the theoretical exam for the drivers license 
                      * as a **fire-fighter** following instructions of your chief when fighting a fire
                    
                    Very often teacher, trainers or coaches make the error that they ask questions that only expect the reciting of memorized stuff. Let&#8217;s look at such a sub-optimal question in our domain and analyze what the outcome might be.
                    
                    #### Question
                    
                    Please tell me the definition of the **Single Responsibility Principle** also called SRP.
                    
                    #### Answers
                    
                      * The SRP states that a class/object should have one and only one reason to change. 
                          * A class or component should have only a single responsibility. 
                              * We have a high cohesion if SRP is truly implemented in an application</ul> 
                            What? &#8220;Sorry, but I don&#8217;t understand&#8221; you might yell. And you are right. These answers are all correct but by no means do I know, whether the responding person has really grasped the essence of the SRP.
                            
                            ## Level 2: Understand and Paraphrase
                            
                            [<img style="border-right: 0px;border-top: 0px;margin: 0px 5px 0px 0px;border-left: 0px;border-bottom: 0px" height="174" alt="kommunikation" src="http://lostechies.com/content/gabrielschenker/uploads/2011/03/kommunikation_thumb.jpg" width="244" align="left" border="0" />](http://lostechies.com/content/gabrielschenker/uploads/2011/03/kommunikation_2.jpg)The student who has been taught a new topic is able to explain the essence of what she has learned to an **interested laymen**. The important thing is that the student cannot use the same vocabulary as when she is communicating with her class mates or with her teacher/trainer. She has to translate from the ubiquitous language to another language. But to be able to make this translation a student has to thoroughly understand the topic she is talking about. Possibly she has to find analogies with topics that the laymen is familiar with.
                            
                            If the laymen is able to grasp what the key elements of the discussed topic are then the student has really understood what she has just learned.
                            
                            #### Question
                            
                            Please try to explain to an interested laymen what the Single Responsibility Principle is about. Please use your own words.
                            
                            #### Answers
                            
                              * An application is normally not made of one single piece of code but rather consist of many smaller pieces of code. These small pieces of code we call classes or objects. The SRP now states that such a small piece, that is a class, should only do one thing and not several things. An example to illustrate what I mean take the cutlery. We have a knife to cut things, a spoon to e.g. eat soup or other liquid things and a fork to pick up solid pieces of our meal. Each of the three has a single responsibility. We normally don&#8217;t have just one item that is a knife, a spoon and a fork at the same time.
                              * To make an analogy: the SRP states that it is better that one person has just one responsibility and not many responsibilities. Having only one responsibility I can better concentrate on this responsibility and possibly improve the outcome. For all the other responsibilities we have different persons. Now if I get sick then only my responsibility is temporarily not fulfilled. All the other persons can continue to fulfil their (other) responsibilities.
                            ## Level 3: Solve a problem
                            
                            [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="173" alt="problem_solving" src="http://lostechies.com/content/gabrielschenker/uploads/2011/03/problem_solving_thumb.jpg" width="164" align="right" border="0" />](http://lostechies.com/content/gabrielschenker/uploads/2011/03/problem_solving_2.jpg) A student has just learned a new topic. Let&#8217;s assume she has been taught the **[Dependency Injection Pattern](http://en.wikipedia.org/wiki/Dependency_injection)** (DI). Now this student should solve a problem, where just this new learned pattern has to be applied. The important thing is that the problem to solve is rather &#8220;simple&#8221; such as that the new learned topic can be applied in isolation and knowledge of no other patterns or practices is needed.
                            
                            #### Question
                            
                            You have learned the **Dependency Injection Pattern**. We have shown you what this pattern is and how it can be applied. Imagine a service which has two dependencies. One of the dependencies is a mandatory dependency and the other one is an optional dependency. Please implement a code fragment which shows how you would implement such a service. Only the part of the service which applies DI is needed. Give short explanations why you implement it like this. 
                            
                            #### Answer
                            
                            Short explanations: 
                            
                              * Mandatory dependencies are best injected via constructor (&#8211;> constructor injection). In this sample the **IProductRepository** dependency.
                              * Optional dependencies are best injected via [writable] properties (&#8211;> property injection). In this case the **ILogger** dependency.
                              * To avoid tedious validation code I would initialize an optional dependency with a default implementation that does _nothing_ (here: **NulloLogger**)
                            <div>
                              <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">class</span> ProductService</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">{</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">    IProductRepository _repository;</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">    ILogger _logger = <span style="color: #0000ff">new</span> NulloLogger();</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">&nbsp;</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">    <span style="color: #0000ff">public</span> ProductService(IProductRepository repository)</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">    {</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">        _repository = repository;</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">    }</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">&nbsp;</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">    <span style="color: #0000ff">public</span> ILogger Logger</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">    {</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">        set { _logger = <span style="color: #0000ff">value</span>; }</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">    }</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">}</pre>
                              </div>
                            </div>
                            
                            Obviously the student has very well understood the DI pattern and is able to apply it to a given problem.
                            
                            ## Creativity
                            
                            _[<img style="border-right: 0px;border-top: 0px;margin: 0px 5px 0px 0px;border-left: 0px;border-bottom: 0px" height="137" alt="creativity" src="http://lostechies.com/content/gabrielschenker/uploads/2011/03/creativity_thumb.jpg" width="137" align="left" border="0" />](http://lostechies.com/content/gabrielschenker/uploads/2011/03/creativity_2.jpg)_What IS creativity? [Wikipedia](http://en.wikipedia.org/wiki/Creativity) defines it as follows
                            
                            > _Creativity is a mental and social process involving the generation of new ideas or concepts, or new associations of the creative mind between existing ideas or concepts, creativity is fueled by the process of either conscious or unconscious insight. An alternative conception of creativeness is that it is simply **the act of making something new**._
                            
                            &nbsp;
                            
                            Up to now no **creativity** is needed. It&#8217;s pure learning and understanding. Even an animal could reach this point if trained accordingly. And all current industrial robots are reaching at most this level.
                            
                            If there is one element through which a human being can be clearly distinguished from an animal it is through his creativity.
                            
                            International studies and meta-studies have shown that up to 90% of the questions asked in a written or in an oral exam do not exceed level 2. That means that teachers and professors do only examine whether a student can recite theory or whether she is able to understand learned material (and thus explain with own words). But whether the student can apply what she has learned is not tested in most of the cases. And the creativity of the student is never challenged.
                            
                            [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="184" alt="sad" src="http://lostechies.com/content/gabrielschenker/uploads/2011/03/sad_thumb.jpg" width="159" align="right" border="0" />](http://lostechies.com/content/gabrielschenker/uploads/2011/03/sad_2.jpg)Another amazing thing I&#8217;ve learned in an experiment where I participated was that the majority of people never reach a level higher than 3. Even more astonishing was the fact that this is also true if you just take people that have at least a Master Degree! At the test we conducted over 300 people participated which had all a Master Degree in at least one topic and many of them even had a Doctor degree. Now, that is sad!
                            
                            ## Level 4: Analyze
                            
                            [<img style="border-right: 0px;border-top: 0px;margin: 0px 5px 0px 0px;border-left: 0px;border-bottom: 0px" height="147" alt="problemsolving" src="http://lostechies.com/content/gabrielschenker/uploads/2011/03/problemsolving_thumb.jpg" width="244" align="left" border="0" />](http://lostechies.com/content/gabrielschenker/uploads/2011/03/problemsolving_2.jpg) If a student reaches this level she is able to analyze a given complex situation or problem and disentangle it. She can identify and isolate sub-problems. She is able to categorize and prioritize those sub-problems.
                            
                            #### Question
                            
                            During the last weeks we have learned many new patterns and practices of good object oriented software design. Given the following (shortened) piece of legacy code please point out which important patterns and principles are violated. Give a short justification for each pattern or practice you point out. You should identify at least 4 patterns or principles that are violated.
                            
                            [Legacy sample code &#8212; omitted]
                            
                            #### Answer
                            
                              * The **Single Responsibility Principle** (SRP) is violated since a single class (EditOrderForm) has several responsibilities (loading data, parsing/mapping data, displaying data, etc.).
                              * The **Dependency Inversion Principle** (DI) is violated since the encryption service (EncryptionService) as a higher level module depends on the implementation of lower level modules for input and output (FileStream) and not upon an abstraction of the lower level modules.
                              * The **Law of Demeter** is violated in the method **SumDiscounts** of the **DiscountFinder** class. There the argument of type **IOrderWithDiscount** is (down-) casted to the class **Order**.
                              * etc.
                            
                            &nbsp;
                            
                            ## Level 5: Create, Synthesize, Compose
                            
                            [<img style="border-right: 0px;border-top: 0px;border-left: 0px;border-bottom: 0px" height="244" alt="Leonardo_da_Vinci" src="http://lostechies.com/content/gabrielschenker/uploads/2011/03/Leonardo_da_Vinci_thumb.jpg" width="177" align="right" border="0" />](http://lostechies.com/content/gabrielschenker/uploads/2011/03/Leonardo_da_Vinci_2.jpg) Here you take what you have learned so far and create (previously unseen) new combinations of different pieces of knowledge. A good sample of this would be the invention of the steam driven engine by James Watt. As I have learned in college James Watt was watching his mother cooking. Then he realized that the cover of a pan which contained boiling water was lifted a little bit from time to time and water vapor exhausted. He deduced that water vapor can be used as a driving force for an engine and finally constructed the first water vapor driven engine. He synthesized a physical effect (pressure caused by heating water and thus creating water vapor) with engineering skills (constructing an engine).
                            
                            Another good sample for this type of creativity is the implementation of an **[internal DSL](http://www.martinfowler.com/bliki/DomainSpecificLanguage.html)** to create HTML fragments in an MVC based Web application (e.g. [MS MVC for ASP.NET](http://www.asp.net/mvc/) or [FuBuMVC](http://code.google.com/p/fubumvc/)). The base elements or knowledge are
                            
                              * Delegates, Lambda Expressions and Expression Trees (see my [post](http://gabrielschenker.lostechies.com/blogs/gabrielschenker/archive/2009/02/03/step-by-step-introduction-to-delegates-and-lambda-expressions.aspx))
                              * Static Reflection (see my [post](http://gabrielschenker.lostechies.com/blogs/gabrielschenker/archive/2009/02/03/dynamic-reflection-versus-static-reflection.aspx))
                              * Declarative programming with attributes
                              * [Fluent interfaces](http://en.wikipedia.org/wiki/Fluent_interface) (also see [this](http://www.martinfowler.com/bliki/FluentInterface.html) post)
                              * Internal DSL
                            
                            These elements are now creatively combined to produce the desired HTML fragments. By carefully inspecting the information that is stored in an **expression tree** one can extract a whole lot of information out of a simple statement like this
                            
                            <div>
                              <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">TextboxFor(p = &gt; p.Name);</pre>
                              </div>
                            </div>
                            
                            where **TextboxFor** is an extension method to the view (of an MVC based Web application) and has the following signature
                            
                            <div>
                              <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #0000ff">public</span> <span style="color: #0000ff">static</span> TextboxExpression TextboxFor&lt;TModel&gt;(</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">        <span style="color: #0000ff">this</span> IViewWithModel view, </pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">        Expression&lt;Func&lt;<span style="color: #0000ff">object</span>, TModel&gt;&gt; expression)</pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">{ ... }</pre>
                              </div>
                            </div>
                            
                            The interesting part in this method is the second parameter of type **Expression**. The meta-information found via this expression can be used to form an HTML snippet like the following
                            
                            <div>
                              <div style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none"><span style="color: #0000ff">&lt;</span><span style="color: #800000">input</span> <span style="color: #ff0000">type</span><span style="color: #0000ff">='text'</span> </pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">       <span style="color: #ff0000">name</span><span style="color: #0000ff">='productName'</span> </pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">       <span style="color: #ff0000">class</span><span style="color: #0000ff">='required'</span></pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">       <span style="color: #ff0000">maxlength</span><span style="color: #0000ff">='50'</span> </pre>
                                
                                <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: white;border-bottom-style: none">       <span style="color: #ff0000">value</span><span style="color: #0000ff">='Apple'</span> <span style="color: #0000ff">/&gt;</span></pre>
                              </div>
                            </div>
                            
                            Meta information is found via static reflection (analyzing the expression tree). For a complete picture please have a look at the [FubuMVC](http://code.google.com/p/fubumvc/) code.
                            
                            ## Level 6: Evaluate, Judge
                            
                            [<img style="border-right: 0px;border-top: 0px;margin: 0px 5px 0px 0px;border-left: 0px;border-bottom: 0px" height="228" alt="judge" src="http://lostechies.com/content/gabrielschenker/uploads/2011/03/judge_thumb.jpg" width="244" align="left" border="0" />](http://lostechies.com/content/gabrielschenker/uploads/2011/03/judge_2.jpg) This is the highest and most sophisticated level a student can reach. At this level she has to be able to judge some given facts. The important thing is that she cannot just say _this is good_ or _this is bad_ but she has to base her judgment on a criteria catalog which she first has to define. Another important thing is that there is not a _objectively correct_ answer but merely an answer that is consistent with the criteria catalog used for the evaluation or judgment.
                            
                            This level should be reached by a person who is asked to give recommendations or a person who who is conducting an assessment.
                            
                            #### Question
                            
                            You have learned that there are two major platforms Java and .NET on which most of the current applications are developed. Your software company has not yet committed itself to one of them. Your manager asks you to evaluate both of those platforms and make a well-founded proposal about which platform your company should use in the future.
                            
                            To solve the problem establish a consistent and reasonable criteria catalog as a base for your evaluation. Prioritize those criteria and justify in which direction and why each criteria influences your decision.
                            
                            #### Answer
                            
                            I will not give a complete answer here to the question but just sketch how I would proceed.
                            
                            In the answer you&#8217;ll first establish the requested criteria catalog. Each criteria should be reasonable for a software company.
                            
                              * who are the majority of our customers
                              * on which platform our current developers are strong
                              * for which platform is it easier to find good qualified developers
                              * on which platform developers of equivalent skills get a higher salary
                              * what is the adoption rate of each platform in the (software) industry
                              * etc.
                            
                            Now as a next step you have to weigh each criteria on a reasonable scale. Let&#8217;s say you define the following levels and assign points to each of them (in parenthesis):
                            
                              * moderately important (1)
                              * important (3)
                              * very important (5)
                            
                            Of course you should also justify the distribution of points that is why do you assign 1, 3 and 5 points instead of 1, 2 and 3.
                            
                            Finally you make your decision based on the above weighed criteria catalog.
                            
                            ## What about the Education?
                            
                            Can only highly educated people having at least a doctor title reach level 6 when learning? No, definitely not! Even a very young child can be creative. To test a young child or an uneducated person for creativity one just has to adjust the problems to solve. The questions we ask have to be on a fair level.
                            
                            There are some interesting sayings about [Wolfgang Amadeus Mozart](http://en.wikipedia.org/wiki/Mozart). It is told that at the age of about 3 he hear a pork squeak. He then said that this is an &#8216;a&#8217; (the note &#8216;a&#8217;). At the age of 4 he was already could play some minuets faultlessly and with the greatest delicacy on the piano. Of course he was a genius and not everybody is a genius. But this example shows us that he was creative before he went to school.
                            
                            ## Summary
                            
                            I have shown that the cognitive aspect of learning can be categorized into 6 different levels. The most basic level is reached when I can memorize topics I learn. But the problem is that if I only memorize facts I do not necessarily understand what I am learning and furthermore I am not able to apply what I have learned in my daily life and work. The farther I climb up the levels the more comes creativity into play. Creativity makes us human being unique. Only through creativity can we invent new things and possibly increase the quality of life. At the uppermost level I am able to judge or balance facts. If I reach this level I can say with confidence that I understand what I am talking about.