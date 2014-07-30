# probably could be simplified
# this handlebars helper wraps sets of 3 entries into a row
Handlebars.registerHelper 'make_entries', (context, options) ->

  len = context.length + 1

  entries = while len -= 1

    entry = options.fn( context[len-1] )

    # add a row every 3rd entry except the last
    if (len) % 3 == 0 and len != context.length
      entry += '</div><div class="entries__row">'

    entry

  # put things in the right order
  entries = entries.reverse()

  # add the final start & end row divs
  entries.unshift('<div class="entries__row">')
  entries.push('</div>')

  # glue the entries together
  return entries.join('')

# add messages to dropdown
do ->
  message_template = Handlebars.compile $("#message-template").html()
  message_html     = message_template({message: window.message_context})

  $("#dropdown-messages").html(message_html)

# add entries to page
do ->
  entry_template = Handlebars.compile $("#entry-template").html()
  entry_html     = entry_template({entry: window.entry_context})

  $("#entries-list").html(entry_html)

# increment hearts by 1 when clicked, then prevent further clicks
# "session" will not persist; reloading will reset everything
# this is for demo purposes only

$hearts = $('.fa-heart')
$hearts.on 'click', () ->

  $el         = $(@)
  $likesCount = $el.siblings('.likes-count')
  likeCount   = parseInt $likesCount.text()

  if !$el.hasClass('has-been-clicked')
    $likesCount.text(likeCount + 1)
    $el.addClass('has-been-clicked')
