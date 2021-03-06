class SpecWriter.Views.RMTextEditor

  TAB_KEY = 9
  TAB_TEXT = "     "
  ENTER_KEY = 13
  LIST_TEXT = "*"
  TABS_AND_LIST_REGEXP = /^(( ){5})*(\*)?/
  BACKSPACE_KEY = 8
  # ' " ( { [
  PAIR_CHARS = [39, 34, 40, 123, 91]
  # ' " ) } ]
  CLOSING_PAIR_CHARS = [39, 34, 41, 125, 93]

  constructor: (element) ->
    @$el = $(element)
    @el = element[0]
    unless @$el.data("rm-text-editor")
      @$el.data("rm-text-editor", @)
      @initTab()
      @initBackSpace()
      @initNewLines()
      @initPairs()

  initTab: ->
    @onKey("keydown", TAB_KEY, (e) =>
      e.preventDefault()
      @insertText(TAB_TEXT)
    )

  initNewLines: ->
    @onKey("keyup", ENTER_KEY, (e) =>
      l = @previousLine()
      tabsAndList = l.match(TABS_AND_LIST_REGEXP)
      if tabsAndList
        toInsert = tabsAndList[0]
        if _.endsWith(toInsert, LIST_TEXT)
          toInsert = toInsert + " "
        @insertText(toInsert)
    )

  initBackSpace: ->
    @onKey("keydown", BACKSPACE_KEY, (e) =>
      pos = @caretPos()
      text = @text()
      textToPos = text.substring(0, pos)
      if pos > 0 && _.endsWith(textToPos, TAB_TEXT)
        e.preventDefault()
        newText = text.substring(0, pos - TAB_TEXT.length) + text.substring(pos, text.length)
        @$el.val(newText)
        @setCaretPos(pos - TAB_TEXT.length)
    )

  initPairs: ->
    @onKey("keypress", PAIR_CHARS, (e, keyIndex) =>
      @insertText(String.fromCharCode(CLOSING_PAIR_CHARS[keyIndex]), -1)
    )

  onKey: (eventName, keys, fun) ->
    @$el[eventName] (e) ->
      keyCode = e.keyCode || e.which
      if keys == keyCode || (_.isArray(keys) && _.include(keys, keyCode))
        ind = keys.indexOf(keyCode) if _.isArray(keys)
        fun(e, ind)

  text: ->
    @$el.val()

  insertText: (text, newCaretOffset = 0) ->
    currentText = @text()
    p = @caretPos()
    newText = currentText.substring(0, p) + text + currentText.substring(p,
      currentText.length)
    @$el.val(newText)
    @setCaretPos(p + text.length + newCaretOffset)

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

