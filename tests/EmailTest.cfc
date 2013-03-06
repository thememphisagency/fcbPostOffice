<cfcomponent extends="farcry.plugins.testmxunit.tests.FarCryTestCase">

	<cfimport path="farcry.plugins.fcbpostoffice.packages.fcb.fcbEmail" />

	<!--- setup and teardown --->
	<cffunction name="setUp" returntype="void" access="public">

		<!--- let the framework do its thing --->
		<cfset super.setUp() />

		<cfscript>
			/* define a standard email struct */
			stDefault = {};
			stDefault.to = 'log@thememphisagency.com';
			stDefault.from = 'log@thememphisagency.com';
			stDefault.subject = 'EmailTestCase Subject';
			stDefault.body = 'EmailTestCase Body';

			/* a reference to data that needs to be removed from the database */
			aPin = [];
		</cfscript>

	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public">

		<!--- if anything was inserted into the database, delete it --->
		<cfloop array="#aPin#" index="objectid">
			<!--- default to log, because that is the only thing that gets created within these tests --->
			<cfset application.fapi.getContentType('fcbLog').delete(objectid) />
		</cfloop>

	</cffunction>

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

	<cffunction name="creating_an_email_should_validate_email_addresses" returntype="void" access="public" mxunit:expectedException="Application">
		
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

	<cffunction name="test_dependency_fcbLog" returntype="void" access="public">
		
		<cfset assertContentTypeExists('fcbLog') />

	</cffunction>

	<cffunction name="test_package_only_helper_logEmail" returntype="void" access="public">
		
		<cfset var logObjectid = '' />

		<cfset var oEmail = new fcbEmail(
				to = stDefault.to,
				from = stDefault.from,
				subject = stDefault.subject,
				body = stDefault.body
			) />

		<cfset makePublic(oEmail, 'logEmail') />

		<!--- log the email --->
		<cfset logObjectid = oEmail.logEmail() />
		<cfset arrayAppend(aPin, logObjectid) />

		<!--- guard --->
		<cfset assertTrue(len(logObjectid)) />

		<!--- grab the record --->
		<cfset var oLog = application.fapi.getContentObject(logObjectid, 'fcbLog') />

		<!--- check it's been inserted into the database --->
		<cfset assertEquals(logObjectid, oLog.objectid) />
		<cfset assertEquals(stDefault, deserializeJSON(oLog.metadata)) />

	</cffunction>

	<cffunction name="should_send_an_email_and_log_it" returntype="void" access="public">
		
		<cfset var logObjectid = '' />

		<!--- make the subject unique for these purposes --->
		<cfset stDefault.subject = stDefault.subject & '-' & CreateUUID() />

		<cfset var oEmail = new fcbEmail(
				to = stDefault.to,
				from = stDefault.from,
				subject = stDefault.subject,
				body = stDefault.body
			) />

		<!--- send the email --->
		<cfset logObjectid = oEmail.send() />
		<cfset arrayAppend(aPin, logObjectid) />

		<!--- give coldfusion time to write the logs --->
		<cfset sleep(12000) />

		<!--- guard --->
		<cfset assertTrue(len(logObjectid)) />

		<!--- grab the record --->
		<cfset var oLog = application.fapi.getContentObject(logObjectid, 'fcbLog') />

		<!--- check it's been inserted into the database --->
		<cfset assertEquals(logObjectid, oLog.objectid) />
		<cfset assertEquals(stDefault, deserializeJSON(oLog.metadata)) />

		<!--- check the email has been sent --->
		<cfset assertTrue(checkLogs(stDefault.subject, stDefault.from), "subject #stDefault.subject#") />

	</cffunction>

	<cffunction name="should_send_an_email_and_not_log_it" returntype="void" access="public">
		
		<cfset var logObjectid = '' />

		<!--- make the subject unique for these purposes --->
		<cfset stDefault.subject = stDefault.subject & '-' & CreateUUID() />

		<cfset var oEmail = new fcbEmail(
				to = stDefault.to,
				from = stDefault.from,
				subject = stDefault.subject,
				body = stDefault.body
			) />

		<!--- send the email --->
		<cfset logObjectid = oEmail.send(false) />

		<!--- give coldfusion time to write the logs --->
		<cfset sleep(12000) />

		<!--- guard --->
		<cfset assertFalse(len(logObjectid)) />

		<!--- check the email has been sent --->
		<cfset assertTrue(checkLogs(stDefault.subject, stDefault.from), 'subject: #stDefault.subject#') />

	</cffunction>

	<cffunction name="test_package_only_helper_stripValuesFromList">
		
		<cfset var list1 = 'a,b,c,d,e' />
		<cfset var list2 = 'c,d' />

		<cfset var oEmail = new fcbEmail(
				to = stDefault.to,
				from = stDefault.from,
				subject = stDefault.subject
			) />

		<cfset makePublic(oEmail, "stripValuesFromList") />

		<cfset assertEquals('a,b,e', oEmail.stripValuesFromList(list1, list2)) />

	</cffunction>

	<cffunction name="test_package_only_helper_checkForValidEmail">

		<cfset var oEmail = new fcbEmail(
				to = stDefault.to,
				from = stDefault.from,
				subject = stDefault.subject
			) />

		<cfset makePublic(oEmail, "checkForValidEmail") />

		<cfset assertTrue(oEmail.checkForValidEmail('log@thememphisagency.com')) />
		<cfset assertTrue(oEmail.checkForValidEmail('log@thememphisagency.com.au')) />
		<cfset assertFalse(oEmail.checkForValidEmail('log@thememphisagency')) />

	</cffunction>

	<cffunction name="checkLogs" returntype="boolean" access="private">
		
		<cfargument name="subject" type="string" required="true" />
		<cfargument name="from" type="string" required="true" />

		<cfset var bReturn = false />
		<cfset var logFile = Server.ColdFusion.RootDir & "/logs/mailsent.log">
		<cfset var logContent = '' />
		<cfset var regex = """Mail: '#arguments.subject#' From:'#arguments.from#'" />

		<cfif fileExists(logFile)>
			<cfset logContent = FileRead(logFile) />
		</cfif>

		<cfreturn ArrayLen(reMatchNoCase(regex, logContent)) GT 0 />

	</cffunction>
	
</cfcomponent>