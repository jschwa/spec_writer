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
    revert: true
    opacity: 0.7
    forcePlaceholderSize: true
    create: ->
      $(this).height($(this).height())
  )
  $(".item-list").disableSelection()
  $("#page_public").change ->
    $(this).parents("form").submit()
  initAddHere()
  initActionsContainer()

@initItemForm = ->
  $(".cancel").click ->
    $(this).parents(".item-form, .edit-form").slideUp()
    $(this).parents(".item").find(".item-view-container").show()

@fixItemsOrdering = ->
  $("li.item").each (index) ->
    position = $("li.item").length - index - 1
    $(this).data("position", position)
    $(this).attr("data-position", position)
  $(".insert-item-container").each (index) ->
    position = $(".insert-item-container").length - index - 1
    $(this).data("position", position)
    $(this).attr("data-position", position)
    $(this).find("a").each ->
      $(this).attr("href", $(this).attr("href").replace(/item_position=\d+/, "item_position=#{position}"))

@initAddHere = ->
  $(".add-here, .cancel-item-container").unbind("click")
  $(".add-here").click ->
    $(".item .insert-item-container .blue-band").hide()
    $(".blue-band-visible").removeClass("blue-band-visible")
    $(this).parents(".item").find(".insert-item-container .blue-band").show()
    $(this).parents(".item").addClass("blue-band-visible")
  $(".cancel-item-container").click ->
    $(this).parents(".item").find(".insert-item-container .blue-band").hide()
    $(this).parents(".item").removeClass("blue-band-visible")

@initActionsContainer = ->
  $(".item").mouseenter ->
    clearItemTimeout($(this))
    hideAllActionContainers($(this))
    $(this).find(".actions-container").show()
  $(".item").mouseleave ->
    actionsContainer = $(this).find(".actions-container")
    timeout = setTimeout(->
      actionsContainer.fadeOut()
    , 1500)
    $(this).data("actionsContainerTimeout", timeout)


clearItemTimeout = (item) ->
  if item.data("actionsContainerTimeout")
    clearTimeout(item.data("actionsContainerTimeout"))

@hideAllActionContainers = (currentItem) ->
  $(".item").each ->
    if(currentItem != $(this))
      clearItemTimeout($(this))
      $(this).find(".actions-container").hide()