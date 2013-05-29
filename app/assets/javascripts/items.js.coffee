$ =>
  $(".item-list").sortable(
    update: (event, ui) ->
      url = $("#reorder_items_path").val()
      newOrder = []
      $("li.item").each ->
        newOrder.push($(this).data("position"))
      $.post(url, new_order: newOrder, ->
        fixItemsOrdering()
      )
  )
  $(".item-list").disableSelection()

@initItemForm = ->
  $(".cancel").click ->
    $(this).parents(".item-form, .edit-form").slideUp()

@fixItemsOrdering = ->
  $("li.item").each (index) ->
    $(this).data("position", $("li.item").length - index - 1)