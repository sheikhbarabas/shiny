\name{navlistPanel}
\alias{navlistPanel}
\title{Create a navigation list panel}
\usage{
  navlistPanel(..., id = NULL, selected = NULL,
    well = TRUE, fluid = TRUE, widths = c(4, 8))
}
\arguments{
  \item{...}{\code{\link{tabPanel}} elements to include in
  the navlist}

  \item{id}{If provided, you can use
  \code{input$}\emph{\code{id}} in your server logic to
  determine which of the current navlist items is active.
  The value will correspond to the \code{value} argument
  that is passed to \code{\link{tabPanel}}.}

  \item{selected}{The \code{value} (or, if none was
  supplied, the \code{title}) of the navigation item that
  should be selected by default. If \code{NULL}, the first
  navigation will be selected.}

  \item{well}{\code{TRUE} to place a well (gray rounded
  rectangle) around the navigation list.}

  \item{fluid}{\code{TRUE} to use fluid layout;
  \code{FALSE} to use fixed layout.}

  \item{widths}{Column withs of the navigation list and
  tabset content areas respectively.}
}
\description{
  Create a navigation list panel that provides a list of
  links on the left which navigate to a set of tabPanels
  displayed to the right.
}
\details{
  You can include headers within the \code{navlistPanel} by
  including plain text elements in the list; you can
  include separators by including "------" (any number of
  dashes works).
}
\examples{
shinyUI(fluidPage(

  titlePanel("Application Title"),

  navlistPanel(
    "Header",
    tabPanel("First"),
    tabPanel("Second"),
    "-----",
    tabPanel("Third")
  )
))
}
