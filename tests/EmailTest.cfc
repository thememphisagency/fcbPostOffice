<cfcomponent extends="mxunit.framework.TestCase">

	<cfimport path="farcry.plugins.fcbpostoffice.packages.types.fcbEmail" />

	<!--- setup and teardown --->
	<cffunction name="setUp" returntype="void" access="public">

		<!--- let the framework do its thing --->
		<cfset super.setUp() />

		<!--- defined a standard email struct --->
		<cfscript>
			stDefault = {};
			stDefault.to = 'log@thememphisagency.com';
			stDefault.from = 'EmailTestCase';
			stDefault.subject = 'EmailTestCase Subject';
			stDefault.body = 'EmailTestCase Body';
		</cfscript>

	</cffunction>

	<!--- cffunction name="tearDown" returntype="void" access="public">
		<!--- Any code needed to return your environment to normal goes here --->
	</cffunction --->

	<cffunction name="should_be_able_create_email_stub" returntype="void" access="public">
		
		<cfset var oExpected = {} />
		<cfset var oEmail = {} />

		<cfscript>
			oExpected.to = 'scott@scottmebberson.com';
			oExpected.from = 'Scott Mebberson';
			oExpected.subject = 'Subject of my test email';
			oExpected.body = 'Body of my email';
			oExpected.bcc = 'scott@mebberson.com';
		</cfscript>

		<cfset oEmail = new fcbEmail(to = oExpected.to, from = oExpected.from, subject = oExpected.subject, body = oExpected.body, bcc = oExpected.bcc) />

		<cfset assertEquals(oExpected.to, oEmail.to) />
		<cfset assertEquals(oExpected.from, oEmail.from) />
		<cfset assertEquals(oExpected.subject, oEmail.subject) />
		<cfset assertEquals(oExpected.body, oEmail.body) />
		<cfset assertEquals(oExpected.bcc, oEmail.bcc) />

	</cffunction>

	<cffunction name="should_automatically_strip_bcc_emails_from_to" returntype="void" access="public">
		
		<cfset var oExpected = {} />
		<cfset var oEmail = {} />

		<cfscript>
			oExpected.to = 'scott@scottmebberson.com';
			oExpected.from = 'Scott Mebberson';
			oExpected.subject = 'Test subject';
			oExpected.body = 'Test body';
			oExpected.bcc = 'scott@mebberson.com';
		</cfscript>

		<cfset oEmail = new fcbEmail (
							to = 'scott@mebberson.com,scott@scottmebberson.com',
							from = oExpected.from,
							subject = oExpected.subject,
							body = oExpected.body,
							bcc = oExpected.bcc
						) />

		<cfset assertEquals(oExpected.to, oEmail.to) />
		<cfset assertEquals(oExpected.bcc, oEmail.bcc) />

	</cffunction>

	<cffunction name="when_creating_an_email_to_is_required" returntype="void" access="public" mxunit:expectedException="Application">
		
		<cfset var oEmail = new fcbEmail() />

	</cffunction>

	<cffunction name="when_creating_an_email_from_is_required" returntype="void" access="public" mxunit:expectedException="Application">
		
		<cfset var oEmail = new fcbEmail(to = 'scott@scottmebberson.com') />

	</cffunction>

	<cffunction name="when_creating_an_email_subject_is_required" returntype="void" access="public" mxunit:expectedException="Application">
		
		<cfset var oEmail = new fcbEmail(to = 'scott@scottmebberson.com', from = 'Scott Mebberson') />

	</cffunction>

	<cffunction name="creating_an_email_should_validate_email_address" returntype="void" access="public" mxunit:expectedException="Application">
		
		<cfset var oEmail = new fcbEmail(to = 'scott@scottmebberson', from = 'Scott Mebberson', subject = 'Test subject') />

	</cffunction>

	<cffunction name="wont_send_an_email_without_a_body" returntype="void" access="public" mxunit:expectedException="Application">
		
		<cfset var oEmail = new fcbEmail(
				to = stDefault.to,
				from = stDefault.from,
				subject = stDefault.subject
			) />

		<!--- guard, ensure we have an fcbEmail record without a body --->
		<cfset assertIsEmpty(oEmail.body) />

		<!--- try and send the email without a body, it should fail --->
		<cfset oEmail.send() />

	</cffunction>
	
</cfcomponent>