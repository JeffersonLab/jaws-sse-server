<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness" %>
<%@taglib prefix="jaws" uri="http://jlab.org/jaws/functions" %>
<c:set var="title" value="Active History"/>
<t:reports-page title="${title}">  
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/active-history.css"/>
    </jsp:attribute>
    <jsp:attribute name="scripts">
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/js/active-history.js"></script>
    </jsp:attribute>
    <jsp:body>
        <section>
            <s:filter-flyout-widget ribbon="false" clearButton="true">
                <form id="filter-form" method="get" action="active-history">
                    <div id="filter-form-panel">
                        <fieldset>
                            <legend>Filter</legend>
                            <s:date-range datetime="${true}" sevenAmOffset="${false}"/>
                            <ul class="key-value-list">
                                <li>
                                    <div class="li-key">
                                        <label for="override-select">Override</label>
                                    </div>
                                    <div class="li-value">
                                        <select id="override-select" name="override">
                                            <option value="">&nbsp;</option>
                                            <option value="Latched"${param.override eq 'Latched' ? ' selected="selected"' : ''}>Latched</option>
                                            <option value="OffDelayed"${param.override eq 'OffDelayed' ? ' selected="selected"' : ''}>OffDelayed</option>
                                        </select>
                                    </div>
                                </li>
                                <li>
                                    <div class="li-key">
                                        <label for="type-select">Type</label>
                                    </div>
                                    <div class="li-value">
                                        <select id="type-select" name="type">
                                            <option value="">&nbsp;</option>
                                            <c:forEach items="${typeList}" var="type">
                                                <option value="${type}"${param.type eq type ? ' selected="selected"' : ''}>
                                                    <c:out value="${type}"/></option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </li>
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
                                        <label for="type-select">Registered</label>
                                    </div>
                                    <div class="li-value">
                                        <select id="registered-select" name="registered">
                                            <option value="">&nbsp;</option>
                                            <option value="Y"${param.registered eq 'Y' ? ' selected="selected"' : ''}>Yes</option>
                                            <option value="N"${param.registered eq 'N' ? ' selected="selected"' : ''}>No</option>
                                        </select>
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
                <table id="notification-table" class="data-table outer-table stripped-table">
                    <thead>
                    <tr>
                        <th>Active</th>
                        <th>Name</th>
                        <th>Priority</th>
                        <th></th>
                        <th class="scrollbar-header"><span class="expand-icon" title="Expand Table"></span></th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="inner-table-cell" colspan="5">
                            <div class="pane-decorator">
                                <div class="table-scroll-pane">
                                    <table class="data-table inner-table">
                                        <tbody>
                                        <c:forEach items="${notificationList}" var="notification">
                                            <tr data-id="${notification.alarm.alarmId}" data-action-id="${notification.alarm.action.actionId}" data-location-id-csv="${notification.alarm.locationIdCsv}" data-device="${notification.alarm.device}" data-screen-command="${notification.alarm.screenCommand}" data-managed-by="${notification.alarm.managedBy}" data-masked-by="${notification.alarm.maskedBy}" data-pv="${notification.alarm.pv}">
                                                <td>
                                                    <fmt:formatDate value="${notification.activeHistoryPK.activeStart}" pattern="dd-MMM-yyyy HH:mm:ss"/>
                                                    <c:if test="${notification.activeEnd ne null}">
                                                        <fmt:formatDate value="${notification.activeEnd}" pattern="dd-MMM-yyyy HH:mm:ss" var="end"/>
                                                        <c:set var="duration" value="${notification.activeEnd.time - notification.activeHistoryPK.activeStart.time}"/>
                                                        <div title="${end}">(<c:out value="${jaws:millisToHumanReadable(duration)}"/>)</div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:url value="/inventory/alarm-detail" var="url">
                                                        <c:param name="name" value="${notification.activeHistoryPK.name}"/>
                                                    </c:url>
                                                    <a title="Alarm Information" class="dialog-ready"
                                                       data-dialog-title="Alarm Information: ${fn:escapeXml(notification.activeHistoryPK.name)}"
                                                       href="${url}"><c:out
                                                            value="${notification.activeHistoryPK.name}"/></a>
                                                </td>
                                                <td>
                                                    <c:out value="${notification.alarm.action.priority.name}"/>
                                                    <div>(<c:out value="${notification.activationType}"/>)</div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${'ChannelError' eq notification.activationType}">
                                                            <div>Error=<c:out value="${notification.activationError}"/></div>
                                                        </c:when>
                                                        <c:when test="${'EPICS' eq notification.activationType}">
                                                            <div>SEVR=<c:out value="${notification.activationSevr}"/></div>
                                                            <div>STAT=<c:out value="${notification.activationStat}"/></div>
                                                        </c:when>
                                                        <c:when test="${'Note' eq notification.activationType}">
                                                            <div>Note=<c:out value="${notification.activationNote}"/></div>
                                                        </c:when>
                                                    </c:choose>
                                                    <div><c:out value="${notification.incitedWith}"/></div>
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
    </jsp:body>
</t:reports-page>