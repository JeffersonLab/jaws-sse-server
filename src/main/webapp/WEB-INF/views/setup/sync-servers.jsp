<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness"%>
<%@taglib prefix="jaws" uri="http://jlab.org/jaws/functions" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<c:set var="title" value="Sync Servers"/>
<t:setup-page title="${title}">
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/sync-servers.css"/>
    </jsp:attribute>
    <jsp:attribute name="scripts">
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/js/sync-servers.js"></script>
    </jsp:attribute>
    <jsp:body>
        <section>
            <h2 class="page-header-title"><c:out value="${title}"/></h2>
            <div id="chart-wrap" class="chart-wrap-backdrop">
                <table class="data-table outer-table">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Base URL</th>
                        <th>Element Path</th>
                        <th>Search Path</th>
                        <th>Extra Search Query</th>
                        <th class="scrollbar-header"><span class="expand-icon" title="Expand Table"></span></th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="inner-table-cell" colspan="7">
                            <div class="pane-decorator">
                                <div class="table-scroll-pane">
                                    <table class="data-table inner-table stripped-table">
                                        <tbody>
                                        <c:forEach items="${serverList}" var="server">
                                            <tr data-id="${server.syncServerId}">
                                                <td><c:out value="${server.name}"/></td>
                                                <td><c:out value="${server.baseUrl}"/></td>
                                                <td><c:out value="${server.elementPath}"/></td>
                                                <td><c:out value="${server.searchPath}"/></td>
                                                <td><c:out value="${server.extraSearchQuery}"/></td>
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
            </div>
        </section>
    </jsp:body>         
</t:setup-page>