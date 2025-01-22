<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness" %>
<%@taglib prefix="jaws" uri="http://jlab.org/jaws/functions" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="title" value="Inventory History"/>
<t:reports-page title="${title}">  
    <jsp:attribute name="stylesheets">   
        <style type="text/css">
            .table-cell-list {
                list-style: none;
                margin: 0;
                padding: 0;
            }

            .table-cell-list-item {
                margin: 1em 0;
            }

            .changes-header {
                width: 250px;
            }
        </style>
    </jsp:attribute>
    <jsp:attribute name="scripts">              
        <script type="text/javascript">
            $(document).on("click", ".default-clear-panel", function () {
                $("#start").val('');
                $("#end").val('');
                $("#range").val('custom').trigger('change');
                $("#entity-select").val('');
                $("#type-select").val('');
                return false;
            });
        </script>
    </jsp:attribute>
    <jsp:body>
        <section>
            <s:filter-flyout-widget clearButton="true">
                <form id="filter-form" method="get" action="inventory-history">
                    <div id="filter-form-panel">
                        <fieldset>
                            <legend>Filter</legend>
                            <s:date-range datetime="${true}" sevenAmOffset="${true}"/>
                        <ul class="key-value-list">
                            <li>
                                <div class="li-key">
                                    <label for="entity-select">Entity</label>
                                </div>
                                <div class="li-value">
                                    <select id="entity-select" name="entity">
                                        <option value="">&nbsp;</option>
                                        <c:forEach items="${entityList}" var="entity">
                                            <option value="${entity.name()}"${param.entity eq entity.name() ? ' selected="selected"' : ''}>
                                                <c:out value="${entity.name()}"/></option>
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
                                            <option value="${type.name()}"${param.type eq type.name() ? ' selected="selected"' : ''}>
                                                <c:out value="${type.name()}"/></option>
                                        </c:forEach>
                                    </select>
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
            <ul class="bracket-horizontal-nav">
                <li>Transactions&nbsp;</li>
                <li>
                    <a href="${pageContext.request.contextPath}/reports/inventory-history/alarm">Alarm</a>&nbsp;
                </li>
                <li><a href="${pageContext.request.contextPath}/reports/inventory-history/action">Action</a>&nbsp;
                </li>
                <li><a href="${pageContext.request.contextPath}/reports/inventory-history/sync-rule">Sync Rule</a>&nbsp;
                </li>
            </ul>
            <div class="message-box"><c:out value="${selectionMessage}"/></div>
            <div class="chart-wrap-backdrop">
                <c:if test="${fn:length(transactionList) > 0}">
                    <table class="data-table stripped-table">
                        <thead>
                        <tr>
                            <th title="Transaction ID">Trans. ID</th>
                            <th>Modified Date</th>
                            <th>Modified By</th>
                            <th>Computer</th>
                            <th class="changes-header">Changes</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${transactionList}" var="revision">
                            <tr>
                                <td><c:out value="${revision.id}"/></td>
                                <td><fmt:formatDate value="${revision.revisionDate}" pattern="dd-MMM-yyyy HH:mm"/></td>
                                <td><c:out
                                        value="${revision.user != null ? s:formatUser(revision.user) : revision.username}"/></td>
                                <td><c:out value="${jaws:getHostnameFromIp(revision.address)}"/></td>
                                <td>
                                    <c:if test="${fn:length(revision.changeList) > 0}">
                                        <ul class="table-cell-list">
                                            <c:forEach items="${revision.changeList}" var="change">
                                                <li class="table-cell-list-item">
                                                    <a title="${change.entityClass.simpleName} Audit"
                                                       href="${pageContext.request.contextPath}/reports/inventory-history/${change.path}"><c:out
                                                            value="${change.type} ${change.classLabel} ${change.entityName}"/></a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    <div class="paginator-button-panel">
                        <button id="previous-button" type="button" data-offset="${paginator.previousOffset}"
                                value="Previous"${paginator.previous ? '' : ' disabled="disabled"'}>Previous
                        </button>
                        <button id="next-button" type="button" data-offset="${paginator.nextOffset}"
                                value="Next"${paginator.next ? '' : ' disabled="disabled"'}>Next
                        </button>
                    </div>
                </c:if>
            </div>
        </section>
    </jsp:body>
</t:reports-page>