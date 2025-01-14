<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="title" value="Notifications"/>
<t:page title="${title}">  
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/notifications.css"/>
    </jsp:attribute>
    <jsp:attribute name="scripts">
        <script type="text/javascript"
                src="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/js/notifications.js"></script>
    </jsp:attribute>
    <jsp:body>
        <section>
            <div class="dialog-content">
                <s:filter-flyout-widget ribbon="true" clearButton="true">
                    <form id="filter-form" method="get" action="notifications">
                        <div id="filter-form-panel">
                            <fieldset>
                                <legend>Filter</legend>
                                <ul class="key-value-list">
                                    <li>
                                        <div class="li-key">
                                            <label for="state-select">State</label>
                                        </div>
                                        <div class="li-value">
                                            <select id="state-select" name="state">
                                                <option value="">&nbsp;</option>
                                                <c:forEach items="${stateList}" var="state">
                                                    <option value="${state.name()}"${param.state eq state.name() ? ' selected="selected"' : ''}>
                                                        <c:out value="${state.name()}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="li-key">
                                            <label for="overridden-select">Overridden</label>
                                        </div>
                                        <div class="li-value">
                                            <select id="overridden-select" name="overridden">
                                                <option value="">&nbsp;</option>
                                                <option value="Y"${param.overridden eq 'Y' ? ' selected="selected"' : ''}>
                                                    Yes
                                                </option>
                                                <option value="N"${param.overridden eq 'N' ? ' selected="selected"' : ''}>
                                                    No
                                                </option>
                                            </select>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="li-key">
                                            <label for="override-select">Override</label>
                                        </div>
                                        <div class="li-value">
                                            <select id="override-select" name="override" multiple="multiple">
                                                <c:forEach items="${overrideList}" var="override">
                                                    <option value="${override.name()}"${s:inArray(paramValues.override, override.name()) ? ' selected="selected"' : ''}>
                                                        <c:out value="${override.getLabel()}"/></option>
                                                </c:forEach>
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
                                            <label for="registered-select">Registered</label>
                                        </div>
                                        <div class="li-value">
                                            <select id="registered-select" name="registered">
                                                <option value="">&nbsp;</option>
                                                <option value="Y"${param.registered eq 'Y' ? ' selected="selected"' : ''}>
                                                    Yes
                                                </option>
                                                <option value="N"${param.registered eq 'N' ? ' selected="selected"' : ''}>
                                                    No
                                                </option>
                                            </select>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="li-key">
                                            <label for="filterable-select">Filterable</label>
                                        </div>
                                        <div class="li-value">
                                            <select id="filterable-select" name="filterable">
                                                <option value="">&nbsp;</option>
                                                <option value="Y"${param.filterable eq 'Y' ? ' selected="selected"' : ''}>
                                                    Yes
                                                </option>
                                                <option value="N"${param.filterable eq 'N' ? ' selected="selected"' : ''}>
                                                    No
                                                </option>
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
                                            <label for="action-select">Action</label>
                                        </div>
                                        <div class="li-value">
                                            <select id="action-select" name="actionName" multiple="multiple">
                                                <c:forEach items="${actionList}" var="action">
                                                    <option value="${fn:escapeXml(action.name)}"${s:inArray(paramValues.actionName, action.name) ? ' selected="selected"' : ''}>
                                                        <c:out value="${action.name}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="li-key">
                                            <label for="system-select">System</label>
                                        </div>
                                        <div class="li-value">
                                            <select id="system-select" name="systemName" multiple="multiple">
                                                <c:forEach items="${systemList}" var="system">
                                                    <option value="${fn:escapeXml(system.name)}"${s:inArray(paramValues.systemName, system.name) ? ' selected="selected"' : ''}>
                                                        <c:out value="${system.name}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </li>
                                </ul>
                            </fieldset>
                            <fieldset>
                                <legend>When Filtering by Active State</legend>
                                <ul class="key-value-list">
                                    <li>
                                        <div class="li-key">
                                            <label for="always-include-unregistered">Always Include Unregistered</label>
                                        </div>
                                        <div class="li-value">
                                            <input type="checkbox" id="always-include-unregistered"
                                                   name="alwaysIncludeUnregistered"
                                                   value="Y" ${param.alwaysIncludeUnregistered eq 'Y' ? 'checked="checked"' : ''}>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="li-key">
                                            <label for="always-include-unfilterable">Always Include Unfilterable</label>
                                        </div>
                                        <div class="li-value">
                                            <input type="checkbox" id="always-include-unfilterable"
                                                   name="alwaysIncludeUnfilterable"
                                                   value="Y" ${param.alwaysIncludeUnfilterable eq 'Y' ? 'checked="checked"' : ''}>
                                        </div>
                                    </li>
                                </ul>
                            </fieldset>
                        </div>
                        <input type="hidden" id="offset-input" name="offset" value="0"/>
                        <input id="filter-form-submit-button" type="submit" value="Apply"/>
                    </form>
                </s:filter-flyout-widget>
                <h2 id="page-header-title"><c:out value="${title}"/></h2>
                <div class="message-box"><c:out value="${selectionMessage}"/></div>
                <div id="chart-wrap" class="chart-wrap-backdrop">
                    <c:set var="editable"
                           value="${pageContext.request.isUserInRole('jaws-admin') || pageContext.request.isUserInRole('jaws-operator')}"/>
                    <c:if test="${editable}">
                        <s:editable-row-table-controls excludeAdd="${true}" excludeDelete="${true}"
                                                       excludeEdit="${true}" multiselect="${true}">
                            <button type="button" id="acknowledge-all-button" class="">Acknowledge All
                            </button>
                            |
                            <button type="button" id="acknowledge-button" class="selected-row-action"
                                    disabled="disabled">Acknowledge
                            </button>
                            <button type="button" id="open-suppress-button" class="selected-row-action"
                                    disabled="disabled">Suppress
                            </button>
                            <button type="button" id="open-unsuppress-button" class="selected-row-action"
                                    disabled="disabled">Unsuppress
                            </button>
                        </s:editable-row-table-controls>
                    </c:if>
                    <table id="notification-table" class="data-table outer-table stripped-table">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>State</th>
                            <th>Priority</th>
                            <th>Type</th>
                            <th></th>
                            <th class="scrollbar-header"><span class="expand-icon" title="Expand Table"></span></th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="inner-table-cell" colspan="6">
                                <div class="pane-decorator">
                                    <div class="table-scroll-pane">
                                        <table class="data-table inner-table${editable ? ' multiselect-table editable-row-table' : ''}">
                                            <tbody>
                                            <c:forEach items="${notificationList}" var="notification">
                                                <tr data-id="${notification.alarm.alarmId}"
                                                    data-action-id="${notification.alarm.action.actionId}"
                                                    data-location-id-csv="${notification.alarm.locationIdCsv}"
                                                    data-device="${notification.alarm.device}"
                                                    data-screen-command="${notification.alarm.screenCommand}"
                                                    data-managed-by="${notification.alarm.managedBy}"
                                                    data-masked-by="${notification.alarm.maskedBy}"
                                                    data-pv="${notification.alarm.pv}">
                                                    <td>
                                                        <c:url value="/inventory/alarm-detail" var="url">
                                                            <c:param name="name" value="${notification.name}"/>
                                                        </c:url>
                                                        <a title="Alarm Information" class="dialog-ready"
                                                           data-dialog-title="Alarm Information: ${fn:escapeXml(notification.name)}"
                                                           href="${url}"><c:out
                                                                value="${notification.name}"/></a>
                                                    </td>
                                                    <td>
                                                        <c:out value="${notification.state}"/>
                                                        <c:if test="${notification.activeOverride ne null}">
                                                            (<c:out value="${notification.activeOverride}"/>)
                                                        </c:if>
                                                    </td>
                                                    <td><c:out value="${notification.alarm.action.priority.name}"/></td>
                                                    <td><c:out value="${notification.activationType}"/></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${'ChannelError' eq notification.activationType}">
                                                                <div>Error=<c:out
                                                                        value="${notification.activationError}"/></div>
                                                            </c:when>
                                                            <c:when test="${'EPICS' eq notification.activationType}">
                                                                <div>SEVR=<c:out
                                                                        value="${notification.activationSevr}"/></div>
                                                                <div>STAT=<c:out
                                                                        value="${notification.activationStat}"/></div>
                                                            </c:when>
                                                            <c:when test="${'Note' eq notification.activationType}">
                                                                <div>Note=<c:out
                                                                        value="${notification.activationNote}"/></div>
                                                            </c:when>
                                                        </c:choose>
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
            </div>
        </section>
        <div id="suppress-dialog" class="dialog" title="Suppress">
            <form id="suppress-form">
                <ul class="key-value-list">
                    <li>
                        <div class="li-key">
                            <span>Alarms:</span>
                        </div>
                        <div class="li-value">
                            <ul id="suppress-selected-row-list" class="selected-row-list"></ul>
                            <span id="suppress-dialog-alarm-count"></span>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <span>Type:</span>
                        </div>
                        <div class="li-value">
                            <span class="radio-pair">
                                <label for="type-disabled">Disable</label>
                                <input name="suppress-type" id="type-disabled" type="radio" value="Disabled"/>
                            </span>
                            <span class="radio-pair">
                                <label for="type-filtered">Filter</label>
                                <input name="suppress-type" id="type-filtered" type="radio" value="Filtered"/>
                            </span>
                            <span class="radio-pair">
                                <label for="type-shelved">Shelve</label>
                                <input name="suppress-type" id="type-shelved" type="radio" value="Shelved"/>
                            </span>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="suppress-comments">Comments</label>
                        </div>
                        <div class="li-value">
                            <textarea id="suppress-comments" name="comments"></textarea>
                        </div>
                    </li>
                </ul>
                <fieldset id="shelve-fieldset">
                    <legend>Shelve</legend>
                    <ul class="key-value-list">
                        <li>
                            <div class="li-key">
                                <label for="oneshot"
                                       title="Check if this alarm unshelves when active">Oneshot</label>
                            </div>
                            <div class="li-value">
                                <input type="checkbox" id="oneshot"/>
                            </div>
                        </li>
                        <li>
                            <div class="li-key">
                                <label for="shelve-reason">Reason</label>
                            </div>
                            <div class="li-value">
                                <select id="shelve-reason">
                                    <option>Stale_Alarm</option>
                                    <option>Chattering_Fleeting_Alarm</option>
                                    <option>Other</option>
                                </select>
                            </div>
                        </li>
                        <li>
                            <div class="li-key">
                                <label for="shelve-expiration"
                                       title="How long do you want this alarm to be shelved for?">Expiration</label>
                            </div>
                            <div class="li-value">
                                <input type="text" id="shelve-expiration" class="date-time-field"
                                       placeholder="DD-MMM-YYYY hh:mm"/>
                            </div>
                        </li>
                    </ul>
                </fieldset>
                <div class="dialog-button-panel">
                    <button type="button" id="suppress-button" class="dialog-submit-button">Save</button>
                    <button type="button" class="dialog-close-button">Cancel</button>
                </div>
            </form>
        </div>
        <div id="unsuppress-dialog" class="dialog" title="Unsuppress">
            <form id="unsuppress-form">
                <ul class="key-value-list">
                    <li>
                        <div class="li-key">
                            <span>Alarms:</span>
                        </div>
                        <div class="li-value">
                            <ul id="unsuppress-selected-row-list" class="selected-row-list"></ul>
                            <span id="unsuppress-dialog-alarm-count"></span>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <span>Type:</span>
                        </div>
                        <div class="li-value">
                            <span class="radio-pair">
                                <label for="type-reenable">Reenable</label>
                                <input name="unsuppress-type" id="type-reenable" type="radio" value="Disabled"/>
                            </span>
                            <span class="radio-pair">
                                <label for="type-unfilter">Unfilter</label>
                                <input name="unsuppress-type" id="type-unfilter" type="radio" value="Filtered"/>
                            </span>
                            <span class="radio-pair">
                                <label for="type-unshelve">Unshelve</label>
                                <input name="unsuppress-type" id="type-unshelve" type="radio" value="Shelved"/>
                            </span>
                        </div>
                    </li>
                </ul>
                <div class="dialog-button-panel">
                    <button type="button" id="unsuppress-button" class="dialog-submit-button">Save</button>
                    <button type="button" class="dialog-close-button">Cancel</button>
                </div>
            </form>
        </div>
    </jsp:body>
</t:page>
