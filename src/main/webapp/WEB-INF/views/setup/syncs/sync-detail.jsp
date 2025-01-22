<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness" %>
<%@taglib prefix="jaws" uri="http://jlab.org/jaws/functions" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="title" value="Sync Rule"/>
<t:setup-page title="${title}">
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/sync.css"/>
    </jsp:attribute>
    <jsp:attribute name="scripts">
        <script type="text/javascript"
                src="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/js/sync-detail.js"></script>
    </jsp:attribute>
    <jsp:body>
        <div class="banner-breadbox">
            <ul>
                <li>
                    <span>Sync Rules</span>
                </li>
                <li>
                    <h2 class="page-header-title"><c:out value="${param.syncRuleId}"/></h2>
                </li>
            </ul>
        </div>
        <section>
            <div class="dialog-content">
                <div class="dialog-links sync-detail-dialog-links">
                    <c:url value="/setup/syncs/${jaws:urlEncodePath(param.syncRuleId)}" var="url">
                    </c:url>
                    <a class="dialog-only-link"
                       href="${url}">Link</a>
                    <c:set var="editable" value="${pageContext.request.isUserInRole('jaws-admin')}"/>
                    <c:if test="${editable}">
                        <c:url var="url" value="/setup/syncs">
                            <c:param name="syncRuleId" value="${param.syncRuleId}"/>
                            <c:param name="edit" value="Y"/>
                        </c:url>
                        <span class="dialog-only-link">|</span> <a href="${url}">Modify</a>
                    </c:if>
                </div>
                <c:choose>
                    <c:when test="${rule ne null}">
                        <div id="accordion">
                        <h3>Primary</h3>
                        <div class="content">
                            <dl>
                                <dt>Action</dt>
                                <dd><c:out value="${rule.action.name}"/></dd>
                                <dt>Server</dt>
                                <dd><c:out value="${rule.syncServer.name}"/></dd>
                                <dt>Description</dt>
                                <dd>
                                    <c:out value="${rule.description}"/>
                                    <c:if test="${empty rule.description}">
                                        None
                                    </c:if>
                                </dd>
                                <dt>Base Query</dt>
                                <dd class="breakword">
                                    <c:out value="${rule.query}"/>
                                </dd>
                                <dt>Property Expression</dt>
                                <dd class="breakword">
                                    <c:choose>
                                        <c:when test="${not empty rule.expressionArray}">
                                            <ul>
                                                <c:forEach items="${rule.expressionArray}" var="operand">
                                                    <li><c:out value="${operand}"/></li>
                                                </c:forEach>
                                            </ul>
                                        </c:when>
                                        <c:otherwise>
                                            None
                                        </c:otherwise>
                                    </c:choose>
                                </dd>
                                <dt>Full URL</dt>
                                <dd class="breakword">
                                    <div><a href="${rule.getHTMLURL()}">HTML</a> | <a href="${rule.searchURL}">JSON</a>
                                    </div>
                                </dd>
                            </dl>
                        </div>
                        <h3>Join</h3>
                        <div>
                            <c:choose>
                                <c:when test="${not empty rule.primaryAttribute}">
                                    <dl>
                                        <dt>Primary Attribute</dt>
                                        <dd class="breakword">
                                            <c:out value="${rule.primaryAttribute}"/>
                                        </dd>
                                        <dt>Foreign Attribute</dt>
                                        <dd class="breakword">
                                            <c:out value="${rule.foreignAttribute}"/>
                                        </dd>
                                        <dt>Foreign Query</dt>
                                        <dd class="breakword">
                                            <c:out value="${rule.foreignQuery}"/>
                                        </dd>
                                        <dt>Foreign Property Expression</dt>
                                        <dd class="breakword">
                                            <c:choose>
                                                <c:when test="${not empty rule.foreignExpressionArray}">
                                                    <ul>
                                                        <c:forEach items="${rule.foreignExpressionArray}" var="operand">
                                                            <li><c:out value="${operand}"/></li>
                                                        </c:forEach>
                                                    </ul>
                                                </c:when>
                                                <c:otherwise>
                                                    None
                                                </c:otherwise>
                                            </c:choose>
                                        </dd>
                                        <dt>Full URL</dt>
                                        <dd class="breakword">
                                            <div><a href="${rule.getJoinHTMLURL()}">HTML</a> | <a
                                                    href="${rule.joinSearchURL}">JSON</a></div>
                                        </dd>
                                    </dl>
                                </c:when>
                                <c:otherwise>
                                    None
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h3>Template</h3>
                        <div>
                            <dl>
                                <dt>Name</dt>
                                <dd><c:out value="${rule.alarmName}"/></dd>
                                <dt>Alias</dt>
                                <dd>{NameAlias}</dd>
                                <dt>Location</dt>
                                <dd>{function:locationFromSegMask(SegMask)}</dd>
                                <dt>Sub-Locations</dt>
                                <dd><c:out value="${rule.subLocations ? 'Yes' : 'No'}"/></dd>
                                <dt>Screen Command</dt>
                                <dd><c:out value="${empty rule.screenCommand ? 'None' : rule.screenCommand}"/></dd>
                                <dt>PV</dt>
                                <dd><c:out value="${empty rule.pv ? 'None' : rule.pv}"/></dd>
                            </dl>
                        </div>
                        <h3>Results</h3>
                        <div>
                            <c:choose>
                                <c:when test="${error ne null}">
                                    Error: <c:out value="${error}"/>
                                </c:when>
                                <c:when test="${fn:length(remoteList) > 0}">
                                    <div>Found ${fn:length(remoteList)} remote alarms, ${fn:length(localList)} local
                                        alarms, and ${collisionCount} name/pv collisions</div>
                                    <div> (${matchCount}
                                        Matched, ${addCount} Add, ${removeCount} Remove, ${updateCount}
                                        Update, ${linkCount} Link)
                                    </div>
                                    <table class="data-table">
                                        <thead>
                                        <tr>
                                            <th>ID
                                                <div>(Element)</div>
                                            </th>
                                            <th>
                                                Name
                                                <div>(Alias)</div>
                                            </th>
                                            <th>Location</th>
                                            <th>Screen Command</th>
                                            <th>PV</th>
                                            <th>
                                                <button ${diff.hasChanges() ? '' : 'disabled="disabled"'}
                                                        id="apply-all-button" type="button">Apply All
                                                </button>
                                            </th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${diff.addList}" var="alarm">
                                            <c:set value="${danglingByNameList[alarm.name]}" var="danglingNameAlarm"/>
                                            <c:set value="${danglingByPvList[alarm.pv]}" var="danglingPvAlarm"/>
                                            <c:set value="${danglingNameAlarm ne null && danglingPvAlarm ne null && danglingNameAlarm.alarmId ne danglingPvAlarm.alarmId}" var="splitCollision"/>
                                            <c:set value="${danglingNameAlarm eq null && danglingPvAlarm eq null}"
                                                   var="doAdd"/>
                                            <c:set value="${alarm.alias}" var="alias"/>
                                            <c:set value="${alarm.screenCommand}" var="screenCommand"/>
                                            <c:set value="${alarm.pv}" var="pv"/>
                                            <c:if test="${not doAdd}"> <%-- If need to link --%>
                                                <c:if test="${empty alarm.alias}"> <%-- If remote alias undefined, then use local --%>
                                                    <c:set value="${danglingNameAlarm ne null ? danglingNameAlarm.alias : danglingPvAlarm.alias}"
                                                           var="alias"/>
                                                </c:if>
                                                <c:if test="${empty alarm.pv}"> <%-- If remote PV undefined, then use local --%>
                                                    <c:set value="${danglingNameAlarm ne null ? danglingNameAlarm.pv : danglingPvAlarm.pv}"
                                                           var="pv"/>
                                                </c:if>
                                                <c:if test="${empty alarm.screenCommand}"> <%-- If remote command undefined, then use local --%>
                                                    <c:set value="${danglingNameAlarm ne null ? danglingNameAlarm.screenCommand : danglingPvAlarm.screenCommand}"
                                                           var="screenCommand"/>
                                                </c:if>
                                            </c:if>
                                            <tr data-action-id="${alarm.action.actionId}"
                                                data-name="${fn:escapeXml(alarm.name)}"
                                                data-alias="${fn:escapeXml(alias)}"
                                                data-location-id-csv="${alarm.locationIdCsv}"
                                                data-device="${fn:escapeXml(alarm.device)}"
                                                data-screen-command="${fn:escapeXml(screenCommand)}"
                                                data-managed-by="${fn:escapeXml(alarm.managedBy)}"
                                                data-masked-by="${fn:escapeXml(alarm.maskedBy)}"
                                                data-pv="${fn:escapeXml(pv)}"
                                                data-rule-id="${alarm.syncRule.syncRuleId}"
                                                data-element-id="${alarm.syncElementId}"
                                                data-element-name="${fn:escapeXml(alarm.syncElementName)}"
                                                class="add-row">
                                                <td>
                                                    <c:out value="${alarm.syncElementId}"/>
                                                    <div>(<c:out value="${alarm.syncElementName}"/>)</div>
                                                </td>
                                                <td>
                                                    <c:out value="${alarm.name}"/>
                                                    <c:if test="${not empty alias}">
                                                        <div>(<c:out value="${alias}"/>)</div>
                                                    </c:if>
                                                </td>
                                                <td><c:out value="${alarm.locationNameCsv}"/></td>
                                                <td><c:out value="${screenCommand}"/></td>
                                                <td><c:out value="${pv}"/></td>
                                                <td>
                                                    <c:set value="${false}" var="linkCreated"/>
                                                    <c:if test="${doAdd}">
                                                        <button class="add" type="button">Add</button>
                                                    </c:if>
                                                    <c:if test="${danglingNameAlarm ne null}">
                                                        <c:set value="${true}" var="linkCreated"/>
                                                        <c:url value="/inventory/alarms/${jaws:urlEncodePath(alarm.name)}"
                                                               var="url">
                                                        </c:url>
                                                        <div>
                                                            <c:if test="${not splitCollision}">
                                                                <button class="link autolink" type="button"
                                                                        data-alarm-id="${danglingNameAlarm.alarmId}">Link
                                                                </button>
                                                            </c:if>
                                                            <a title="Alarm Information" class="dialog-ready"
                                                               data-dialog-title="Alarm Information: ${fn:escapeXml(alarm.name)}"
                                                               href="${url}">Name Exists</a>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${splitCollision}">
                                                        <div style="cursor: help;" title="One existing alarm matches name, while a different one matches PV.  You must delete/edit one of the alarms to continue!">
                                                            ⚠
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${danglingPvAlarm ne null}">
                                                        <c:url value="/inventory/alarms/${jaws:urlEncodePath(danglingPvAlarm.name)}"
                                                               var="url">
                                                        </c:url>
                                                        <div>
                                                            <c:if test="${not splitCollision}">
                                                                <button class="link ${linkCreated ? '' : 'autolink'}"
                                                                        type="button"
                                                                        data-alarm-id="${danglingPvAlarm.alarmId}">Link
                                                                </button>
                                                            </c:if>
                                                            <a title="Alarm Information" class="dialog-ready"
                                                               data-dialog-title="Alarm Information: ${fn:escapeXml(danglingPvAlarm.name)}"
                                                               href="${url}">PV Exists</a>
                                                        </div>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:forEach items="${diff.removeList}" var="alarm">
                                            <tr data-id="${alarm.alarmId}"
                                                class="remove-row">
                                                <td>
                                                    <c:out value="${alarm.syncElementId}"/>
                                                    <div>(<c:out value="${alarm.syncElementName}"/>)</div>
                                                </td>
                                                <td>
                                                    <c:url value="/inventory/alarms/${jaws:urlEncodePath(alarm.name)}"
                                                           var="url">
                                                    </c:url>
                                                    <a title="Alarm Information" class="dialog-ready"
                                                       data-dialog-title="Alarm Information: ${fn:escapeXml(alarm.name)}"
                                                       href="${url}"><c:out value="${alarm.name}"/></a>
                                                    <c:if test="${not empty alarm.alias}">
                                                        <div>(<c:out value="${alarm.alias}"/>)</div>
                                                    </c:if>
                                                </td>
                                                <td><c:out value="${alarm.locationNameCsv}"/></td>
                                                <td><c:out value="${alarm.screenCommand}"/></td>
                                                <td><c:out value="${alarm.pv}"/></td>
                                                <td>
                                                    <button class="remove" type="button">Remove</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:forEach items="${diff.updateList}" var="alarm">
                                            <c:set value="${not empty remoteList[alarm.syncElementId].alias}"
                                                   var="aliasSync"/>
                                            <c:set value="${not empty remoteList[alarm.syncElementId].screenCommand}"
                                                   var="screenCommandSync"/>
                                            <c:set value="${not empty remoteList[alarm.syncElementId].pv}"
                                                   var="pvSync"/>
                                            <tr data-id="${alarm.alarmId}"
                                                data-name="${fn:escapeXml(remoteList[alarm.syncElementId].name)}"
                                                data-alias="${fn:escapeXml(aliasSync ? remoteList[alarm.syncElementId].alias : alarm.alias)}"
                                                data-action-id="${alarm.action.actionId}"
                                                data-location-id-csv="${remoteList[alarm.syncElementId].locationIdCsv}"
                                                data-device="${fn:escapeXml(alarm.device)}"
                                                data-screen-command="${fn:escapeXml(screenCommandSync ? remoteList[alarm.syncElementId].screenCommand : alarm.screenCommand)}"
                                                data-managed-by="${fn:escapeXml(alarm.managedBy)}"
                                                data-masked-by="${fn:escapeXml(alarm.maskedBy)}"
                                                data-pv="${fn:escapeXml(pvSync ? remoteList[alarm.syncElementId].pv : alarm.pv)}"
                                                data-rule-id="${alarm.syncRule.syncRuleId}"
                                                data-element-id="${alarm.syncElementId}"
                                                data-element-name="${fn:escapeXml(remoteList[alarm.syncElementId].syncElementName)}">
                                                <td>
                                                    <c:out value="${alarm.syncElementId}"/>
                                                    <c:choose>
                                                        <c:when test="${alarm.syncElementName eq remoteList[alarm.syncElementId].syncElementName}">
                                                            <div>(<c:out value="${alarm.syncElementName}"/>)</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div>
                                                            (
                                                                <div class="remote"><c:out
                                                                    value="${remoteList[alarm.syncElementId].syncElementName}"/></div>
                                                                <span class="local"><c:out value="${alarm.syncElementName}"/></span>
                                                            )
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:url value="/inventory/alarms/${jaws:urlEncodePath(alarm.name)}"
                                                           var="url">
                                                    </c:url>
                                                    <c:choose>
                                                        <c:when test="${alarm.name eq remoteList[alarm.syncElementId].name}">
                                                            <a title="Alarm Information" class="dialog-ready"
                                                               data-dialog-title="Alarm Information: ${fn:escapeXml(alarm.name)}"
                                                               href="${url}"><c:out value="${alarm.name}"/></a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="remote"><c:out
                                                                    value="${remoteList[alarm.syncElementId].name}"/></div>
                                                            <span class="local"><c:out value="${alarm.name}"/></span>
                                                            <a title="Alarm Information" class="dialog-ready"
                                                               data-dialog-title="Alarm Information: ${fn:escapeXml(alarm.name)}"
                                                               href="${url}"><c:out value="[🔗]"/></a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:choose>
                                                        <c:when test="${not aliasSync || alarm.alias eq remoteList[alarm.syncElementId].alias}">
                                                            <c:if test="${not empty alarm.alias}">
                                                                <div>(<c:out value="${alarm.alias}"/>)</div>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div>
                                                                (
                                                                <div class="remote"><c:out
                                                                        value="${remoteList[alarm.syncElementId].alias}"/></div>
                                                                <div class="local"><c:out value="${alarm.alias}"/></div>
                                                                )
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${alarm.locationNameCsv eq remoteList[alarm.syncElementId].locationNameCsv}">
                                                            <c:out value="${alarm.locationNameCsv}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="remote"><c:out
                                                                    value="${remoteList[alarm.syncElementId].locationNameCsv}"/></div>
                                                            <div class="local"><c:out
                                                                    value="${alarm.locationNameCsv}"/></div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not screenCommandSync || alarm.screenCommand eq remoteList[alarm.syncElementId].screenCommand}">
                                                            <c:out value="${alarm.screenCommand}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="remote"><c:out
                                                                    value="${remoteList[alarm.syncElementId].screenCommand}"/></div>
                                                            <div class="local"><c:out
                                                                    value="${alarm.screenCommand}"/></div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not pvSync || alarm.pv eq remoteList[alarm.syncElementId].pv}">
                                                            <c:out value="${alarm.pv}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="remote"><c:out
                                                                    value="${remoteList[alarm.syncElementId].pv}"/></div>
                                                            <div class="local"><c:out value="${alarm.pv}"/></div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <button class="update" type="button">Update</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:forEach items="${diff.matchList}" var="alarm">
                                            <tr>
                                                <td>
                                                    <c:out value="${alarm.syncElementId}"/>
                                                    <div>(<c:out value="${alarm.syncElementName}"/>)</div>
                                                </td>
                                                <td>
                                                    <c:url value="/inventory/alarms/${jaws:urlEncodePath(alarm.name)}"
                                                           var="url">
                                                    </c:url>
                                                    <a title="Alarm Information" class="dialog-ready"
                                                       data-dialog-title="Alarm Information: ${fn:escapeXml(alarm.name)}"
                                                       href="${url}"><c:out value="${alarm.name}"/></a>
                                                    <c:if test="${not empty alarm.alias}">
                                                        <div>(<c:out value="${alarm.alias}"/>)</div>
                                                    </c:if>
                                                </td>
                                                <td><c:out value="${alarm.locationNameCsv}"/></td>
                                                <td><c:out value="${alarm.screenCommand}"/></td>
                                                <td><c:out value="${alarm.pv}"/></td>
                                                <td></td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div>No results found.</div>
                                </c:otherwise>
                            </c:choose>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div>Sync Rule with ID <c:out value="${param.syncRuleId}"/> not found!
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </jsp:body>
</t:setup-page>