---
id: 4732
title: Setting up Apache with SSL on Windows (for Subversion)
date: 2007-03-30T16:34:00+00:00
author: Nelson Montalvo
layout: post
guid: /blogs/nelson_montalvo/archive/2007/03/30/setting-up-apache-with-ssl-on-windows-for-subversion.aspx
categories:
  - NHibernate
---
Well, I finally decided to begin using [Subversion](http://subversion.tigris.org/) rather than my usual choice, [SourceGear Vault](http://www.sourcegear.com/vault/index.html), for source code control. Vault is great, but lately I&#8217;ve been finding the need to use Subversion and well&#8230; it&#8217;s free (but certainly not without its hassles).  
  
I decided to go the Apache route so as to be able to securely connect to my Subversion server via the Internet. The basic windows MSI installer of Subversion ([1.4.3](http://subversion.tigris.org/servlets/ProjectDocumentList?folderID=91) as of this posting) comes with a server application that runs as a service and it&#8217;s easy to setup&#8230; Tortoise can even connect to it using secure SSH, but I wanted to give Apache a shot. Looking back, I might stick to the basic install next time. 🙂  

  



  


  1. Use this [link](http://www.codeproject.com/aspnet/Subversion.asp) to get started. Be sure to grab Apache 2.0.59.  
      
    
  
      * Use this [link](http://tud.at/programm/apache-ssl-win32-howto.php3) to get setup the SSL version of Apache, located [here](http://hunter.campbus.com/). Download version 2.0.59 and simply extract the zipped files over the version of Apache downloaded in step 1.  
          
        Follow the instructions through Step 2 and you will now have the SSL capabilities to generate key files and certificates.  
          
        
  
          * Purchase a cert to make this official. I got mine from GoDaddy and used [these instructions](https://certificates.godaddy.com/CSRgeneration.go) to generate a CSR for Apache 2.x (using the windows version of OpenSSL, of course).  
              
            Otherwise, generate the test certificate.  
              
            
  
              * The only issues I had were:  
                  
                
  
                
  
                
                
                  * Pay careful attention to the error.log file in the Apache logs directory. It&#8217;ll help you to work out any issues.  
                      
                    
                
  
                
  
                
                
                  * The Windows version of Apache is retarded. Be sure to decrypt the key file prior to running Apache with SSL using the command: openssl rsa -in originalEncryptedKeyFile.key -out newDecryptedKeyFile.key  
                      
                    
  
                      * The SSLMutex parameter in the httpd.conf file is different. Set the SSLMutex parameter to &#8216;default&#8217;.  
                          
                        
  
                          * The SSLLog parameters in the httpd.conf file don&#8217;t seem to work anymore. Remove any reference to them.  
                              
                            
  
                              * In your virtual host entry in the httpd.conf file, set the ServerName to whatever your Canonical Name was in the certificate (foo.bar.com).</UL></OL>It&#8217;s late, I haven&#8217;t tested Subversion out yet. I&#8217;ll let you know tomorrow.
                          
                          
                        By the way, I&#8217;m running my version of Apache side-by-side with IIS, so I had to set the SSL port to 444. You can set that up in the http.conf file by setting up the ListenOn port to 444 and including the port number in your VirtualHost entry.</p>