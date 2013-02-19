---
layout: page
title: "Coffeescript"
date: 2013-02-08 11:34
comments: true
sharing: true
footer: true
---

## func

`-> "Hello, ET!"`

## jQuery & ajax

{% highlight coffeescript %}
$ ?= require 'jquery' # For Node.js compatibility

$(document).ready ->
	# Basic Examples
	$.get '/', (data) ->
		$('body').append "Successfully got the page."

	$.post '/',
		userName: 'John Doe'
		favoriteFlavor: 'Mint'
		(data) -> $('body').append "Successfully posted to the page."

	# Advanced Settings
	$.ajax '/',
		type: 'GET'
		dataType: 'html' error: (jqXHR, textStatus, errorThrown) ->
			$('body').append "AJAX Error: #{textStatus}"
		success: (data, textStatus, jqXHR) ->
			$('body').append "Successful AJAX call: #{data}"
{% endhighlight %}
