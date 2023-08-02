
#let outline(title) = locate(loc => {
  set text(font:"New Computer Modern Sans")
  block(strong(text(size:15pt)[#title]))
  set text(rgb("#2196F3"))
  let headings = query(heading, loc)
  let toc = ()
  for h in headings {
    let padd = h.level* 1em
    let page = counter(page).at(h.location())
    let ch = if h.level == 1 {
      strong[#counter("h").display("I.")]
    } else {
      counter("h").display("I.1")
    }
    let heading = if h.level == 1 {
      strong[#h.body]
    } else {
      h.body
    }
      if h.level ==1 [ #v(1em, weak:true)]
      else [#v(0.5em, weak:true)]
      box[#pad(left: padd)[#link(h.location())[#{counter("h").step(level: h.level)}#ch#sym.space.third#heading]]]
      box(width: 1fr)[
        #if h.level != 1 [
          #repeat([#sym.space.])
        ]
        ]
        if h.level == 1 [
          #strong(text(font:"CMU Sans Serif")[#page.join()])
        ] else [
          #page.join()
        ]
  }
  
})


#let project(
  title: "",
  subtitle: "",
  author: "",

  body,
) = {
  // Set the document's basic properties.
  set document(title: title)
  set page(
    numbering: "1", 
    number-align: center,
    header: locate((loc) => {
  if loc.page() == 1 { return }
  box(stroke:(bottom:0.7pt), inset: 0.2em)[#text(font:"New Computer Modern Sans")[by #author #h(1fr)#title]]
  })
  )
  set text(font: "New Computer Modern", lang: "en")
  show math.equation: set text(weight: 400)
  set heading(numbering: "I.1.")
  show heading: it => block(text(font:"New Computer Modern Sans")[#text(rgb("#2196F3"), weight:500)[#sym.section]#text(rgb("#2196F3"))[#counter(heading).display()] #it.body#v(0.6em)])



  // Title row.
  align(center)[
    #set text(font:"New Computer Modern Sans")
    #block(text(weight: 700, 25pt, title))
    #v(0.6em, weak: true)
    #if subtitle!=none [#text(14pt)[#subtitle] #v(0.5em, weak: true)]
    #if author!=none [#author]
  ]
  
  // Main body.
  set par(
  justify: true,
  first-line-indent: 1em,
)
  
  body
}




// Store theorem environment numbering

#let thmcounters = state("thm",
  (
    "counters": ("heading": ()),
    "latest": ()
  )
)

#let shadowblock(content, fill: white, stroke:2pt, inset:1em, radius:3pt, breakable:true, width: 100%, shadowsize:3pt) = layout((sz) => style((s) => {
  let content = block(
    stroke: stroke, inset: inset, radius: radius, fill: fill,
    width: sz.width,
    content
  )
  let content-h = measure(content, s).height
  block(breakable: false)[
    #place(top + left, dx: shadowsize, dy: shadowsize,
      block(width: 100%, height: content-h, radius: radius, fill: luma(70%))
    )
    #content
  ]
}))


#let thmenv(identifier, base, base_level, fmt) = {

  let global_numbering = numbering

  return (
    body,
    name: none,
    numbering: "I.1.1",
    base: base,
    title: none,
    base_level: base_level
  ) => {
    let number = none
    if not numbering == none {
      locate(loc => {
        thmcounters.update(thmpair => {
          let counters = thmpair.at("counters")
          // Manually update heading counter
          counters.at("heading") = counter(heading).at(loc)
          if not identifier in counters.keys() {
            counters.insert(identifier, (0, ))
          }

          let tc = counters.at(identifier)
          if base != none {
            let bc = counters.at(base)

            // Pad or chop the base count
            if base_level != none {
              if bc.len() < base_level {
                bc = bc + (0,) * (base_level - bc.len())
              } else if bc.len() > base_level{
                bc = bc.slice(0, base_level)
              }
            }

            // Reset counter if the base counter has updated
            if tc.slice(0, -1) == bc {
              counters.at(identifier) = (..bc, tc.last() + 1)
            } else {
              counters.at(identifier) = (..bc, 1)
            }
          } else {
            // If we have no base counter, just count one level
            counters.at(identifier) = (tc.last() + 1,)
            let latest = counters.at(identifier)
          }

          let latest = counters.at(identifier)
          return (
            "counters": counters,
            "latest": latest
          )
        })
      })

      number = thmcounters.display(x => {
        return global_numbering(numbering, ..x.at("latest"))
      })
    }

    fmt(title,name, number, body)
  }
}


#let thmref(
  label,
  fmt: auto,
  makelink: true,
  ..body
) = {
  if fmt == auto {
    fmt = (nums, body) => {
      if body.pos().len() > 0 {
        body = body.pos().join(" ")
        return [#body #numbering("1.1", ..nums)]
      }
      return numbering("1.1", ..nums)
    }
  }

  locate(loc => {
    let elements = query(label, loc)
    let locationreps = elements.map(x => repr(x.location().position())).join(", ")
    assert(elements.len() > 0, message: "label <" + str(label) + "> does not exist in the document: referenced at " + repr(loc.position()))
    assert(elements.len() == 1, message: "label <" + str(label) + "> occurs multiple times in the document: found at " + locationreps)
    let target = elements.first().location()
    let number = thmcounters.at(target).at("latest")
    if makelink {
      return link(target, fmt(number, body))
    }
    return fmt(number, body)
  })
}



#let thmbox(
  identifier,
  head,
  fill: none,
  stroke: none,
  inset: 1.2em,
  radius: 0.3em,
  breakable: true,
  padding: (top: 0em, bottom: 0em),
  namefmt: x => [(#x)],
  titlefmt: strong,
  bodyfmt: x => x,
  shadow : false,
  shadowsize: 3pt,
  separator: [ ],
  base: "heading",
  end: ".",
  base_level: none,
) = {
  let boxfmt(title, name, number, body) = {
    if not name == none {
      name = [ #namefmt(name)]
    } else {
      name = []
    }
    if title == none {
      title = [#head]
    }
    if not number == none {
      title += " " + number
    }
    title = titlefmt(title + end)
    body = bodyfmt(body)
    let cont
    if shadow==true {
      cont = shadowblock(
        fill: fill,
        stroke: stroke,
        inset: inset,
        width: 100%,
        radius: radius,
        breakable: breakable,
        shadowsize: shadowsize,
        [#title#name#separator#body]
      )}
    else {
        cont = block(
        fill: fill,
        stroke: stroke,
        inset: inset,
        width: 100%,
        radius: radius,
        breakable: breakable,
        [#title#name#separator#body]
      )
    }
    pad(
      ..padding,
      cont
    )
  }
  return thmenv(identifier, base, base_level, boxfmt)
}





#let thmtitle(t, color: rgb("#000000")) = {
  return text(font:"New Computer Modern Sans", weight: "semibold", fill: color)[#t]
}
#let thmname(t, color:rgb("#000000")) = {
  return text(font:"New Computer Modern Sans", fill: color)[(#t)]
}

#let thmtext(t,color:rgb("#000000")) = {
  return text(font:"New Computer Modern", fill: color)[#t]
}

#let styled_thmbox= thmbox.with(titlefmt: thmtitle, namefmt: thmname)

#let get_full_thmbox(c) = {
  return styled_thmbox.with(titlefmt: thmtitle.with(color: c.darken(30%)), namefmt: thmname.with(color:c.darken(30%)), fill: c.lighten(92%),bodyfmt: thmtext.with(color:c.darken(80%)), stroke:c.darken(10%)+1.5pt)
}

#let get_line_thmbox(c) = {
  return styled_thmbox.with(titlefmt: thmtitle.with(color: c.darken(30%)), namefmt: thmname.with(color:c.darken(30%)), fill: c.lighten(90%),bodyfmt: thmtext.with(color:c.darken(80%)), stroke:(left:c.darken(10%)+2pt), radius:0pt)
}

#let styled_thmplain= thmbox.with(titlefmt: thmtitle, namefmt: thmname, inset:0em)

#let theorem_style = get_full_thmbox(rgb("#42A5F5")).with(shadow:true, shadowsize:5pt, separator:"\n")
#let theorem = theorem_style("theorem", "Theorem")
#let lemma = theorem_style("lemma", "Lemma")
#let corollary = theorem_style("corollary","Corollary")

#let problem_style = get_full_thmbox(rgb("#FF7043")).with(shadow:true, separator:"\n")
#let problem = problem_style("problem", "Problem")

#let example = problem_style("example", "Example").with(numbering: none)

#let definition_style = get_line_thmbox(rgb("#4DB6AC"))
#let definition = definition_style("definition","Definition").with(base:"problem")

#let observation_style = get_line_thmbox(rgb("#26C6DA"))
#let observation = observation_style("observation","Observation").with(base:"problem")

#let hint_style = get_line_thmbox(rgb("#66BB6A"))
#let hint = hint_style("hint","Hint").with(numbering: none)

#let claim = hint_style("claim","Claim").with(base:"problem")



#let proof = styled_thmplain(
  "proof",
  "Proof",
  breakable:true,
  bodyfmt: body => [#body #h(1fr) $square$]
).with(numbering: none)
