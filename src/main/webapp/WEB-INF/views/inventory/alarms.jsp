<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness"%>
<%@taglib prefix="jaws" uri="http://jlab.org/jaws/functions" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%> 
<c:set var="title" value="Alarms"/>
<t:inventory-page title="${title}">
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/alarms.css"/>
    </jsp:attribute>
    <jsp:attribute name="scripts">
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/js/alarms.js"></script>
    </jsp:attribute>        
    <jsp:body>
        <section>
            <s:filter-flyout-widget clearButton="true">
                <form id="filter-form" method="get" action="alarms">
                    <div id="filter-form-panel">
                        <fieldset>
                            <legend>Filter</legend>
                            <ul class="key-value-list">
                                <li>
                                    <div class="li-key">
                                        <label for="location-select">Location</label>
                                    </div>
                                    <div class="li-value">
                                        <select id="location-select" name="locationId" multiple="multiple">
                                            <c:forEach items="${locationRoot.children}" var="child">
                                                <t:hierarchical-select-option node="${child}" level="0"
                                                                              parameterName="locationId"/>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </li>
                                <li>
                                    <div class="li-key">
                                        <label for="priority-select">Priority</label>
                                    </div>
                                    <div class="li-value">
                                        <select id="priority-select" name="priorityId">
                                            <option value="">&nbsp;</option>
                                            <c:forEach items="${priorityList}" var="priority">
                                                <option value="${priority.priorityId}"${param.priorityId eq priority.priorityId ? ' selected="selected"' : ''}>
                                                    <c:out value="${priority.name}"/></option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </li>
                                <li>
                                    <div class="li-key">
                                        <label for="team-select">Team</label>
                                    </div>
                                    <div class="li-value">
                                        <select id="team-select" name="teamId">
                                            <option value="">&nbsp;</option>
                                            <c:forEach items="${teamList}" var="team">
                                                <option value="${team.teamId}"${param.teamId eq team.teamId ? ' selected="selected"' : ''}>
                                                    <c:out value="${team.name}"/></option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </li>
                                <li>
                                    <div class="li-key">
                                        <label for="synced-select">Synced</label>
                                    </div>
                                    <div class="li-value">
                                        <select id="synced-select" name="synced">
                                            <option value="">&nbsp;</option>
                                            <option value="Y"${param.synced eq 'Y' ? ' selected="selected"' : ''}>Yes</option>
                                            <option value="N"${param.synced eq 'N' ? ' selected="selected"' : ''}>No</option>
                                        </select>
                                    </div>
                                </li>
                                <li>
                                    <div class="li-key">
                                        <label for="pv">PV</label>
                                    </div>
                                    <div class="li-value">
                                        <input id="pv"
                                               name="pv" value="${fn:escapeXml(param.pv)}"
                                               placeholder="EPICS PV name"/>
                                        <div>(use % as wildcard)</div>
                                    </div>
                                </li>
                                <li>
                                    <div class="li-key">
                                        <label for="alarm-name">Alarm Name</label>
                                    </div>
                                    <div class="li-value">
                                        <input id="alarm-name"
                                               name="alarmName" value="${fn:escapeXml(param.alarmName)}"
                                               placeholder="alarm name"/>
                                        <div>(use % as wildcard)</div>
                                    </div>
                                </li>
                                <li>
                                    <div class="li-key">
                                        <label for="action-name">Action Name</label>
                                    </div>
                                    <div class="li-value">
                                        <input id="action-name"
                                               name="actionName" value="${fn:escapeXml(param.actionName)}"
                                               placeholder="action name"/>
                                        <div>(use % as wildcard)</div>
                                    </div>
                                </li>
                                <li>
                                    <div class="li-key">
                                        <label for="system-name">System Name</label>
                                    </div>
                                    <div class="li-value">
                                        <input id="system-name"
                                               name="systemName" value="${fn:escapeXml(param.systemName)}"
                                               placeholder="system name"/>
                                        <div>(use % as wildcard)</div>
                                    </div>
                                </li>
                            </ul>
                        </fieldset>
                    </div>
                    <input type="hidden" id="offset-input" name="offset" value="0"/>
                    <input id="filter-form-submit-button" type="submit" value="Apply"/>
                </form>
            </s:filter-flyout-widget>
            <h2 class="page-header-title"><c:out value="${title}"/></h2>
            <div class="message-box"><c:out value="${selectionMessage}"/></div>
            <div id="chart-wrap" class="chart-wrap-backdrop">
                <c:set var="readonly" value="${!pageContext.request.isUserInRole('jaws-admin')}"/>
                <c:if test="${not readonly}">
                    <s:editable-row-table-controls>
                    </s:editable-row-table-controls>
                </c:if>
                <table class="data-table outer-table">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Action</th>
                        <th>Location</th>
                        <th></th>
                        <th class="scrollbar-header"><span class="expand-icon" title="Expand Table"></span></th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="inner-table-cell" colspan="5">
                            <div class="pane-decorator">
                                <div class="table-scroll-pane">
                                    <table class="data-table inner-table stripped-table ${readonly ? '' : 'uniselect-table editable-row-table'}">
                                        <tbody>
                                        <c:forEach items="${alarmList}" var="alarm">
                                            <tr data-id="${alarm.alarmId}"
                                                data-action-id="${alarm.action.actionId}"
                                                data-location-id-csv="${alarm.locationIdCsv}"
                                                data-alias="${fn:escapeXml(alarm.alias)}"
                                                data-device="${fn:escapeXml(alarm.device)}"
                                                data-screen-command="${fn:escapeXml(alarm.screenCommand)}"
                                                data-managed-by="${fn:escapeXml(alarm.managedBy)}"
                                                data-masked-by="${fn:escapeXml(alarm.maskedBy)}"
                                                data-pv="${fn:escapeXml(alarm.pv)}"
                                                data-sync-rule-id="${alarm.syncRule.syncRuleId}"
                                                data-sync-element-name="${fn:escapeXml(alarm.syncElementName)}"
                                                data-sync-element-id="${alarm.syncElementId}"
                                                data-sync-screen-command="${empty alarm.syncRule.screenCommand ? 'N' : 'Y'}"
                                                data-sync-pv="${empty alarm.syncRule.pv ? 'N' : 'Y'}">
                                                <td>
                                                    <c:url value="/inventory/alarms/${jaws:urlEncodePath(alarm.name)}" var="url">
                                                    </c:url>
                                                    <a title="Alarm Information" class="dialog-ready"
                                                       data-dialog-title="Alarm Information: ${fn:escapeXml(alarm.name)}"
                                                       href="${url}"><c:out
                                                            value="${alarm.name}"/></a>
                                                </td>
                                                <td><c:out value="${alarm.action.name}"/></td>
                                                <td><c:out value="${alarm.locationNameCsv}"/></td>
                                                <td>
                                                    <!-- Use onclick to avoid https://bugs.webkit.org/show_bug.cgi?id=30103 -->
                                                    <form method="get"
                                                          action="${pageContext.request.contextPath}/inventory/alarms/${fn:escapeXml(alarm.name)}">
                                                        <button class="single-char-button" type="button" onclick="window.location.href = '${url}';  return false;">&rarr;</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <button id="previous-button" type="button" data-offset="${paginator.previousOffset}"
                        value="Previous"${paginator.previous ? '' : ' disabled="disabled"'}>Previous
                </button>
                <button id="next-button" type="button" data-offset="${paginator.nextOffset}"
                        value="Next"${paginator.next ? '' : ' disabled="disabled"'}>Next
                </button>
            </div>
        </section>
        <s:editable-row-table-dialog>
            <form id="row-form">
                <ul class="key-value-list">
                    <li>
                        <div class="li-key">
                            <label for="row-name">Name</label>
                        </div>
                        <div class="li-value">
                            <input type="text" required="required" id="row-name"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-action">Action</label>
                        </div>
                        <div class="li-value">
                            <select id="row-action" required="required">
                                <option value="">&nbsp;</option>
                                <c:forEach items="${actionList}" var="action">
                                    <option value="${action.actionId}">
                                        <c:out value="${action.name}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-location">Location</label>
                        </div>
                        <div class="li-value">
                            <select id="row-location" multiple="multiple">
                                <c:forEach items="${locationRoot.children}" var="child">
                                    <t:hierarchical-select-option node="${child}" level="0"
                                                                  parameterName="location"/>
                                </c:forEach>
                            </select>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-alias">Alias</label>
                        </div>
                        <div class="li-value">
                            <input type="text" id="row-alias"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-device">Device</label>
                        </div>
                        <div class="li-value">
                            <input type="text" id="row-device"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-screen-command">Screen Command</label>
                        </div>
                        <div class="li-value">
                            <input type="text" id="row-screen-command"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-managed-by">Managed By</label>
                        </div>
                        <div class="li-value">
                            <input type="text" id="row-managed-by"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-masked-by">Masked By</label>
                        </div>
                        <div class="li-value">
                            <input type="text" id="row-masked-by"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-pv">EPICS PV</label>
                        </div>
                        <div class="li-value">
                            <input type="text" id="row-pv"/>
                        </div>
                    </li>
                </ul>
                <ul class="key-value-list">
                    <li>
                        <div class="li-key">
                            <label for="row-sync-rule-id">Sync Rule ID</label>
                        </div>
                        <div class="li-value">
                            <input type="text" id="row-sync-rule-id" disabled="disabled"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-sync-element-name">Sync Element Name</label>
                        </div>
                        <div class="li-value">
                            <input type="text" id="row-sync-element-name" disabled="disabled"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-sync-element-id">Sync Element ID</label>
                        </div>
                        <div class="li-value">
                            <input type="text" id="row-sync-element-id" disabled="disabled"/>
                        </div>
                    </li>
                </ul>
            </form>
            <button id="remove-sync-button" type="button" class="hidden">Remove Sync</button>
        </s:editable-row-table-dialog>
    </jsp:body>         
</t:inventory-page>