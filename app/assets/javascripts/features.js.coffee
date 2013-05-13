$ =>
  $(".add-feature-link").click ->
    $(".feature-form").slideDown()
    $("input[type=text], textarea").val("")
    $(".error").removeClass("error")
    $("p.inline-errors").remove()
  @initFeatureForm()
  $(".feature-list").sortable(
    update: (event, ui) ->
      url = $("#reorder_features_path").val()
      newOrder = []
      $("li.feature").each ->
        newOrder.push($(this).data("position"))
      $.post(url, new_order: newOrder, ->
        $("li.feature").each (index) ->
          $(this).data("position", $("li.feature").length - index - 1)
      )
  )
  $(".feature-list").disableSelection()

@initFeatureForm = ->
  $(".cancel").click ->
    $(".feature-form").slideUp()