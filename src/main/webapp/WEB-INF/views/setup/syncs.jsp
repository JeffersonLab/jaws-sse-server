<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness" %>
<%@taglib prefix="jaws" uri="http://jlab.org/jaws/functions" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="title" value="Sync Rules"/>
<t:setup-page title="${title}">
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/syncs.css"/>
    </jsp:attribute>
    <jsp:attribute name="scripts">
        <script type="text/javascript"
                src="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/js/syncs.js"></script>
    </jsp:attribute>
    <jsp:body>
        <section>
            <s:filter-flyout-widget clearButton="true">
                <form id="filter-form" method="get" action="syncs">
                    <div id="filter-form-panel">
                        <fieldset>
                            <legend>Filter</legend>
                            <ul class="key-value-list">
                                <li>
                                    <div class="li-key">
                                        <label for="sync-rule-id">Sync Rule ID</label>
                                    </div>
                                    <div class="li-value">
                                        <input id="sync-rule-id"
                                               name="syncRuleId" value="${fn:escapeXml(param.syncRuleId)}"/>
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
                <table id="rule-table" class="data-table outer-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Action</th>
                        <th>Server</th>
                        <th>Description</th>
                        <th></th>
                        <th class="scrollbar-header"><span class="expand-icon" title="Expand Table"></span></th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="inner-table-cell" colspan="7">
                            <div class="pane-decorator">
                                <div class="table-scroll-pane">
                                    <table class="data-table inner-table stripped-table ${readonly ? '' : 'uniselect-table editable-row-table'}">
                                        <tbody>
                                        <c:forEach items="${syncList}" var="sync">
                                            <tr data-id="${sync.syncRuleId}" data-action-id="${sync.action.actionId}"
                                                data-name="${fn:escapeXml(sync.alarmName)}"
                                                data-screencommand="${fn:escapeXml(sync.screenCommand)}"
                                                data-pv="${fn:escapeXml(sync.pv)}"
                                                data-sub-locations="${sync.subLocations ? 'Y' : 'N'}"
                                                data-query="${fn:escapeXml(sync.query)}"
                                                data-expression="${fn:escapeXml(sync.propertyExpression)}"
                                                data-primary-attribute="${fn:escapeXml(sync.primaryAttribute)}"
                                                data-foreign-attribute="${fn:escapeXml(sync.foreignAttribute)}"
                                                data-foreign-query="${fn:escapeXml(sync.foreignQuery)}"
                                                data-foreign-expression="${fn:escapeXml(sync.foreignExpression)}">
                                                <td><c:out value="${sync.syncRuleId}"/></td>
                                                <td>
                                                    <c:url value="/inventory/actions/${jaws:urlEncodePath(sync.action.name)}"
                                                           var="url">
                                                    </c:url>
                                                    <a title="Action Information" class="dialog-ready"
                                                       data-dialog-title="Action Information: ${fn:escapeXml(sync.action.name)}"
                                                       href="${url}"><c:out
                                                            value="${sync.action.name}"/></a>
                                                </td>
                                                <td><c:out value="${sync.syncServer.name}"/></td>
                                                <td><c:out value="${sync.description}"/></td>
                                                <td>
                                                    <!-- Use onclick to avoid https://bugs.webkit.org/show_bug.cgi?id=30103 -->
                                                    <c:url value="/setup/syncs/${jaws:urlEncodePath(sync.syncRuleId)}"
                                                           var="url">
                                                    </c:url>
                                                    <form method="get"
                                                          action="${pageContext.request.contextPath}/setup/syncs/${fn:escapeXml(sync.syncRuleId)}">
                                                        <button class="single-char-button" type="button"
                                                                onclick="window.location.href = '${url}';  return false;">
                                                            &rarr;
                                                        </button>
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
                <div id="rule-form-tabs">
                    <ul>
                        <li><a href="#primary-tab">Primary</a></li>
                        <li><a href="#join-tab">Join</a></li>
                        <li><a href="#template-tab">Template</a></li>
                    </ul>
                    <div id="primary-tab">
                        <ul class="key-value-list">
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
                                    <label for="row-server">Server</label>
                                </div>
                                <div class="li-value">
                                    <select id="row-server" required="required">
                                        <option value="">&nbsp;</option>
                                        <c:forEach items="${serverList}" var="server">
                                            <option value="${server.name}">
                                                <c:out value="${server.name}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </li>
                            <li>
                                <div class="li-key">
                                    <label for="row-description">Description</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" required="required" id="row-description"/>
                                </div>
                            </li>
                            <li>
                                <div class="li-key">
                                    <label for="row-query">Base Query</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" required="required" id="row-query"
                                           placeholder="URL Encoded (Example: t=IOC&a=A_HallA)"/>
                                </div>
                            </li>
                            <li>
                                <div class="li-key">
                                    <label for="row-expression">Property Expression</label>
                                </div>
                                <div class="li-value">
                            <textarea id="row-expression"
                                      placeholder="Not URL Encoded, each line is automatically combined with &amp;. Example:

!unpowered
!hallcontrolled"></textarea>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <div id="join-tab">
                        <ul class="key-value-list">
                            <li>
                                <div class="li-key">
                                    <label for="row-primary-attribute">Primary Attribute</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" required="required" id="row-primary-attribute"
                                           placeholder="Examples: name, Controlled_by, Housed_by"/>
                                </div>
                            </li>
                            <li>
                                <div class="li-key">
                                    <label for="row-foreign-attribute">Foreign Attribute</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" required="required" id="row-foreign-attribute"
                                           placeholder="Examples: name, Controlled_by, Housed_by"/>
                                </div>
                            </li>
                            <li>
                                <div class="li-key">
                                    <label for="row-foreign-query">Foreign Base Query</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" required="required" id="row-foreign-query"
                                           placeholder="URL Encoded (Example: t=IOC&a=A_HallA)"/>
                                </div>
                            </li>
                            <li>
                                <div class="li-key">
                                    <label for="row-foreign-expression">Foreign<br/>Property Expression</label>
                                </div>
                                <div class="li-value">
                            <textarea id="row-foreign-expression"
                                      placeholder="Not URL Encoded, each line is automatically combined with &amp;. Example:

!unpowered
!hallcontrolled"></textarea>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <div id="template-tab">
                        <ul class="key-value-list">
                            <li>
                                <div class="li-key">
                                    <label for="row-name">Name</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" id="row-name" value="{ElementName} {ActionName}"/>
                                </div>
                            </li>
                            <li>
                                <div class="li-key right">
                                    <label for="row-alias">Alias</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" id="row-alias" value="{NameAlias}" disabled="disabled"/>
                                </div>
                            </li>
                            <li>
                                <div class="li-key">
                                    <label for="row-location">Location</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" id="row-location" value="{function:locationFromSegMask(SegMask)}"
                                           disabled="disabled"/>
                                </div>
                            </li>
                            <li>
                                <div class="li-key">
                                    <label for="row-sub-locations">Sub-Locations</label>
                                </div>
                                <div class="li-value">
                                    <input type="checkbox" id="row-sub-locations" checked="checked"/>
                                    <div>Check to include Locations that specify pass or fine-grained segment</div>
                                </div>
                            </li>
                            <li>
                                <div class="li-key">
                                    <label for="row-screencommand">Screen Command</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" id="row-screencommand"/>
                                </div>
                            </li>
                            <li>
                                <div class="li-key">
                                    <label for="row-pv">PV</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" id="row-pv"/>
                                </div>
                            </li>
                        </ul>
                        <div><b>Expression variables</b>: {ElementName}, {ActionName}, {Area}, {ForeignName}</div>
                        <div><b>Plus any CED API Property Name such as</b>: {EPICSName}, {HVName}</div>
                    </div>
                </div>
            </form>
            <button id="save-and-run-button" type="button">Save and Run</button>
        </s:editable-row-table-dialog>
    </jsp:body>
</t:setup-page>