<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<c:set var="title" value="Active Alarms"/>
<t:page title="${title}">  
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/active.css"/>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/notifications.css"/>
    </jsp:attribute>
    <jsp:attribute name="scripts">
        <script>
            jlab.materializedLocations = ${materializedLocationsArrayStr};

            jlab.visibleLocations = new Map([
                [1, {name: 'CEBAF', tree: ['CEBAF', 'MCC', 'ESR', 'HallA', 'HallB', 'HallC', 'HallD']}],
                [2, {name: 'CHL', tree: ['CHL']}],
                [3, {name: 'LERF', tree: ['LERF']}],
                [4, {name: 'UITF', tree: ['UITF']}],
                [5, {name: 'Injector', tree: ['Injector', '1D', '2D', '3D', '4D', '5D']}],
                [6, {name: 'North Linac', tree: ['North Linac', 'Linac1', 'Linac3', 'Linac5', 'Linac7', 'Linac9']}],
                [7, {name: 'South Linac', tree: ['South Linac', 'Linac2', 'Linac4', 'Linac6', 'Linac8']}],
                [8, {name: 'East Arc', tree: ['East Arc', 'ARC1', 'ARC3', 'ARC5', 'ARC7', 'ARC9']}],
                [9, {name: 'West Arc', tree: ['West Arc', 'ARC2', 'ARC4', 'ARC6', 'ARC8', 'ARCA']}],
                [10, {name: 'BSY', tree: ['BSY', 'BSY Dump', 'BSY2', 'BSY4', 'BSY6', 'BSY8', 'BSYA']}],
                [11, {name: 'HallA', tree: ['HallA']}],
                [12, {name: 'HallB', tree: ['HallB']}],
                [13, {name: 'HallC', tree: ['HallC']}],
                [14, {name: 'HallD', tree: ['HallD']}],
                [45, {name: 'MCC', tree: ['MCC']}],
                [46, {name: 'ESR', tree: ['ESR']}]
            ]);

            jlab.locationCountSpanMap = new Map();

            for(let id of jlab.visibleLocations.keys()) {
                jlab.locationCountSpanMap.set(id, document.getElementById("location-count-" + id));
            }

            jlab.systemNameIdMap = new Map([
                <c:forEach items="${systemList}" var="system">
                ['${fn:escapeXml(system.name)}',${system.systemId}],
                </c:forEach>
            ]);

            jlab.systemCountDivMap = new Map();

            for(let id of jlab.systemNameIdMap.values()) {
                jlab.systemCountDivMap.set(id, document.getElementById("system-count-" + id));
            }
        </script>
        <script type="text/javascript"
                src="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/js/active.js"></script>
        <script type="text/javascript"
                src="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/js/notifications.js"></script>
    </jsp:attribute>
    <jsp:body>
        <section>
            <s:filter-flyout-widget ribbon="true" clearButton="true">
                <form id="filter-form" method="get" action="active">
                    <div id="filter-form-panel">
                        <fieldset>
                            <legend>Filter</legend>
                            <ul class="key-value-list">
                                <li>
                                    <div class="li-key">
                                        <label for="location-select">Location</label>
                                    </div>
                                    <div class="li-value">
                                        <select id="location-select" name="location" multiple="multiple">
                                            <c:forEach items="${locationRoot.children}" var="child">
                                                <t:hierarchical-select-option-by-name node="${child}" level="0"
                                                                                      parameterName="location"/>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </li>
                            </ul>
                        </fieldset>
                    </div>
                    <input id="filter-form-submit-button" type="submit" value="Apply"/>
                </form>
            </s:filter-flyout-widget>
            <h2 id="page-header-title"><c:out value="${title}"/><span class="status" id="alarm-count"><a id="list-active-link" class="dialog-ready" data-dialog-title="Notification Snapshot" href="${pageContext.request.contextPath}/notifications?state=Active&alwaysIncludeUnregistered=Y&alwaysIncludeUnfilterable=Y${locationFilterStr}">0</a></span><span class="status" id="loading"><span class="button-indicator"></span> Loading...</span></h2>
            <div id="liveness-heartbeat">Liveness: <span id="liveness-ts">None</span></div>
            <span id="info-counts">
                (<span><a href="${pageContext.request.contextPath}/notifications?override=Latched&override=OffDelayed${locationFilterStr}"><span id="incited-count">-</span></a> Incited</span>)
                | <span><a href="${pageContext.request.contextPath}/notifications?state=Normal${locationFilterStr}"><span id="normal-count">-</span></a> Normal</span>
                (<span><a href="${pageContext.request.contextPath}/notifications?override=Disabled&override=Shelved&override=Masked&override=OnDelayed&override=Filtered${locationFilterStr}"><span id="suppressed-count">-</span></a> Suppressed</span>)
                | <span><a href="${pageContext.request.contextPath}/notifications${rootLocationFilterStr}"><span id="all-count">-</span></a> Alarms</span>
            </span>
            <div class="message-box"><c:out value="${selectionMessage}"/></div>
            <div id="diagram-container">
                <img draggable="false" alt="site" src="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/img/site.png"/>
                <div id="system-grid">
                    <c:forEach items="${systemList}" var="system">
                        <div id="system-count-${system.systemId}"><span class="system-status system-count"><a class="dialog-ready2" data-dialog-title="Notification Snapshot" href="${pageContext.request.contextPath}/notifications?state=Active&systemName=${system.name}${locationFilterStr}">0</a></span> <c:out value="${system.name}"/></div>
                    </c:forEach>
                </div>
                <c:forEach items="${locationList}" var="location">
                    <span class="location-status" id="location-count-${location.locationId}"><a class="dialog-ready" data-dialog-title="Notification Snapshot" href="${pageContext.request.contextPath}/notifications?state=Active&locationId=${location.locationId}">0</a></span>
                </c:forEach>
            </div>
            <span id="link-bar">
                <span id="unregistered" class="initially-none"><a class="dialog-ready" data-dialog-title="Notification Snapshot" href="${pageContext.request.contextPath}/notifications?state=Active&registered=N"><span class="special-count" id="unregistered-count"></span></a> Unregistered</span>
                <span id="unfilterable" class="initially-none"><a class="dialog-ready" data-dialog-title="Notification Snapshot" href="${pageContext.request.contextPath}/notifications?state=Active&filterable=N"><span class="special-count" id="unfilterable-count"></span></a> Unfilterable</span>
            </span>
        </section>
    </jsp:body>
</t:page>
