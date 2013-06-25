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
    handle: ".icon-move"
    axis: "y"
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
  $(".insert-item-container").each (index) ->
    position = $(".insert-item-container").length - index - 1
    $(this).attr("data-position", position)
    $(this).find("a").each ->
      $(this).attr("href", $(this).attr("href").replace(/item_position=\d+/, "item_position=#{position}"))
