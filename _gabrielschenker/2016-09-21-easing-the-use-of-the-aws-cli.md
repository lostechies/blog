---
id: 1846
title: Easing the use of the AWS CLI
date: 2016-09-21T09:32:06+00:00
author: Gabriel Schenker
layout: post
guid: https://lostechies.com/gabrielschenker/?p=1846
dsq_thread_id:
  - "5161797001"
categories:
  - containers
  - docker
tags:
  - containers
  - Docker
  - script
  - time-saver
  - utility
---
[<img src="https://lostechies.com/gabrielschenker/files/2016/09/time_snapseed.jpg" alt="" title="time_snapseed" width="283" height="283" class="alignleft size-full wp-image-1849" />](https://lostechies.com/gabrielschenker/files/2016/09/time_snapseed.jpg) This post talks about a little welcome time-saver and how we achieved it by using Docker.

In our company we work a lot with AWS and since we automate everything we use the AWS CLI. To make the usage of the CLI as easy and frictionless as possible we use Docker. Here is the `Dockerfile` to create a container having the AWS CLI installed

[gist id=e4015d5e8dbc27f12c229efebf0617f2]

Note that we need to provide the three environment variables `AWS_DEFAULT_REGION`, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` set in the container such as that the CLI can automatically authenticate with AWS.

> **Update**: a few people rightfully pointed out that one should never ever
    
> disclose secrets in the public, ever! And I agree 100% with this. In
    
> this regard my post was a bit misleading and my &#8220;Note:&#8221; further down
    
> not explicit enough. My fault, I agree. Thus let me say it loudly
    
> here: &#8220;Do not push any image that contains secrets to a public
    
> registry like Docker Hub!&#8221; Leave the Dockerfile from above as is
    
> without modifications and pass the real values of the secrets when
    
> running a container, as command line parameters as shown further down

Let&#8217;s build and push this container to Docker Hub

`docker build -t gnschenker/awscli`

to push to Docker Hub I of course need to be logged in. I can use `docker login` to do so. Now pushing is straight forward

`docker push gnschenker/awscli:latest`

**Note**: I do not recommend to hard-code the values of the secret keys into the `Dockerfile` but pass them as parameters when running the container. Do this

`docker run -it --rm -e AWS_DEFAULT_REGION='[your region] -e AWS_ACCESS_KEY_ID='[your access ID] -e AWS_SECRET_ACCESS_KEY='[your access key] gnschenker/awscli:latest`

Running the above command you find yourself running in a bash shell inside your container and can use the AWS CLI. Try to type something like this

`aws ecs list-clusters`

to get a list of all ECS clusters in your account.

To simplify my life I define an alias in my `bash` profile (file `~/.bash_profile`) for the above command. Let&#8217;s call it `awscli`.

[gist id=42610d1a9ad3c9d6f74fff95ddf3790e]

Once I have done that and sourced the profile I can now use the CLI e.g. like this

`awscli s3 ls`

and I get the list of all S3 buckets defined in my account.

Thanks to the fact that Docker containers are ephemeral by design they are really fast to startup (once you have the Docker image in you local cache) and thus using a container is similar in experience than natively installing the AWS CLI on you machine and using it.