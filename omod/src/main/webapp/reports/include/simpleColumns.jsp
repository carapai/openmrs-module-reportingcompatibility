<openmrs:globalProperty key="use_patient_attribute.healthCenter" defaultValue="false" var="showHealthCenter"/>

<br />
<table>
	<tr>
		<td><spring:message code="reportingcompatibility.DataExport.columnName"/></td>
		<td><input type="text" name="simpleName" size="30"/></td>
	</tr>
	<tr>
		<td><spring:message code="reportingcompatibility.DataExport.columnValue"/></td>
		<td>
			<input type="text" name="simpleValue" size="50"/>
			
			<select name="simplePatient" onchange="updateSimpleColumn(this)">
				
				<option value=""> </option>
				<option disabled><spring:message code="reportingcompatibility.DataExport.simple.identifiers"/></option>
				<option value="$!{fn.patientId}">&nbsp; <spring:message code="reportingcompatibility.DataExport.simple.identifier.patientId" /></option>
				<option value=""> </option>
				<openmrs:forEachRecord name="patientIdentifierType">
					<option value="$!{fn.getPatientIdentifier('${record.patientIdentifierTypeId}')}">&nbsp; ${record.name}</option>
				</openmrs:forEachRecord>
				<option value=""> </option>
				<option value="$!{fn.getPatientAttr('PatientIdentifier', 'identifier')}">&nbsp; <spring:message code="reportingcompatibility.DataExport.simple.preferredIdentifier" /></option>
				<option value="$!{fn.getPatientAttr('PatientIdentifier', 'identifierType').getName()}">&nbsp; <spring:message code="reportingcompatibility.DataExport.simple.preferredIdentifierType" /></option>
				<option value="$!{fn.getPatientAttr('PatientIdentifier', 'location').getName()}">&nbsp; <spring:message code="reportingcompatibility.DataExport.simple.preferredIdentifierLocation" /></option>
				<option value=""> </option>
				<option disabled><spring:message code="reportingcompatibility.DataExport.simple.personName"/></option>		
				<option value="$!{fn.getPatientAttr('PersonName', 'givenName')}">&nbsp; <spring:message code="PersonName.givenName" /></option>
				<option value="$!{fn.getPatientAttr('PersonName', 'middleName')}">&nbsp; <spring:message code="PersonName.middleName" /></option>
				<option value="$!{fn.getPatientAttr('PersonName', 'familyName')}">&nbsp; <spring:message code="PersonName.familyName" /></option>
				<option value="$!{fn.getPatientAttr('PersonName', 'degree')}">&nbsp; <spring:message code="PersonName.degree" /></option>

				<option disabled> </option>
				<option disabled><spring:message code="reportingcompatibility.DataExport.simple.demographics"/></option>
				<option value="$!{fn.getPatientAttr('Person', 'gender')}">&nbsp; <spring:message code="Patient.gender" /></option>
				<option value="$!{fn.calculateAge($fn.getPatientAttr('Person', 'birthdate'))}">&nbsp; <spring:message code="Person.age" /></option>
				<option value="$!{fn.formatDate('short', $fn.getPatientAttr('Person', 'birthdate'))}">&nbsp; <spring:message code="Person.birthdate" /></option>
				<option value="$!{fn.getPatientAttr('Person', 'birthdateEstimated')}">&nbsp; <spring:message code="Person.birthdateEstimated" /></option>
				<c:if test="${showHealthCenter == 'true'}">
					<option value="$!{fn.getPersonAttribute('Health Center', 'Location', 'locationId', 'name', false)}">&nbsp; <spring:message code="PersonAttributeType.HealthCenter" /></option>
				</c:if>
				<option value="$!{fn.getPersonAttribute('Race')}">&nbsp; <spring:message code="PersonAttributeType.Race" /></option>
                <option value="$!{fn.getPatientAttr('Person', 'dead')}">&nbsp; <spring:message code="Person.dead" /></option>
				<option value="$!{fn.formatDate('short', $fn.getPatientAttr('Person', 'deathDate'))}">&nbsp; <spring:message code="Person.deathDate" /></option>
				<option value="$!{fn.getPatientAttr('Person', 'causeOfDeath').name}">&nbsp; <spring:message code="Person.causeOfDeath" /></option>

				<option value=""> </option>
				<option disabled><spring:message code="reportingcompatibility.DataExport.simple.programs"/></option>
				<openmrs:forEachRecord name="workflowProgram">
					<option value="$!{fn.formatDate('ymd', $fn.getProgram('${record.programId}').getDateEnrolled())}">&nbsp; <spring:message code="reportingcompatibility.DataExport.programEnrollmentDate" arguments="${record.concept.name}" /></option>
					<c:forEach var="workflow" items="${record.workflows}">
						<option value="$!{fn.getProgram('${record.programId}').getCurrentState($fn.getProgram('${record.programId}').getProgram().getWorkflowByName('${workflow.concept.name}')).getState().getConcept().getName()}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${workflow.concept.name}</option>
					</c:forEach>
				</openmrs:forEachRecord>

				<option value=""> </option>
				<option disabled><spring:message code="reportingcompatibility.DataExport.simple.drugSets"/></option>
				<openmrs:globalProperty var="drugSetConcepts" key="dashboard.regimen.displayDrugSetIds" listSeparator="," />
				<c:if test="${empty drugSetConcepts}">
					<option disabled>&nbsp; <spring:message code="reportingcompatibility.DataExport.simple.drugSets.instructions" arguments="dashboard.regimen.displayDrugSetIds"/></option>
				</c:if>
				<c:if test="${not empty drugSetConcepts}">
					<c:forEach var="drugSet" items="${drugSetConcepts}">
						<openmrs:concept conceptName="${drugSet}" var="drugSetConcept">
							<option value="$!{fn.getCurrentDrugNames('${drugSetConcept.name}')}">&nbsp; <spring:message code="reportingcompatibility.DataExport.currentDrugs" arguments="${drugSetConcept.name}"/></option>
						</openmrs:concept>
					</c:forEach>
					<c:forEach var="drugSet" items="${drugSetConcepts}">
						<openmrs:concept conceptName="${drugSet}" var="drugSetConcept">
							<option value="$!{fn.getCurrentFullDrugOrders('${drugSetConcept.name}')}">&nbsp; <spring:message code="Current Full Drug Orders {0}" arguments="${drugSetConcept.name}"/></option>
						</openmrs:concept>
					</c:forEach>
					<c:forEach var="drugSet" items="${drugSetConcepts}">
						<openmrs:concept conceptName="${drugSet}" var="drugSetConcept">
							<option value="$!{fn.formatDate('ymd', $fn.getEarliestDrugStart('${drugSetConcept.name}'))}">&nbsp; <spring:message code="reportingcompatibility.DataExport.earliestDrugStart" arguments="${drugSetConcept.name}" /></option>
						</openmrs:concept>
					</c:forEach>
					<c:forEach var="drugSet" items="${drugSetConcepts}">
						<openmrs:concept conceptName="${drugSet}" var="drugSetConcept">
							<option value="$!{fn.formatDate('ymd', $fn.getLastDrugStart('${drugSetConcept.name}'))}">&nbsp; <spring:message code="Most Recent Regimen Change {0}" arguments="${drugSetConcept.name}" /></option>
						</openmrs:concept>
					</c:forEach>
				</c:if>

				<option value=""> </option>
				<option disabled><spring:message code="reportingcompatibility.DataExport.simpleLastEncounter"/></option>
				<option value="$!{fn.getLastEncounterAttr([''], 'encounterType').getName()}">&nbsp; <spring:message code="Encounter.type" /></option>
				<option value="$!{fn.getLastEncounterAttr([''], 'provider').getFirstName()} $!{fn.getLastEncounterAttr([''], 'provider').getLastName()}">&nbsp; <spring:message code="Encounter.provider" /></option>
				<option value="$!{fn.getLastEncounterAttr([''], 'location').getName()}">&nbsp; <spring:message code="Encounter.location" /></option>
				<option value="$!{fn.getLastEncounterAttr([''], 'form').getName()}">&nbsp; <spring:message code="Encounter.form" /></option>
				<option value="$!{fn.formatDate('short', $!{fn.getLastEncounterAttr([''], 'encounterDatetime')})}">&nbsp; <spring:message code="Encounter.datetime" /></option>

				<option value=""> </option>
				<option disabled><spring:message code="reportingcompatibility.DataExport.simpleFirstEncounter"/></option>
				<option value="$!{fn.getFirstEncounterAttr([''], 'encounterType').getName()}">&nbsp; <spring:message code="Encounter.type" /></option>
				<option value="$!{fn.getFirstEncounterAttr([''], 'provider').getFirstName()} $!{fn.getFirstEncounterAttr([''], 'provider').getLastName()}">&nbsp; <spring:message code="Encounter.provider" /></option>
				<option value="$!{fn.getFirstEncounterAttr([''], 'location').getName()}">&nbsp; <spring:message code="Encounter.location" /></option>
				<option value="$!{fn.getFirstEncounterAttr([''], 'form').getName()}">&nbsp; <spring:message code="Encounter.form" /></option>
				<option value="$!{fn.formatDate('short', $!{fn.getFirstEncounterAttr([''], 'encounterDatetime')})}">&nbsp; <spring:message code="Encounter.datetime" /></option>

				<option value=""> </option>
				<option disabled><spring:message code="reportingcompatibility.DataExport.simple.relationships"/></option>
				<option value="$!{fn.getRelationshipNames('')}">&nbsp; <spring:message code="All Relationships" /></option>
				<option value="$!{fn.getRelationshipNames('Accompagnateur/Patient')}">&nbsp; <spring:message code="provider.chw.names" /></option>
				<option value="$!{fn.getRelationshipIds('Accompagnateur/Patient')}">&nbsp; <spring:message code="provider.chw.id" /></option>
				<option value="$!{fn.getRelationshipIdentifiers('Mother')}">&nbsp; <spring:message code="RelationshipType.mother" /></option>
				
				<option disabled> </option>
				<option disabled><spring:message code="reportingcompatibility.DataExport.addressElements"/></option>
				<c:forEach items="${addressTemplate.lines}" var="line">
					<c:forEach items="${line}" var="token">
						<c:if test="${token.isToken == addressTemplate.layoutToken}">
							<option value="$!{fn.getPatientAttr('PersonAddress', '${token.codeName}')}">&nbsp; <spring:message code="${token.displayText}" /></option>
						</c:if>
					</c:forEach>
				</c:forEach>
				<option disabled> </option>
				<option disabled><spring:message code="reportingcompatibility.DataExport.personAttributes"/></option>
				<c:forEach items="${personAttributeTypes}" var="personAttributeType">
					<option value="$!{fn.getPersonAttribute(&#34;${personAttributeType}&#34;)}">&nbsp; ${personAttributeType}</option>
				</c:forEach>
			</select>
			
		</td>
	</tr>
</table>
<br />