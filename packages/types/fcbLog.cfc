<cfcomponent output="false" extends="farcry.core.packages.types.types" displayname="Application Log" hint="A log record to store into the database" bObjectBroker="false" bSystem="false" bAudit="false" bRefObjects="false">

	<cfproperty ftSeq="1" ftLabel="Reference" name="reference" type="string" ftType="string" ftDisplayOnly="true" default="" ftDefault="" required="false" />
	<cfproperty ftSeq="2" ftLabel="Title" name="title" type="string" ftType="string" bLabel="true" ftDisplayOnly="true" default="" ftDefault="" required="false" />
	<cfproperty ftSeq="3" ftLabel="Data" name="data" type="longchar" ftType="" ftDisplayOnly="true" default="" ftDefault="" required="false" />

	<cffunction name="createData" access="public" returntype="any" output="true" hint="Creates an instance of an object">
		<cfargument name="stProperties" type="struct" required="true" hint="Structure of properties for the new object instance">
		<cfargument name="user" type="string" required="true" hint="Username for object creator" default="">
		<cfargument name="auditNote" type="string" required="true" hint="Note for audit trail" default="Created">
		<cfargument name="dsn" required="No" default="#application.dsn#">
		<cfargument name="bAudit" type="boolean" default="true" required="false" hint="Set to false to disable logging" />

		<cfset var stObj = {} />

		<cfset arguments.stProperties.title = 'Log created by #arguments.stProperties.reference#' />
		<cfset stObj = super.createData(
				stProperties = arguments.stProperties,
				user = arguments.user,
				auditNote = arguments.auditNote,
				dsn = arguments.dsn,
				bAudit = arguments.bAudit
			) />

		<cfreturn stObj>

	</cffunction>

	<cffunction name="setData" access="public" output="true" hint="Update the record for an objectID including array properties.  Pass in a structure of property values; arrays should be passed as an array.">
		<cfargument name="stProperties" required="true">
		<cfargument name="user" type="string" required="true" hint="Username for object creator" default="">
		<cfargument name="auditNote" type="string" required="true" hint="Note for audit trail" default="Updated">
		<cfargument name="bAudit" type="boolean" required="No" default="1" hint="Pass in 0 if you wish no audit to take place">
		<cfargument name="dsn" required="No" default="#application.dsn#">
		<cfargument name="bSessionOnly" type="boolean" required="false" default="false"><!--- This property allows you to save the changes to the Temporary Object Store for the life of the current session. ---> 
		<cfargument name="bAfterSave" type="boolean" required="false" default="true" hint="This allows the developer to skip running the types afterSave function.">	
		<cfargument name="bSetDefaultCoreProperties" type="boolean" required="false" default="true" hint="This allows the developer to skip defaulting the core properties if they dont exist.">	
		<cfargument name="previousStatus" type="string" required="false" default="" />

		<cfset var stObj = {} />

		<cfset arguments.stProperties.title = 'Log created by #arguments.stProperties.reference#' />
		<cfset stObj = super.setData(
				stProperties = arguments.stProperties,
				user = arguments.user,
				auditNote = arguments.auditNote,
				bAudit = arguments.bAudit,
				dsn = arguments.dsn,
				bSessionOnly = arguments.bSessionOnly,
				bAfterSave = arguments.bAfterSave,
				bSetDefaultCoreProperties = arguments.bSetDefaultCoreProperties,
				previousStatus = arguments.previousStatus
			) />

		<cfreturn stObj>

	</cffunction>

</cfcomponent>