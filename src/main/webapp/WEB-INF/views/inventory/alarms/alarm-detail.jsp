<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<c:set var="title" value="Alarm"/>
<t:inventory-page title="${title}">
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/alarm.css"/>
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
                    <h2 id="page-header-title"><c:out value="${alarm.name}"/></h2>
                </li>
            </ul>
        </div>
        <section>
            <div class="dialog-content">
                <div class="dialog-links">
                    <a class="dialog-only-link" href="${pageContext.request.contextPath}/inventory/alarms/detail?alarmId=${alarm.alarmId}">Link</a>
                    <c:set var="editable" value="${pageContext.request.isUserInRole('jaws-admin')}"/>
                    <c:if test="${editable}">
                        <c:url var="url" value="/inventory/alarms">
                            <c:param name="alarmName" value="${alarm.name}"/>
                        </c:url>
                        <span class="dialog-only-link">|</span> <a href="${url}">Modify</a>
                    </c:if>
                </div>
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
                    <dt>Active Override:</dt>
                    <dd><c:out value="${alarm.notification.activeOverride eq null ? 'None' : alarm.notification.activeOverride}"/></dd>
                    <dt>Activation Type:</dt>
                    <dd><c:out value="${alarm.notification.activationType}"/></dd>
                    <dt>Activation Extra:</dt>
                    <dd>
                        <c:choose>
                            <c:when test="${'ChannelError' eq notification.activationType}">
                                Error=<c:out value="${notification.activationError}"/>
                            </c:when>
                            <c:when test="${'EPICS' eq notification.activationType}">
                                SEVR=<c:out value="${notification.activationSevr}"/>,
                                STAT=<c:out value="${notification.activationStat}"/>
                            </c:when>
                            <c:when test="${'Note' eq notification.activationType}">
                                Note=<c:out value="${notification.activationNote}"/>
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
                    <c:url var="url" value="/inventory/actions/detail">
                        <c:param name="actionId" value="${alarm.action.actionId}"/>
                    </c:url>
                    <dd>
                        <c:out value="${alarm.action.component.team.name}"/> &gt;
                        <c:out value="${alarm.action.component.name}"/> &gt;
                        <a href="${url}"><c:out value="${alarm.action.name}"/></a>
                    </dd>
                    <dt>Location:</dt>
                    <dd><c:out value="${alarm.locationNameCsv}"/></dd>
                    <dt>Device:</dt>
                    <dd><c:out value="${alarm.device eq null ? 'None' : alarm.device}"/></dd>
                    <dt>Screen Command:</dt>
                    <dd><c:out value="${alarm.screenCommand eq null ? 'None' : alarm.screenCommand}"/></dd>
                    <dt>Masked By:</dt>
                    <dd><c:out value="${alarm.maskedBy eq null ? 'None' : alarm.maskedBy}"/></dd>
                    <dt>Source:</dt>
                    <dd><c:out value="${alarm.pv eq null ? 'None' : 'EPICS PV: '.concat(alarm.pv)}"/></dd>
                </dl>
            </div>
        </section>
    </jsp:body>         
</t:inventory-page>