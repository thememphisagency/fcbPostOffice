<cfsetting enablecfoutputonly="true">

<!--- @@displayname: Log Body --->
<!--- @@viewstack: body --->
<!--- @@viewbinding: object --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">
<cfimport taglib="/farcry/core/tags/container" prefix="con">

<cfoutput>
	<dl>
		<dt>label</dt>
		<dd>#stObj.label#</dd>
		<dt>title</dt>
		<dd>#stObj.title#</dd>
		<dt>reference</dt>
		<dd>#stObj.reference#</dd>
		<dt>date time created</dt>
		<dd>#stObj.datetimecreated#</dd>
		<dt>data</dt>
		<dd><cfdump var="#deserializeJSON(stObj.data)#" /></dd>
	</dl>
</cfoutput>

<cfsetting enablecfoutputonly="false">