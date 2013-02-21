<cfsetting enablecfoutputonly="yes">

<!--- import tag libraries --->
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />

<!--- set up page header --->
<admin:header title="Logs" />

<ft:objectAdmin
	title="Logs" 
	typename="fcbLog" 
	plugin="fcbPostOffice"
	ColumnList="label,reference"
	SortableColumns="label,reference,emailAddress"
	lFilterFields="label,reference"
	lButtons=""
	bCheckAll="0"
    bSelectCol="0"
    bEditCol="0"
    bViewCol="0"
    bFlowCol="0"
    bPreviewCol="1"/>

<!--- page footer --->
<admin:footer />

<cfsetting enablecfoutputonly="no">
