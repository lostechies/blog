---
wordpress_id: 452
title: An Introduction to the Managed Extensibility Framework
date: 2008-10-28T19:06:00+00:00
author: Derek Greer
layout: post
wordpress_guid: http://www.aspiringcraftsman.com/2008/10/an-introduction-to-the-managed-extensibility-framework/
dsq_thread_id:
  - "325603762"
categories:
  - Uncategorized
tags:
  - Managed Extensibility Framework
---
<span style="color: #ff0000">[Note: This article was based upon a very early preview of the Managed Extensibility Framework and may differ substantially from later releases.]</span>

## Introduction

Over the years applications have followed an increasing trend of providing the ability to extend their core features through the use of various extensibility mechanisms. From the Microsoft Office suite of applications, to Internet browsers, to instance messenger programs &#8230; virtually every application we use today offers some form of extensibility. Unfortunately, developing extensible applications on the .Net platform has always required development teams to provide their own infrastructure. That is, until now.

The [Managed Extensibility Framework](http://www.codeplex.com/MEF) is a new library being developed by Microsoft to support the creation of extensible applications on the .Net platform. The following is a brief introduction to the features within the Managed Extensibility Framework.

## Overview

The Managed Extensibility Framework provides an infrastructure for enabling an application to easily consume extensions by providing the ability to dynamically bind internal and add-in components together through contract-based declarations. The main types of components within the framework are the Container, the Catalog, and the composable Parts.

[<img class="aligncenter size-full wp-image-75" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/MEF1.png" alt="" width="468" height="108" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/MEF1.png)

## Container

The Container is responsible for managing the creation and composition of dependencies between parts. It is represented within the framework by the type CompositionContainer. This type implements an interface, ICompositionService, which can itself be added to the container for explicit use by Parts during the lifetime of the application.

## Catalogs

Catalogs are responsible for discovering dependencies between the registered Parts. All catalogs extend the abstract base type ComposablePartCatalog. There are currently four types of catalogs provided within MEF:

<table border="1" style="border: solid 1px black">
  <tr>
    <td>
      AttributedAssemblyPartCatalog
    </td>
    
    <td>
      provides discovery of Parts within a collection of types
    </td>
  </tr>
  
  <tr>
    <td>
      AttributedTypesPartCatalog
    </td>
    
    <td>
      provides discovery of Parts within a given assembly
    </td>
  </tr>
  
  <tr>
    <td>
      DirectoryPartCatalog
    </td>
    
    <td>
      provides discovery of Parts within a given file system directory
    </td>
  </tr>
  
  <tr>
    <td>
      AggregatingComposablePartCatalog
    </td>
    
    <td>
      provides the ability to combine multiple catalogs into a single composite catalog
    </td>
  </tr>
</table>

## Parts

Parts are the logical units of composition within MEF and are used to encapsulate information about types used during the composition process. Each Part is identified by a Contract and contains a list of Exports and Imports. Contracts take the form of a string identifier and are used to identify dependencies between Parts. Exports specify the services offered to other Parts, while Imports specify services required by other Parts.

[<img class="aligncenter size-full wp-image-76" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/MEF2.png" alt="" width="281" height="132" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/MEF2.png)

## Example Application &#8211; MefPad

The following example demonstrates the basic features of the Managed Extensibility Framework by walking through the creation of a simple text editor application which utilizes extensions as the file persistence mechanism.

### Step 1 &#8211; Project and Form Creation

  * Create a new Windows Forms Application project named &#8220;MefPad&#8221;.
  * Add a reference to the System.ComponentModel.Composition assembly.
  * Rename &#8220;Form1.cs&#8221; to &#8220;MefPad.cs&#8221;.
  * Add a MenuStrip control docked at the top.
  * Add a top level menu item named &#8220;File&#8221;.
  * Add a submenu item under &#8220;File&#8221; named &#8220;Open&#8221;.
  * Double-click on the &#8220;Open&#8221; menu item to auto-create a Click event handler.
  * Return to the designer and add another submenu item under &#8220;File&#8221; named &#8220;Save&#8221;.
  * Double-click on the &#8220;Save&#8221; menu item to auto-create a Click event handler.
  * Return to the designer and add a TextBox control named &#8220;mainContentTextBox&#8221;.
  * Change the Dock property to &#8220;Fill&#8221;.

The following illustrates the resulting MefPad form design:

[<img class="aligncenter size-full wp-image-77" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/MefPad1.png" alt="" width="309" height="313" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/MefPad1.png)

### Step 2 &#8211; Configure MEF Container

  * Add the following call to Compose() in the MefPad constructor:

<pre class="brush:csharp">public MefPad()
        {
            InitializeComponent();
            Compose();
        }
</pre>

  * Add the following method:

<pre class="brush:csharp">void Compose()
        {
            // search currently directory for extension assemblies
            var catalog = new DirectoryPartCatalog(".", "*Extensions.dll", true);
            var container = new CompositionContainer(catalog);
            container.AddPart(this);
            container.Compose();
        }
</pre>

This method uses a DirectoryPartCatalog to discover any MefPad extensions. In this case, the catalog will discover any assemblies in the current executing directory whose name ends with &#8220;Extensions.dll&#8221;. Next, a CompositionContainer is instantiated with the catalog. The MefPad Form (i.e. &#8220;this&#8221;) is then added as a Part to the container. This will allow any Exports or Imports within the MefPad class to be discovered by the container. Finally, the container is directed to compose all Parts.

### Step 3 &#8211; Define an Extension

  * Create a new interface type named IFilePersistenceExtension:

<pre class="brush:csharp">using System.IO;

namespace MEFPad
{
    public interface IFilePersistenceExtension
    {
        /// &lt;summary&gt;
        /// Description of the file type.
        /// &lt;/summary&gt;
        string Description { get; }

        /// &lt;summary&gt;
        /// The extension of the file type.
        /// &lt;/summary&gt;
        string Extension { get; }

        /// &lt;summary&gt;
        /// Reads from an open stream.
        /// &lt;/summary&gt;
        /// &lt;param name="stream"&gt;An open &lt;see cref="Stream"/&gt;&lt;/param&gt;
        /// &lt;returns&gt;character array of text read.&lt;/returns&gt;
        char[] Read(Stream stream);

        /// &lt;summary&gt;
        /// Writes to an open stream.
        /// &lt;/summary&gt;
        /// &lt;param name="stream"&gt;An open &lt;see cref="Stream"/&gt;&lt;/param&gt;
        /// &lt;param name="text"&gt;The text to be written to the stream&lt;/param&gt;
        void Write(Stream stream, char[] text);
    }
}
</pre>

This interface defines the types which MefPad will use for reading and saving files to disk. The Description and Extension properties will be used by the file dialog box presented to the user while the Read() and Write() methods will be used to open and save files respectively.

### Step 4 &#8211; Create an Import

  * Add the following property to the MefPad class:

<pre class="brush:csharp">[Import]
        public List&lt;IFilePersistenceExtension&gt; FilePersistenceExtensions { get; set; }
</pre>

This property will contain the collection of IFilePersistenceExtension types which will be presented as file type options to the user. The [Import] attribute is used to indicate that the MefPad Part has a dependency upon IFilePersistenceExtension types. Upon discovering any Parts with a contract of this type within the Catalog, the Container will add instances of the Part to the FilePersistenceExtensions collection.

### Step 5 &#8211; Create the Business Logic

  * Add the following method to the MefPad.cs class:

<pre class="brush:csharp">T GetFileDialog() where T : FileDialog, new()
        {
            var fileDialog = new T();
            var fileTypesBuffer = new StringBuilder();

            if (FilePersistenceExtensions != null)
                FilePersistenceExtensions
                    .ForEach(x =&gt;
                             fileTypesBuffer.Append(string.Format("{0}{1}|*{2}",
                                                                  (fileTypesBuffer.Length == 0)
                                                                      ? null
                                                                      : "|", x.Description,
                                                                  x.Extension)));

            fileDialog.Filter = fileTypesBuffer.ToString();
            return fileDialog;
        }
    }
</pre>

This method provides the common setup behavior used when configuring the open and save dialog boxes to be presented to the user. The ForEach() method is used to add file types to the dialog filter.

  * Replace the openToolStripMenuItem\_Click() and saveToolStripMenuItem\_Click() event handler methods with the following code:

<pre class="brush:csharp">void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Stream stream;
            OpenFileDialog openFileDialog = GetFileDialog&lt;OpenFileDialog&gt;();

            if (openFileDialog.ShowDialog() == DialogResult.OK)
            {
                if ((stream = openFileDialog.OpenFile()) != null)
                {
                    char[] content = FilePersistenceExtensions[openFileDialog.FilterIndex - 1].Read(stream);
                    mainContentTextBox.Text = new String(content);
                    stream.Close();
                }
            }
        }

        void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Stream stream;
            SaveFileDialog saveFileDialog = GetFileDialog&lt;SaveFileDialog&gt;();

            if (saveFileDialog.ShowDialog() == DialogResult.OK)
            {
                if ((stream = saveFileDialog.OpenFile()) != null)
                {
                    FilePersistenceExtensions[saveFileDialog.FilterIndex - 1].Write(stream, mainContentTextBox.Text.ToCharArray());
                    stream.Close();
                }
            }
        }
</pre>

These methods handle the &#8220;Open&#8221; and &#8220;Save&#8221; Click menu item events respectively. The openToolStripMenuItem\_Click() method calls the Read() method of the IFilePersistenceExtension instance corresponding to the selected filter index. Likewise, the saveToolSripMenuItem\_Click() method calls the Write() method of the IFilePersistenceExtension instance corresponding to the selected filter index.

### Step 6 &#8211; Create the Extensions

  * Create a new Class Library project named MefPadExtensions.
  * Add a reference to the MefPad project.
  * Add a reference to the System.ComponentModel.Composition.
  * Change the build output folder to ..MEFPadbinDebug.
  * Create a new class named TextFilePersistenceExtension with the following source:

<pre class="brush:csharp">using System.IO;

namespace MEFPadExtensions
{
    [Export(typeof (IFilePersistenceExtension))]
    public class TextFileSaverExtension : IFilePersistenceExtension
    {
        public string Description
        {
            get { return "Text file"; }
        }

        public string Extension
        {
            get { return ".txt"; }
        }

        public char[] Read(Stream stream)
        {
            var streamReader = new StreamReader(stream);
            string bytes;

            try
            {
                bytes = streamReader.ReadToEnd();
                return bytes.ToCharArray();
            }

            finally
            {
                streamReader.Close();
                stream.Close();
            }
        }

        public void Write(Stream stream, char[] text)
        {
            var streamWriter = new StreamWriter(stream);

            try
            {
                streamWriter.Write(text);
            }
            finally
            {
                streamWriter.Close();
                stream.Close();
            }
        }
    }
}
</pre>

This class provides the MefPad application with simple file persistence capabilities.

  * Create a new class named EncryptedFilePersistenceExtension with the following source:

<pre class="brush:csharp">using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace MEFPadExtensions
{
    [Export(typeof (IFilePersistenceExtension))]
    public class EncryptedFilePersistenceExtension : IFilePersistenceExtension
    {
        readonly byte[] iv = Encoding.ASCII.GetBytes("ABCDEFGHIJKLMNOP");
        readonly byte[] key = Encoding.ASCII.GetBytes("ABCDEFGHIJKLMNOP");

        public string Description
        {
            get { return "Encrypted"; }
        }

        public string Extension
        {
            get { return ".crypt"; }
        }

        public char[] Read(Stream stream)
        {
            Rijndael rijndael = Rijndael.Create();
            var cryptoStream = new CryptoStream(stream,
                                                rijndael.CreateDecryptor(key, iv),
                                                CryptoStreamMode.Read);
            var streamReader = new StreamReader(cryptoStream);
            string bytes;

            try
            {
                bytes = streamReader.ReadToEnd();
                return bytes.ToCharArray();
            }
            finally
            {
                streamReader.Close();
                cryptoStream.Close();
                stream.Close();
            }
        }

        public void Write(Stream stream, char[] text)
        {
            Rijndael rijndael = Rijndael.Create();
            var cryptoStream = new CryptoStream(stream,
                                                rijndael.CreateEncryptor(key, iv),
                                                CryptoStreamMode.Write);
            var streamWriter = new StreamWriter(cryptoStream);

            try
            {
                streamWriter.Write(text);
            }
            finally
            {
                streamWriter.Close();
                cryptoStream.Close();
                stream.Close();
            }
        }
    }
}
</pre>

This class provides the MefPad application with encrypted file persistence capabilities.

### Step 7 &#8211; Run the Application

  * Start the application and enter some text into the text box.

[<img class="aligncenter size-full wp-image-78" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/MefPad2.png" alt="" width="351" height="325" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/MefPad2.png)

  * From the menu bar, select File -> Save

[<img class="aligncenter size-full wp-image-79" src="http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/MefPad3.png" alt="" width="881" height="603" />](http://www.aspiringcraftsman.com/wp-content/uploads/2010/01/MefPad3.png)

Notice in the Save as type: dropdown box that two choices are presented: &#8220;Text file&#8221; and &#8220;Encrypted&#8221;. Selecting each of these types will result in the entered text being saved using the corresponding extension. The source for this example can be downloaded here.

### Conclusion

The Managed Extensibility Framework provides developers with the tools needed to easily create extensible .Net applications. Moreover, its future ubiquitous presence as an option for enabling extensibility will provide a readily accessible solution across projects and companies. By leveraging MEF for your extensibility needs, you&#8217;ll be able to focus less on the concerns of infrastructure development and more on simply creating great software for your company.
