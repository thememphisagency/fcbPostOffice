<cfsetting enablecfoutputonly="yes">

<!--- import tag libraries --->
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />

<!--- set up page header --->
<admin:header title="Logs" />

<cfset stFilterMetaData = structNew() /> 
<cfset stFilterMetaData.label.ftValidation = "" /> 
<cfset stFilterMetaData.label.ftDefault = "" />

<cfscript>
	aCustomColumns = arrayNew(1);
	aCustomColumns[1] = structNew();
	aCustomColumns[1].webskin = 'objectadminPreview.cfm';
	aCustomColumns[1].title = 'Preview';
</cfscript>

<ft:objectAdmin
	title="Logs" 
	typename="fcbLog" 
	plugin="fcbPostOffice"
	ColumnList="label,reference,datetimecreated"
	SortableColumns="label,reference,datetimecreated"
	lFilterFields="label,reference"
	aCustomColumns="#aCustomColumns#"
	stFilterMetaData = '#stFilterMetaData#'
	sqlOrderBy="datetimecreated DESC"
	lButtons=""
	bShowActionList="false" />

<!--- page footer --->
<admin:footer />

<cfsetting enablecfoutputonly="no">
