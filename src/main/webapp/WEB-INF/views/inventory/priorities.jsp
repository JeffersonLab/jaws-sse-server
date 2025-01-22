<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="s" uri="http://jlab.org/jsp/smoothness"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%> 
<c:set var="title" value="Alarm Priorities"/>
<t:inventory-page title="${title}">
    <jsp:attribute name="stylesheets">
    </jsp:attribute>
    <jsp:attribute name="scripts">
    </jsp:attribute>        
    <jsp:body>
        <section>                              
            <h2 class="page-header-title"><c:out value="${title}"/></h2>
            <div class="message-box"></div>
            <div id="chart-wrap" class="chart-wrap-backdrop">
                <table class="data-table outer-table">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th class="scrollbar-header"><span class="expand-icon" title="Expand Table"></span></th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="inner-table-cell" colspan="2">
                            <div class="pane-decorator">
                                <div class="table-scroll-pane">
                                    <table class="data-table inner-table stripped-table">
                                        <tbody>
                                        <c:forEach items="${priorityList}" var="priority">
                                            <tr data-id="${priority.priorityId}">
                                                <td><c:out value="${priority.name}"/></td>
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
        <s:editable-row-table-dialog>
            <form id="row-form">
                <ul class="key-value-list">
                    <li>
                        <div class="li-key">
                            <label for="row-code">Code</label>
                        </div>
                        <div class="li-value">
                            <input type="text" maxlength="2" pattern="[A-Z0-9]{2}" title="Sector code is a pair of uppercase letters or numbers" required="required" id="row-code"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-description">Description</label>
                        </div>
                        <div class="li-value">
                            <input type="text" maxlength="256" title="Explanation of code" required="required" id="row-description"/>
                        </div>
                    </li>
                    <li>
                        <div class="li-key">
                            <label for="row-grouping">Grouping</label>
                        </div>
                        <div class="li-value">
                            <input type="text" maxlength="16" title="Grouping Label" id="row-grouping"/>
                        </div>
                    </li>
                </ul>
            </form>
        </s:editable-row-table-dialog>
    </jsp:body>         
</t:inventory-page>