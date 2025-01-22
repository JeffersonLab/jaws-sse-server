<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness"%>
<%@taglib prefix="jaws" uri="http://jlab.org/jaws/functions" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<c:set var="title" value="Alarm Actions"/>
<t:inventory-page title="${title}">
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/actions.css"/>
    </jsp:attribute>
    <jsp:attribute name="scripts">
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/js/actions.js"></script>
    </jsp:attribute>
    <jsp:body>
        <section>
            <s:filter-flyout-widget clearButton="true">
                <form id="filter-form" method="get" action="actions">
                    <div id="filter-form-panel">
                        <fieldset>
                            <legend>Filter</legend>
                            <ul class="key-value-list">
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
                        <th>System</th>
                        <th>Priority</th>
                        <th></th>
                        <th class="scrollbar-header"><span class="expand-icon" title="Expand Table"></span></th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="inner-table-cell" colspan="6">
                            <div class="pane-decorator">
                                <div class="table-scroll-pane">
                                    <table class="data-table inner-table stripped-table ${readonly ? '' : 'uniselect-table editable-row-table'}">
                                        <tbody>
                                        <c:forEach items="${actionList}" var="action">
                                            <tr data-id="${action.actionId}" data-system-id="${action.system.systemId}" data-priority-id="${action.priority.priorityId}" data-corrective-action="${fn:escapeXml(action.correctiveAction)}" data-rationale="${fn:escapeXml(action.rationale)}"  data-filterable="${action.filterable}" data-latchable="${action.latchable}" data-ondelay="${action.onDelaySeconds}" data-offdelay="${action.offDelaySeconds}">
                                                <td>
                                                    <c:url value="/inventory/actions/${jaws:urlEncodePath(action.name)}" var="url">
                                                    </c:url>
                                                    <a title="Action Information" class="dialog-ready"
                                                       data-dialog-title="Action Information: ${fn:escapeXml(action.name)}"
                                                       href="${url}"><c:out
                                                        value="${action.name}"/></a>
                                                </td>
                                                <td><c:out value="${action.system.name}"/></td>
                                                <td><c:out value="${action.priority.name}"/></td>
                                                <td>
                                                    <!-- Use onclick to avoid https://bugs.webkit.org/show_bug.cgi?id=30103 -->
                                                    <form method="get"
                                                          action="${pageContext.request.contextPath}/inventory/actions/${fn:escapeXml(action.name)}">
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
                            <label for="row-system">System</label>
                        </div>
                        <div class="li-value">
                            <select id="row-system" required="required">
                                <option value="">&nbsp;</option>
                                <c:forEach items="${systemList}" var="system">
                                    <option value="${system.systemId}">
                                        <c:out value="${system.name}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-priority">Priority</label>
                        </div>
                        <div class="li-value">
                            <select id="row-priority" required="required">
                                <option value="">&nbsp;</option>
                                <c:forEach items="${priorityList}" var="priority">
                                    <option value="${priority.priorityId}">
                                        <c:out value="${priority.name}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                    </li>
                </ul>

                <h3>Corrective Action</h3>
                <div class="split-pane">
                    <div class="left-pane">
                        <textarea id="corrective-action-textarea" placeholder="Markdown"></textarea>
                    </div>
                    <div class="splitter"></div>
                    <div class="right-pane">
                        <div class="markdown-html" id="corrective-action-rendered"></div>
                    </div>
                </div>

                <h3>Rationale</h3>
                <div class="split-pane">
                    <div class="left-pane">
                        <textarea id="rationale-textarea" placeholder="Markdown"></textarea>
                    </div>
                    <div class="splitter"></div>
                    <div class="right-pane">
                        <div class="markdown-html" id="rationale-rendered"></div>
                    </div>
                </div>

                <ul class="key-value-list bottom-ul">
                    <li>
                        <div class="li-key">
                            <label for="row-filterable">Filterable</label>
                        </div>
                        <div class="li-value">
                            <input type="checkbox" id="row-filterable"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-latchable">Latchable</label>
                        </div>
                        <div class="li-value">
                            <input type="checkbox" id="row-latchable"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-ondelay">On Delay (seconds)</label>
                        </div>
                        <div class="li-value">
                            <input type="text" id="row-ondelay"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-offdelay">Off Delay (seconds)</label>
                        </div>
                        <div class="li-value">
                            <input type="text" id="row-offdelay"/>
                        </div>
                    </li>
                </ul>
            </form>
        </s:editable-row-table-dialog>
    </jsp:body>         
</t:inventory-page>