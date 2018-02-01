---
id: 447
title: Model View Presenter Styles
date: 2008-11-23T19:13:00+00:00
author: Derek Greer
layout: post
guid: http://www.aspiringcraftsman.com/2008/11/model-view-presenter-styles/
dsq_thread_id:
  - "317966714"
categories:
  - Uncategorized
tags:
  - Model-View-Presenter
---
## Introduction

The Model-View-Presenter pattern is an interactive application architecture pattern used to separate the concerns of an application’s data, presentation, and user input into specialized components. The article [Interactive Application Architecture Patterns](/2007/08/interactive-application-architecture.html) includes an introduction to the MVP pattern along with discussion of its history and pattern variations. In addition to the variations discussed therein, there also exists variation in how the pattern may be implemented. This article presents three styles for implementing the Model-View-Presenter pattern.

## The Encapsulated Presenter Style

The first of the styles considered here is what might be called the Encapsulated Presenter style. Following this style, the Presenter exists as an implementation detail of the View. The Presenter responds to event notifications from the Model, but is known only to the View to which it is assigned and consequently is only accessed directly by the View.

[<img class="aligncenter size-full wp-image-70" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/EncapsulatedPresenter.png" alt="" width="467" height="351" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/EncapsulatedPresenter.png)

Other components within the system requiring view-related data and/or behavior encapsulated within the Presenter will request access through a reference to the View. This results in consistent access to the encapsulated data and behavior, regardless of whether the access is triggered through the user interface or by other components within the system. One practical benefit gained through this approach is the ability to change the particular pattern used to segment presentation logic without affecting other components within the system. For instance, an application initially designed to use the Supervising Controller or Passive View variations of the MVP pattern may later be refactored to encapsulate both data and behavior using the Presentation Model pattern.

The following example demonstrates the Encapsulated Presenter style:

<pre class="brush:csharp">public interface IView
    {
        string Text { get; set; }

        void Show();
    }

    public class View : IView
    {
        Presenter presenter;

        public View() : this(new Presenter())
        {
        }

        public View(Presenter presenter)
        {
            this.presenter = presenter;
            presenter.View = this;
        }

        #region IView Members

        public string Text { get; set; }

        public void Show()
        {
            presenter.OnShow();

            Console.WriteLine("Current Time: " + Text);
        }

        #endregion

        protected void Button_Click(object sender, EventArgs e)
        {
            presenter.OnButtonClick();
        }
    }

    public class Presenter
    {
        IModel model;

        public Presenter() : this(new Model())
        {
        }

        public Presenter(IModel model)
        {
            this.model = model;
            model.TextChanged += new EventHandler(model_TextChanged);
        }

        public IView View { get; set; }

        void model_TextChanged(object sender, EventArgs e)
        {
            View.Text = model.Text;
        }

        internal void OnButtonClick()
        {
            model.Text = "Button Clicked";
        }

        internal void OnShow()
        {
            // Update view when shown
            View.Text = model.Text;
        }
    }

    public interface IModel
    {
        string Text { get; set; }
        event EventHandler TextChanged;
    }

    public class Model : IModel
    {
        string text;

        public event EventHandler TextChanged = delegate { };

        public string Text
        {
            get { return text ?? (text = DateTime.Now.ToString()); }

            set
            {
                text = value;
                TextChanged(this, EventArgs.Empty);
            }
        }
    }
</pre>

In this example, a View provides constructors for being instantiated with either a default or provided instance of the Presenter. The View then sets its private Presenter instance used later for delegation and sets the Presenter’s View property to itself. The View also contains a Button_Click() event handler representing the initial interceptor for a button control. When invoked, this handler delegates control to the Presenter.OnButtonClick() method.

The Presenter likewise provides constructors for being instantiated with either a default or provided instance of the Model and registers to receive event notifications when the Model changes. When notified, the Presenter updates the Text property of the View.

The following is a test for the presentation logic contained within the Presenter:

<pre class="brush:csharp">[TestClass]
    public class ViewTest
    {
        [TestMethod]
        public void PresenterShouldUpdateViewOnModelChange()
        {
            var model = new Model {Text = "Initial value"};
            var view = new StubView();
            var presenter = new Presenter(model);
            presenter.View = view;
            model.Text = "Changed value";
            Assert.AreEqual(view.Text, "Changed value");
        }
    }

    class StubView : IView
    {
        public string Text { get; set; }

        public void Show()
        {
        }
    }
</pre>

The following code snippet demonstrates how a View might be accessed using the Encapsulated Presenter style:

<pre class="brush:csharp">class Program
    {
        static void Main(string[] args)
        {
            // Show the view
            var view = new View();
            view.Show();

            // Retrieve the view state
            string text = view.Text;

            Console.WriteLine("View text: " + text);
            Console.ReadKey(true);
        }
    }
</pre>

## The Encapsulated View Style

The next style considered will be referred to here as the Encapsulated View style. Following this style, the Presenter serves as an interface to view-related data and behavior accessed by other components within the application. In addition to decoupling the presentation logic from the View, this assigns a form of Page Controller responsibility to the Presenter. As with Page Controller, the Presenter in this style provides input control for views when accessed by other components.

[<img class="aligncenter size-full wp-image-71" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/EncapsulatedView.png" alt="" width="476" height="350" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/EncapsulatedView.png)

While the View continues to delegate user input requests to the Presenter, other components within the system interact with view-related data and/or behavior through a reference to the Presenter. One of the benefits of this approach is that it eliminates the need to expose delegating properties or methods on the View which are not otherwise required by the user interface. For example, given a View which presents a selection dialog of mailing addresses associated with a specific customer, this approach would allow other components to call a method directly on the Presenter to display the selection for a given customer number. By allowing access to the Presenter directly, the View interface is free from the need of exposing any properties or methods not directly concerned with the visual display of the application.

The following example demonstrates the Encapsulated View style using an explicit delegation approach:

<pre class="brush:csharp">public interface IView
    {
        IPresenter Presenter { get; set; }
        string Text { get; set; }
        void Show();
    }

    public class View : IView
    {
        public View()
        {
        }

        public IPresenter Presenter { get; set; }
        public string Text { get; set; }

        public void Show()
        {
            Console.WriteLine("Current Time: " + Text);
        }

        protected void Button_Click(object sender, EventArgs e)
        {
            Presenter.OnButtonClick();
        }
    }

    public interface IPresenter
    {
        string Text { get; set; }
        void ShowView();
        void OnButtonClick();
    }

    public partial class Presenter : IPresenter
    {
        IModel model;
        IView view;

        public Presenter() : this(new View(), new Model())
        {
        }

        public Presenter(IView view) : this(view, new Model())
        {
        }

        public Presenter(IView view, IModel model)
        {
            this.view = view;
            this.model = model;
            view.Presenter = this;
            model.TextChanged += new EventHandler(model_TextChanged);
        }

        public string Text
        {
            get { return view.Text; }

            set { view.Text = value; }
        }

        public void OnButtonClick()
        {
            model.Text = "Button Clicked";
        }

        public void ShowView()
        {
            // Update view when shown
            view.Text = model.Text;
            view.Show();
        }

        void model_TextChanged(object sender, EventArgs e)
        {
            view.Text = model.Text;
        }
    }

    public interface IModel
    {
        string Text { get; set; }
        event EventHandler TextChanged;
    }

    public class Model : IModel
    {
        string text;
        public event EventHandler TextChanged = delegate { };

        public string Text
        {
            get { return text ?? (text = DateTime.Now.ToString()); }

            set
            {
                text = value;
                TextChanged(this, EventArgs.Empty);
            }
        }
    }
</pre>

In this example, a Presenter provides constructors for being instantiated with default or provided instances of the View and Model. The Presenter sets its private View and Model instances, sets the View’s Presenter property to itself, and then registers to receive event notifications when the Model changes. When notified, the Presenter updates the Text property of the View.

As with the previous example, the View contains a Button_Click() event handler representing the initial interceptor for a button control. When invoked, it delegates control to the Presenter.OnButtonClick() method.

The following is a test for the presentation logic contained within the Presenter:

<pre class="brush:csharp">[TestClass]
    public class ViewTest
    {
        [TestMethod]
        public void PresenterShouldUpdateViewOnModelChange()
        {
            var model = new Model {Text = "Initial value"};
            var view = new StubView();
            var presenter = new Presenter(view, model);
            model.Text = "Changed value";
            Assert.AreEqual(view.Text, "Changed value");
        }
    }

    class StubView : IView
    {
        public IPresenter Presenter { get; set; }
        public string Text { get; set; }

        public void Show()
        {
        }
    }
</pre>

The following code snippet demonstrates how the View might be displayed using the Encapsulated View style:

<pre class="brush:csharp">public class Program
    {
        public static void Main(string[] args)
        {
            // Show the view
            var presenter = new Presenter();
            presenter.ShowView();

            // Retrieve the view state
            string text = presenter.Text;
            Console.WriteLine("View text: " + text);
            Console.ReadKey(true);
        }
    }
</pre>

While this approach eliminates the need to expose delegating methods on the View (often necessary with the Encapsulated Presenter style), it can result in an inverse need to provide wrapper methods on the Presenter for accessing view state. This can be observed in the above example with the Presenter’s Text property. Another approach taken is to provide direct access to the View as a public property of the Presenter. This, however, constitutes a Law of Demeter violation and as such is considered by some to be a poor programming practice.

## The Observing Presenter Style

The final style considered here will be referred to as the Observing Presenter style. Following this style, the Presenter is notified of pertinent activity within the View via the Observer Pattern. The View defines events or delegates to be raised in response to user interaction (or exposes event-raising components), while the Presenter registers for the appropriate events for handling the desired presentation logic.

[<img class="aligncenter size-full wp-image-72" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/ObservingPresenter.png" alt="" width="372" height="688" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/ObservingPresenter.png)

This style may be used alongside both the Encapsulated Presenter or Encapsulated View styles. When following the Encapsulated Presenter style, the end user and external components interact directly with the View which raises events handled by the Presenter. When following the Encapsulated View style, user interaction with the View raises events handled by the Presenter, while other components interact directly with the Presenter.

The benefit of the Observing Presenter style is that it completely decouples knowledge of the Presenter from the View making the View less susceptible to changes within the Presenter.

The following example demonstrates the Observing Presenter style with the View encapsulated by the Presenter:

<pre class="brush:csharp">public interface IView
    {
        string Text { get; set; }
        event EventHandler ButtonClick;
        void Show();
    }

    public class View : IView
    {
        public View()
        {
        }

        public event EventHandler ButtonClick;
        public string Text { get; set; }

        public void Show()
        {
            Console.WriteLine("Current Time: " + Text);
        }
    }

    public interface IPresenter
    {
        string Text { get; set; }
        void ShowView();
    }

    public partial class Presenter : IPresenter
    {
        IModel model;
        IView view;

        public Presenter() : this(new View(), new Model())
        {
        }

        public Presenter(IView view) : this(view, new Model())
        {
        }

        public Presenter(IView view, IModel model)
        {
            this.view = view;
            this.model = model;
            InitializeEvents();
        }

        public string Text
        {
            get { return view.Text; }
            set { view.Text = value; }
        }

        public void ShowView()
        {
            // Update view when shown
            view.Text = model.Text;
            view.Show();
        }

        void InitializeEvents()
        {
            model.TextChanged += new EventHandler(model_TextChanged);
            view.ButtonClick += new EventHandler(view_ButtonClick);
        }

        void view_ButtonClick(object sender, EventArgs e)
        {
            OnButtonClick();
        }

        void model_TextChanged(object sender, EventArgs e)
        {
            view.Text = model.Text;
        }

        protected virtual void OnButtonClick()
        {
            model.Text = "Button Clicked";
        }
    }

    public interface IModel
    {
        string Text { get; set; }
        event EventHandler TextChanged;
    }

    public class Model : IModel
    {
        string text;
        public event EventHandler TextChanged = delegate { };

        public string Text
        {
            get { return text ?? (text = DateTime.Now.ToString()); }

            set
            {
                text = value;

                TextChanged(this, EventArgs.Empty);
            }
        }
    }
</pre>

As with the first Encapsulated View example, this example contains a Presenter which provides constructors for being instantiated with default or provided instances of the View and Model. The Presenter sets its private View and Model instances, but this time registers to receive event notifications from both the Model and the View. When notified of changes within the Model, the Presenter updates the Text property of the View. When notified of user interaction on the View, the Model is updated.

The following is a test for the presentation logic contained within the Presenter:

<pre class="brush:csharp">[TestClass]
    public class ViewTest
    {
        [TestMethod]
        public void PresenterShouldUpdateViewOnModelChange()
        {
            var model = new Model {Text = "Initial value"};
            var view = new StubView();
            var presenter = new Presenter(view, model);
            model.Text = "Changed value";
            Assert.AreEqual(view.Text, "Changed value");
        }
    }

    class StubView : IView
    {
        public string Text { get; set; }
        public event EventHandler ButtonClick = delegate { };

        public void Show()
        {
        }

        public void OnButtonClick()
        {
            ButtonClick(this, EventArgs.Empty);
        }
    }
</pre>

The same code demonstrating how the View might be displayed using the Encapsulated View style applies equally for this example:

<pre class="brush:csharp">public class Program

  {

   public static void Main(string[] args)

      {

   // Show the view

          IPresenter presenter = new Presenter();

          presenter.ShowView();

   // Retrieve the view state

   string text = presenter.Text;

          Console.WriteLine("View text: " + text);

          Console.ReadKey(true);

      }

  }
</pre>

While use of the Observer Pattern further decouples the Presenter from the View, this can introduce some added complexity, particularly with respect to testing the behavior contained within the Presenter. Since event handlers are generally marked either private or protected, they are not readily accessible within a unit test. In general, testing the internals of a component is unnecessary since all behavior is normally exercised through the component’s public interface. Unfortunately, this is often not the case with delegates. A thorough discussion of testing non-public methods and event handlers is beyond the intended scope of this article. However, one approach that can be used for this type of testing is to provision delegate invocation through a testing stub.

In the following example, a Presenter contains an event handler which expects a custom EventArgs generic type containing a Data property of type string:

<pre class="brush:csharp">public class Presenter : IPresenter
    {
        // ...

        void view_ButtonClick(object sender, DataEventArgs&lt;string&gt; e)
        {
            OnButtonClick(e.Data);
        }

        protected virtual void OnButtonClick(string value)
        {
            model.Text = value;
        }

        // ...
    }
</pre>

By supplying a testing stub with a method for raising the event with an expected value, the resulting state can be tested without direct access to the Presenter method:

<pre class="brush:csharp">[TestClass]
    public class ViewTest
    {
        [TestMethod]
        public void OnButtonClickSetsExpectedValue()
        {
            var view = new StubView();
            var presenter = new Presenter(view);
            view.OnButtonClick("Expected Value");
            Assert.AreEqual(view.Text, "Expected Value");
        }
    }

    public class StubView : IView
    {
        public string Text { get; set; }

        public void Show()
        {
        }

        public event EventHandler&lt;string&gt; ButtonClick = delegate { };

        public void OnButtonClick(string value)
        {
            ButtonClick(this, new DataEventArgs&lt;string&gt;(value));
        }
    }
</pre>

## Conclusion

While there are several approaches to how one may implement the Model-View-Presenter pattern, the chosen approach is to some degree a matter of personal taste. That being said, each approach does have its pros and cons. When choosing one style over another, consider the impact the chosen approach will have on the style and level of testing to be performed along with the encapsulation requirements of the application.
