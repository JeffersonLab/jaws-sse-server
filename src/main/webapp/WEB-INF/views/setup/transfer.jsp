<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="title" value="Transfer"/>
<t:setup-page title="${title}">
    <jsp:attribute name="stylesheets">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/css/transfer.css"/>
    </jsp:attribute>
    <jsp:attribute name="scripts">
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/v${initParam.releaseNumber}/js/transfer.js"></script>
    </jsp:attribute>
    <jsp:body>
        <section>
            <h2 class="page-header-title"><c:out value="${title}"/></h2>
            <div class="message-box"></div>
            <table class="data-table">
                <thead>
                <tr>
                    <th>Topic</th>
                    <th>Key=Value List</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <form method="post" action="${pageContext.request.contextPath}/ajax/setup/add-alarm-key-value-list">
                        <td>Alarms</td>
                        <td>
                            <textarea id="alarms-textarea" name="actions"></textarea>
                        </td>
                        <td><button id="alarms-import-button" type="button">Import</button></td>
                    </form>
                </tr>
                <tr>
                    <form method="post" action="${pageContext.request.contextPath}/ajax/setup/add-action-key-value-list">
                    <td>Actions</td>
                    <td>
                        <textarea id="actions-textarea" name="actions"></textarea>
                    </td>
                    <td><button id="actions-import-button" type="button">Import</button></td>
                    </form>
                </tr>
                </tbody>
            </table>
        </section>
    </jsp:body>
</t:setup-page>