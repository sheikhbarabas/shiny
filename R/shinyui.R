
#' @export
p <- function(...) tags$p(...)

#' @export
h1 <- function(...) tags$h1(...)

#' @export
h2 <- function(...) tags$h2(...)

#' @export
h3 <- function(...) tags$h3(...)

#' @export
h4 <- function(...) tags$h4(...)

#' @export
h5 <- function(...) tags$h5(...)

#' @export
h6 <- function(...) tags$h6(...)

#' @export
a <- function(...) tags$a(...)

#' @export
br <- function(...) tags$br(...)

#' @export
div <- function(...) tags$div(...)

#' @export
span <- function(...) tags$span(...)

#' @export
pre <- function(...) tags$pre(...)

#' @export
code <- function(...) tags$code(...)

#' @export
img <- function(...) tags$img(...)

#' @export
strong <- function(...) tags$strong(...)

#' @export
em <- function(...) tags$em(...)


renderPage <- function(ui, connection) {
  
  # provide a filter so we can intercept head tag requests
  context <- new.env()
  context$head <- character()
  context$filter <- function(tag) {
    if (identical(tag$name, "head")) {
      textConn <- textConnection(NULL, "w") 
      textConnWriter <- function(text) cat(text, file = textConn)
      tagWriteChildren(tag, textConnWriter, 1, context)
      context$head <- append(context$head, textConnectionValue(textConn))
      close(textConn)
      return (FALSE)
    }
    else {
      return (TRUE)
    }
  }
  
  # write ui HTML to a character vector
  textConn <- textConnection(NULL, "w") 
  tagWrite(ui, function(text) cat(text, file = textConn), 0, context)
  uiHTML <- textConnectionValue(textConn)
  close(textConn)
 
  # write preamble
  writeLines(c('<!DOCTYPE html>',
               '<html>',
               '<head>',
               '   <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>',
               '   <script src="shared/jquery.js" type="text/javascript"></script>',
               '   <script src="shared/shiny.js" type="text/javascript"></script>',
               '   <link rel="stylesheet" type="text/css" href="shared/shiny.css"/>',
               context$head[!duplicated(context$head)],
               '</head>',
               '<body>', 
               recursive=TRUE),
             con = connection)
  
  # write UI html to connection
  writeLines(uiHTML, con = connection)
  
  # write end document
  writeLines(c('</body>',
               '</html>'),
             con = connection)
}

#' @export
shinyUI <- function(ui, path='/') {
  
  registerClient({
    
    function(ws, header) {
      if (header$RESOURCE != path)
        return(NULL)
      
      textConn <- textConnection(NULL, "w") 
      on.exit(close(textConn))
      
      renderPage(ui, textConn)
      html <- paste(textConnectionValue(textConn), collapse='\n')
      return(http_response(ws, 200, content=html))
    }
  })
}
