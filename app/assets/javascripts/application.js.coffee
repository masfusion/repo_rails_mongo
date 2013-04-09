###
//= require jquery
//= require jquery_ujs
###

###
* @paquete Archivo de aplicacion
* @Archivo application.js
* @copyright 2013
* @version 1.0
###

# Plugins JQuery.
# Vertical Align.
(($) ->
  $.fn.vAlign = (container) ->
    @each (i) ->
      container = "div"  unless container?
      $(this).html "<" + container + ">" + $(this).html() + "</" + container + ">"
      el = $(this).children(container + ":first")
      elh = $(el).height()
      ph = $(this).parent().height()
      nh = (ph - elh) / 2
      $(el).css "margin-top", nh
) jQuery

vMiddle = (selector) ->
  $(selector).each( ->
    elh = $(this).height() + (parseInt($(this).css("padding-top")) * 2)
    ph = $(this).parent().height()
    nh = (ph - elh) / 2
    $(this).css "margin-top", nh
  ).css visibility: "visible"

# The formatter used by extended text() and html().
# It replaces all placeholders found in the first argument
# by the elements of the array from the second argument.
# Would be the base to extend other HTML transforming
# methods as append().
$.format = (source, params) ->
  if arguments_.length is 1
    return ->
      args = $.makeArray(arguments_)
      args.unshift source
      $.format.apply this, args
  params = $.makeArray(arguments_).slice(1)  if arguments_.length > 2 and params.constructor isnt Array
  params = [params]  unless params.constructor is Array
  $.each params, (i, n) ->
    source = source.replace(new RegExp("\\{" + i + "\\}", "g"), n)
  source

# Smart resize.
(($, sr) ->
  debounce = (func, threshold, execAsap) ->
    timeout = undefined
    debounced = ->
      delayed = ->
        func.apply obj, args  unless execAsap
        timeout = null
      obj = this
      args = arguments_
      if timeout
        clearTimeout timeout
      else func.apply obj, args  if execAsap
      timeout = setTimeout(delayed, threshold or 100)

  jQuery.fn[sr] = (fn) ->
    (if fn then @bind("resize", debounce(fn)) else @trigger(sr))
) jQuery, "smartresize"

# Function Isnumeric.
IsNumeric = (input) ->
  (input - 0) is input and input.length > 0

# Placeholder for elements form.
placeHolderForm = ->

  # Placeholder for form items.
  $("input, textarea").not("input[type=submit]").each ->

    # Tomamos el valor actual del input.
    currentValue = $(this).val()

    # En el focus() comparamos si es el mismo por defecto, y si es asi lo vaciamos.
    $(this).focus ->
      $(this).val ""  if $(this).val() is currentValue

    # En el blur, si el usuario dejo el value vacio, lo volvemos a restablecer.
    $(this).blur ->
      $(this).val currentValue  if $(this).val() is ""

# Custom checkbox/radio.
setupLabel = ->

  if $(".label_check input").length
    $(".label_check").each ->
      $(this).removeClass "c_on"

    $(".label_check input:checked").each ->
      $(this).parent("label").addClass "c_on"

  if $(".label_radio input").length
    $(".label_radio").each ->
      $(this).removeClass "r_on"

    $(".label_radio input:checked").each ->
      $(this).parent("label").addClass "r_on"

# Dropdown.
dropdown = ->

  resetScroll = ->
    $(".dropdown_content .info").animate
      scrollTop: 0
    , 1

  # Hide all visible dropdown's.
  $("html").click ->
    $(".dropdown_content").hide()

  # Stop click propagation.
  $(".dropdown_wrapper").on "click", (e) ->
    e.stopPropagation()

  # Dropdown link.
  $(".dropdown_link").on "click", (e) ->
    $(".dropdown_content").hide()  if $(this).parents(".dropdown_wrapper").find(".dropdown_content").is(":hidden")
    $(this).parents(".dropdown_wrapper").find(".dropdown_content").toggle resetScroll()

# General DOM Ready.
$ ->

  # Placeholder for forms.
  placeHolderForm()

  # Form submit.
  $(".submit").click ->
    $(this).parents("form").submit()

  # Custom checkbox/radio.
  $("body").addClass "has-js"
  $(".label_check, .label_radio").on "click", ->
    setupLabel()

  setupLabel()

  # Close lightbox.
  $(".close_lb").on "click", ->
    $.fancybox.close()

  # Vertical align middle.
  $(window).load vMiddle(".vmiddle")

  # Dropdown.
  dropdown() if $(".dropdown_wrapper").length > 0

