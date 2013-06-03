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
  $("#page_public").change ->
    $(this).parents("form").submit()

@initItemForm = ->
  $(".cancel").click ->
    $(this).parents(".item-form, .edit-form").slideUp()
    $(this).parents(".item").find(".item-view-container").show()

@fixItemsOrdering = ->
  $("li.item").each (index) ->
    $(this).data("position", $("li.item").length - index - 1)