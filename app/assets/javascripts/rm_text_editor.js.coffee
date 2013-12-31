class SpecWriter.Views.RMTextEditor

  TAB_KEY = 9
  TAB_TEXT = "     "

  constructor: (element) ->
    @$el = $(element)
    @el = element[0]
    unless @$el.data("rm-text-editor")
      @$el.data("rm-text-editor", @)
      @initTab()

  initTab: ->
    @onKeydown(TAB_KEY, (e) =>
      e.preventDefault()
      @insertText(TAB_TEXT)
    )

  onKeydown: (keys, fun) ->
    @$el.keydown (e) ->
      keyCode = e.keyCode || e.which
      if keys == keyCode || (keys.isArray && _.include(keys, keyCode))
        fun(e)

  insertText: (text) ->
    currentText = @$el.val()
    p = @caretPos()
    newText = currentText.substring(0, p) + text + currentText.substring(p,
      currentText.length)
    @$el.val(newText)
    @setCaretPos(p + text.length)

  caretPos: ->
    if @el.selectionStart
      return @el.selectionStart
    else if document.selection
      @el.focus()
      r = document.selection.createRange()
      unless r
        return 0;
      re = el.createTextRange()
      rc = re.duplicate()
      re.moveToBookmark(r.getBookmark())
      rc.setEndPoint('EndToStart', re)
      return rc.text.length
    else
      return 0

  setCaretPos: (caretPos) ->
    if @el.createTextRange
      range = @el.createTextRange()
      range.move('character', caretPos)
      range.select()
    else if @el.selectionStart
      @el.focus();
      @el.setSelectionRange(caretPos, caretPos);