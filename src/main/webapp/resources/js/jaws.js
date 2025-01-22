var jlab = jlab || {};
jlab.sanitizeConfig = {
    ALLOWED_TAGS: ['p', '#text', 'h1', 'h2', 'h3', 'em', 'strong', 'ul', 'ol', 'li', 'a', 'table', 'thead', 'tbody', 'tr', 'td', 'th'],
    KEEP_CONTENT: false
};

jlab.initMarkdownWidgets = function() {
    $(".markdown-widget").each(function (item) {
        let markdown = $(this).find(".markdown-text").text(),
            rendered = DOMPurify.sanitize(marked.parse(markdown), jlab.sanitizeConfig);

        $(this).find(".markdown-html").html(rendered);
    });
};
jlab.doneLoading = function() {
    jlab.initMarkdownWidgets();
};
/*jlab.openPageInDialog = function (href, title) {
    $("<div class=\"page-dialog\"></div>")
        .load(href + ' .dialog-content', jlab.doneLoading)
        .dialog({
            modal: true,
            autoOpen: true,
            title: title,
            width: jlab.pageDialog.width,
            height: jlab.pageDialog.height,
            minWidth: jlab.pageDialog.minWidth,
            minHeight: jlab.pageDialog.minHeight,
            resizable: jlab.pageDialog.resizable,
            close: function () {
                $(this).dialog('destroy').remove();
            }
        });
};*/
$(function () {
    jlab.initMarkdownWidgets();
});