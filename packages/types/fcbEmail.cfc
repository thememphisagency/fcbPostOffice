<cfcomponent name="fcbEmail" displayname="Email" hint="Used to automate the sending of emails" extends="farcry.core.packages.types.types" bAsbtract="true">

	<cfproperty name="to" hint="" type="string" default="" />
	<cfproperty name="from" hint="" type="string" default="" />
	<cfproperty name="cc" hint="" type="string" default="" />
	<cfproperty name="bcc" hint="" type="string" default="" />
	<cfproperty name="subject" hint="" type="longchar" default="" />
	<cfproperty name="body" hint="" type="longchar" default="" />

	<cffunction name="init" returntype="fcbEmail" access="public">
		
		<cfargument name="to" type="string" required="true" />
		<cfargument name="from" type="string" required="true" />
		<cfargument name="subject" type="string" required="true" />
		<cfargument name="body" type="string" required="false" default="" />
		<cfargument name="cc" type="string" required="false" default="" />
		<cfargument name="bcc" type="string" required="false" default="" />

		<cfscript>
			
			this.to = arguments.to;
			this.from = arguments.from;
			this.subject = arguments.subject;
			this.body = arguments.body;
			this.cc = arguments.cc;
			this.bcc = arguments.bcc;

		</cfscript>

		<!--- arguments.to needs to be a list of valid email address(es) --->
		<cfif not this.checkForValidEmails(arguments.to)>
			<cfthrow type="Application" detail="All email addresses supplied need to be valid." />
		</cfif>

		<!--- strip any addresses from the to field, that also exist in the bcc field --->
		<cfset this.to = this.stripValuesFromList(this.to, this.bcc) />

		<cfreturn this />

	</cffunction>

	<cffunction name="send" returntype="void" access="public">
		
		<cfargument name="bLog" type="boolean" required="false" default="true" />

		<!--- check the body has a length --->
		<cfif not len(this.body)>
			<cfthrow type="Application" detail="You can't send an email without a body." />
		</cfif>

		<!--- let's send the email and log it if required --->

		<!--- do we need to log the email? --->
		<cfif arguments.bLog>
			
			<!--- create the log and go for it --->

		</cfif>

	</cffunction>

	<cffunction name="checkForValidEmails" returntype="boolean" access="package">
		
		<cfargument name="emails" type="string" required="true" />

		<cfset var bReturn = true />

		<cfloop list="#arguments.emails#" index="email">
			<cfif not this.checkForValidEmail(email)>
				<cfset bReturn = false />
			</cfif>
		</cfloop>

		<cfreturn bReturn />

	</cffunction>

	<cffunction name="checkForValidEmail" returntype="boolean" access="package">
		
		<cfargument name="email" type="string" required="true" />

		<cfreturn isValid('email', arguments.email) />

	</cffunction>

	<cffunction name="stripValuesFromList" returntype="string" access="package">
		
		<cfargument name="list" type="string" required="true" />
		<cfargument name="listRemove" type="string" required="true" />

		<cfset lReturn = arguments.list />

		<!--- strip any values from one list, that appear in another --->
		<cfif len(arguments.list)>

			<cfset lReturn = '' />

			<cfloop list="#arguments.list#" index="val">
				<cfif not listContainsNoCase("#arguments.listRemove#", val)>
					<cfset lReturn = listAppend(lReturn, val) />
				</cfif>
			</cfloop>
			
		</cfif>

		<cfreturn lReturn />

	</cffunction>

</cfcomponent>