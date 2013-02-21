<cfcomponent extends="farcry.plugins.testmxunit.tests.FarcryTestCase">

	<!--- setup and teardown --->
	<cffunction name="setUp" returntype="void" access="public">

		<!--- let the framework do its thing --->
		<cfset super.setUp() />

		<!--- defined a standard email struct --->
		<cfscript>

			stData = {};
			stData.foo = 'bar';

			stDefault = {};
			stDefault.reference = 'LogTest';
			stDefault.title = 'EmailTestCase';
			stDefault.data = SerializeJSON(stData);
		</cfscript>

	</cffunction>

	<!--- cffunction name="tearDown" returntype="void" access="public">
		<!--- Any code needed to return your environment to normal goes here --->
	</cffunction --->

	<cffunction name="should_create_log_within_database" returntype="void" access="public">

		<cfset var stLog = createTemporaryObject(
				typename = 'fcbLog',
				reference = stDefault.reference,
				title = stDefault.title,
				data = stDefault.data
			) />

		<cfset assertContentTypeExists(typename = 'fcbLog') />
		<cfset assertObjectExists(typename = 'fcbLog', objectid = stLog.objectid) />
		<cfset assertEquals('Log created by LogTest', stLog.title) />

	</cffunction>
	
</cfcomponent>