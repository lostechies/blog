---
id: 111
title: 'PTOM: OCP revisited in Ruby'
date: 2008-03-31T02:54:43+00:00
author: Joe Ocampo
layout: post
guid: /blogs/joe_ocampo/archive/2008/03/30/ptom-ocp-revisited-in-ruby.aspx
dsq_thread_id:
  - "262089696"
categories:
  - PTOM
  - Ruby
---
I was playing with some <a title="Ruby" href="http://www.ruby-lang.org/en/" target="_blank">Ruby</a> code this weekend and thought I would show some <a href="http://www.objectmentor.com/resources/articles/ocp.pdf" target="_blank">OCP</a> with <a title="Ruby" href="http://www.ruby-lang.org/en/" target="_blank">Ruby</a>. 

For more of an in-depth discussion on OCP please read <a href="http://www.lostechies.com/blogs/joe_ocampo/archive/2008/03/21/ptom-the-open-closed-principle.aspx" target="_blank">my previous post</a>. 

Now the first thing I want to point out is that dynamic languages are naturally by default open for extension. Since the types are dynamic, there are no fixed (static) types. The enables us to have awesome extensibility. It is the closure part of the equation that really scares me more than anything else. If you really aren’t careful when you are programming with dynamic languages you can quickly make a mess of things. This doesn’t take away from the power of a dynamic language you just have to exercise greater care that is all. 

So let’s use our OCP scenario template again and apply them to the example scenario. 

  * The **_ProductFilter_** is responsible for **_filtering products_** by **_color_** 
      * The **_ProductFilter_** is responsible for **_filtering products_** by **_size_** 
          * The **_ProductFilter_** is responsible for **_filtering products_** by **_color and size_**</ul> 
        Let’s go ahead and create the ProductFilter first. 
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">class</span> ProductFilter
    
    attr_reader :products
    
    def initialize(products)
        @products = products
    end
    
    def by(filter_spec)
        
    end
end</pre>
        </div>
        
        For those that have never created a class in Ruby let me breakdown the syntax structures. 
        
        **class** keyword is used to define a class followed by the name of the class. It is important to note that class names must be start with an uppercase letter. The uppercase letter signifies to the <a title="Ruby" href="http://www.ruby-lang.org/en/" target="_blank">Ruby</a> interpreter that this is constant, meaning that whenever the term “ProductFilter” comes up it will always reference this class structure. 
        
        **attr_reader** keyword used to signify a read only accessor (read only property). The property name follows the colon. 
        
        **def** keyword is used to declare a method block. The “initialize” method is the same as the constructor method in C#. 
        
        The **@** symbol denotes an instance variable. Notice that the “products” read accessor is never typed but is assigned in the constructor through @products reference. The instance variable @products is assigned to the products parameter variable that is passed into the constructor. 
        
        Now that we are talking about products we have to create the actual product class.
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">class</span> Product
    attr_accessor :color
    attr_accessor :size
    
    def initialize(color, size)
        @color = color
        @size = size
    end
end</pre>
        </div>
        
        Nothing fancy here, just a class with two read/write accessors Color and Size. 
        
        If you remember from my previous post I was using a template pattern to serve as the basis for extending the behavior of my filter class. Well I am going to do the same thing here (kind of) and define an Item\_color\_filter_spec class.
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">class</span> Item_color_filter_spec
    attr_accessor :color
    
    def initialize(color)
        @color = color
    end
    
    def apply_to(items)
        
    end
end</pre>
        </div>
        
        Now I have a class that accepts a color and has an “apply_to” method that accepts “items”. I have left out the implementation code of this method on purpose. 
        
        The next thing I am going to do is create an array of products I can use against the ProductFilter class. <a title="Ruby" href="http://www.ruby-lang.org/en/" target="_blank">Ruby</a> makes this pretty painless: 
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">products = [
    Product.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Blue"</span>, <span style="color: #006080">"Large"</span>),
    Product.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Red"</span>, <span style="color: #006080">"Large"</span>),
    Product.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Blue"</span>, <span style="color: #006080">"Medium"</span>),
    Product.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Red"</span>, <span style="color: #006080">"Small"</span>),
    Product.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Blue"</span>, <span style="color: #006080">"Large"</span>),
    Product.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Yellow"</span>, <span style="color: #006080">"Small"</span>),
]</pre>
        </div>
        
        So what’s going on here? I declared a variable called “products” and assigned it to array by using the square braces “[ ]”. Yup that simple! 
        
        What you may have noticed is that I actually instantiated several new products in the array. To instantiate a class you simply use the “new” method that is part of the Object class that all objects in <a title="Ruby" href="http://www.ruby-lang.org/en/" target="_blank">Ruby</a> inherit from similar to C#. 
        
        Now that I have a collection of products I am going to give to my product filter class.
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">product_filter = Product_Filter.<span style="color: #0000ff">new</span>(products)</pre>
        </div>
        
        In the example below I am going to filter all the “Blue” products.
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">blue_products = product_filter.by(Item_color_filter_spec.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Blue"</span>))</pre>
        </div>
        
        At this point I am creating a new “Item\_color\_filter\_spec” and giving the color “Blue” as the color to filter on. The ProductFilter class would then simply call the “apply\_to” method on the “Item\_color\_filter_spec”. 
        
        If you ran the code at this point nothing would happen because we haven’t actually written our filter code yet. So to do that we are going to modify the “apply\_to” method of our “Item\_color\_filter\_spec” class with the following code.
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">def apply_to(items)
    items.select{|item| item.color == @color}
end</pre>
        </div>
        
        In the code above the “apply\_to” method is expecting an array of items to be passed in. We then call the “select” method on the array class and pass in a filter “proc” by enclosing the statement in curly braces {} (In Ruby a “proc” is an object that holds a chunk of code but more on this later). The pipe block “||” is used to signify parameters to the proc similar to the parameters of a method. After the pipe block is the actual statement that is executed. We are trusting that the “select” method of the array object is going to enumerate over each object (product) it contains and pass it into Proc. Once in the Proc we simply determine if the color of product matches the instance variable “@color” of the “Item\_color\_filter\_spec” in this case the color “blue”. When the Proc evaluates to true it passes the item to an array that the select method returns.
        
        > You can possibly equate a “proc” to a <a href="http://msdn2.microsoft.com/en-us/library/bb397687.aspx" target="_blank">lambda expression</a> in C#.
        
        (Normally I would have used <a href="http://rspec.info/" target="_blank">rSpec</a> to govern everything I am doing but I didn’t want to explain BDD as well. I wanted to focus on the Ruby language in general.) 
        
        Now if you run the code you will have three products in the “blue_products” variable. How do you know? Well let’s iterate over it by using the following code.
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">blue_products.each <span style="color: #0000ff">do</span> |product|
    puts(product.color)
end</pre>
        </div>
        
        Now remember “blue_products” is an array object. The array object has an “each” method (as do other objects in Ruby) that accepts a “proc” object. The “proc” block is denoted by the “do” keyword and terminated with the “end” keyword. In our block we expecting that the array objects “each” method is going to give us a product. As the each method iterates over each product it passes it to the “proc” and we simply tell Ruby to write it to the screen using the “puts” method. The result of this small statement block in the following:
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">Blue

Blue

Blue
</pre>
        </div>
        
        So there you have it 3 blue products! 
        
        I know, nothing special right? Well now let’s play with some <a title="Ruby" href="http://www.ruby-lang.org/en/" target="_blank">Ruby</a> sweetness! 
        
        That sure is a lot effort to filter a product by color. Imagine if you had to keep adding different color filters. You would have to create several “color filter specs” over and over again. That is dull and most static languages have played this out! So let’s use some Ruby Lambda’s to accomplish the same thing as the “color filter spec” 
        
        We are going to create a filter spec that filters all products that are yellow. 
        
        Remember I told you that Ruby views all uppercase variable names as constants; well we are going to harness the power of this convention and create a constant to hold the reference to the lambda. After all <a href="http://en.wikipedia.org/wiki/Don't_repeat_yourself" target="_blank">DRY</a> principles still apply here.
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">YELLOW_COLOR_FILTER_SPEC = lambda <span style="color: #0000ff">do</span> |products|
    products.select{|product| product.color == <span style="color: #006080">"Yellow"</span>}
end</pre>
        </div>
        
        Nothing in the code block above should be foreign at this point except for the “lambda” key word. What the “lambda” keyword does is tell the Ruby interpreter to assign the “Proc” to the constant “YELLOW\_COLOR\_FILTER_SPEC”. 
        
        We have to now modify our ProductFilter class to accept a Proc object. All you have to do is add the following method to the ProductFilter class.
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">def by_proc(&filter_spec_proc)
    filter_spec_proc.call(@products)
end</pre>
        </div>
        
        This method has a parameter named “filter\_spec\_proc” but if you notice there is an ampersand preceding its declaration. This tells the Ruby interpreter to expect a Proc object to be passed in. Since we are expecting a Proc object all we have to do is use the &#8220;call&#8221; method and pass the products instance variable to the Proc. 
        
        Now let’s wire the whole thing together.
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">yellow_products = product_filter.by_proc(&YELLOW_COLOR_FILTER_SPEC)</pre>
        </div>
        
        Pretty simple about the only thing you have to remember is that you have to place the ampersand before the Proc constant when you call the “by_proc” method on the ProductFilter class. 
        
        #### But wait there is more!
        
        Our ProductFilter class now has a method that accepts a Proc object. In our previous example we passed it a constant that referenced a lambda Proc block. But since it accepts a Proc we can simply write the block in line with the method call like this. 
        
        With our new found knowledge lets filter all the “Red” products.
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none">red_products = product_filter.by_proc <span style="color: #0000ff">do</span> |products|
        products.select{|product| product.color == <span style="color: #006080">"Red"</span>}
    end</pre>
        </div>
        
        Parenthesis are optional in Ruby when you call a method. 
        
        Pretty nice huh? 
        
        Now for something really freaky for all you static type people! 
        
        Lets say you aren’t dealing with products anymore and you are dealing with Cars. 
        
        cars have 4 wheels but they also have color don’t they. Gee it would be nice if we could filter the Cars just like we are able to filter the Products. Wait! We can, we already wrote it! 
        
        We have that “Item\_color\_filter\_spec” class. We could use the ProductFilter class but that class already has a purpose but the “Item\_color\_filter\_spec” is pretty agnostic.
        
        <div>
          <pre style="padding-right: 0px;padding-left: 0px;font-size: 8pt;padding-bottom: 0px;margin: 0em;overflow: visible;width: 100%;color: black;border-top-style: none;line-height: 12pt;padding-top: 0px;font-family: consolas, 'Courier New', courier, monospace;border-right-style: none;border-left-style: none;background-color: #f4f4f4;border-bottom-style: none"><span style="color: #0000ff">class</span> Car
    attr_accessor :color
    def initialize(color)
        @color = color
    end
end

cars = [
    Car.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Red"</span>),
    Car.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Blue"</span>),
    Car.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Red"</span>),
    Car.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Blue"</span>)
]

blue_filter = Item_color_filter_spec.<span style="color: #0000ff">new</span>(<span style="color: #006080">"Blue"</span>)
blue_cars = blue_filter.apply_to(cars)</pre>
        </div>
        
        Wow talk about reuse!!! 
        
        How is this possible? Well remember types do not exist in Ruby. There are objects but objects are <a href="http://en.wikipedia.org/wiki/Duck_typing" target="_blank">duck typed</a> when you ask them to perform an action. Meaning if it walks like a duck or quacks like a duck it must be a duck. The “Item\_color\_filter_spec” only cares that it is passed an array of objects. It is then going to iterate over the array of objects and call the “color” accessor on each object to check for equality against the instance variable that was passed in through the constructor. It doesn’t care if the array contains cars, products or both; just that whatever object it is has to have an accessor of &#8220;color.&#8221; 
        
        I know this is a ton on information to digest all at once but I am just very passionate about the Ruby language. I see tremendous potential in its future especially with its entrance into the .Net space through the <a href="http://www.ironruby.net/" target="_blank">IronRuby</a> project. I can easily see it over throwing the Visual Basic crowd once it becomes more main stream in the .Net community.