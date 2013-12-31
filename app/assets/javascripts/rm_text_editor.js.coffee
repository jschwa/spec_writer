class SpecWriter.Views.RMTextEditor

  TAB_KEY = 9
  TAB_TEXT = "     "
  ENTER_KEY = 13
  LIST_TEXT = "*"

  constructor: (element) ->
    @$el = $(element)
    @el = element[0]
    unless @$el.data("rm-text-editor")
      @$el.data("rm-text-editor", @)
      @initTab()
      @initNewLines()

  initTab: ->
    @onKey("keydown", TAB_KEY, (e) =>
      e.preventDefault()
      @insertText(TAB_TEXT)
    )

  initNewLines: ->
    @onKey("keyup", ENTER_KEY, (e) =>
      l = @previousLine()
      tabsAndList =  l.match(/^(( ){5})*(\*)?/)
      if tabsAndList
        toInsert = tabsAndList[0]
        if _.endsWith(toInsert, "*")
          toInsert = toInsert + " "
        @insertText(toInsert)
    )

  onKey: (eventName, keys, fun) ->
    @$el[eventName] (e) ->
      keyCode = e.keyCode || e.which
      if keys == keyCode || (keys.isArray && _.include(keys, keyCode))
        fun(e)

  text: ->
    @$el.val()

  insertText: (text) ->
    currentText = @text()
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

  previousLine: ->
    pos = @caretPos()
    text = @text().substring(0, pos)
    lines = _.lines(text)
    if lines.length > 1
      lines[lines.length - 2]

