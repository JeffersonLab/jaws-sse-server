<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="jaws" uri="http://jlab.org/jaws/functions" %>
<c:set var="title" value="Sync Rule History"/>
<t:reports-page title="${title}">  
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/history-entity.css"/>
    </jsp:attribute>
    <jsp:attribute name="scripts">
    </jsp:attribute>
    <jsp:body>
        <section>
            <s:filter-flyout-widget requiredMessage="true">
                <form id="filter-form" method="get" action="sync-rule">
                    <fieldset>
                        <legend>Filter</legend>
                        <ul class="key-value-list">
                            <li>
                                <div class="li-key">
                                    <label class="required-field" for="sync-rule-id">Sync Rule ID</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" id="sync-rule-id" name="syncRuleId"
                                           value="${fn:escapeXml(param.syncRuleId)}"/>
                                </div>
                            </li>
                            <li>
                                <div class="li-key">
                                    <label for="revision-id">Revision ID</label>
                                </div>
                                <div class="li-value">
                                    <input type="text" id="revision-id" name="revisionId" value="${fn:escapeXml(param.revisionId)}"/>
                                </div>
                            </li>
                        </ul>
                    </fieldset>
                    <input type="hidden" id="offset-input" name="offset" value="0"/>
                    <input id="filter-form-submit-button" type="submit" value="Apply"/>
                </form>
            </s:filter-flyout-widget>
            <h2 class="page-header-title">Inventory Activity: Sync Rule <c:out value="${param.syncRuleId}"/></h2>
            <ul class="bracket-horizontal-nav">
                <li><a href="${pageContext.request.contextPath}/reports/inventory-history">Transactions</a>&nbsp;</li>
                <li><a href="${pageContext.request.contextPath}/reports/inventory-history/alarm">Alarm</a>&nbsp;</li>
                <li><a href="${pageContext.request.contextPath}/reports/inventory-history/action">Action</a>&nbsp;
                <li>Sync Rule&nbsp;</li>
            </ul>
            <c:choose>
                <c:when test="${param.syncRuleId == null}">
                    <div class="message-box">Choose a Sync Rule ID to continue</div>
                </c:when>
                <c:when test="${fn:length(revisionList) == 0}">
                    <div class="message-box">Found 0 Revisions</div>
                </c:when>
                <c:otherwise>
                    <div class="message-box">Showing Revisions <fmt:formatNumber value="${paginator.startNumber}"/> -
                        <fmt:formatNumber value="${paginator.endNumber}"/> of <fmt:formatNumber
                                value="${paginator.totalRecords}"/></div>
                    <table id="revision-table" class="data-table stripped-table">
                        <thead>
                        <tr>
                            <th>Revision #:</th>
                            <c:forEach items="${revisionList}" var="revision" varStatus="status">
                                <td>
                                    <c:out value="${status.count + paginator.offset}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        </thead>
                        <tfoot>
                        <tr>
                            <th>Modified By:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.revision.user != null ? s:formatUser(entity.revision.user) : entity.revision.username}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Modified Date:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <fmt:formatDate pattern="dd-MMM-yyyy HH:mm"
                                                    value="${entity.revision.revisionDate}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Computer:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${jaws:getHostnameFromIp(entity.revision.address)}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Revision ID:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.revision.id}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Revision Type:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.type}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        </tfoot>
                        <tbody>
                        <tr>
                            <th>Action:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <c:url value="/reports/inventory-history/action" var="url">
                                    <c:param name="actionId" value="${entity.actionId}"/>
                                </c:url>
                                <td>
                                    <a href="${url}"><c:out value="${entity.actionId}"/></a>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Sync Server:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.syncServer.name}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Description:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.description}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Base Query:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.query}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Property Expression:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.propertyExpression}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Primary Attribute:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.foreignAttribute}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Foreign Attribute:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.foreignAttribute}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Foreign Base Query:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.foreignQuery}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Foreign Property Expression:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.foreignExpression}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Alarm Name:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.alarmName}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Screen Command:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.screenCommand}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>PV:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.pv}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <th>Sub-Locations:</th>
                            <c:forEach items="${revisionList}" var="entity">
                                <td>
                                    <c:out value="${entity.subLocations ? 'Yes' : 'No'}"/>
                                </td>
                            </c:forEach>
                        </tr>
                        </tbody>
                    </table>
                    <div class="revision-controls">
                        <button id="previous-button" type="button" data-offset="${paginator.previousOffset}"
                                value="Previous"${paginator.previous ? '' : ' disabled="disabled"'}>Previous
                        </button>
                        <button id="next-button" type="button" data-offset="${paginator.nextOffset}"
                                value="Next"${paginator.next ? '' : ' disabled="disabled"'}>Next
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </jsp:body>
</t:reports-page>
