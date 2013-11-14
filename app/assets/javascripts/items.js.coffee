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
  )
  $(".item-list").disableSelection()
  $("#page_public").change ->
    $(this).parents("form").submit()
  initAddHere()
  initActionsContainer()


@initItemForm = ->
  $(".cancel").unbind().click ->
    cancel = $(this)
    cancel.parents(".item-form, .edit-form").unbind().fadeOut(->
      cancel.parents(".item").find(".item-view-container").fadeIn()
    )
  initAddBackend()


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
  $(".add-here").mouseenter ->
    hideAllActionContainers(null)
  $(".add-here").mouseleave ->
    $(this).parents(".actions-container-parent").find(".actions-container").show()
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
  $(".actions-container-parent").unbind().mouseenter ->
    clearItemTimeout($(this))
    hideAllActionContainers($(this))
    $(this).find(".actions-container").show()
  $(".actions-container-parent").mouseleave ->
    actionsContainer = $(this).find(".actions-container")
    timeout = setTimeout(->
      actionsContainer.fadeOut()
    , 1000)
    $(this).data("actionsContainerTimeout", timeout)

clearItemTimeout = (element) ->
  if element.data("actionsContainerTimeout")
    clearTimeout(element.data("actionsContainerTimeout"))

@hideAllActionContainers = (currentItem) ->
  $(".actions-container-parent").each ->
    if(currentItem != $(this))
      clearItemTimeout($(this))
      $(this).find(".actions-container").hide()

@initAddBackend = ->
  $(".add-backend").click ->
    $(this).hide()
    $(".back-end-container").show()
    $(".front-end-container").removeClass("span9").addClass("span6")
    $(".front-end-container .control-label").show()
    $(".front-end-container textarea").addClass("span11")
