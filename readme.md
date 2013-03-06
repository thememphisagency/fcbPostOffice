fcbPostOffice
=============

> fcbPostOffice is an email framework, for anything and everything to do with sending emails inside the FarCry framework. This document outlines what will be capable with fcbPostOffice.

Features
--------

* All emails sent using the framework should be logged.
* All emails should use a webskin, like any other display oriented object.

Installation
------------

* clone this repository using GIT to your local computer
* open farcryConstructor.cfm and add ",fcbpostoffice,fcbhistory,testmxunit" to the `THIS.plugins` variable

Dependencies
------------

* fcbHistory

Basic usage
-----------

	<cfimport path="farcry.plugins.fcbpostoffice.packages.fcb.fcbEmail" />

	<cfset var oEmail = new fcbEmail(
			to = 'to@domain.com',
			from = 'sender@domain.com',
			subject = 'email subject',
			body = 'email body'
		) />

	<!--- send the email --->
	<cfset logObjectid = oEmail.send() />

To send without logging an email:

	<!--- send without logging --->
	<cfset oEmail.send() />

You can also define the following properties for the email:

	<cfset var oEmail = new fcbEmail(
		to = 'to@domain.com',
		from = 'sender@domain.com',
		subject = 'email subject',
		body = 'email body',
		cc = 'cc@domain.com',
		bcc = 'bcc@domain.com'
	) />
