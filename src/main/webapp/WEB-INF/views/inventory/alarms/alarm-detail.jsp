<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness" %>
<%@taglib prefix="jaws" uri="http://jlab.org/jaws/functions" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="title" value="Alarm"/>
<t:inventory-page title="${title}">
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/alarm.css"/>
    </jsp:attribute>
    <jsp:attribute name="scripts">
    </jsp:attribute>
    <jsp:body>
        <div class="banner-breadbox">
            <ul>
                <li>
                    <span>Alarms</span>
                </li>
                <li>
                    <h2 class="page-header-title"><c:out value="${param.name}"/></h2>
                </li>
            </ul>
        </div>
        <section>
            <div class="dialog-content">
                <div class="dialog-links">
                    <c:url value="/inventory/alarms/${jaws:urlEncodePath(param.name)}" var="url">
                    </c:url>
                    <a class="dialog-only-link"
                       href="${url}">Link</a>
                    <c:set var="editable" value="${pageContext.request.isUserInRole('jaws-admin')}"/>
                    <c:if test="${editable}">
                        <c:url var="url" value="/inventory/alarms">
                            <c:param name="alarmName" value="${alarm.name}"/>
                            <c:param name="edit" value="Y"/>
                        </c:url>
                        <span class="dialog-only-link">|</span> <a href="${url}">Modify</a>
                    </c:if>
                </div>
                <c:choose>
                    <c:when test="${alarm ne null}">
                        <h3>Quick Response Info</h3>
                        <dl>
                            <dt>Priority</dt>
                            <dd><c:out value="${alarm.action.priority.name}"/></dd>
                            <dt>Corrective Action</dt>
                            <dd>
                                <div class="markdown-widget">
                                    <div class="markdown-text"><c:out value="${alarm.action.correctiveAction}"/></div>
                                    <div class="markdown-html"></div>
                                </div>
                            </dd>
                        </dl>
                        <h3>Notification Details</h3>
                        <dl>
                            <dt>State:</dt>
                            <dd><c:out value="${alarm.notification.state}"/></dd>
                            <dt>Since:</dt>
                            <dd>
                                <fmt:formatDate value="${alarm.notification.since}" pattern="dd-MMM-yyyy HH:mm:ss"/>
                            </dd>
                            <dt>Active Override:</dt>
                            <dd>
                                <c:out
                                        value="${alarm.notification.activeOverride eq null ? 'None' : alarm.notification.activeOverride}"/>
                            </dd>
                            <dt>Activation Type:</dt>
                            <dd><c:out value="${alarm.notification.activationType}"/></dd>
                            <dt>Activation Extra:</dt>
                            <dd>
                                <c:choose>
                                    <c:when test="${'ChannelError' eq alarm.notification.activationType}">
                                        Error=<c:out value="${alarm.notification.activationError}"/>
                                    </c:when>
                                    <c:when test="${'EPICS' eq alarm.notification.activationType}">
                                        SEVR=<c:out value="${alarm.notification.activationSevr}"/>,
                                        STAT=<c:out value="${alarm.notification.activationStat}"/>
                                    </c:when>
                                    <c:when test="${'Note' eq alarm.notification.activationType}">
                                        Note=<c:out value="${alarm.notification.activationNote}"/>
                                    </c:when>
                                    <c:otherwise>
                                        None
                                    </c:otherwise>
                                </c:choose>
                            </dd>
                            <dt>Overrides</dt>
                            <dd>
                                <c:choose>
                                    <c:when test="${not empty alarm.overrideList}">
                                        <ul>
                                            <c:forEach items="${alarm.overrideList}" var="override">
                                                <li>
                                                    <c:out value="${override.overridePK.type}"/>
                                                    <ul>
                                                        <c:choose>
                                                            <c:when test="${'Disabled' eq override.overridePK.type || 'Filtered' eq override.overridePK.type}">
                                                                <li>Comments: <c:out value="${override.comments}"/></li>
                                                            </c:when>
                                                            <c:when test="${'Shelved' eq override.overridePK.type}">
                                                                <li>Comments: <c:out value="${override.comments}"/></li>
                                                                <li>Oneshot: <c:out
                                                                        value="${override.oneshot ? 'Yes' : 'No'}"/></li>
                                                                <li>Reason: <c:out value="${override.shelvedReason}"/></li>
                                                                <li>Expiration: <fmt:formatDate value="${override.expiration}"
                                                                                                pattern="dd-MMM-yyyy HH:mm:ss"/></li>
                                                            </c:when>
                                                            <c:when test="${'OnDelayed' eq override.overridePK.type}">
                                                                <li>Expiration: <fmt:formatDate value="${override.expiration}"
                                                                                                pattern="dd-MMM-yyyy HH:mm:ss"/></li>
                                                            </c:when>
                                                        </c:choose>
                                                    </ul>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        None
                                    </c:otherwise>
                                </c:choose>
                            </dd>
                        </dl>
                        <h3>Registration Details</h3>
                        <dl>
                            <dt>Taxonomy:</dt>
                            <c:url var="url" value="/inventory/actions/${jaws:urlEncodePath(alarm.action.name)}">
                            </c:url>
                            <dd>
                                <c:out value="${alarm.action.system.team.name}"/> &gt;
                                <c:out value="${alarm.action.system.name}"/> &gt;
                                <a href="${url}"><c:out value="${alarm.action.name}"/></a>
                            </dd>
                            <dt>Location:</dt>
                            <dd><c:out value="${alarm.locationNameCsv}"/></dd>
                            <dt>Alias:</dt>
                            <dd><c:out value="${alarm.alias eq null ? 'None' : alarm.alias}"/></dd>
                            <dt>Device:</dt>
                            <dd><c:out value="${alarm.device eq null ? 'None' : alarm.device}"/></dd>
                            <dt>Screen Command:</dt>
                            <dd><c:out value="${alarm.screenCommand eq null ? 'None' : alarm.screenCommand}"/></dd>
                            <dt>Managed By:</dt>
                            <dd><c:out value="${alarm.managedBy eq null ? 'None' : alarm.managedBy}"/></dd>
                            <dt>Masked By:</dt>
                            <dd><c:out value="${alarm.maskedBy eq null ? 'None' : alarm.maskedBy}"/></dd>
                            <dt>Source:</dt>
                            <dd><c:out value="${alarm.pv eq null ? 'None' : 'EPICS PV: '.concat(alarm.pv)}"/></dd>
                            <dt>Sync Rule:</dt>
                            <dd>
                                <c:choose>
                                    <c:when test="${alarm.syncRule eq null}">
                                        None
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="url" value="/setup/syncs/${alarm.syncRule.syncRuleId}">
                                        </c:url>
                                        <a href="${url}"><c:out value="${alarm.syncRule.description ne null ? alarm.syncRule.description : alarm.action.name}"/> (#${alarm.syncRule.syncRuleId})</a>
                                    </c:otherwise>
                                </c:choose>
                            </dd>
                            <dt>Sync Element:</dt>
                            <dd>
                                <c:choose>
                                    <c:when test="${alarm.syncElementId eq null}">
                                        None
                                    </c:when>
                                    <c:otherwise>
                                        <c:set value="${alarm.syncElementName ne null ? alarm.syncElementName : alarm.name.split(' ')[0]}" var="elementName"/>
                                        <c:url var="url" value="${alarm.syncRule.syncServer.baseUrl}${alarm.syncRule.syncServer.elementPath}/${jaws:urlEncodePath(elementName)}">
                                        </c:url>
                                        <a href="${url}"><c:out value="${elementName}"/> (#${alarm.syncElementId})</a>
                                    </c:otherwise>
                                </c:choose>
                            </dd>
                        </dl>
                        <hr/>
                        <dl>
                            <dt>Rationale:</dt>
                            <dd>
                                <div class="markdown-widget">
                                    <div class="markdown-text"><c:out value="${alarm.action.rationale}"/></div>
                                    <div class="markdown-html"></div>
                                </div>
                            </dd>
                            <dt>Filterable:</dt>
                            <dd><c:out value="${alarm.action.filterable ? 'Yes' : 'No'}"/></dd>
                            <dt>Latchable:</dt>
                            <dd><c:out value="${alarm.action.latchable ? 'Yes' : 'No'}"/></dd>
                            <dt>On Delay (seconds):</dt>
                            <dd><c:out
                                    value="${alarm.action.onDelaySeconds eq null ? 'None' : alarm.action.onDelaySeconds}"/></dd>
                            <dt>Off Delay (seconds):</dt>
                            <dd><c:out
                                    value="${alarm.action.offDelaySeconds eq null ? 'None' : alarm.action.offDelaySeconds}"/></dd>
                        </dl>
                        <hr/>
                        <dl>
                            <dt>History:</dt>
                            <dd>
                                <ul>
                                    <li>
                                        <c:url var="url" value="/reports/active-history">
                                            <c:param name="alarmName" value="${alarm.name}"/>
                                        </c:url>
                                        <a href="${url}">Active</a>
                                    </li>
                                    <li>
                                        <c:url var="url" value="/reports/suppress-history">
                                            <c:param name="alarmName" value="${alarm.name}"/>
                                        </c:url>
                                        <a href="${url}">Suppress</a>
                                    </li>
                                    <li>
                                        <c:url var="url" value="/reports/inventory-history/alarm">
                                            <c:param name="alarmId" value="${alarm.alarmId}"/>
                                        </c:url>
                                        <a href="${url}">Inventory</a>
                                    </li>
                                </ul>
                            </dd>
                        </dl>
                    </c:when>
                    <c:otherwise>
                        <div>Unregistered Alarm!
                        <p>An administrator can register this alarm in the <a href="${pageContext.request.contextPath}/inventory/alarms">inventory</a>.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </jsp:body>
</t:inventory-page>