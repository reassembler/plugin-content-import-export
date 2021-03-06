<%@ include file="/html/plugins/org.dotcms.plugins.contentImporter/init.jsp" %>

<!-- JSP Imports --> 
<%@ page import="java.util.*" %>
<%@ page import="com.dotmarketing.portlets.contentlet.model.Contentlet" %>
<%@ page import="org.dotcms.plugins.contentImporter.portlet.form.ImportExternalContentletsForm" %>
<%@ page import="com.dotmarketing.portlets.structure.factories.StructureFactory" %>
<%@ page import="com.dotmarketing.portlets.structure.model.Structure" %>
<%@ page import="com.dotmarketing.portlets.structure.model.Field"%>
<%@ page import="com.dotmarketing.portlets.languagesmanager.business.LanguageAPI" %>
<%@ page import="com.dotmarketing.business.APILocator" %>
<%@ page import="com.dotmarketing.util.UtilMethods" %>

<!--  Initialization Code -->
<% 
	List<Structure> structures = StructureFactory.getStructuresWithWritePermissions(user, false);
	request.setAttribute("structures", structures);
	String selectedStructure = null;
	if(UtilMethods.isSet(session.getAttribute("selectedStructure"))){
		selectedStructure= (String)session.getAttribute("selectedStructure");
	}
	

	List<com.dotmarketing.portlets.languagesmanager.model.Language> languages = APILocator.getLanguageAPI().getLanguages();
	List<HashMap<String, Object>> languagesMap = new ArrayList<HashMap<String, Object>>();
	HashMap<String, Object> languageMap;
	for (com.dotmarketing.portlets.languagesmanager.model.Language language: languages) {
		languageMap = new HashMap<String, Object>();
		languageMap.put("id", language.getId());
		languageMap.put("description", language.getCountry() + " - " + language.getLanguage());
		languagesMap.add(languageMap);
	}
	languageMap = new HashMap<String, Object>();
	languageMap.put("id", -1);
	languageMap.put("description", "Multilingual File");
	languagesMap.add(languageMap);
	request.setAttribute("languages", languagesMap);
	
	ImportExternalContentletsForm form = (ImportExternalContentletsForm)request.getAttribute("ImportExternalContentletsForm");
	
	if (form.getLanguage() == 0) {
		form.setLanguage(APILocator.getLanguageAPI().getDefaultLanguage().getId());
	}
%>
<%@page import="com.dotmarketing.portlets.contentlet.action.ImportAuditUtil.ImportAuditResults"%>
<%@page import="com.dotmarketing.portlets.contentlet.action.ImportAuditUtil"%>
<script type='text/javascript' src='/dwr/interface/StructureAjax.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>

<script type='text/javascript'>
	function structureChanged () {
		var inode = dijit.byId("structuresSelect").attr('value');
	}

	function submitForm () {
		var button = document.getElementById("goToPreviewButton");
		button.value='<%= UtilMethods.escapeSingleQuotes(LanguageUtil.get(pageContext, "Generating-Preview-Info-Please-be-patient")) %>';
		button.disabled = true;
		var href =  '<portlet:actionURL>';
			href +=		'<portlet:param name="struts_action" value="/ext/content_importer/import_external_contentlets" />';
			href +=		'<portlet:param name="cmd" value="preview" />';			
			href +=	'</portlet:actionURL>';
		var form = document.getElementById("importExternalContentletsForm");
		form.action = href;
		form.fileName.value = document.getElementById("file").value;
		form.cmd.value = "preview";
		form.submit();
	}
	
	function downloadCSVExample() {
		var href =  '<portlet:actionURL>';
			href +=		'<portlet:param name="struts_action" value="/ext/content_importer/import_external_contentlets" />';
			href +=		'<portlet:param name="cmd" value="downloadCSVTemplate" />';			
			href +=	'</portlet:actionURL>';
		var form = document.getElementById("importExternalContentletsForm");
		
		form.action = href;
		form.cmd.value = "downloadCSVTemplate";
		form.submit();
	}

	function languageChanged() {
		var languageId = dijit.byId("languageSelect").attr('value');
		if (-1 < languageId) {
				document.getElementById("multiLingualImportNotes").style.display="none";
		} else {
			document.getElementById("multiLingualImportNotes").style.display="block";
		}
	}
</script>

<liferay:box top="/html/common/box_top.jsp" bottom="/html/common/box_bottom.jsp">
    

      <liferay:param name="box_title" value="<%= LanguageUtil.get(pageContext, \"import-contentlets\") %>" />
      
      			<% 
			     	ImportAuditUtil.ImportAuditResults iar = request.getAttribute("audits") == null ? null:(ImportAuditUtil.ImportAuditResults)request.getAttribute("audits");
			     	if(iar != null && iar.getUserRecords().size() > 0){ 
			     %>
			     <div style="position:absolute;left:60%;top:16%; padding: 30px;">
					<table class="listingTable">
						<tr>
							<th><%= LanguageUtil.get(pageContext, "Time-Started") %></th>
							<th><%= LanguageUtil.get(pageContext, "File-Name") %></th>
							<th><%= LanguageUtil.get(pageContext, "Total") %></th>
						</tr>
						<% for(Map<String, Object> recs : iar.getUserRecords()){ %>
						<tr>
						<% 
						String dateData="";
						if(recs.get("start_date")instanceof oracle.sql.TIMESTAMP){
							oracle.sql.TIMESTAMP timestamp= (oracle.sql.TIMESTAMP) recs.get("start_date");
							dateData=timestamp.timestampValue().toString();
						}
						else {
							dateData= recs.get("start_date").toString();
						}
						SimpleDateFormat dateFormatter = new SimpleDateFormat(com.dotmarketing.util.WebKeys.DateFormats.LONGDBDATE);
						Date dateValue = dateFormatter.parse(dateData);
						
						%>
							<td><%= dateValue %></td>
							<td><%= recs.get("filename") %></td>
							<td><%= recs.get("records_to_import") == null || recs.get("records_to_import").toString().equals(0) ? "Still Processing": recs.get("records_to_import").toString() %></td>
						</tr>
						<% } %>
						<tr>
							<td colspan="3"><%= LanguageUtil.get(pageContext, "Total-number-of-other-imports") %>: <%= iar.getOtherUsersJobs() %></td>
						</tr>
					</table>
				</div>
				<% } %>
      
      		<html:form action="/ext/content_importer/import_external_contentlets" styleId="importExternalContentletsForm" method="POST" enctype="multipart/form-data">
		
				<input type="hidden" name="cmd" value="preview" />
				<input type="hidden" name="fileName" value="" />
				
			     <fieldset>
			     
				<div>
		         	<dl>
		
			            <dt><%= LanguageUtil.get(pageContext, "Structure-to-Import") %>:</dt>
			            <dd>
			                <select dojoType="dijit.form.FilteringSelect" name="structure" id="structuresSelect" onchange="structureChanged()" value="<%= UtilMethods.isSet(form.getStructure()) ? form.getStructure() : "" %>" >
			<%
							for (Structure structure: structures) {
			%>
								<option <%=(selectedStructure !=null && selectedStructure.equals(structure.getInode())) ? "selected='true'" : "" %>value="<%= structure.getInode() %>"><%= structure.getName() %></option>
			<%
							}
			%>
			                </select>
			            </dd>
			            
			            
			            <dt><%= LanguageUtil.get(pageContext, "Language-of-the-Contents-to-Import") %>:</dt>
			            <dd>
			                <select dojoType="dijit.form.FilteringSelect" name="language" id="languageSelect" onchange="languageChanged()" value="<%= UtilMethods.isSet(form.getLanguage()) ? form.getLanguage() : "" %>" >
			<%
							
							for (HashMap<String, Object> language: languagesMap) {
			%>
								<option value="<%= language.get("id") %>"><%= language.get("description") %></option>
			<%
							}
			%>
			                </select>
			                <div id="multiLingualImportNotes" style="display: none">
			                    <%= LanguageUtil.get(pageContext, "Note") %>:
			                    <p>
			                        <%= LanguageUtil.get(pageContext, "In-order-to-import-correctly-a-multilingual-file") %>:
			                        <ol>
			                            <li><%= LanguageUtil.get(pageContext, "The-CSV-file-must-saved-using--UTF-8--enconding") %></li>
			                            <li><%= LanguageUtil.get(pageContext, "There-CSV-file-must-have-two-extra-fields") %></li>
			                            <li><%= LanguageUtil.get(pageContext, "A-key-field-must-be-selected") %></li>
			                        </ol>
			                    </p>
			                </div>
			            </dd>
			            
			           <dt><%= LanguageUtil.get(pageContext, "title-field") %>:</dt>
			            <dd>
			                <input type="text" name="titleField" id="titleField" /> <br/>
			            </dd>
			            
			            <dt><%= LanguageUtil.get(pageContext, "content-field") %>:</dt>
			            <dd>
			                <input type="text" name="contentField" id="contentField" /> <br/>
			            </dd>
			            
			            <dt><%= LanguageUtil.get(pageContext, "path-field") %>:</dt>
			            <dd>
			                <input type="text" name="pathField" id="pathField" /> <br/>
			            </dd>
			            
			            <dt><%= LanguageUtil.get(pageContext, "File-to-Import-CSV-File-Required") %>:</dt>
			            <dd>
			                <input type="file" name="file" id="file" /> <br/>
			                <!-- <a href="javascript: downloadCSVExample()"><%//=LanguageUtil.get(pageContext, "Click-here-to-download-a-csv-sample-file") %></a>-->
			            </dd>
			            
			            <dt>&nbsp;</dt>
			            <dd>
			                <button dojoType="dijit.form.Button" onclick="submitForm()" id="goToPreviewButton" iconClass="previewIcon">
			                  <%= UtilMethods.escapeSingleQuotes(LanguageUtil.get(pageContext, "Go-to-Preview")) %>  
			                </button>
			            </dd>    
		       		</dl>
					</div>		       	
		    	</fieldset>
			</html:form>
		
	
</liferay:box>
<script type="text/javascript">
	dojo.addOnLoad(function() {
		var structure = dijit.byId("structuresSelect").attr('value');
		if ((structure != null) && (structure != '')) {
			structureChanged(structure);
		}
		languageChanged();
	});
</script>